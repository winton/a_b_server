Application.class_eval do
  helpers do
    
    def variant_tooltip
      [ 'Variant names are comma separated.',
        'The first variant is the control.',
        'Each variant name must be unique (across all tests).',
        'Each variant name must only consist of letters.'
      ].join '<br/>'
    end
  end
end