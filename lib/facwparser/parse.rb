# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + '/element'

module Facwparser
  module Parse
    def self.parse(content, options = {})
      parse1(content, options)
    end

    def self.parse1(content, options)
      lines = content.split("\n")

      elements = []

      p = nil

      # TODO:
      # table
      # macro: toc, code, pagetree, noformat, jira
      lines.each { |l|
        case l
        when /\Ah(\d)\.\s+(.+)\z/
          p = nil
          elements << Element::Heading.new(l, $1.to_i, $2)
        when /\A----+\z/
          p = nil
          elements << Element::HorizontalRule.new(l)
        when /\A([*\-#]+)\s+(.+)\z/
          p = nil
          elements << Element::ListItem.new(l, $1, $2)
        when /\A\|\|.+\|\|\s*\z/
          p = nil
          elements << Element::TableHeaders.new(l)
        when /\A\|.+\|\s*\z/
          p = nil
          elements << Element::TableData.new(l)
        when /\A\s*\z/
          p = nil
        when /\A(.+)\z/
          if p
            p.append($1)
          else
            p = Element::P.new($1)
            elements << p
          end
        else
          raise "Parse Error. line=#{l}"
        end
      }
      elements
    end

    def self.parse_content
      # TODO:
      # link
      # img
      # strong....
    end
  end
end
