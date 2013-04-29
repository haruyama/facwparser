# -*- encoding: utf-8 -*-
require 'test/unit'
require_relative '../../../lib/facwparser/parser'

class TestAddTableElements < Test::Unit::TestCase

  def test_add_table_elements_1
    pre = [
        Facwparser::Element::TableHeaders.new('||head1||head2||', '||head1||head2||'),
        Facwparser::Element::TableData.new('|3|4|', '|3|4|'),
        Facwparser::Element::TableData.new('|5|6|', '|5|6|'),
      ]

      assert_equal([
        Facwparser::Element::Table.new.push(
          Facwparser::Element::TableHeaders.new('||head1||head2||', '||head1||head2||')).push(
          Facwparser::Element::TableData.new('|3|4|', '|3|4|')).push(
        Facwparser::Element::TableData.new('|5|6|', '|5|6|')),
    ], Facwparser::Parser.add_table_elements(pre, {}))

  end

  def test_add_table_elements_2
    pre = [
        Facwparser::Element::TableHeaders.new('||head1||head2||', '||head1||head2||'),
        Facwparser::Element::TableData.new('|3|4|', '|3|4|'),
        Facwparser::Element::TableData.new('|5|6|', '|5|6|'),
        Facwparser::Element::TableHeaders.new('||head1||head2||', '||head1||head2||'),
        Facwparser::Element::TableData.new('|3|4|', '|3|4|'),
        Facwparser::Element::TableData.new('|5|6|', '|5|6|'),
      ]

      assert_equal([
        Facwparser::Element::Table.new.push(
          Facwparser::Element::TableHeaders.new('||head1||head2||', '||head1||head2||')).push(
          Facwparser::Element::TableData.new('|3|4|', '|3|4|')).push(
        Facwparser::Element::TableData.new('|5|6|', '|5|6|')),
        Facwparser::Element::Table.new.push(
          Facwparser::Element::TableHeaders.new('||head1||head2||', '||head1||head2||')).push(
          Facwparser::Element::TableData.new('|3|4|', '|3|4|')).push(
        Facwparser::Element::TableData.new('|5|6|', '|5|6|')),
    ], Facwparser::Parser.add_table_elements(pre, {}))

  end

end

