# Error values and comments are taken from Exempi's xmperrors.h
# 
# Copyright (C) 2012 Canadian Museum for Human Rights
# Copyright (C) 2007 Hubert Figuiere
# Copyright 2002-2007 Adobe Systems Incorporated
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1 Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 
# 2 Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the
# distribution.
#
# 3 Neither the name of the Authors, nor the names of its
# contributors may be used to endorse or promote products derived
# from this software wit hout specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.

module Exempi
  # This maps the numeric exceptions to their names.
  # The numeric values are output by xmp_get_error()
  ErrorCodes = {
      # More or less generic error codes.
       0     =>  :XMPErr_Unknown,
      -1     =>  :XMPErr_TBD,
      -2     =>  :XMPErr_Unavailable,
      -3     =>  :XMPErr_BadObject,
      -4     =>  :XMPErr_BadParam,
      -5     =>  :XMPErr_BadValue,
      -6     =>  :XMPErr_AssertFailure,
      -7     =>  :XMPErr_EnforceFailure,
      -8     =>  :XMPErr_Unimplemented,
      -9     =>  :XMPErr_InternalFailure,
      -10    =>  :XMPErr_Deprecated,
      -11    =>  :XMPErr_ExternalFailure,
      -12    =>  :XMPErr_UserAbort,
      -13    =>  :XMPErr_StdException,
      -14    =>  :XMPErr_UnknownException,
      -15    =>  :XMPErr_NoMemory,

      # More specific parameter error codes.
      -101   =>  :XMPErr_BadSchema,
      -102   =>  :XMPErr_BadXPath,
      -103   =>  :XMPErr_BadOptions,
      -104   =>  :XMPErr_BadIndex,
      -105   =>  :XMPErr_BadIterPosition,
      -106   =>  :XMPErr_BadParse,
      -107   =>  :XMPErr_BadSerialize,
      -108   =>  :XMPErr_BadFileFormat,
      -109   =>  :XMPErr_NoFileHandler,
      -110   =>  :XMPErr_TooLargeForJPEG,

      # File format and internal structure error codes.
      -201   =>  :XMPErr_BadXML,
      -202   =>  :XMPErr_BadRDF,
      -203   =>  :XMPErr_BadXMP,
      -204   =>  :XMPErr_EmptyIterator,
      -205   =>  :XMPErr_BadUnicode,
      -206   =>  :XMPErr_BadTIFF,
      -207   =>  :XMPErr_BadJPEG,
      -208   =>  :XMPErr_BadPSD,
      -209   =>  :XMPErr_BadPSIR,
      -210   =>  :XMPErr_BadIPTC,
      -211   =>  :XMPErr_BadMPEG
  }

  # Returns a symbol representing the XMP error for an int code.
  # Used with the output of Exempi.xmp_get_error
  # This is just a bit of sugar over Exempi::ErrorCodes[code]
  # @param [Integer] integer error code; should be the output of Exempi.xmp_get_error
  def self.exception_for code
    if !ErrorCodes[code]
      raise ArgumentError, "#{error_code} is not an Exempi error code"
    end
    ErrorCodes[code]
  end
end