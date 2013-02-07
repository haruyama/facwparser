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
        case type
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
    class TableHeaders < ElementBase
      attr_reader :elements
      def initialize(source)
        super(source)
        @elements = source.split('||')[1..-2]
      end
    end
    class TableData < ElementBase
      attr_reader :elements
      def initialize(source)
        super(source)
        @elements = source.split('|')[1..-2]
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
        "TODO: table of contents\n"
      end
    end
    class PagetreeMacro < MacroBase
      def initialize(source, options = nil)
        super(source)
        @options = options
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
        #TODO: syntax highlight
        "<code><pre>\n#{CGI.escapeHTML @value}\n</pre></code>\n"
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
        "<p>TODO: A.render_html: " + CGI.escapeHTML(@text) + "</p>"
      end
    end

    class Bold < InlineElementBase
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
    end

    class Image < InlineElementBase
    end

    class JiraMacro < MacroBase
      def initialize(source, options)
        super(source)
        @options = options
      end
      def render_html(options)
        "<p>TODO: JiraMacro.render_html: " + CGI.escapeHTML(@options) + "</p>"
      end
    end

    class Text < InlineElementBase
      def render_html(options)
        CGI.escapeHTML source
      end
    end
  end
end
