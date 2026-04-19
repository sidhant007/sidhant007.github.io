require 'rouge'

module Jekyll
  class CodeCellBlock < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
      parts = markup.strip.split(/\s+/, 2)
      @language = parts[0].nil? || parts[0].empty? ? "python" : parts[0]
      @title = parts[1].nil? || parts[1].empty? ? "Code cell" : parts[1]
    end

    def render(context)
      code = super.strip

      lexer = Rouge::Lexer.find(@language) || Rouge::Lexers::PlainText
      formatter = Rouge::Formatters::HTML.new
      highlighted = formatter.format(lexer.lex(code))

      <<~HTML
        <details class="codecell-wrapper" open>
          <summary class="codecell-summary">
            #{@title}
          </summary>

          <div class="codecell-body" data-language="#{@language}">
            <div class="codecell-static">
              <div class="highlight"><pre>#{highlighted}</pre></div>
            </div>

            <div class="codecell-live" style="display:none;">
              <pre data-executable="true" data-language="#{@language}">#{escape_html(code)}</pre>
            </div>
          </div>
        </details>
      HTML
    end

    private

    def escape_html(text)
      text.gsub("&", "&amp;")
          .gsub("<", "&lt;")
          .gsub(">", "&gt;")
    end
  end
end

Liquid::Template.register_tag("codecell", Jekyll::CodeCellBlock)
