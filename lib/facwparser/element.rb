# -*- encoding: utf-8 -*-
module Facwparser
  module Element
    class ElementBase
      attr_reader :source, :children
      def initialize(source)
        @source   = source
        @children = []
      end
      def ==(other)
        self.class == other.class && self.source == other.source
      end
    end
    class P < ElementBase
      def append(source)
        @source += source
      end
    end
    class HorizontalRule < ElementBase
    end
    class Heading < ElementBase
      attr_reader :level, :value
      def initialize(source, level, value)
        super(source)
        @level = level
        @value = value
      end
    end
    class List < ElementBase
      attr_reader :type
      def initialize(type)
        super('')
        @type = type
      end
      def push(item)
        children.push(item)
        self
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
    end
    class CodeMacro < MacroBase
      def initialize(source, options, value)
        super(source)
        @options = options
        @value = value
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
    end

    class Bold < InlineElementBase
    end

    class Italic < InlineElementBase
    end

    class Strike < InlineElementBase
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
    end

    class Text < InlineElementBase
    end
  end
end
