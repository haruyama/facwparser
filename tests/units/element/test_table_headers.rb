# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/element'


class TestTableHeaders < Test::Unit::TestCase

  def test_table_headers_1
    tr = Facwparser::Element::TableHeaders.new("||hoge||kuke|| \n", '||hoge||kuke||')
    assert_equal(%Q{<tr><th>hoge</th><th>kuke</th></tr>},
                 tr.render_html({}))
  end

  def test_table_headers_2
    tr = Facwparser::Element::TableHeaders.new("||hoge||[hoge|http://www.unixuser.org]||\n", '||hoge||[hoge|http://www.unixuser.org]||')
    assert_equal(%Q{<tr><th>hoge</th><th><a href="http://www.unixuser.org">hoge</a></th></tr>},
                 tr.render_html({}))
  end
end

