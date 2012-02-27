
module Protokoll
  class Formater
    def format(number, options)
      @options = options
      
      build(number)
    end
    
    private 
    
    # gets the next number.
    # it prepends the prefix + counter + sufix
    # ex:
    #   "%Y####BANK" 
    #   %Y => prefix (year)
    #   #### => counter (starts with 0001)
    #   BANK => sufix
    # 
    # if we are in 2011, the first model to be saved will get "20110001BANK"
    # the next model to be saved will get "20110002BANK", "20110003BANK"...
    #
    #   number => is the counter
    #   
    #   next_custom_number(1) 
    #   => "20110001BANK"
    def build(number)
      prefix(@options[:pattern]).to_s + 
      counter(@options[:pattern], number).to_s + 
      sufix(@options[:pattern]).to_s
    end

    def prefix(pattern)
      prefx = extract_prefix(pattern)
      expand_times(prefx.to_s)
    end

    def counter(pattern, n)
      format_counter(digits_size(pattern), n)
    end

    def sufix(pattern)
      sufx = extract_sufix(pattern)
      expand_times(sufx.to_s)
    end

    def format_counter(zeros, value)
      "%0#{zeros}d" % value
    end

    def extract_prefix(pattern)
      # Company#### => Company
      symbol = @options[:number_symbol]
      (pattern =~ /^(\s|\d)*[^#{symbol}]+/ and $&)
    end

    def extract_sufix(pattern)
      # ###Company => Company
      symbol = @options[:number_symbol]
      (pattern =~ /[^#{symbol}]+$/ and $&)
    end

    def expand_times(pattern)
      pattern.sub!("%y", Time.now.strftime("%y"))
      pattern.sub!("%Y", Time.now.strftime("%Y"))
      pattern.sub!("%d", Time.now.strftime("%d"))
      pattern.sub!("%m", Time.now.strftime("%m"))
      pattern.sub!("%M", Time.now.strftime("%M"))
      pattern.sub("%H",  Time.now.strftime("%H"))
    end

    def digits_size(pattern)
      symbol = @options[:number_symbol]
      (pattern =~ /[#{symbol}]+/ and $&).length
    end


  end  
end
