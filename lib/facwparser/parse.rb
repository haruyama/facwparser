# -*- encoding: utf-8 -*-

require 'strscan'

require File.dirname(__FILE__) + '/element'

module Facwparser
  module Parse
    def self.parse(content, options = {})
      parse1(content, options)
    end

    def self.parse1(content, options)
      s = StringScanner.new(content + "\n")

      elements = []

      p = nil

      # TODO:
      # macro: toc, code, pagetree, noformat
      while !s.eos?
        case
        when s.scan(/h(\d)\.[ \t\v]+(.+?)\n/)
          p = nil
          elements << Element::Heading.new(s[0], s[1].to_i, s[2])
        when s.scan(/----+?\n/)
          p = nil
          elements << Element::HorizontalRule.new(s[0])
        when s.scan(/([*\-#]+)[ \t\v]+(.+?)\n/)
          p = nil
          elements << Element::ListItem.new(s[0], [1], s[2])
        when s.scan(/\|\|.+\|\|\s*?\n/)
          p = nil
          elements << Element::TableHeaders.new(s[0])
        when s.scan(/\|.+\|\s*?\n/)
          p = nil
          elements << Element::TableData.new(s[0])
        when s.scan(/\{toc\}\s*?\n/)
          p = nil
          elements << Element::TocMacro.new(s[0])
        when s.scan(/\s*?\n/)
          p = nil
        when s.scan(/(.+?)\n/)
          if p
            p.append(s[0])
          else
            p = Element::P.new(s[0])
            elements << p
          end
        else
          raise "Parse Error. line=#{s.rest}"
        end
      end
      elements
    end

    def self.parse_content
      # TODO:
      # link
      # img
      # strong....
      # macro: jira
    end
  end
end
