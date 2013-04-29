# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/element'

class TestText < Test::Unit::TestCase

  def test_text_1
    text = Facwparser::Element::Text.new('hoge>', 'hoge>')
    assert_equal(%Q{hoge&gt;},
                 text.render_html({}))
  end
end
