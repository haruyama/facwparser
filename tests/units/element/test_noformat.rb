# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/element'


class TestNoformat < Test::Unit::TestCase

  def test_noformat_1
    noformat = Facwparser::Element::NoformatMacro.new("{noformat}\n*a*\n{noformat}\n", '*a*')
    assert_equal(%Q{<pre class="noformat">\n*a*\n</pre>\n},
                 noformat.render_html({}))
  end

end

