describe Ufo::CLI do
  before(:all) do
    create_ufo_project
    @args = "--noop"
  end

  describe "ufo" do
    context "docker" do
      it "build builds image" do
        out = execute("exe/ufo docker build #{@args}")
        expect(out).to include("docker build -t tongueroo/demo-ufo")
      end

      it "tag shows the tag" do
        out = execute("exe/ufo docker name #{@args}")
        expect(out).to match(%r{tongueroo/demo-ufo:ufo-.{7}})
      end

      it "compiles Dockerfile from Dockerfile.erb" do
        FileUtils.cp("spec/fixtures/dockerfiles/Dockerfile.erb", "#{Ufo.root}/Dockerfile.erb")
        out = execute("exe/ufo docker compile #{@args}")
        expect(out).to include("Compiled Dockerfile.erb to Dockerfile")
      end
    end

    context "tasks" do
      before(:each) do
        FileUtils.mkdir_p("#{Ufo.root}/.ufo/data/")
        FileUtils.touch("#{Ufo.root}/.ufo/data/docker_image_name_ufo.txt")
      end
      after(:each) do
        FileUtils.rm_f("#{Ufo.root}/.ufo/data/docker_image_name_ufo.txt")
      end

      it "build builds task definition" do
        out = execute("exe/ufo tasks build #{@args}")
        expect(out).to include("Task Definitions built")
      end

      it "register it registers all the output task definitions" do
        out = execute("exe/ufo tasks register #{@args}")
        expect(out).to include("register")
      end
    end

    context "ship" do
      it "deploys software" do
        out = execute("exe/ufo ship demo-web-prod #{@args} --no-wait")
        # cannot look for Software shipped! because
        #   ship.deploy unless ENV['TEST'] # to allow me to quickly test CLI portion only
        # just testing the CLI portion.  The ship class itself is tested via ship_spec.rb
        expect(out).to include("Task Definitions built")
      end
    end

    context "ships" do
      it "deploys software to multiple services" do
        out = execute("exe/ufo ships demo-web-prod demo-worker-prod #{@args} --no-wait")
        # cannot look for Software shipped! because
        #   ship.deploy unless ENV['TEST'] # to allow me to quickly test CLI portion only
        # just testing the CLI portion.  The ship class itself is tested via ship_spec.rb
        expect(out).to include("Task Definitions built")
      end
    end

    context "task" do
      it "runs one time task" do
        out = execute("exe/ufo completion ship name")
        expect(out).to include("--help")
      end
    end
  end
end
