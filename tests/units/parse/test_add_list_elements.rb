# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/parse'


class TestAddListElements < Test::Unit::TestCase

  def test_add_list_elements_1
    pre = [
        Facwparser::Element::ListItem.new("* 4\n", '*', '4'),
        Facwparser::Element::ListItem.new("** 5\n", '**', '5'),
        Facwparser::Element::ListItem.new("**# 6\n", '**#', '6'),
      ]

      assert_equal([
        Facwparser::Element::ListStart.new('*'),
        Facwparser::Element::ListItem.new("* 4\n", '*', '4'),
        Facwparser::Element::ListStart.new('*'),
        Facwparser::Element::ListItem.new("** 5\n", '**', '5'),
        Facwparser::Element::ListStart.new('#'),
        Facwparser::Element::ListItem.new("**# 6\n", '**#', '6'),
        Facwparser::Element::ListEnd.new('#'),
        Facwparser::Element::ListEnd.new('*'),
        Facwparser::Element::ListEnd.new('*'),
    ], Facwparser::Parse.add_list_elements(pre, {}))

  end

end

