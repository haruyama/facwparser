# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/element'

class TestStrong < Test::Unit::TestCase

  def test_strong_1
    strong = Facwparser::Element::Strong.new('*hoge*', 'hoge')
    assert_equal(%Q{<strong>hoge</strong>},
                 strong.render_html({}))
  end
end
