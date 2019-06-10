module Ufo
  class Docker::Dockerfile
    def initialize(full_image_name, options={})
      @full_image_name, @options = full_image_name, options
    end

    def update
      write_new_dockerfile
    end

    def current_dockerfile
      @current_dockerfile ||= IO.read(dockerfile_path)
    end

    def dockerfile_path
      "#{Ufo.root}/Dockerfile"
    end

    def new_dockerfile
      lines = current_dockerfile.split("\n")
      # replace FROM line
      new_lines = lines.map do |line|
                    if line =~ /^FROM /
                      "FROM #{@full_image_name}"
                    else
                      line
                    end
                  end
      new_lines.join("\n") + "\n"
    end

    def write_new_dockerfile
      IO.write(dockerfile_path, new_dockerfile)
      unless @options[:mute]
        puts "The Dockerfile FROM statement has been updated with the latest base image:".color(:green)
        puts "  #{@full_image_name}".color(:green)
      end
    end
  end
end
