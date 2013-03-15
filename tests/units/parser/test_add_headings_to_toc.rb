# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/parser'

class TestAddHeadingsToToc < Test::Unit::TestCase

  def test_add_headings_to_toc_1
    toc = Facwparser::Element::TocMacro.new('{toc}');
    pre = [
      toc,
      Facwparser::Element::Heading.new('h1. hoge', 1, 'hoge'),
      Facwparser::Element::Heading.new('h2. hige', 2, 'hige'),
      Facwparser::Element::Heading.new('h1. huge', 1, 'huge'),
    ]
    Facwparser::Parser.add_headings_to_toc(pre, {})
    assert_equal([
      Facwparser::Element::Heading.new('h1. hoge', 1, 'hoge'),
      Facwparser::Element::Heading.new('h1. huge', 1, 'huge'),
    ], toc.headings)

  end

end
