require 'htmlentities'

module TwineLinkChecker
  module Checker
    EXTENSIONS = %i{jpg jpeg webm gif png}

    FILE_MATCHER = %r{(\.\/|\w)[ \w\/\\&-]*\.(#{EXTENSIONS * '|'})}
    # as one can see, not all valid characters will be matched
    # the file must be a relative path 

    def self.extract_paths(filename)
      File.open(filename) do |file|
        file.readlines.map(&HTMLEntities.new.method(:decode)).map do |line|
          line[FILE_MATCHER]&.gsub(/\\\\|\\/, '/')
        end.compact.uniq
      end
    end

    def self.check_file(filename)
      Dir.chdir(File.dirname(File.expand_path(filename))) do
        extract_paths(File.basename(filename)).reject(&File.method(:file?))
      end
    end
  end
end

