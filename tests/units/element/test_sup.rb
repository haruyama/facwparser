# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/element'

class TestSup < Test::Unit::TestCase

  def test_sup_1
    sup = Facwparser::Element::Sup.new('^hoge^', 'hoge')
    assert_equal(%Q{<sup>hoge</sup>},
                 sup.render_html({}))
  end
end
