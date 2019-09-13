# frozen_string_literal: true

require 'htmlentities'

module TwineLinkChecker
  # mixin class to extract paths from files
  module FileParser
    EXTS = %w[jpg jpeg webm gif png].join('|').freeze

    FILE_MATCHER = %r{(?:[./[:alnum:]])[[:alnum:] &_/\\'-]*\.(?:#{EXTS})}i.freeze
    # should match most filenames

    def each_path
      rewind
      Enumerator.new do |y|
        each_line.map(&HTMLEntities.new.method(:decode)).map do |line|
          line.scan(FILE_MATCHER) { |url| y << url.gsub(/\\\\|\\/, '/') }
        end
      end
    end

    def in_own_dir
      Dir.chdir(File.dirname(File.expand_path(self))) do
        yield
      end
    end

    def missing_paths
      in_own_dir do
        each_path.reject(&File.method(:file?)).uniq
      end
    end

    def real_paths
      in_own_dir do
        missing_paths.map do |path|
          # not efficient, but FNM_CASEFOLD doesn't seem to work
          [path, Dir.glob('**/*').find do |f|
            [path, f].map { |p| File.expand_path(p).downcase }.reduce(:==)
          end]
        end
      end
    end

    def fix_paths
      hash = Hash.new { |h, k| h[k] = k }.merge(real_paths.to_h.compact)
      rewind
      read.gsub(FILE_MATCHER, hash)
    end
  end
end
