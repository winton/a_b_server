source "http://rubygems.org"

v = {
  :bundler => '=1.0.0.beta.5',
  :httparty => '=0.5.2',
  :json => '=1.2.0',
  :rack_test => '=0.5.3',
  :rake => '=0.8.7',
  :rails => '=2.3.5',
  :rspec => '=1.3.0',
  :sinatra => '=1.0'
}

group :gemspec do
  gem 'bundler', v[:bundler]
  gem 'httparty', v[:httparty]
end

group :gemspec_dev do
  gem 'rspec', v[:rspec]
end

group :lib do
  gem 'httparty', v[:httparty]
end

group :rake do
  gem 'rake', v[:rake], :require => %w(rake rake/gempackagetask)
  gem 'rspec', v[:rspec], :require => %w(spec/rake/spectask)
end

group :spec do
  gem 'json', v[:json], :require => %w(json)
  gem 'rack-test', v[:rack_test], :require => %w(rack/test)
  gem 'rails', v[:rails]
  gem 'sinatra', v[:sinatra], :require => %w(sinatra/base)
  gem 'rspec', v[:rspec], :require => %w(
    spec/adapters/mock_frameworks/rspec
    spec/runner/formatter/progress_bar_formatter
    spec/runner/formatter/text_mate_formatter
  )
end