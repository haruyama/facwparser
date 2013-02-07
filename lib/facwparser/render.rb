# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + '/element'

module Facwparser
  module Render
    def self.render_html(elements, options = {})
      output = ''
      elements.each { |e|
        output += e.render_html(options)
      }
      output
    end
  end
end
