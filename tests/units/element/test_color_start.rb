# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/element'

class TestColorStart < Test::Unit::TestCase

  def test_color_start_1
    cs = Facwparser::Element::ColorMacroStart.new('{color:red}', 'red')
    assert_equal(%Q{<span style="color: red">},
                 cs.render_html({}))
  end
end
