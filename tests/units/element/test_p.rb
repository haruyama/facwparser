# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/element'


class TestP < Test::Unit::TestCase

  def test_p_1
    p = Facwparser::Element::P.new('hoge')
    assert_equal("<p>hoge</p>\n",
                 p.render_html({}))
  end

end

