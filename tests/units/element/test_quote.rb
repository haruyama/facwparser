# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/element'

class TestQuote < Test::Unit::TestCase

  def test_quote_=
    quote = Facwparser::Element::QuoteMacro.new("{qoute}\n*a*\n\n{quote}\n", "*a*\n")
    assert_equal(%Q{<blockquote>\n<p>*a*<br></p>\n</blockquote>\n},
                 quote.render_html({}))
  end

end

