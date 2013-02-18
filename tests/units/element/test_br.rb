#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/element'

class TestBr < Test::Unit::TestCase

  def test_br_1
    br = Facwparser::Element::Br.new('\\\\')
    assert_equal(%Q{<br>},
                 br.render_html({}))
  end
end
