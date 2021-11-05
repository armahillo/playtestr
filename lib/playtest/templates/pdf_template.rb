require_relative '../template'
require 'prawn'

# PDF's built-in fonts have very limited support for internationalized text.
# If you need full UTF-8 support, consider using an external font instead.
# To disable this warning, add the following line to your code:
Prawn::Fonts::AFM.hide_m17n_warning = true

module Playtest
  class PdfTemplate < Template

    def initialize(destination)
      super(destination)
    end

    def render
      # Create the document
      @pdf = ::Prawn::Document.new
      
      # Generate the PDF using the HTML we've generated
      #generate_grid(columns: 3, rows: 6)
      halfsize_cards

      # Save the PDF to our machine
      @pdf.render_file @destination
      super
    end
    
  private
    def poker_cards
      generate_grid(columns: 3, rows: 3, heading_size: 18, text_size: 14)
    end

    def halfsize_cards
      generate_grid(columns: 3, rows: 6, heading_size: 14, text_size: 10)
    end

    def generate_grid(columns: 3, rows: 3, heading_size: 18, text_size: 14)
      @cards_rendered = 0
      @pdf.define_grid(columns: columns, rows: rows, gutter: 0)
      per_page = columns * rows

      @cards.each do |card|
        card_name = card[1].delete("name")
        
        card[1].delete("quantity").times do
          @pdf.start_new_page if ((@cards_rendered > 0) && (@cards_rendered % per_page == 0))
          @pdf.grid((@cards_rendered % per_page) / columns, @cards_rendered % columns).bounding_box do |cell|
            # Draw Card outline
            @pdf.transparent(0.2) { @pdf.stroke_bounds }
            # Write the card title
            @pdf.pad(10) { 
              @pdf.indent(10) {
                @pdf.text(card_name, size: heading_size, style: :bold, overflow: :shrink_to_fit) 
              }
            }
            # Write the card body
            card[1].each do |k,v| 
              @pdf.indent(10) { @pdf.text("#{k} #{v.inspect}", size: text_size, overflow: :shrink_to_fit) }
              @pdf.move_down(5)
            end
          end
          @cards_rendered += 1
        end
      end
    end
  end
end