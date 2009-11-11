class ABVariant < ActiveRecord::Base
  set_table_name :a_b_variants
  belongs_to :test, :class_name => 'ABTest', :foreign_key => 'a_b_test_id'
  
  validates_uniqueness_of :name
  
  def confidence
    if compute_confidence?
      cumulative_normal_distribution(z_score(self.test.control))
    else
      'n/a'
    end
  end
  
  def conversion_rate
    if conversions > 0
      1.0 * conversions / visitors
    else
      0.0
    end
  end
  
  def pretty_confidence
    pretty confidence
  end
  
  def pretty_conversion_rate
    pretty conversion_rate
  end
  
  def suggested_visitors
    0
  end
  
  def suggested_visitors_with_commas
    commafy suggested_visitors
  end
  
  def visitors_with_commas
    commafy visitors
  end
  
  private
  
  def commafy(num)
    num.to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1,\2')
  end
  
  def cumulative_normal_distribution(x)
    b1 =  0.319381530
    b2 = -0.356563782
    b3 =  1.781477937
    b4 = -1.821255978
    b5 =  1.330274429
    p  =  0.2316419
    c  =  0.39894228

    if x >= 0.0
      t = 1.0 / ( 1.0 + p * x )
      (1.0 - c * Math.exp( -x * x / 2.0 ) * t * ( t * ( t * ( t * ( t * b5 + b4 ) + b3 ) + b2 ) + b1 ))
    else
      t = 1.0 / ( 1.0 - p * x )
      ( c * Math.exp( -x * x / 2.0 ) * t * ( t *( t * ( t * ( t * b5 + b4 ) + b3 ) + b2 ) + b1 ))
    end
  end
  
  def compute_confidence?
    self.test.control && self != self.test.control &&
    self.visitors > 0
  end
  
  def pretty(num)
    if num.respond_to?(:strip)
      num
    else
      sprintf("%.3f", num)[1..-1]
    end
  end
  
  def z_score(control)
    cr1 = control.conversion_rate
    cr2 = self.conversion_rate

    v1 = control.visitors
    v2 = self.visitors
    
    puts cr1
    puts cr2
    puts v1
    puts v2
    
    if v1 == 0.0 || v2 == 0.0
      0.0
    else
      z = cr2 - cr1
      s = (cr2 * (1 - cr2)) / v2 + (cr1 * (1 - cr1)) / v1
      z / Math.sqrt(s)
    end
  end
end
