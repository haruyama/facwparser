# -*- encoding: utf-8 -*-

require 'cgi'
require File.dirname(__FILE__) + '/parser'


module Facwparser
  module Element
    class ElementBase
      attr_reader :source, :children
      def initialize(source)
        @source   = source
        @children = nil
      end
      def ==(other)
        self.class == other.class && self.source == other.source
      end

      def render_html(options)
        raise "TODO: render_html is not implemented: " + self.class.to_s + "\n"
      end
      private
      def render_html_by_name_and_value(name, value, element_join_char = '')
        ["<#{CGI.escapeHTML name}>", CGI.escapeHTML(value), "</#{CGI.escapeHTML name}>"].join(element_join_char)
      end
      def render_html_by_name_and_childlen(name, children, options, childlen_join_char = '', element_join_char = '')
        ["<#{CGI.escapeHTML name}>", children.map {|c| c.render_html(options) }.join(childlen_join_char), "</#{CGI.escapeHTML name}>"].join(element_join_char)
      end
    end

    class P < ElementBase
      def append(source)
        @source += source
      end
      def render_html(options)
        if @source =~ /\A *bq. (.+)/m
          "<blockquote>\n" +
            render_html_by_name_and_value('p', $1).gsub("\n", '<br>') + "\n" +
            "</blockquote>\n"
        else
          @children ||= Parser.parse_value(@source, options)
          render_html_by_name_and_childlen('p', @children, options) + "\n"
        end
      end
    end
    class HorizontalRule < ElementBase
      def render_html(options)
        "<hr>\n"
      end
    end
    class Heading < ElementBase
      attr_reader :level, :value
      def initialize(source, level, value)
        super(source)
        @level = level
        @value = value
      end
      def render_html(options)
        @children = Parser.parse_value value, options
        render_html_by_name_and_childlen("h#{level}", @children, options) + "\n"
      end
    end
    class List < ElementBase
      attr_reader :type
      def initialize(type)
        super('')
        @type = type
      end
      def push(item)
        @children ||= []
        @children.push(item)
        self
      end
      def render_html(options)
        (render_html_by_name_and_childlen(@type == '#' ? 'ol' : 'ul', @children, options, "\n", "\n") + "\n").gsub("\n\n", "\n")
      end
    end
    class ListItem < ElementBase
      attr_reader :symbols, :level, :value
      def initialize(source, symbols, value)
        super(source)
        @symbols = symbols
        @level   = symbols.size
        @value = value
      end
      def render_html(options)
        @children ||= Parser.parse_value value, options
        render_html_by_name_and_childlen('li', @children, options)
      end
    end
    class Table < ElementBase
      def initialize()
        super('')
      end
      def push(item)
        @children ||= []
        @children.push(item)
        self
      end
      def render_html(options)
        "<table>\n" +
        render_html_by_name_and_childlen('thead', @children.take(1), options, "\n", "\n") + "\n" +
        render_html_by_name_and_childlen('tbody', @children.drop(1), options, "\n", "\n") + "\n" +
        "</table>\n"
      end
    end
    class TableHeaders < ElementBase
      attr_reader :elements
      def initialize(source)
        super(source)
        @elements = source[2..-3].split('||')
      end
      def render_html(options)
        "<tr>" +
          @elements.map { |e| render_html_by_name_and_childlen('th', Parser.parse_value(e, options), options) }.join() +
        "</tr>"
      end
    end
    class TableData < ElementBase
      attr_reader :elements
      def initialize(source)
        super(source)
        @elements = []
        element = ''
        s = StringScanner.new(source[1..-2])
        in_link = false
        while s.rest?
          case
          when s.scan(/[^|\[\]]+/) || s.scan(/\\\[/) || s.scan(/\\\]/) || s.scan(/\\\|/)
            element += s[0]
          when s.scan(/\[/)
            in_link = true
            element += s[0]
          when s.scan(/\]/)
            in_link = false
            element += s[0]
          when s.scan(/\|/)
            if in_link
              element += s[0]
            else
              @elements << element
              element = ''
            end
          else
            element += s.rest
            break
          end
        end
        @elements << element if !element.empty?
      end
      def render_html(options)
        "<tr>" +
          @elements.map { |e| render_html_by_name_and_childlen('td', Parser.parse_value(e, options), options) }.join() +
        "</tr>"
      end
    end

    class MacroBase < ElementBase
    end
    class TocMacro < MacroBase
      def initialize(source, options = nil)
        super(source)
        @options = options
      end
      def render_html(options)
        "TODO: table of contents Macro\n"
      end
    end
    class PagetreeMacro < MacroBase
      def initialize(source, options = nil)
        super(source)
        @options = options
      end
      def render_html(options)
        "TODO: pagetree macro\n"
      end
    end
    class NoformatMacro < MacroBase
      def initialize(source, value)
        super(source)
        @value = value
      end
      def render_html(options)
        render_html_by_name_and_value('pre', @value, "\n") + "\n"
      end
    end
    class CodeMacro < MacroBase
      def initialize(source, options, value)
        super(source)
        @options = options
        @value = value
      end
      def render_html(options)
        "<code class=\"#{CGI.escapeHTML(@options[1..-1])}\">\n" +
          render_html_by_name_and_value('pre', @value, "\n") + "\n" +
          "</code>"
      end
    end
    class QuoteMacro < MacroBase
      def initialize(source, value)
        super(source)
        @value = value
      end
      def render_html(options)
        "<blockquote>\n" +
          render_html_by_name_and_value('p', @value).gsub("\n", '<br>') + "\n" +
          "</blockquote>\n"
      end
    end

    class InlineElementBase < ElementBase
      attr_reader :text
      def initialize(source, text)
        super(source)
        @text = text
      end
      def ==(other)
        super(other) && self.text == other.text
      end
    end

    class A < InlineElementBase
      def render_html(options)
        if @text =~ /\A(.+)\|((?:https?|ftp|file):.+)\z/
          return '<a href="' + CGI.escapeHTML($2) +'">' + CGI.escapeHTML($1) + '</a>'
        elsif @text =~ /\A(?:https?|ftp|file):.+\z/
          return '<a href="' + CGI.escapeHTML(@text) +'">' + CGI.escapeHTML(@text) + '</a>'
        else
          return '[' + CGI.escapeHTML(@text) + ']'
        end
      end
    end

    class Bold < InlineElementBase
      def render_html(options)
        render_html_by_name_and_value('b', @text)
      end
    end

    class Italic < InlineElementBase
      def render_html(options)
        render_html_by_name_and_value('i', @text)
      end
    end

    class Strike < InlineElementBase
      def render_html(options)
        render_html_by_name_and_value('s', @text)
      end
    end

    class Under < InlineElementBase
      def render_html(options)
        render_html_by_name_and_value('u', @text)
      end
    end

    class Q < InlineElementBase
      def render_html(options)
        render_html_by_name_and_value('q', @text)
      end
    end

    class SUP < InlineElementBase
      def render_html(options)
        render_html_by_name_and_value('sup', @text)
      end
    end

    class SUB < InlineElementBase
      def render_html(options)
        render_html_by_name_and_value('sub', @text)
      end
    end

    class TT < InlineElementBase
      def render_html(options)
        render_html_by_name_and_value('tt', @text)
      end
    end

    class Image < InlineElementBase
      def render_html(options)
        '<img src="' + CGI.escapeHTML(@text) + '">'
      end
    end

    class JiraMacro < MacroBase
      attr_reader :options
      def initialize(source, options)
        super(source)
        @options = options
      end
      def render_html(options)
        jira_browse_url = (options && options['jira_browse_url']) || ''
        return '<a href="' + CGI.escapeHTML(jira_browse_url + @options) +'">' + CGI.escapeHTML(@options) + '</a>'
      end
    end

    class ColorMacroStart < MacroBase
      attr_reader :options
      def initialize(source, options)
        super(source)
        @options = options
      end
      def render_html(options)
        return '<font color="' + CGI.escapeHTML(@options) +'">'
      end
    end

    class ColorMacroEnd < MacroBase
      def initialize(source)
        super(source)
      end
      def render_html(options)
        return '</font>'
      end
    end

    class Text < InlineElementBase
      def render_html(options)
        CGI.escapeHTML @source
      end
    end

    class Br < InlineElementBase
      def render_html(options)
        '<br>'
      end
    end

  end
end
