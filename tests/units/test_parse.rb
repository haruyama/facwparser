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
        Facwparser::Element::P.new("ほげ\n"),
        Facwparser::Element::P.new("ほげほげ\n"),
        Facwparser::Element::P.new("ほげほげげほ\nにゃ\n"),
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
        Facwparser::Element::Heading.new("h1. ほげ\n", 1, "ほげ"),
        Facwparser::Element::P.new("ほげほげ\n"),
        Facwparser::Element::Heading.new("h3.  ほげほげげほ\n", 3, "ほげほげげほ"),
        Facwparser::Element::P.new("にゃ\n"),
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
        Facwparser::Element::P.new("1\n"),
        Facwparser::Element::HorizontalRule.new("----\n"),
        Facwparser::Element::P.new("2\n---\n3\n"),
        Facwparser::Element::HorizontalRule.new("-----\n"),
        Facwparser::Element::P.new("4\n"),
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
        Facwparser::Element::P.new("1\n"),
        Facwparser::Element::ListItem.new("- 2\n", '-', '2'),
        Facwparser::Element::P.new("3\n"),
        Facwparser::Element::ListItem.new("** 4\n", '**', '4'),
        Facwparser::Element::ListItem.new("### 5\n", '###', '5'),
        Facwparser::Element::ListItem.new("#*#* 6\n", '#*#*', '6'),
      ],
      Facwparser::Parse.parse1(source, {}))

  end

  def test_parse1_table
    source =<<EOS
1
||2||3||
|4|5|
6
EOS
    assert_equal(
      [
        Facwparser::Element::P.new("1\n"),
        Facwparser::Element::TableHeaders.new("||2||3||\n"),
        Facwparser::Element::TableData.new("|4|5|\n"),
        Facwparser::Element::P.new("6\n"),
      ],
      Facwparser::Parse.parse1(source, {}))

  end

  def test_parse1_toc_1
    source =<<EOS
1
{toc}
2
EOS
    assert_equal(
      [
        Facwparser::Element::P.new("1\n"),
        Facwparser::Element::TocMacro.new("{toc}\n"),
        Facwparser::Element::P.new("2\n"),
      ],
      Facwparser::Parse.parse1(source, {}))

  end

  def test_parse1_toc_2
    source =<<EOS
1
{toc:max_level=3}
2
EOS
    assert_equal(
      [
        Facwparser::Element::P.new("1\n"),
        Facwparser::Element::TocMacro.new("{toc:max_level=3}\n"),
        Facwparser::Element::P.new("2\n"),
      ],
      Facwparser::Parse.parse1(source, {}))

  end

end
