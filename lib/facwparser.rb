require 'facwparser/version'
require 'facwparser/parser'
require 'facwparser/render'

module Facwparser
  def self.to_html(source, options = nil)
    print Render.render_html Parser.parse(source, options), options
    print "\n"
  end
end
