# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/element'

class TestUnder < Test::Unit::TestCase

  def test_Under_1
    under = Facwparser::Element::Under.new('+hoge+', 'hoge')
    assert_equal(%Q{<u>hoge</u>},
                 under.render_html({}))
  end
end
