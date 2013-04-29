# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/element'

class TestBr < Test::Unit::TestCase

  def test_br_1
    br = Facwparser::Element::Br.new('\\\\')
    assert_equal(%Q{<br>},
                 br.render_html({}))
  end
end
