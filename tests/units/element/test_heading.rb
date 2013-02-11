# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/element'


class TestHeading < Test::Unit::TestCase

  def test_heading_1
    heading = Facwparser::Element::Heading.new('h1. hoge', 1, 'hoge')
    assert_equal("<h1>hoge</h1>\n",
                 heading.render_html({}))
  end

  def test_heading_2
    heading = Facwparser::Element::Heading.new('h1. hoge>', 1, 'hoge>')
    assert_equal("<h1>hoge&gt;</h1>\n",
                 heading.render_html({}))
  end

  def test_heading_3
    heading = Facwparser::Element::Heading.new('h1. hoge[http://www.unixuser.org]', 1, 'hoge[http://www.unixuser.org]')
    assert_equal(%Q{<h1>hoge<a href="http://www.unixuser.org">http://www.unixuser.org</a></h1>\n},
                 heading.render_html({}))
  end

  def test_heading_4
    heading = Facwparser::Element::Heading.new('h1. hoge [http://www.unixuser.org]', 1, 'hoge [http://www.unixuser.org]')
    assert_equal(%Q{<h1>hoge <a href="http://www.unixuser.org">http://www.unixuser.org</a></h1>\n},
                 heading.render_html({}))
  end
end

