# -*- encoding: utf-8 -*-

require 'strscan'

require File.dirname(__FILE__) + '/element'

module Facwparser
  module Parse
    def self.parse(content, options = {})
      elements = parse1(content, options)
      processed_elements = process_elements(elements, options)
    end

    def self.process_elements(elements, options)
      add_list_elements(elements, options)
    end

    def self.add_list_elements(elements, options)
      processed = []
      list_stack = []
      elements.each { |e|
        case
        when e.class == Element::ListItem
          while list_stack.size > e.level
            processed << Element::ListEnd.new(list_stack.pop.type)
          end
          while list_stack.size < e.level
            start = Element::ListStart.new(e.symbols[list_stack.size])
            processed << start
            list_stack.push(start)
          end
          processed << e
        else
          while list_stack.size > 0
            processed << Element::ListEnd.new(list_stack.pop.type)
          end
          processed << e
        end
      }
      while list_stack.size > 0
        processed << Element::ListEnd.new(list_stack.pop.type)
      end
      processed
    end

    def self.parse1(content, options)
      s = StringScanner.new(content + "\n")

      elements = []

      p = nil

      while s.rest?
        case
        when s.scan(/h(\d)\.[ \t\f]+(.+)\n/)
          p = nil
          elements << Element::Heading.new(s[0], s[1].to_i, s[2])
        when s.scan(/----+\n/)
          p = nil
          elements << Element::HorizontalRule.new(s[0])
        when s.scan(/([*\-#]+)[ \t\f]+(.+)\n/)
          p = nil
          elements << Element::ListItem.new(s[0], [1], s[2])
        when s.scan(/\|\|.+\|\|[ \t\f]*\n/)
          p = nil
          elements << Element::TableHeaders.new(s[0])
        when s.scan(/\|.+\|[ \t\f]*\n/)
          p = nil
          elements << Element::TableData.new(s[0])
        when s.scan(/\{toc(:.*)?\}[ \t\f]*\n/)
          p = nil
          elements << Element::TocMacro.new(s[0], s[1] ? s[1][1,] : nil)
        when s.scan(/\{pagetree(:.*)?\}[ \t\f]*\n/)
          p = nil
          elements << Element::PagetreeMacro.new(s[0], s[1] ? s[1][1,] : nil)
        when s.scan(/\{noformat\}[ \t\f]*\n(?m)(.+?\n)\{noformat\}[ \t\f]*\n/)
          p = nil
          elements << Element::NoformatMacro.new(s[0], s[1])
        when s.scan(/\{code(:.*?)?\}[ \t\f]*\n(?m)(.+?\n)\{code\}[ \t\f]*\n/)
          p = nil
          elements << Element::CodeMacro.new(s[0], s[1], s[2])
        when s.scan(/[ \t\f]*\n/)
          p = nil
        when s.scan(/(.+)\n/)
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

    def self.parse_value
      # TODO:
      # link
      # img
      # strong....
      # macro: jira
    end
  end
end
