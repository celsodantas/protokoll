module Protokoll
  module ExtractNumber
    def self.create_number_mask(format)
      format.split("").map do |i|
        (i == "#") ? 1 : 0
      end
    end

    def self.extract_using_mask(db_number, mask)
      result = db_number.split("").select.with_index do |n, i| 
        n if mask[i] == 1
      end
      result.join.to_i
    end

    def self.number(str, pattern)
      mask = create_number_mask( expand_pattern(pattern) )
      extract_using_mask(str, mask)
    end
    
    def self.expand_pattern(pattern)
      pattern.sub("%Y", "0000")
    end
  end
end