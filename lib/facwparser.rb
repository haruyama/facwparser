require 'facwparser/version'
require 'facwparser/parser'
require 'facwparser/render'

module Facwparser
  def self.to_html(source, options = {})
    Render.render_html(Parser.parse(source, options), options) + "\n"
  end
end
