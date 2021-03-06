require 'open3'
require 'ostruct'
require 'net/ssh'

module Gearship
  class Cli < Thor
    include Thor::Actions

    desc 'init', 'Initialize gearship project'
    def init
      init!('gearship')
    end

    desc 'go [mission] [--sudo]', 'Send gearship on a mission with ssh.'
    method_options :sudo => false
    def go(mission, *args)
      go!(mission, *args)
    end
    
    desc 'local [mission] [--sudo]', 'Send gearship on a local mission.'
    method_options :sudo => false
    def local(mission, *args)
      local!(mission, *args)
    end
    
    desc 'compile', 'Compile gearship project for debugging'
    def compile(mission = nil)
      compile!(mission)
    end

    no_tasks do
      include Gearship::Utility

      def self.source_root
        File.expand_path('../../',__FILE__)
      end

      def init!(project)
        copy_file 'templates/.dockerignore',                 ".dockerignore"
        copy_file 'templates/.gitignore',                    "gearship/.gitignore"
        copy_file 'templates/gearship.yml',                  "gearship/gearship.yml"
        copy_file 'templates/gearship.sh',                   "gearship/gearship.sh"
        
        copy_file 'templates/actions/configure_firewall.sh', "gearship/actions/configure_firewall.sh"
        copy_file 'templates/actions/install_basics.sh',     "gearship/actions/install_basics.sh"
        copy_file 'templates/actions/install_docker.sh',     "gearship/actions/install_docker.sh"
        copy_file 'templates/actions/login_docker.sh',       "gearship/actions/login_docker.sh"
        copy_file 'templates/actions/pull_image.sh',         "gearship/actions/pull_image.sh"
        copy_file 'templates/actions/remove_container.sh',   "gearship/actions/remove_container.sh"
        copy_file 'templates/actions/start_container.sh',    "gearship/actions/start_container.sh"
        
        copy_file 'templates/missions/install_container.sh', "gearship/missions/install_container.sh"
        copy_file 'templates/missions/setup_host.sh',        "gearship/missions/setup_host.sh"
        copy_file 'templates/missions/update_container.sh',  "gearship/missions/update_container.sh"
        
        copy_file 'templates/cargo/sample.conf',             "gearship/cargo/sample.conf"
      end

      def go!(*args)
        mission = args[0]
        compile!(mission)
        sudo = 'sudo ' if options.sudo?
        
        if mission.include? 'local'
          local_commands = <<-EOS
          cd compiled
          #{sudo}bash gearship.sh
          EOS
        else
          user, host, port = parse_target(@config['attributes']['ssh_target'])
          endpoint = "#{user}@#{host}"

          # Remove server key from known hosts to avoid mismatch errors when VMs change.
          `ssh-keygen -R #{host} 2> /dev/null`

          remote_commands = <<-EOS
          rm -rf ~/gearship &&
          mkdir ~/gearship &&
          cd ~/gearship &&
          tar xz &&
          #{sudo}bash gearship.sh
          EOS

          remote_commands.strip! << ' && rm -rf ~/gearship' if @config['preferences'] and @config['preferences']['erase_remote_folder']

          local_commands = <<-EOS
          cd compiled
          tar cz . | ssh -o 'StrictHostKeyChecking no' #{endpoint} -p #{port} '#{remote_commands}'
          EOS
        end
        
        execute(local_commands)
      end
      
      def local!(*args)
        mission = args[0]
        compile!(mission)
        sudo = 'sudo ' if options.sudo?
        
        local_commands = <<-EOS
          cd compiled
          #{sudo}bash gearship.sh
        EOS
          
        execute(local_commands)
      end
        
      def execute(local_commands)
        Open3.popen3(local_commands) do |stdin, stdout, stderr|
          stdin.close
          t = Thread.new do
            while (line = stderr.gets)
              print line.color(:red)
            end
          end
          while (line = stdout.gets)
            print line.color(:green)
          end
          t.join
        end
      end
      
      def compile!(mission)
        abort_with 'You must be in the gearship folder' unless File.exists?('gearship.yml')
        abort_with "#{mission} doesn't exist!" if mission and !File.exists?("missions/#{mission}.sh")

        @config = YAML.load(File.read('gearship.yml'))

        @config['attributes'] ||= {}
        @config['attributes'].update(Hash[@instance_attributes.map{|k,v| [k.to_s, v] }]) if @instance_attributes

        (@config['attributes'] || {}).each {|key, value| create_file "compiled/attributes/#{key}", value }

        cache_remote_actions = @config['preferences'] && @config['preferences']['cache_remote_actions']
        (@config['actions'] || []).each do |key, value|
          next if cache_remote_actions and File.exists?("compiled/actions/#{key}.sh")
          get value, "compiled/actions/#{key}.sh"
        end

        copy_or_template = (@config['preferences'] && @config['preferences']['eval_erb']) ? :template : :copy_file
        copy_local_files(@config, copy_or_template)

        if mission
          if copy_or_template == :template
            template File.expand_path('gearship.sh'), 'compiled/_gearship.sh'
            create_file 'compiled/gearship.sh', File.binread('compiled/_gearship.sh') << "\n" << File.binread("compiled/missions/#{mission}.sh")
          else
            create_file 'compiled/gearship.sh', File.binread('gearship.sh') << "\n" << File.binread("missions/#{mission}.sh")
          end
        else
          send copy_or_template, File.expand_path('gearship.sh'), 'compiled/gearship.sh'
        end
      end

      def parse_target(target)
        target.match(/(.*@)?(.*?)(:.*)?$/)
        config = Net::SSH::Config.for($2)
        [ ($1 && $1.delete('@') || config[:user] || 'root'), 
          config[:host_name] || $2, 
          ($3 && $3.delete(':') || config[:port] && config[:port].to_s || '22') ]
      end

      def copy_local_files(config, copy_or_template)
        @attributes = OpenStruct.new(config['attributes'])
        files = Dir['{actions,missions,cargo}/**/*'].select { |file| File.file?(file) }
        files.each { |file| send copy_or_template, File.expand_path(file), File.expand_path("compiled/#{file}") }

        (config['files'] || []).each {|file| send copy_or_template, File.expand_path(file), "compiled/cargo/#{File.basename(file)}" }
      end
    end
  end
end
