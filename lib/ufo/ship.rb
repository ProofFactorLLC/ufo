module Ufo
  class UfoError < RuntimeError; end
  class ShipmentOverridden < UfoError; end

  class Ship < Base
    def initialize(service, options={})
      super
      @task_definition = options[:task_definition]
    end

    def deploy
      message = "Deploying service #{@service.color(:green)} to cluster #{@cluster.color(:green)}..."
      unless @options[:mute]
        if @options[:noop]
          puts "NOOP: #{message}"
          return
        else
          puts message
        end
      end

      ensure_log_group_exist
      ensure_cluster_exist
      stop_old_tasks if @options[:stop_old_tasks]
      success = deploy_stack

      return if @options[:mute] || !@options[:wait]
      if success
        puts "Software shipped!"
      else
        puts "Software fail to ship."
        exit 1
      end
    end

    # Start a thread that will poll for ecs deployments and kill of tasks
    # in old deployments.
    # This must be done in a thread because the stack update process is blocking.
    def stop_old_tasks
      # only works when deployment is blocking
      return unless @options[:wait]

      Thread.new do
        stop = Ufo::Stop.new(@service, @options.merge(mute: true))
        while true
          stop.log "checking for old tasks and waiting for 10 seconds"
          stop.run
          sleep 10
        end
      end
    end

    def ensure_log_group_exist
      LogGroup.new(@task_definition, @options).create
    end

    def deploy_stack
      options = @options.merge(
        service: @service,
        task_definition: @task_definition,
      )
      stack = Stack.new(options)
      stack.deploy
    end

    def show_aws_cli_command(action, params)
      puts "Equivalent aws cli command:"
      # Use .ufo/data instead of .ufo/output because output files all get looped
      # through as part of `ufo tasks register`
      rel_path = ".ufo/data/#{action}-params.json"
      output_path = "#{Ufo.root}/#{rel_path}"
      FileUtils.rm_f(output_path)

      # Thanks: https://www.mnishiguchi.com/2017/11/29/rails-hash-camelize-and-underscore-keys/
      params = params.deep_transform_keys { |key| key.to_s.camelize(:lower) }
      json = JSON.pretty_generate(params)
      IO.write(output_path, json)

      file_path = "file://#{rel_path}"
      puts "  aws ecs #{action}-service --cli-input-json #{file_path}".color(:green)
    end

    def ensure_cluster_exist
      cluster = ecs_clusters.first
      unless cluster && cluster.status == "ACTIVE"
        message = "#{@cluster} cluster created."
        if @options[:noop]
          message = "NOOP #{message}"
        else
          ecs.create_cluster(cluster_name: @cluster)
          # TODO: Add Waiter logic, sometimes the cluster does not exist by the time
          # we create the service
        end

        puts message unless @options[:mute]
      end
    end

    def ecs_clusters
      ecs.describe_clusters(clusters: [@cluster]).clusters
    end
  end
end
