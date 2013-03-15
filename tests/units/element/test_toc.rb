# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/element'

class TestToc < Test::Unit::TestCase

  def test_toc_1
    toc = Facwparser::Element::TocMacro.new('{toc}', '')
    heading1 = Facwparser::Element::Heading.new('h1. hoge', 1, 'hoge')
    heading1.id = 'heading1'
    heading2 = Facwparser::Element::Heading.new('h1. kuke', 1, 'kuke')
    heading2.id = 'heading2'

    toc.headings = [heading1, heading2]


    assert_equal(%Q{<ul>\n<li><a href="#heading1">hoge</a></li>\n<li><a href="#heading2">kuke</a></li>\n</ul>\n},
                 toc.render_html({}))
  end
end
