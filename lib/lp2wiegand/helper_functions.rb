module Lp2wiegand
  module HelperFunctions
    def add_parity_bits(bits)
      add_odd_parity_bit(add_even_parity_bit(bits))
    end
    
    def add_even_parity_bit(bits)
      one_bits = (bits & EVEN_PARITY_FIELD).to_s(2).count("1")
      must_add_parity_bit = one_bits % 2 != 0
      return must_add_parity_bit ? bits | EVEN_PARITY_MASK : bits
    end
    
    def add_odd_parity_bit(bits)
      one_bits = (bits & ODD_PARITY_FIELD).to_s(2).count("1")
      must_add_parity_bit = one_bits % 2 == 0
      return must_add_parity_bit ? bits | ODD_PARITY_MASK : bits
    end
    
    def get_facility_code(hex_string)
      read_bytes(hex_string, 1, 1).to_i(2)
    end
    
    def get_card_number(hex_string)
      read_bytes(hex_string, 9, 2).to_i(2)
    end
    
    
    def read_bytes(hex_string, position, number_of_bytes)
      if hex_string.nil? || hex_string.empty?
        raise ArgumentError, "A Wiegand26 cannot be empty or blank"
      end
    
      binary = hex_string.to_i(16).to_s(2).rjust(26, '0')
    
      binary[position, 8 * number_of_bytes]
    end
  end
end

