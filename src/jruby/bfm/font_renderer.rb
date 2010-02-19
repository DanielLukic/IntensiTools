module BFM

  import java.awt.Color
  import java.awt.Font
  import java.awt.GraphicsEnvironment
  import java.awt.Toolkit
  import java.awt.font.FontRenderContext
  import java.awt.geom.Rectangle2D
  import java.awt.image.BufferedImage

  class FontRenderer

    def initialize
      temp_image = BufferedImage.new(32, 32, BufferedImage::TYPE_INT_ARGB)
      @font_render_context = temp_image.create_graphics.font_render_context

      toolkit = Toolkit.default_toolkit
      @rendering_hints = toolkit.get_desktop_property("awt.font.desktophints")
    end

    def available_font_names
      environment = GraphicsEnvironment.local_graphics_environment
      environment.available_font_family_names
    end

    def render_available_fonts(font_size)
      available_font_names.map { |name| render_font_name(name, font_size) }
    end

    def render_font_name(font_name, font_size, color = Color::BLACK)
      font = make_font(font_name, font_size )
      bounds = font.get_string_bounds(font_name, @font_render_context)
      image = create_image(bounds.width, bounds.height)
      graphics = image.create_graphics
      graphics.set_color color
      graphics.set_font font
      graphics.add_rendering_hints @rendering_hints if @rendering_hints
      graphics.draw_string font_name, 0, -bounds.y
      image
    end

    def make_font(font_name, font_size)
      Font.new(font_name, Font::PLAIN, font_size)
    end

    def create_image(image_width, image_height)
      BufferedImage.new(image_width, image_height, BufferedImage::TYPE_INT_ARGB)
    end

    def setup_antialiasing(graphics)
      graphics.add_rendering_hints @rendering_hints if @rendering_hints
    end

#    renderFont(  aFontSpec )
#       
#        renderContext = getFontRenderContext
#        font = makeFont( aFontSpec.name, aFontSpec.size )
#       .Double maxCharBounds = determineMaxCharBounds( font )
#        charsToRender = LAST_CHAR_CODE_PLUS_ONE - FIRST_CHAR_CODE
#        rowsToRender = ( charsToRender + CHARS_PER_ROW - 1 ) / CHARS_PER_ROW
#        imageWidth = (int) ( CHARS_PER_ROW * maxCharBounds.getWidth )
#        imageHeight = (int) ( rowsToRender * maxCharBounds.getHeight )
#        image = createImage( imageWidth, imageHeight )
#        graphics = image.createGraphics
#       graphics.setColor( Color.BLACK )
#       graphics.setFont( font )
#
#       int xPos = 0
#       int yPos = 0
#       for ( int idx = FIRST_CHAR_CODE idx < LAST_CHAR_CODE_PLUS_ONE idx++ )
#           
#           CHAR_BUFFER[0] = (char) idx
#            bounds = font.getStringBounds( CHAR_BUFFER, 0, 1, renderContext )
#           graphics.drawChars( CHAR_BUFFER, 0, 1, xPos, (int) ( yPos - bounds.getY ) )
#           xPos += maxCharBounds.width
#           if ( xPos >= imageWidth )
#               
#               xPos = 0
#               yPos += maxCharBounds.height
#           end
#       end
#
#       return image
#   end
#
#   private Rectangle2D.Double determineMaxCharBounds(  aFont )
#       
#       charContainer = char.new[1]
#        renderContext = getFontRenderContext
#
#       .Double bounds = Rectangle2D.new.Double
#       for ( int idx = FIRST_CHAR_CODE idx < LAST_CHAR_CODE_PLUS_ONE idx++ )
#           
#           charContainer[ 0 ] = (char) idx
#            charBounds = aFont.getStringBounds( charContainer, 0, 1, renderContext )
#           bounds.width = Math.max( bounds.width, charBounds.getWidth )
#           bounds.height = Math.max( bounds.height, charBounds.getHeight )
#       end
#       return bounds
#   end
#
#   private Rectangle2D.Double determineImageBounds( [] font_names,  font_size )
#       
#        renderContext = getFontRenderContext
#
#       .Double bounds = Rectangle2D.new.Double
#       for (  fontName : font_names )
#           
#            font = makeFont( fontName, font_size )
#            fontBounds = font.getStringBounds( fontName, renderContext )
#           bounds.width = Math.max( bounds.width, fontBounds.getWidth )
#           bounds.height += fontBounds.getHeight
#       end
#       return bounds
#   end

  end

end
