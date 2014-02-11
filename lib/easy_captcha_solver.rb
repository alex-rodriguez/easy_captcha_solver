require 'mechanize'
require 'tesseract-ocr'

class EasyCaptchaSolver
  attr_reader :captcha

  def initialize ( options = {} )
    image = options[:image_path] if options[:image_path]
    image = get_captcha_image(options[:image_url]) if options[:image_url]

    throw Exception.new "Image path or image URL must be provided.
    Example:  easy_c = EasyCaptcha.new( image_url: 'http://www.example.com/captcha' )
      or easy_c = EasyCaptcha.new( image_path: './captcha.jpg' )" unless image

    # Try to solve the captcha and delete temp img if necessary
    solve_captcha(image) ensure File.delete(image) if options[:image_url] && File.exist?(image)
  end

  private
  def get_captcha_image( image_url )
    agent = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    # Save a file instead of trying to solve the captcha from memory
    # because of tesseract limitations with .png images
    image = agent.get(image_url).save!  "./tmp_image"
    image_extension  = "./tmp_image.#{get_image_extension(image)}"
    File.rename( image,  image_extension)

    image_extension
  end

  def solve_captcha(image)
    e = Tesseract::Engine.new {|e|
      e.language  = :eng
      e.blacklist = '|'
    }
    @captcha = e.text_for(image).strip # => 'ABC'
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

end
