# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/element'


class TestTableData < Test::Unit::TestCase

  def test_table_data_1
    td = Facwparser::Element::TableData.new('|hoge|kuke|')
    assert_equal(%Q{<tr><td>hoge</td><td>kuke</td></tr>},
                 td.render_html({}))
  end

  def test_table_data_2
    td = Facwparser::Element::TableData.new('|hoge|[hoge|http://www.unixuser.org]|')
    assert_equal(%Q{<tr><td>hoge</td><td><a href="http://www.unixuser.org">hoge</a></td></tr>},
                 td.render_html({}))
  end
end

