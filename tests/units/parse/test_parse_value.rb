# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/parser'


class TestParseValue < Test::Unit::TestCase

  def test_parse_value_text
      assert_equal([
        Facwparser::Element::Text.new('1', '1')
    ], Facwparser::Parser.parse_value('1', {}))
      assert_equal([
        Facwparser::Element::Text.new('1', '1'),
        Facwparser::Element::Text.new('2', '2')
    ], Facwparser::Parser.parse_value("1\n2", {}))
  end

  def test_parse_value_a
      assert_equal([
        Facwparser::Element::Text.new('1', '1'),
        Facwparser::Element::A.new('[hoge]', 'hoge'),
        Facwparser::Element::Text.new('2', '2')
    ], Facwparser::Parser.parse_value('1[hoge]2', {}))
      assert_equal([
        Facwparser::Element::Text.new('1', '1'),
        Facwparser::Element::A.new('[hoge\]]', 'hoge]'),
        Facwparser::Element::Text.new('2', '2')
    ], Facwparser::Parser.parse_value('1[hoge\]]2', {}))
  end

  def test_parse_value_bold
      assert_equal([
        Facwparser::Element::Text.new('1', '1'),
        Facwparser::Element::Bold.new('*hoge*', 'hoge'),
        Facwparser::Element::Text.new('2', '2')
    ], Facwparser::Parser.parse_value('1*hoge*2', {}))
  end

  def test_parse_value_italic
      assert_equal([
        Facwparser::Element::Text.new('1', '1'),
        Facwparser::Element::Italic.new('_hoge_', 'hoge'),
        Facwparser::Element::Text.new('2', '2')
    ], Facwparser::Parser.parse_value('1_hoge_2', {}))
  end

  def test_parse_value_strike
      assert_equal([
        Facwparser::Element::Text.new('1', '1'),
        Facwparser::Element::Strike.new('-hoge\-i-', 'hoge-i'),
        Facwparser::Element::Text.new('2', '2')
    ], Facwparser::Parser.parse_value('1-hoge\-i-2', {}))
  end

  def test_parse_value_under
      assert_equal([
        Facwparser::Element::Text.new('1', '1'),
        Facwparser::Element::Under.new('+hoge+', 'hoge'),
        Facwparser::Element::Text.new('2', '2')
    ], Facwparser::Parser.parse_value('1+hoge+2', {}))
  end

  def test_parse_value_image
      assert_equal([
        Facwparser::Element::Text.new('1', '1'),
        Facwparser::Element::Image.new('!http://www.unixuser.org/!', 'http://www.unixuser.org/'),
        Facwparser::Element::Text.new('2', '2')
    ], Facwparser::Parser.parse_value('1!http://www.unixuser.org/!2', {}))
  end

  def test_parse_value_jira_macro
      assert_equal([
        Facwparser::Element::Text.new('1', '1'),
        Facwparser::Element::JiraMacro.new('{jira:SYSTEMRD-1}', 'SYSTEMRD-1'),
        Facwparser::Element::Text.new('2', '2')
    ], Facwparser::Parser.parse_value('1{jira:SYSTEMRD-1}2', {}))
  end

  def test_parse_value_jira_misc
      assert_equal([
        Facwparser::Element::Text.new('1', '1'),
        Facwparser::Element::Text.new('{jira:SYSTEMRD-1', '{jira:SYSTEMRD-1'),
    ], Facwparser::Parser.parse_value('1{jira:SYSTEMRD-1', {}))

      assert_equal([
        Facwparser::Element::Text.new('1', '1'),
        Facwparser::Element::Text.new('{jira:SYSTEMRD\-1', '{jira:SYSTEMRD-1'),
    ], Facwparser::Parser.parse_value('1{jira:SYSTEMRD\-1', {}))

      assert_equal([
        Facwparser::Element::Text.new('1', '1'),
        Facwparser::Element::Text.new('\{', '{'),
        Facwparser::Element::Text.new('jira:SYSTEMRD', 'jira:SYSTEMRD'),
        Facwparser::Element::Text.new('\\-', '-'),
        Facwparser::Element::Text.new('1', '1'),
    ], Facwparser::Parser.parse_value('1\\{jira:SYSTEMRD\\-1', {}))

      assert_equal([
        Facwparser::Element::Text.new('1', '1'),
        Facwparser::Element::Text.new('\{', '{'),
        Facwparser::Element::JiraMacro.new('{jira:SYSTEMRD\-1}', 'SYSTEMRD-1'),
    ], Facwparser::Parser.parse_value('1\\{{jira:SYSTEMRD\\-1}', {}))

  end

end

