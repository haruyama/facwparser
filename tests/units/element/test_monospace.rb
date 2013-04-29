# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/element'

class TestMonospace < Test::Unit::TestCase

  def test_monospace_1
    monospace = Facwparser::Element::Monospace.new('{{hoge}}', 'hoge')
    assert_equal(%Q{<code>hoge</code>},
                 monospace.render_html({}))
  end
end
