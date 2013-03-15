# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/element'

class TestTable < Test::Unit::TestCase

  def test_table_1
    table = Facwparser::Element::Table.new
    tr = Facwparser::Element::TableHeaders.new("||hoge||kuke||\n", '||hoge||kuke||')
    td1 = Facwparser::Element::TableData.new("|1|2|\n", '|1|2|')
    td2 = Facwparser::Element::TableData.new("|3|4|\n", '|3|4|')
    table.push tr
    table.push td1
    table.push td2
    assert_equal(%Q{<table>\n<thead>\n<tr><th>hoge</th><th>kuke</th></tr>\n</thead>\n<tbody>\n<tr><td>1</td><td>2</td></tr>\n<tr><td>3</td><td>4</td></tr>\n</tbody>\n</table>\n},
                 table.render_html({}))
  end

end

