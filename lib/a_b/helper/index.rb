Application.class_eval do
  helpers do
    
    def table_class(test, index)
      (index + 1) % 3 == 0 || @tests.last == test ? 'last' : nil
    end
    
    def table_json(test)
      { :name => test.name, :ticket_url => test.ticket_url, :variant_names => test.variant_names }.to_json
    end
  end
end