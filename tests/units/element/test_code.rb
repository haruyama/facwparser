# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/element'


class TestCode < Test::Unit::TestCase

  def test_code_1
    code = Facwparser::Element::CodeMacro.new("{code:perl}\n*a*\n{code}\n", ':perl', '*a*')
    assert_equal(%Q{<pre class="perl">\n<code>*a*</code>\n</pre>\n},
                 code.render_html({}))
  end

end

