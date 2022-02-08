require_relative '../template'
require 'rmagick'

module Playtestr
  class JpgTemplate < Template

    attr_reader :css
    
    def initialize (destination_dir, assets_dir = nil)  
      @css = css
      # Background and other image resources will be here
      @assets_dir = assets_dir || '.'
      super(destination_dir)
    end

    def render
      @cards.each do |name, details|
        details.delete('name')
        quantity = details.delete('quantity') || 1

        @cards_rendered += quantity.times {
          render_card(name, details)
        }
      end
      
      super
    end
   
  private
    def render_card(name, card_details)
      card = if(background = card_details.delete('background'))
        background_file = @assets_dir + "/#{background}"
        Magick::Image.read(background_file) do |img|
          img.size = '440x624'
        end
      else
        Magick::Image.new(440,624) do |img|
          img.background_color = "white"
        end
      end

      base_filename = "#{@destination}/#{name.to_s.downcase.gsub(/[^\d\w]+/,'')}"
      existing_file_count = Dir.glob("#{base_filename}*").size

      base_offset = 80

      blocks = card_details.count
      max_block_height = (580.0 / blocks).to_i
      min_block_height = 30

      title_text = Magick::Image.read('caption:' + name.to_s) do |img|
        img.pointsize = 32
        #img.font_weight = Magick::BoldWeight
        img.size = "420x90"
      end.first

      card.composite!(title_text, 10, 10, Magick::OverCompositeOp)

      y_cursor = base_offset

      card_details.each.with_index do |detail,i|
        key,value = detail

        key_text = Magick::Image.read('caption:' + key) do |img|
          img.pointsize = 20
          img.size = Magick::Geometry.new(400, 580)
        end.first

        card.composite!(key_text, 30, y_cursor, Magick::OverCompositeOp)
        lines = (key.length / 45).ceil
        y_cursor += (lines * min_block_height).clamp(min_block_height, max_block_height)

        value_text = Magick::Image.read('caption:' + value) do |img|
          img.pointsize = 16
          img.size = Magick::Geometry.new(390, 580)
        end.first

        card.composite!(value_text, 50, y_cursor, Magick::OverCompositeOp)
        lines = (value.length / 45).ceil
        y_cursor += (lines * min_block_height).clamp(min_block_height, max_block_height)
      end

      card.write("#{base_filename}_#{existing_file_count}.jpg")
    end
  end
end