require "identiconify/version"
require "chunky_png"
require "digest"

module Identiconify
  class Identicon
    DEFAULT_HASH_PROVIDER = ->(string) {
      Digest::SHA1.hexdigest(string).to_i(16)
    }

    def initialize(string, options={})
      @string = string
      @size = options.fetch(:size) { 250 }
      @colors = options.fetch(:colors) { :default }.to_sym
      @hash_provider = options.fetch(:hash_provider) { DEFAULT_HASH_PROVIDER }
    end

    def to_png_blob
      render.to_blob :fast_rgba
    end

    private

    attr_reader :string, :size, :colors, :hash_provider

    def render
      bits = hash.to_s(2).split("").map(&:to_i)

      # Drop the first three bytes that are used for the color
      bits.drop(3*8)

      png = ChunkyPNG::Image.new(size, size, bg_color)

      coordinates.each do |row, column|
        render_square(row, column, png) if bits.shift == 1
      end

      png
    end

    def render_square(row, column, png)
      x0 = column*square_size
      y0 = row*square_size
      x1 = (column+1)*square_size-1
      y1 = (row+1)*square_size-1
      png.rect(x0, y0, x1, y1, color, color)

      # Inverse the x coordinates making the image mirrored vertically
      x0 = size-(column+1)*square_size-inverse_offset
      x1 = size-column*square_size-inverse_offset-1
      png.rect(x0, y0, x1, y1, color, color)
    end

    def row_count
      7
    end

    def column_count
      row_count.even? ? row_count / 2 : row_count / 2 + 1
    end

    def square_size
      size / row_count
    end

    def inverse_offset
      # Since we can't draw subpixels we need to calculate how much we have to
      # offset the inverted version of the identicon to not create gaps or
      # overlaps in the middle of the image.
      size - square_size * row_count
    end

    def hash
      hash_provider.call(string)
    end

    def coordinates
      rows = 0.upto(row_count-1).to_a
      columns = 0.upto(column_count-1).to_a
      rows.product(columns)
    end

    def bg_color
      ChunkyPNG::Color::TRANSPARENT
    end

    def color
      # Use the three first bytes of the hash to generate a color
      r = hash & 255
      g = (hash >> 8) & 255
      b = (hash >> 16) & 255
      transform_color ChunkyPNG::Color.rgb(r,g,b)
    end

    def transform_color(color)
      case colors
      when :bw then greyscale(color)
      when :tinted then tint(color)
      else color
      end
    end

    def greyscale(color)
      ChunkyPNG::Color.to_grayscale(color)
    end

    def tint(color)
      r = ChunkyPNG::Color.r(color)
      g = ChunkyPNG::Color.g(color)
      b = ChunkyPNG::Color.b(color)
      ChunkyPNG::Color.rgb(tint_component(r),tint_component(g),tint_component(b))
    end

    def tint_component(component)
      component + (0.3 * (255 - component)).round
    end
  end
end
