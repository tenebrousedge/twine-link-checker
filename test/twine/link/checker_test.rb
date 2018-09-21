require "test_helper"

class Twine::Link::CheckerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Twine::Link::Checker::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
