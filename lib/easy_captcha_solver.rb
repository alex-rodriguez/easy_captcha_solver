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

    # If URL, save a file instead of trying to solve the captcha from memory because of tesseract limitations with .png images
    if options[:image_url]
      image = agent.get(options[:image_url]).save!  "./tmp_image"

      # Guess image extension and rename tmp file
      @image  = "./tmp_image.#{get_image_extension(image)}"
      File.rename( image,  @image)
    end

    unless @image
      throw Exception.new "A local image path or a image URL must be provided. Example:  easy_c = EasyCaptcha.new( image_url: 'http://www.example.com/captcha_img.jpg')"
    end

    solve_captcha ensure File.delete(@image) if options[:image_url]

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

def get_image_extension(local_file_path)
  png = Regexp.new("\x89PNG".force_encoding("binary"))
  jpg = Regexp.new("\xff\xd8\xff\xe0\x00\x10JFIF".force_encoding("binary"))
  jpg2 = Regexp.new("\xff\xd8\xff\xe1(.*){2}Exif".force_encoding("binary"))
  case IO.read(local_file_path, 10)
  when /^GIF8/
    'gif'
  when /^#{png}/
    'png'
  when /^#{jpg}/
    'jpg'
  when /^#{jpg2}/
    'jpg'
  else
    mime_type = `file #{local_file_path} --mime-type`.gsub("\n", '') # Works on linux and mac
    raise UnprocessableEntity, "unknown file type" if !mime_type
    mime_type.split(':')[1].split('/')[1].gsub('x-', '').gsub(/jpeg/, 'jpg').gsub(/text/, 'txt').gsub(/x-/, '')
  end
end
