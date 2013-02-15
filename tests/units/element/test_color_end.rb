# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/element'

class TestColorEnd < Test::Unit::TestCase

  def test_color_end_1
    ce = Facwparser::Element::ColorMacroEnd.new('{color}')
    assert_equal(%Q{</span>},
                 ce.render_html({}))
  end
end
