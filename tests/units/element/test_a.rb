# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/element'

class TestP < Test::Unit::TestCase

  def test_a_1
    a = Facwparser::Element::A.new('[hoge|http://www.unixuser.org]', 'hoge|http://www.unixuser.org')
    assert_equal(%Q{<a href="http://www.unixuser.org">hoge</a>},
                 a.render_html({}))
  end

  def test_a_2
    a = Facwparser::Element::A.new('[http://www.unixuser.org]', 'http://www.unixuser.org')
    assert_equal(%Q{<a href="http://www.unixuser.org">http://www.unixuser.org</a>},
                 a.render_html({}))
  end

  def test_a_3
    a = Facwparser::Element::A.new('[hoge]', 'hoge')
    assert_equal(%Q{<a href="/hoge">hoge</a>},
                 a.render_html({}))
  end

  def test_a_4
    a = Facwparser::Element::A.new('[hoge]', 'hoge')
    assert_equal(%Q{<a href="http://www.unixuser.org/hoge">hoge</a>},
                 a.render_html({'url_prefix' => 'http://www.unixuser.org/'}))
  end
end
