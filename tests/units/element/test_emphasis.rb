# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/element'

class TestEmphasis < Test::Unit::TestCase

  def test_emphasis_1
    emphasis = Facwparser::Element::Emphasis.new('_hoge_', 'hoge')
    assert_equal(%Q{<em>hoge</em>},
                 emphasis.render_html({}))
  end
end
