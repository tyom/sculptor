require 'thor'
require 'middleman-core/version'
require 'middleman-core/cli'

module Sculptor
  module CLI
    class Base < Middleman::Cli::Base
      desc 'version', 'Show version'
      def version
        say "Sculptor #{Sculptor::VERSION} (Middleman #{Middleman::VERSION})"
      end

      def help(meth=nil, subcommand=false)
        if meth && !self.respond_to?(meth)
          klass, task = Thor::Util.find_class_and_task_by_namespace("#{meth}:#{meth}")
          klass.start(['-h', task].compact, shell: shell)
        else
          list = []
          Thor::Util.thor_classes_in(Sculptor::CLI).each do |thor_class|
            list += thor_class.printable_tasks(false)
          end
          list.sort! { |a, b| a[0] <=> b[0] }

          shell.say "\n"
          shell.print_table(list, ident: 2, truncate: true)
          shell.say
        end
      end

      # Intercept missing methods and search subtasks for them
      # @param [Symbol] meth
      def method_missing(meth, *args)
        meth = meth.to_s
        meth = self.class.map[meth] if self.class.map.key?(meth)

        klass, task = Thor::Util.find_class_and_task_by_namespace("#{meth}:#{meth}")

        if klass.nil?
          raise Thor::Error, "There's no '#{meth}' command for Sculptor. Try 'sculptor help' for a list of commands."
        else
          args.unshift(task) if task
          klass.start(args, shell: shell)
        end
      end
    end
  end
end

require 'sculptor/version'
require 'sculptor/cli/create'
require 'sculptor/cli/init'
require 'sculptor/cli/server'
