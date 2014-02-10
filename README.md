Easy Captcha Solver
----------------
A captcha solver for really easy ones (don't expect it to solve recaptcha or any similar)

Tested with Ruby 2.0

Installation
----------------
add to Gemfile 


Requirements
----------------

* Install Tesseract #=> brew install tesseract
* gem install 'tesseract-ocr'
* gem install 'mechanize'

Tesseract Gem
----------------

If Tesseract-ocr is required in the gemspec file it always fails when installing the easy_captcha_solver gem. I don't know why, so be aware of installing tesseract-ocr gem despite of not being required.

Using the gem
----------------
Solving a captcha using an URL:

```ruby
require 'easy_captcha_solver'

easy_c = EasyCaptchaSolver.new(image_url: "http://www.example.net/LoadCaptcha.icm?idCaptcha=123456")
easy_c.captcha #=> "ABCDE"
```
You can also use an image from your local:

```ruby
require 'easy_captcha_solver'

easy_c = EasyCaptchaSolver.new(image_path: "./captcha_img.jpg")
easy_c.captcha #=> "ABCDE"
```
