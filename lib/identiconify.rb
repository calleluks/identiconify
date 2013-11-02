require "identiconify/version"
require "chunky_png"
require "siphash"

module Identiconify
  class Identicon
    HASH_KEY = "61616f73646a6173646a616f7369646a"

    attr_reader :string, :square_size, :row_count

    def initialize(string)
      @string = string
      @square_size = 50
      @row_count = 5
    end

    def column_count
      row_count.even? ? row_count/2 : row_count/2+1
    end

    def width
      square_size * row_count
    end

    def to_png_blob
      hash = SipHash.digest(HASH_KEY, string)

      # Use the three first bytes of the hash to generate a color
      r = hash & 0xff
      g = (hash >> 8) & 0xff
      b = (hash >> 16) & 0xff
      a = 0xff
      color = ChunkyPNG::Color.rgba(r,g,b,a)
      bg_color = ChunkyPNG::Color::TRANSPARENT

      # Remove the used three bytes
      hash >>= 24

      png = ChunkyPNG::Image.new(width, width, bg_color)
      0.upto(row_count).each do |row|
        0.upto(column_count).each do |column|
          if hash & 1 == 1
            x0 = column*square_size
            y0 = row*square_size
            x1 = (column+1)*square_size-1
            y1 = (row+1)*square_size-1
            png.rect(x0, y0, x1, y1, color, color)

            # Inverse the x coordinates making the image mirrored vertically
            x0 = width-(column+1)*square_size
            x1 = width-column*square_size-1
            png.rect(x0, y0, x1, y1, color, color)
          end
          hash >>= 1
        end
      end
      png.to_blob :color_mode => ChunkyPNG::COLOR_INDEXED
    end
  end
end