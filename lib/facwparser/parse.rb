# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + '/element'
require 'strscan'

module Facwparser
  module Parse
    def self.parse(content, options = {})
      parse1(content, options)
    end

    def self.parse1(content, options)
      s = StringScanner.new(content + "\n")

      elements = []

      p = nil

      while !s.eos?
        case
        when s.scan(/\s*\n/)
          p = nil
        when s.scan(/h(\d)\.\s+(.+)\n/)
          p = nil
          elements << Element::Heading.new(s[0], s[1].to_i, s[2])
        when s.scan(/----+\n/)
          p = nil
          elements << Element::HorizontalRule.new(s[0])
        when s.scan(/(.+)\n/)
          if p
            p.append(s[0])
          else
            p = Element::P.new(s[0])
            elements << p
          end
        else
          raise "Parse Error. rest=#{ s.rest }"
        end
      end
      elements
    end
  end
end
