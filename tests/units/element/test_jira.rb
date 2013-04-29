# -*- encoding: utf-8 -*-
require 'test/unit'

require_relative '../../../lib/facwparser/element'

class TestJira < Test::Unit::TestCase

  def test_toc_1
    jira = Facwparser::Element::JiraMacro.new('{jira:TICKET-<}', 'TICKET-<')

    assert_equal(%Q{<a href="TICKET-&lt;">TICKET-&lt;</a>},
                 jira.render_html({}))
    assert_equal(%Q{<a href="http://jira/browse/TICKET-&lt;">TICKET-&lt;</a>},
                 jira.render_html({'jira_browse_url' => 'http://jira/browse/'}))
  end
end
