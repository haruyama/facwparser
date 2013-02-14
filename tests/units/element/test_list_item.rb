# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/element'


class TestListItem < Test::Unit::TestCase

  def test_list_item_1
    li = Facwparser::Element::ListItem.new('* hoge', '*', 'hoge')
    assert_equal(%Q{<li>hoge</li>},
                 li.render_html({}))
  end

  def test_list_item_2
    li = Facwparser::Element::ListItem.new('## hoge*nyo*', '##', 'hoge*nyo*')
    assert_equal(%Q{<li>hoge<b>nyo</b></li>},
                 li.render_html({}))
  end
end

