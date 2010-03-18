require 'rake'
require 'rspec/core/rake_task'

module Rspec
  module Core
    class RakeTask
      def define # :nodoc:
        actual_name = Hash === name ? name.keys.first : name
        desc("Run Rspec code examples") unless ::Rake.application.last_comment
 
        task name do
          RakeFileUtils.send(:verbose, verbose) do
            if files_to_run.empty?
              puts "No examples matching #{pattern} could be found"
            else
              spec_script = File.expand_path(File.join(File.dirname(__FILE__),"bin","spec"))
              cmd_parts = [rcov ? 'rcov' : RUBY]
              cmd_parts += rcov ? [rcov_opts] : [ruby_opts]
              cmd_parts << '-Ilib'
              cmd_parts << '-Ispec'
              cmd_parts << "-w" if warning
              cmd_parts << %["#{spec_script}"]
              cmd_parts += files_to_run.collect { |fn| %["#{fn}"] }
              cmd = cmd_parts.join(" ")
              puts cmd if verbose
              unless system(cmd)
                STDERR.puts failure_message if failure_message
                raise("Command #{cmd} failed") if fail_on_error
              end
            end
          end
        end
 
        self
      end
    end
  end
end

Rspec::Core::RakeTask.new(:spec)

task :default => :spec
