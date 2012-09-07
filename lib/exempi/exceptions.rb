require 'exempi/errors'

module Exempi
  # This class provides a convenient interface for throwing exceptions
  # when using Exempi functions. It allows the caller to specify an
  # error code (retrievable from xmp_get_error()), and provides a
  # method to retrieve the error name based on the code.
  class ExempiError < StandardError
    attr :error_code
    def initialize error_code=0
      if !Exempi::ErrorCodes[error_code]
        raise ArgumentError, "#{error_code} is not an Exempi error code"
      end
      @error_code = error_code
    end

    # @return [Symbol] Exempi's error string for this exception
    def xmp_error
      Exempi::ErrorCodes[@error_code]
    end
  end

  class InvalidOptionError < StandardError; end
end