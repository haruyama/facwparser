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

end
