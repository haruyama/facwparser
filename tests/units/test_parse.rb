# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../lib/facwparser/parse'


class TestParse < Test::Unit::TestCase

  def test_parse1_p
    source =<<EOS
ほげ

ほげほげ

ほげほげげほ
にゃ
EOS
    assert_equal(
      [
        Facwparser::Element::P.new("ほげ"),
        Facwparser::Element::P.new("ほげほげ"),
        Facwparser::Element::P.new("ほげほげげほにゃ"),
      ],
      Facwparser::Parse.parse1(source, {}))

  end

  def test_parse1_heading
    source =<<EOS
h1. ほげ

ほげほげ
h3.  ほげほげげほ
にゃ
EOS
    assert_equal(
      [
        Facwparser::Element::Heading.new("h1. ほげ", 1, "ほげ"),
        Facwparser::Element::P.new("ほげほげ"),
        Facwparser::Element::Heading.new("h3.  ほげほげげほ", 3, "ほげほげげほ"),
        Facwparser::Element::P.new("にゃ"),
      ],
      Facwparser::Parse.parse1(source, {}))

  end

  def test_parse1_horizontal_rule
    source =<<EOS
1
----
2
---
3

-----
4
EOS
    assert_equal(
      [
        Facwparser::Element::P.new("1"),
        Facwparser::Element::HorizontalRule.new("----"),
        Facwparser::Element::P.new("2---3"),
        Facwparser::Element::HorizontalRule.new("-----"),
        Facwparser::Element::P.new("4"),
      ],
      Facwparser::Parse.parse1(source, {}))

  end

  def test_parse1_list_item
    source =<<EOS
1
- 2
3
** 4
### 5
#*#* 6
EOS
    assert_equal(
      [
        Facwparser::Element::P.new("1"),
        Facwparser::Element::ListItem.new("- 2", '-', '2'),
        Facwparser::Element::P.new("3"),
        Facwparser::Element::ListItem.new("** 4", '**', '4'),
        Facwparser::Element::ListItem.new("### 5", '###', '5'),
        Facwparser::Element::ListItem.new("#*#* 6", '#*#*', '6'),
      ],
      Facwparser::Parse.parse1(source, {}))

  end

end
