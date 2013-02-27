#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/element'

class TestNop < Test::Unit::TestCase

  def test_nop_1
    nop = Facwparser::Element::Nop.new("\n")
    assert_equal(%Q{\n},
                 nop.render_html({}))
  end
end
