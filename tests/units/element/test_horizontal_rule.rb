# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/element'

class TestHr < Test::Unit::TestCase

  def test_hr
    hr = Facwparser::Element::HorizontalRule.new('----')
    assert_equal("<hr>\n",
                 hr.render_html({}))
  end
end

