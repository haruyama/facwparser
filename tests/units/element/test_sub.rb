# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/element'

class TestSub < Test::Unit::TestCase

  def test_sub_1
    sub = Facwparser::Element::Sub.new('^hoge^', 'hoge')
    assert_equal(%Q{<sub>hoge</sub>},
                 sub.render_html({}))
  end
end
