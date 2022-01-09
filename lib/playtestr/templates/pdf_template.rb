require_relative '../template'
require 'prawn'

# PDF's built-in fonts have very limited support for internationalized text.
# If you need full UTF-8 support, consider using an external font instead.
# To disable this warning, add the following line to your code:
Prawn::Fonts::AFM.hide_m17n_warning = true

module Playtestr
  class PdfTemplate < Template

    def initialize(destination)
      super(destination)
    end

    def render(gridsize = :poker)
      # Create the document
      @pdf = ::Prawn::Document.new
      @pdf.font_families.update("OpenSans" => {
        :normal => "assets/fonts/OpenSans/OpenSans-Regular.ttf",
        :italic => "assets/fonts/OpenSans/OpenSans-Italic.ttf",
        :bold => "assets/fonts/OpenSans/OpenSans-Bold.ttf",
        :bold_italic => "assets/fonts/OpenSans/OpenSans-BoldItalic.ttf"
      })
      @pdf.font_families.update("OpenSans_Condensed" => {
        :normal => "assets/fonts/OpenSans_Condensed/OpenSans_Condensed-Regular.ttf",
        :italic => "assets/fonts/OpenSans_Condensed/OpenSans_Condensed-Italic.ttf",
        :bold => "assets/fonts/OpenSans_Condensed/OpenSans_Condensed-Bold.ttf",
        :bold_italic => "assets/fonts/OpenSans_Condensed/OpenSans_Condensed-BoldItalic.ttf"
      })
      @pdf.font "OpenSans"
      
      # Generate the PDF using the HTML we've generated
      if gridsize == :halfsize
        halfsize_cards
      else
        poker_cards
      end

      # Save the PDF to our machine
      @pdf.render_file @destination
#      super
    end
    
  private
    def poker_cards
      generate_grid(columns: 3, rows: 3, heading_size: 16, text_size: 12)
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
            @pdf.font "OpenSans"
            @pdf.pad(10) { 
              @pdf.indent(10) {
                @pdf.text(card_name, size: heading_size, style: :bold, leading: -2, overflow: :shrink_to_fit) 
              }
            }
            # Write the card body
            @pdf.font "OpenSans_Condensed"
            card[1].each do |k,v|
              # Will it fit on one line?
              if (k.size + v.size <= 40)
                @pdf.indent(10) do 
                  @pdf.text("<b>#{k}</b> #{v}", size: text_size, inline_format: true)
                end
              # Display it on two lines 
              else
                @pdf.indent(10) { @pdf.text(k, style: :bold, size: text_size, overflow: :shrink_to_fit) }
                @pdf.indent(15) { @pdf.text(v, size: text_size, overflow: :shrink_to_fit) }
              end
              @pdf.move_down(5)
            end
          end
          @cards_rendered += 1
        end
      end
    end
  end
end