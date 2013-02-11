# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/element'


class TestHr < Test::Unit::TestCase

  def test_hr
    hr = Facwparser::Element::HorizontalRule.new('----')
    assert_equal("<hr>\n",
                 hr.render_html({}))
  end
end

