# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/element'

class TestStrike < Test::Unit::TestCase

  def test_strike_1
    strike = Facwparser::Element::Strike.new('-hoge-', 'hoge')
    assert_equal(%Q{<span style="text-decoration: line-through;">hoge</span>},
                 strike.render_html({}))
  end
end
