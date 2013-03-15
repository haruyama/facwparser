# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/element'


class TestP < Test::Unit::TestCase

  def test_p_1
    p = Facwparser::Element::P.new('hoge')
    assert_equal("<p>hoge</p>\n",
                 p.render_html({}))
  end

  def test_p_2
    p = Facwparser::Element::P.new("hoge\nkuke")
    assert_equal("<p>hogekuke</p>\n",
                 p.render_html({}))
  end

  def test_p_3
    p = Facwparser::Element::P.new("hoge\\\\\nkuke")
    assert_equal("<p>hoge<br>kuke</p>\n",
                 p.render_html({}))
  end

  def test_p_4
    p = Facwparser::Element::P.new("<>")
    assert_equal("<p>&lt;&gt;</p>\n",
                 p.render_html({}))
  end

  def test_p_blockquote
    p = Facwparser::Element::P.new('bq. hoge')
    assert_equal("<blockquote>\n<p>hoge</p>\n</blockquote>\n",
                 p.render_html({}))
  end

  def test_p_blockquote_2
    p = Facwparser::Element::P.new(" bq. hoge\n kuke")
    assert_equal("<blockquote>\n<p>hoge<br> kuke</p>\n</blockquote>\n",
                 p.render_html({}))
  end
end

