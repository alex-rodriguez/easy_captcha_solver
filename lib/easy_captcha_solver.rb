require 'mechanize'
require 'tesseract-ocr'

class EasyCaptchaSolver
  attr_reader :captcha

  def initialize ( options = {} )
    # Mechanize initializacion, pretends to be Mac Safari
    agent = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    @image = options[:image_path] if options[:image_path]
    @image = agent.get(options[:image_url]).body if options[:image_url]
    unless @image
      throw Exception.new "A local image path or a image URL must be provided. Example:  easy_c = EasyCaptcha.new( image_url: 'http://www.example.com/captcha_img.jpg')"
    end

    solve_captcha
  end

  private

  def solve_captcha()
    # Solve captcha using Tesseract-ocr
    e = Tesseract::Engine.new {|e|
      e.language  = :eng
      e.blacklist = '|'
    }
    @captcha = e.text_for(@image).strip # => 'ABC'
  end
end


