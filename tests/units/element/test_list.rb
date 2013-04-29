# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/element'

class TestList < Test::Unit::TestCase

  def test_list_1
    ul = Facwparser::Element::List.new('*')
    ul.push Facwparser::Element::ListItem.new('* hoge', '*', 'hoge')
    ol = Facwparser::Element::List.new('#')
    ul.push ol
    ol.push Facwparser::Element::ListItem.new('## kuke', '##', 'kuke')

    assert_equal(%Q{<ul>\n<li>hoge</li>\n<ol>\n<li>kuke</li>\n</ol>\n</ul>\n},
                 ul.render_html({}))
  end

end

