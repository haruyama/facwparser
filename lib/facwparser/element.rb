# -*- encoding: utf-8 -*-
module Facwparser
  module Element
    class ElementBase
      attr_reader :source
      def initialize(source)
        @source = source
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
      attr_reader :level, :content
      def initialize(source, level, content)
        super(source)
        @level = level
        @content = content
      end
    end
    class ListItem < ElementBase
      attr_reader :type, :level, :content
      def initialize(source, symbols, content)
        super(source)
        @type    = symbols[-1]
        @level   = symbols.size
        @content = content
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
      def initialize(source, content)
        super(source)
        @content = content
      end
    end
    class CodeMacro < MacroBase
      def initialize(source, options, content)
        super(source)
        @options = options
        @content = content
      end
    end
  end
end
