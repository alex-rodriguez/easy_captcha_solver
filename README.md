Easy Captcha Solver
----------------
A captcha solver for really easy ones (don't expect it to solve recaptcha or any similar)

Tested with Ruby 2.0 and jpg captchas

Installation
----------------
gem install 'easy_captcha_solver'


Requirements
----------------

* Install Tesseract #=> brew install tesseract
* gem install 'tesseract-ocr'
* gem install 'mechanize'

Tesseract Gem
----------------

If Tesseract-ocr is required in the gemspec file it fails when installing easy_captcha_solver. I don't know why, so be aware of installing tesseract-ocr gem despite of not being required by gemspec.

Using the gem
----------------
Solve a captcha using an URL with image_url:

```ruby
require 'easy_captcha_solver'

easy_c = EasyCaptchaSolver.new(image_url: "http://www.madrid.org/i012_opina/run/j/CargarCaptchaAccion.icm?idCaptcha=&anticache=1")
easy_c.captcha #=> "ABCDE"
```
You can also solve a captcha from your local using image_path:

```ruby
require 'easy_captcha_solver'

easy_c = EasyCaptchaSolver.new(image_path: "./captcha_img.jpg")
easy_c.captcha #=> "ABCDE"
```

Contributing
------------
If you'd like to contribute fork the project, make your changes and 
then send a pull request.

Contact
-------
Comments and feedback are welcome.

License
-------
This code is free to use under the terms of the MIT license.


