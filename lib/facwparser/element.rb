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
      def ==(other)
        super(other) && self.level == other.level && self.content == other.content
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
      def ==(other)
        super(other) && self.type == other.type && self.level == other.level && self.content == other.content
      end
    end
  end
end
