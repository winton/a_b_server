When /^the application requests (.+) \((.+)\)$/ do |url, method|
  self.send method.downcase.intern, url, @params
  if last_response.headers["Content-Type"].include?('json')
    @json = JSON last_response.body
  end
end