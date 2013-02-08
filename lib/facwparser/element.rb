# -*- encoding: utf-8 -*-

require 'cgi'


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
    end

    class P < ElementBase
      def append(source)
        @source += source
      end
      def render_html(options)
        @children ||= Parser.parse_value(source, options)
        "<p>\n" + @children.map { |c| c.render_html(options) }.join("\n")  + "<p>\n"
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
        "<h#{level}>#{CGI.escapeHTML value}</h#{level}>\n"
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
        case @type
        when '#'
          return "<ol>\n" + @children.map{ |c| c.render_html(options) }.join(" ") + "</ol>\n"
        else
          return "<ul>\n" + @children.map{ |c| c.render_html(options) }.join(" ") + "</ul>\n"
        end
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
        @children = Parser.parse_value value, options
        "<li>" + @children.map {|c| c.render_html(options) }.join(" ") + "</li>\n"
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
        "<table><thead>\n" + @children[0].render_html(options) +
        "\n</thead>\n<tbody>\n" +
        @children.drop(1).map{|c| c.render_html(options)}.join("\n") +
        "\n</tbody></table>\n"
      end
    end
    class TableHeaders < ElementBase
      attr_reader :elements
      def initialize(source)
        super(source)
        @elements = source.split('||')[1..-2]
      end
      def render_html(options)
        "<tr>" +
          @elements.map { |e| '<th>' + CGI.escapeHTML(e.strip) + '</th>'}.join() +
        "</tr>"
      end
    end
    class TableData < ElementBase
      attr_reader :elements
      def initialize(source)
        super(source)
        @elements = source.split('|')[1..-2]
      end
      def render_html(options)
        "<tr>" +
          @elements.map { |e| '<td>' + CGI.escapeHTML(e.strip) + '</td>'}.join() +
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
        "<pre>\n#{CGI.escapeHTML @value}\n</pre>\n"
      end
    end
    class CodeMacro < MacroBase
      def initialize(source, options, value)
        super(source)
        @options = options
        @value = value
      end
      def render_html(options)
        "<code class=\"code_#{CGI.escapeHTML(@options[1..-1])}\"><pre>\n#{CGI.escapeHTML @value}\n</pre></code>\n"
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
        "<em>#{CGI.escapeHTML(@text)}</em>"
      end
    end

    class Italic < InlineElementBase
      def render_html(options)
        "<i>#{CGI.escapeHTML(@text)}</i>"
      end
    end

    class Strike < InlineElementBase
      def render_html(options)
        "<s>#{CGI.escapeHTML(@text)}</s>"
      end
    end

    class Under < InlineElementBase
      def render_html(options)
        "<u>#{CGI.escapeHTML(@text)}</u>"
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
        return '<a href="' + CGI.escapeHTML(jira_browse_url) + CGI.escapeHTML(@options) +'>' + CGI.escapeHTML(@options) + '</a>'
      end
    end

    class Text < InlineElementBase
      def render_html(options)
        CGI.escapeHTML @source
      end
    end
  end
end
