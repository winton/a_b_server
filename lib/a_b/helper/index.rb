Application.class_eval do
  helpers do
    
    def table_class(test, index)
      (index % 3 == 0 && index > 0) || @tests.last == test ? 'last' : nil
    end
    
    def table_json(test)
      { :name => test.name, :ticket_url => test.ticket_url, :variant_names => test.variant_names }.to_json
    end
    
    def variant_tooltip
      [ 'Variant names are comma separated.',
        'The first variant is the control.',
        'Each variant name must be unique (across all tests).',
        'Each variant name must only consist of letters.'
      ].join '<br/>'
    end
  end
end