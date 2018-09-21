require 'thor'
require 'twine-link-checker/checker'

module TwineLinkChecker
  class CLI < Thor
    desc 'show missing images', 'shows which image links do not exist on disk'
    def missing(filename)
      puts TwineLinkChecker::Checker.check_file(filename)
    end
  end
end
