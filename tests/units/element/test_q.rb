# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/element'

class TestQ < Test::Unit::TestCase

  def test_q_1
    q = Facwparser::Element::Q.new('??hoge??', 'hoge')
    assert_equal(%Q{<q>hoge</q>},
                 q.render_html({}))
  end
end
