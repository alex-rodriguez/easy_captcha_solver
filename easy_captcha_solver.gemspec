Gem::Specification.new do |s|
  s.name        = 'easy_captcha_solver'
  s.version     = '0.0.4'
  s.date        = '2014-02-10'
  s.summary     = "Easy Captcha Solver"
  s.description = "A captcha solver (only for easy ones) gem"
  s.authors     = ["Alex Rodriguez"]
  s.files       = ["lib/easy_captcha_solver.rb"]
  s.add_runtime_dependency "mechanize", ["~> 2.7.3"]
  s.add_runtime_dependency "tesseract-ocr", ["~> 0.1.5"]
  s.homepage    =
    'https://github.com/alex-rodriguez/easy_captcha_solver'
  s.license       = 'MIT'
end
