require 'fileutils'
require 'yaml'

class Ufo::Upgrade
  class Upgrade43to44
    def initialize(options)
      @options = options
    end

    def run
      settings_path = ".ufo/settings.yml"
      settings = YAML.load_file(settings_path)
      if settings["base"]["stack_naming"]
        puts "Detected stack_naming in the #{settings_path}. Already upgraded to v4.4"
        return
      end

      puts "Upgrading to ufo v4.4..."
      settings["base"]["stack_naming"] = "append_env"
      text = YAML.dump(settings)
      IO.write(settings_path, text)
      puts "Updated .ufo/settings.yml"
    end
  end
end
