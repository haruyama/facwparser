# -*- encoding: utf-8 -*-

require 'strscan'

require File.dirname(__FILE__) + '/element'

module Facwparser
  module Parser
    def self.parse(content, options = {})
      elements = parse1(content, options)
      process_elements(elements, options)
    end

    def self.process_elements(elements, options)
      processed = add_list_elements(elements, options)
      processed = add_table_elements(processed, options)
      processed = add_toc(processed, options)
      processed
    end

    def self.add_toc(elements, options)
      tocs = elements.select{ |e| e.class == Element::TocMacro}
      if !tocs.empty?
        headings = elements.select{ |e| e.class == Element::Heading && e.level == 1}
        id = 0
        headings.each { |h|
          h.id = 'heading_' + id.to_s
          id += 1
        }
        tocs.each {|t| t.headings = headings }
      end
      elements
    end

    def self.add_list_elements(elements, options)
      processed = []
      list_stack = []
      elements.each { |e|
        case
        when e.class == Element::ListItem
          while list_stack.size > e.level
            list_stack.pop
          end
          while list_stack.size < e.level
            list = Element::List.new(e.symbols[list_stack.size])
            if list_stack.empty?
              processed << list
            else
              list_stack[-1].push list
            end
            list_stack << list
          end
          list_stack[-1].push e
        else
          list_stack.clear if list_stack.size > 0
          processed << e
        end
      }
      processed
    end

    def self.add_table_elements(elements, options)
      processed = []
      table = nil
      elements.each { |e|
        case
        when e.class == Element::TableHeaders || e.class == Element::TableData
          if !table
            table = Element::Table.new
            processed << table
          end
          table.push e
        else
          table = nil
          processed << e
        end
      }
      processed
    end

    def self.parse1(content, options)
      s = StringScanner.new(content.gsub("\r", '').gsub(/[\t\f]/, ' ') + "\n")

      elements = []

      p = nil

      while s.rest?
        case
        when s.scan(/h(\d)\. +(.+)\n/)
          p = nil
          elements << Element::Heading.new(s[0], s[1].to_i, s[2])
        when s.scan(/----+\n/)
          p = nil
          elements << Element::HorizontalRule.new(s[0])
        when s.scan(/([*\-#]+) +(.+)\n/)
          p = nil
          elements << Element::ListItem.new(s[0], s[1], s[2])
        when s.scan(/(\|\|.+\|\|) *\n/)
          p = nil
          elements << Element::TableHeaders.new(s[0], s[1])
        when s.scan(/(\|.+\|) *\n/)
          p = nil
          elements << Element::TableData.new(s[0], s[1])
        when s.scan(/\{toc(:.*)?\} *\n/)
          p = nil
          elements << Element::TocMacro.new(s[0], s[1] ? s[1][1,] : nil)
        when s.scan(/\{noformat\} *\n(?m)(.+?\n)\{noformat\} *\n/)
          p = nil
          elements << Element::NoformatMacro.new(s[0], s[1])
        when s.scan(/\{code(:.*?)?\} *\n(?m)(.+?\n)\{code\} *\n/)
          p = nil
          elements << Element::CodeMacro.new(s[0], s[1], s[2])
        when s.scan(/\{quote\} *\n(?m)(.+?\n)\{quote\} *\n/)
          p = nil
          elements << Element::QuoteMacro.new(s[0], s[1])
        when s.scan(/ *\n/)
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

    def self.unescape_text(text)
      text.gsub(/\\([\[\]\*+_?{}!^~-])/) {
        $1
      }
    end

    def self.parse_value(value, options)

      #jira
      #img

      children = []

      value.split("\n").each { |l|
        s = StringScanner.new(l)
        while s.rest?
          case
          when s.scan(/\[(.+?)(?<!\\)\]/)
            children << Element::A.new(s[0], unescape_text(s[1]))
          when s.scan(/\*(.+?)(?<!\\)\*/)
            children << Element::Strong.new(s[0], unescape_text(s[1]))
          when s.scan(/\_(.+?)(?<!\\)\_/)
            children << Element::Emphasis.new(s[0], unescape_text(s[1]))
          when s.scan(/\-(.+?)(?<!\\)\-/)
            children << Element::Strike.new(s[0], unescape_text(s[1]))
          when s.scan(/\+(.+?)(?<!\\)\+/)
            children << Element::Under.new(s[0], unescape_text(s[1]))
          when s.scan(/\^(.+?)(?<!\\)\^/)
            children << Element::Sup.new(s[0], unescape_text(s[1]))
          when s.scan(/\~(.+?)(?<!\\)\~/)
            children << Element::Sub.new(s[0], unescape_text(s[1]))
          when s.scan(/\?\?(.+?)(?<!\\)\?\?/)
            children << Element::Q.new(s[0], unescape_text(s[1]))
          when s.scan(/\{\{(.+?)(?<!\\)\}\}/)
            children << Element::Monospace.new(s[0], unescape_text(s[1]))
          when s.scan(/\!(https?:(?:.+?))(?<!\\)\!/)
            children << Element::Image.new(s[0], unescape_text(s[1]))
          when s.scan(/\!(\/(?:.+?))(?<!\\)\!/)
            children << Element::Image.new(s[0], unescape_text(s[1]))
          when s.scan(/\{jira:(.+?)(?<!\\)\}/)
            children << Element::JiraMacro.new(s[0], unescape_text(s[1]))
          when s.scan(/\{color:(.+?)(?<!\\)\}/)
            children << Element::ColorMacroStart.new(s[0], unescape_text(s[1]))
          when s.scan(/\{color\}/)
            children << Element::ColorMacroEnd.new(s[0])
          when s.scan(/[^\[\a^\\*+_?{}!-]+/)
            children << Element::Text.new(s[0], unescape_text(s[0]))
          when s.scan(/\\\\/)
            children << Element::Br.new(s[0])
          when s.scan(/\\[\[\]\*+_?{}!^~-]/)
            children << Element::Text.new(s[0], unescape_text(s[0]))
          else
            children << Element::Text.new(s.rest, unescape_text(s.rest))
            break
          end
        end
      }

      children
    end
  end
end
