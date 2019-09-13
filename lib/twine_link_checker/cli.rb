# frozen_string_literal: true

require 'thor'
require 'twine_link_checker/twine_link_checker'

module TwineLinkChecker
  # Command line interface for twine_link_checker
  class CLI < Thor
    desc 'show missing paths', 'shows which image links do not exist on disk'
    def missing(filename)
      file = File.open(filename).extend(TwineLinkChecker::FileParser)
      puts file.missing_paths
      file.close
    end

    desc 'fixes missing paths', 'outputs file with correctly-cased paths. '\
    'OVERWRITES ORIGINAL FILE BY DEFAULT'
    def fix(filename, output = filename)
      file = File.open(filename, 'w+').extend(TwineLinkChecker::FileParser)
      File.open(output, 'w') do |o|
        count = o.write(file.fix_paths)
        puts "Wrote #{count} bytes."
      end
      file.close
    end
  end
end
