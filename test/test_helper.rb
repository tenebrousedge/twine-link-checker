# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'twine_link_checker/twine_link_checker'

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'

require 'tempfile'
require 'pathname'

def in_tmpdir
  Dir.mktmpdir do |dir|
    Dir.chdir do
      yield dir
    end
  end
end
