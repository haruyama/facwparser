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
    heading = Facwparser::Element::Heading.new('h3. hoge>', 3, 'hoge>')
    assert_equal("<h3>hoge&gt;</h3>\n",
                 heading.render_html({}))
    assert_equal(%Q{hoge>},
                 heading.render_text({}))
  end

  def test_heading_3
    heading = Facwparser::Element::Heading.new('h1. hoge[http://www.unixuser.org]', 1, 'hoge[http://www.unixuser.org]')
    assert_equal(%Q{<h1>hoge<a href="http://www.unixuser.org">http://www.unixuser.org</a></h1>\n},
                 heading.render_html({}))
    assert_equal(%Q{hogehttp://www.unixuser.org},
                 heading.render_text({}))
  end

  def test_heading_4
    heading = Facwparser::Element::Heading.new('h1. hoge [http://www.unixuser.org]', 1, 'hoge [http://www.unixuser.org]')
    assert_equal(%Q{<h1>hoge <a href="http://www.unixuser.org">http://www.unixuser.org</a></h1>\n},
                 heading.render_html({}))
    assert_equal(%Q{hoge http://www.unixuser.org},
                 heading.render_text({}))
  end
  def test_heading_5
    heading = Facwparser::Element::Heading.new('h1. hoge[http://www.unixuser.org]', 1, 'hoge[http://www.unixuser.org]')
    heading.id = 'heading_0'
    assert_equal(%Q{<h1 id="heading_0">hoge<a href="http://www.unixuser.org">http://www.unixuser.org</a></h1>\n},
                 heading.render_html({}))
    assert_equal(%Q{hogehttp://www.unixuser.org},
                 heading.render_text({}))
  end

  def test_heading_6
    heading = Facwparser::Element::Heading.new('h1. hoge[http://www.unixuser.org]', 1, 'hoge[http://www.unixuser.org]')
    heading.id = 'he<ading_0'
    assert_equal(%Q{<h1 id="he&lt;ading_0">hoge<a href="http://www.unixuser.org">http://www.unixuser.org</a></h1>\n},
                 heading.render_html({}))
    assert_equal(%Q{hogehttp://www.unixuser.org},
                 heading.render_text({}))
  end
end

