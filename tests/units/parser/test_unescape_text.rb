# -*- encoding: utf-8 -*-
require 'test/unit'
require File.dirname(__FILE__) + '/../../../lib/facwparser/parser'


class TestUnescapeText < Test::Unit::TestCase

  def test_unescape_text

    %w( [ ] \\ * + _ ? { } ! ^ ~ - ).each { |e|
      assert_equal(e, Facwparser::Parser.unescape_text('\\' + e))
    }

    assert_equal('hogehoge', Facwparser::Parser.unescape_text('hogehoge'))
    assert_equal('hoge[]', Facwparser::Parser.unescape_text('hoge\[\]'))
    assert_equal('hoge\\', Facwparser::Parser.unescape_text('hoge\\\\'))
    assert_equal('hoge*', Facwparser::Parser.unescape_text('hoge\*'))
    assert_equal('hoge+_?{}', Facwparser::Parser.unescape_text('hoge\+\_\?\{\}'))
    assert_equal('hoge!^~-', Facwparser::Parser.unescape_text('hoge\!\^\~\-'))

    assert_equal('hoge[]', Facwparser::Parser.unescape_text('hoge[]'))
    assert_equal('hoge\\', Facwparser::Parser.unescape_text('hoge\\'))
    assert_equal('hoge*', Facwparser::Parser.unescape_text('hoge*'))
    assert_equal('hoge+_?{}', Facwparser::Parser.unescape_text('hoge+_?{}'))
    assert_equal('hoge!^~-', Facwparser::Parser.unescape_text('hoge!^~-'))
  end
end
