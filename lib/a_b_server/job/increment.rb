module Job
  class Increment < Hash

    def perform
      ip = IP.create_or_increment(self[:ip], self[:date])
      if !ip.limited? && self[:json] && self[:identifier]
        data = JSON(self[:json])
        visits, conversions = Variant.record(
          :env => self[:env],
          :data => data,
          :referer => self[:referer]
        )
        ABRequest.record(
          :agent => self[:agent],
          :identifier => self[:identifier],
          :ip => self[:ip], 
          :referer => self[:referer],
          :visits => visits,
          :conversions => conversions
        )
      end
    end
  end
end