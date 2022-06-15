# frozen_string_literal: true

require 'digest/sha1'

require_relative "lp2wiegand/version"
require_relative "lp2wiegand/constants"
require_relative "lp2wiegand/helper_functions"

module Lp2wiegand
  extend self
  extend HelperFunctions

  class Lp2WiegandError < StandardError; end
  def generate_hex_from_string(string)
    raise Lp2WiegandError("String exceeded character limit") if string.size > MAX_NUMBER_OF_CHARACTERS
    sha1_encoded = Digest::SHA1.hexdigest(string)
  
    bits = [sha1_encoded].pack("H*").unpack("c*")
    last_4_bits = [0, *bits.last(3)]
  
    numerical_representation = last_4_bits.pack("C*").unpack("N").first
    fixed_to_26_bit = numerical_representation << 1
  
    result = add_parity_bits(fixed_to_26_bit)
  
    hex_result = result.to_s(16).upcase
  end
  
  def extract_fac_and_number_from_hash(hex_result)
    {
      facility_code: get_facility_code(hex_result),
      card_number: get_card_number(hex_result)
    }
  end

  def convert_to_wiegand(licence_plate)
    hex_result = generate_hex_from_string(licence_plate)
    extract_fac_and_number_from_hash(hex_result)
  end
end
