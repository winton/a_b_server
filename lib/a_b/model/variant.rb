class Variant < ActiveRecord::Base
  
  extend CachedFind
  
  belongs_to :category
  belongs_to :site
  belongs_to :test, :class_name => 'ABTest', :foreign_key => 'test_id'
  belongs_to :user
  
  serialize :data
  
  validates_uniqueness_of :name, :scope => :test_id
  
  attr_reader :condition, :env
  attr_accessor :conversions, :visits
  attr_accessor :visit_conditions, :conversion_conditions
  
  # Callbacks
  
  after_destroy :save_test
  before_save :update_env_data
  
  def save_test
    self.test.save if self.test
  end
  
  def update_env_data
    if self.env
      self.env_data[:conversions] = self.conversions
      self.env_data[:visits] = self.visits
      self.env_data[:visit_conditions] = self.visit_conditions
      self.env_data[:conversion_conditions] = self.conversion_conditions
    end
  end
  
  # Class methods
  
  def self.record(options)
    env, data = options[:env], options[:data]
    
    data['c'] ||= []
    data['v'] ||= []
    
    ids = data['c'] + data['v']
    ids = ids.compact.uniq
    
    variants = ids.collect do |id|
      Variant.cached_find(id, :include => :site)
    end
    
    env = Env.cached_find(:first, :conditions => {
      :name => env,
      :user_id => variants[0].user_id
    })
    
    return [ [], [] ] if variants.empty? || !env
    
    visit = []
    convert = []
    
    variants.each do |variant|
      next unless env.domain_match?(options[:referer])
      variant.env = env.name
      visit.push(variant) if data['v'].include?(variant.id)
      convert.push(variant) if data['c'].include?(variant.id)
    end
    
    visit.each do |v|
      v.visits += 1
      if data['e'] && !data['e'].empty?
        v.visit_conditions ||= {}
        (data['e'] || {}).each do |key, value|
          v.visit_conditions[key] ||= 0
          v.visit_conditions[key] += 1 if value
        end
      end
    end
    
    convert.each do |c|
      c.conversions += 1
      if data['e'] && !data['e'].empty?
        c.conversion_conditions ||= {}
        (data['e'] || {}).each do |key, value|
          c.conversion_conditions[key] ||= 0
          c.conversion_conditions[key] += 1 if value
        end
      end
    end
    
    variants.each(&:save)
    
    [ visit.collect(&:id), convert.collect(&:id) ]
  end
  
  def self.reset!
    Variant.find(:all).each do |variant|
      variant.reset!
    end
  end
  
  # Instance methods
  
  def condition=(c)
    @condition = c
    if @condition
      self.conversions = self.env_data[:conversion_conditions][c] || 0
      self.visits = self.env_data[:visit_conditions][c] || 0
      self.visit_conditions = {}
      self.conversion_conditions = {}
    end
  end
  
  def confidence
    if self.control?
      'n/a'
    else
      self.test.control.env = @env
      self.test.control.condition = @condition
      cumulative_normal_distribution(z_score(self.test.control))
    end
  end
  
  def conversion_rate
    if conversions > 0
      1.0 * conversions / visits
    else
      0.0
    end
  end
  
  def env_data
    raise 'Variant#env not set' unless self.env
    hash = {}
    hash[self.env] = {}
    self.data ||= hash
    self.data[self.env] ||= {}
  end
  
  def env=(e)
    @env = e
    self.conversions = self.env_data[:conversions] || 0
    self.visits = self.env_data[:visits] || 0
    self.visit_conditions = self.env_data[:visit_conditions] || {}
    self.conversion_conditions = self.env_data[:conversion_conditions] || {}
  end
  
  def for_dashboard
    (self.data || {}).keys.inject({}) do |hash, key|
      self.env = key
      hash[key] = {
        :confidence => pretty_confidence,
        :conversion_rate => pretty_conversion_rate,
        :conversions => pretty_conversions,
        :suggested_visits => pretty_suggested_visits,
        :visits => pretty_visits
      }
      condition_keys = (self.visit_conditions.keys + self.conversion_conditions.keys).uniq
      hash[key][:condition_keys] = condition_keys
      hash[key][:conditions] = condition_keys.inject({}) do |h, k|
        self.condition = k
        h[k] = {
          :confidence => pretty_confidence,
          :conversion_rate => pretty_conversion_rate,
          :conversions => pretty_conversions,
          :suggested_visits => pretty_suggested_visits,
          :visits => pretty_visits
        }
        h
      end
      hash
    end
  end
  
  def pretty_confidence
    pretty confidence, true
  end
  
  def pretty_conversion_rate
    pretty conversion_rate, true
  end
  
  def pretty_conversions
    commafy conversions
  end
  
  def pretty_suggested_visits
    commafy suggested_visits
  end
  
  def pretty_visits
    commafy visits
  end
  
  def reset!
    self.update_attributes(
      :conversions => 0,
      :visits => 0
    )
  end
  
  def suggested_visits
    if self.control?
      'n/a'
    else
      self.test.control.env = @env
      self.test.control.condition = @condition
      size = sample_size(self.test.control)
      if conversion_rate == 0 || size < 100
        100
      else
        commafy size
      end
    end
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
        d = (1.0 - c * Math.exp(-z * z / 2.0) * t * (t * (t * (t * (t * b5 + b4) + b3) + b2) + b1))
      else
        t = 1.0 / (1.0 - p * z)
        d = (c * Math.exp(-z * z / 2.0) * t * (t * (t * (t * (t * b5 + b4) + b3) + b2) + b1))
      end
    rescue Exception => e
      d = 0.0
    end
    d.nan? ? 0.0 : d
  end
  
  def pretty(num, pct=false)
    if num.respond_to?(:infinite?) && num.infinite?
      num = 0.0
    end
    if num.respond_to?(:strip)
      num
    elsif num.nan?
      'n/a'
    elsif pct
      (num * 100).round.to_s + '%'
    elsif num == 0 || num == 0.0
      '0'
    else
      sprintf("%.3f", num)
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