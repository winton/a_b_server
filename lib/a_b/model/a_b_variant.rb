class ABVariant < ActiveRecord::Base
  
  set_table_name :a_b_variants
  belongs_to :test, :class_name => 'ABTest', :foreign_key => 'a_b_test_id'
  
  after_destroy :save_test
  
  validates_uniqueness_of :name
  
  def self.reset!
    ABVariant.find(:all).each do |variant|
      variant.reset!
    end
  end
  
  def confidence
    cumulative_normal_distribution(z_score(self.test.control))
  end
  
  def confidence_ok?
    c = cumulative_normal_distribution(z_score(self.test.control))
    c != 'n/a' && c >= 0.95
  end
  
  def conversion_rate
    if conversions > 0
      1.0 * conversions / visits
    else
      0.0
    end
  end
  
  def conversion_rate_ok?
    conversion_rate > self.test.control.conversion_rate
  end
  
  def pretty_confidence
    pretty confidence
  end
  
  def pretty_conversion_rate
    pretty conversion_rate
  end
  
  def reset!
    self.update_attributes(
      :conversions => 0,
      :visits => 0
    )
  end
  
  def suggested_visits
    size = sample_size(self.test.control)
    if conversion_rate == 0 || size < 100
      100
    else
      commafy size
    end
  end
  
  def suggested_visits_ok?
    if suggested_visits == 100
      false
    else
      visits > sample_size(self.test.control)
    end
  end
  
  def suggested_visits_with_commas
    commafy suggested_visits
  end
  
  def visits_with_commas
    commafy visits
  end
  
  private
  
  def commafy(num)
    num.to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1,\2')
  end
  
  def cumulative_normal_distribution(z)
    begin
      raise if z == 'n/a'
      
      b1 =  0.319381530
      b2 = -0.356563782
      b3 =  1.781477937
      b4 = -1.821255978
      b5 =  1.330274429
      p  =  0.2316419
      c  =  0.39894228

      if z >= 0.0
        t = 1.0 / (1.0 + p * z)
        (1.0 - c * Math.exp(-z * z / 2.0) * t * (t * (t * (t * (t * b5 + b4) + b3) + b2) + b1))
      else
        t = 1.0 / (1.0 - p * z)
        (c * Math.exp(-z * z / 2.0) * t * (t * (t * (t * (t * b5 + b4) + b3) + b2) + b1))
      end
    rescue Exception => e
      'n/a'
    end
  end
  
  def pretty(num)
    if num.respond_to?(:strip)
      num
    elsif num.nan?
      'n/a'
    else
      str = sprintf("%.3f", num)[1..-1]
      if str[0..1] == '.0' && num > 0.9
        sprintf("%.2f", num)
      else
        str
      end
    end
  end
  
  def sample_size(control)
    begin
      # conﬁdence level is 95% and the desired power is 80%
      variance = control.conversion_rate * (1 - control.conversion_rate)
      sensitivity = (self.conversion_rate - control.conversion_rate) ** 2
      (16 * variance / sensitivity).to_i
    rescue Exception => e
      0
    end
  end
  
  def save_test
    self.test.save if self.test
  end
  
  def z_score(control)
    begin
      cr1 = control.conversion_rate
      cr2 = self.conversion_rate

      v1 = control.visits
      v2 = self.visits
    
      z = cr2 - cr1
      s = (cr2 * (1 - cr2)) / v2 + (cr1 * (1 - cr1)) / v1
      z / Math.sqrt(s)
    rescue Exception => e
      'n/a'
    end
  end
end
