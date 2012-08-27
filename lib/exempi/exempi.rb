# These comments are taken from Exempi's xmp.h
# 
# Copyright (C) 2012 Canadian Museum for Human Rights
# Copyright (C) 2007-2008,2012 Hubert Figuiere
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

require 'exempi/consts'

require 'ffi'

module Exempi
  extend FFI::Library
  ffi_lib 'exempi'

  # we redefine attach_function so we can wrap all of the C functions
  class << self
    def attach_function name, func, args, returns=nil, options={}
      super
      old_method = method(name)
      define_singleton_method(name) do |*args|
        shutup! { old_method.call(*args) }
      end
    end

    protected

    # Exempi spews stderr all over the place without giving you any way
    # to quiet it! Boo!
    def shutup!
      IO.new(2).reopen(IO::NULL)
      yield
    ensure
      IO.new(2).reopen(STDERR)
    end
  end

  # Init the library. Must be called before anything else
  attach_function :xmp_init, [  ], :bool
  attach_function :xmp_terminate, [  ], :void

  # get the error code that last occurred.
  # @todo make this thread-safe. Getting the error code
  # from another thread than the on it occurred in is undefined.
  attach_function :xmp_get_error, [  ], :int

  attach_function :xmp_files_new, [  ], :pointer
  attach_function :xmp_files_open_new, [ :string, XmpOpenFileOptions ], :pointer
  attach_function :xmp_files_open, [ :pointer, :string, XmpOpenFileOptions ], :bool

  # Close an XMP file. Will flush the changes
  # @param xf the file object
  # @param options the options to close.
  # @return true on succes, false on error
  # xmp_get_error() will give the error code.
  attach_function :xmp_files_close, [ :pointer, XmpCloseFileOptions ], :bool

  attach_function :xmp_files_get_new_xmp, [ :pointer ], :pointer
  attach_function :xmp_files_get_xmp, [ :pointer, :pointer ], :bool

  attach_function :xmp_files_can_put_xmp, [ :pointer, :pointer ], :bool
  attach_function :xmp_files_put_xmp, [ :pointer, :pointer ], :bool

  # Get the file info from the open file
  # @param xf the file object
  # @param[out] filePath the file path object to store the path in. Pass NULL if not needed.
  # @param[out] options the options for open. Pass NULL if not needed.
  # @param[out] file_format the detected file format. Pass NULL if not needed.
  # @param[out] handler_flags the format options like from %xmp_files_get_format_info.
  # @return false in case of error.
  attach_function :xmp_files_get_file_info, [ :pointer, :pointer, :pointer, :pointer, :pointer ], :bool

  # Free a XmpFilePtr
  # @param xf the file ptr. Cannot be NULL
  # @return false on error.
  # xmp_get_error() will give the error code.
  attach_function :xmp_files_free, [ :pointer ], :bool

  # Get the format info 
  # @param format type identifier
  # @param option the options for the file format handler
  # @return false on error
  attach_function :xmp_files_get_format_info, [ :int, :pointer ], :bool

  # Check the file format of a file. Use the same logic as in xmp_files_open()
  # @param filePath the path to the file
  # @return XMP_FT_UNKNOWN on error or if the file type is unknown
  attach_function :xmp_files_check_file_format, [ :string ], :int

  # Register a new namespace to add properties to
  # This is done automatically when reading the metadata block
  # @param namespaceURI the namespace URI to register
  # @param suggestedPrefix the suggested prefix
  # @param registeredPrefix the really registered prefix. Not necessarily
  # %suggestedPrefix. 
  # @return true if success, false otherwise.
  attach_function :xmp_register_namespace, [ :string, :string, :pointer ], :bool

  # Check if a namespace is registered
  # @param ns the namespace to check.
  # @param prefix The prefix associated if registered. Pass NULL
  # if not interested.
  # @return true if registered.
  # NEW in 2.1
  attach_function :xmp_namespace_prefix, [ :string, :pointer ], :bool

  # Check if a ns prefix is registered.
  # @param prefix the prefix to check.
  # @param ns the namespace associated if registered. Pass NULL 
  # if not interested.
  # @return true if registered.
  # NEW in 2.1
  attach_function :xmp_prefix_namespace_uri, [ :string, :pointer ], :bool

  attach_function :xmp_new_empty, [  ], :pointer

  # Create a new XMP packet
  # @param buffer the buffer to load data from. UTF-8 encoded.
  # @param len the buffer length in byte
  # @return the packet pointer. Must be free with xmp_free()
  attach_function :xmp_new, [ :string, :uint ], :pointer

  # Create a new XMP packet from the one passed.
  # @param xmp the instance to copy. Can be NULL.
  # @return the packet pointer. NULL is failer (or NULL is passed).
  attach_function :xmp_copy, [ :pointer ], :pointer

  # Free the xmp packet
  # @param xmp the xmp packet to free
  attach_function :xmp_free, [ :pointer ], :bool

  # Parse the XML passed through the buffer and load
  # it.
  # @param xmp the XMP packet.
  # @param buffer the buffer.
  # @param len the length of the buffer.
  attach_function :xmp_parse, [ :pointer, :string, :uint ], :bool

  # Serialize the XMP Packet to the given buffer
  # @param xmp the XMP Packet
  # @param buffer the buffer to write the XMP to
  # @param options options on how to write the XMP.  See XMP_SERIAL_*
  # @param padding number of bytes of padding, useful for modifying
  #                embedded XMP in place.
  # @return TRUE if success.
  attach_function :xmp_serialize, [ :pointer, :pointer, XmpSerialOptions, :uint32 ], :bool

  # Serialize the XMP Packet to the given buffer with formatting
  # @param xmp the XMP Packet
  # @param buffer the buffer to write the XMP to
  # @param options options on how to write the XMP.  See XMP_SERIAL_*
  # @param padding number of bytes of padding, useful for modifying
  #                embedded XMP in place.
  # @param newline the new line character to use
  # @param tab the indentation character to use
  # @param indent the initial indentation level
  # @return TRUE if success.
  attach_function :xmp_serialize_and_format, [ :pointer, :pointer, XmpSerialOptions, :uint32, :string, :string, :int32 ], :bool

  # Get an XMP property and it option bits from the XMP packet
  # @param xmp the XMP packet
  # @param schema
  # @param name
  # @param property the allocated XmpStringPtr
  # @param propsBits pointer to the option bits. Pass NULL if not needed
  # @return true if found
  attach_function :xmp_get_property, [ :pointer, :string, :string, :pointer, :pointer ], :bool
  attach_function :xmp_get_property_date, [ :pointer, :string, :string, XmpDateTime, :pointer ], :bool
  attach_function :xmp_get_property_float, [ :pointer, :string, :string, :pointer, :pointer ], :bool
  attach_function :xmp_get_property_bool, [ :pointer, :string, :string, :pointer, :pointer ], :bool
  attach_function :xmp_get_property_int32, [ :pointer, :string, :string, :pointer, :pointer ], :bool
  attach_function :xmp_get_property_int64, [ :pointer, :string, :string, :pointer, :pointer ], :bool

  # Get an item frpm an array property
  # @param xmp the xmp meta
  # @param schema the schema
  # @param name the property name
  # @param index the index in the array
  # @param property the property value
  # @param propsBits the property bits. Pass NULL is unwanted.
  # @return TRUE if success.
  attach_function :xmp_get_array_item, [ :pointer, :string, :string, :int32, :pointer, :pointer ], :bool

  # Set an XMP property in the XMP packet
  # @param xmp the XMP packet
  # @param schema
  # @param name
  # @param value 0 terminated string
  # @param optionBits
  # @return false if failure
  attach_function :xmp_set_property, [ :pointer, :string, :string, :string, XmpPropsBits ], :bool

  # Set a date XMP property in the XMP packet
  # @param xmp the XMP packet
  # @param schema
  # @param name
  # @param value the date-time struct
  # @param optionBits
  # @return false if failure
  attach_function :xmp_set_property_date, [ :pointer, :string, :string, :pointer, XmpPropsBits ], :bool

  # Set a float XMP property in the XMP packet
  # @param xmp the XMP packet
  # @param schema
  # @param name
  # @param value the float value
  # @param optionBits
  # @return false if failure
  attach_function :xmp_set_property_float, [ :pointer, :string, :string, :double, XmpPropsBits ], :bool
  attach_function :xmp_set_property_bool, [ :pointer, :string, :string, :bool, XmpPropsBits ], :bool
  attach_function :xmp_set_property_int32, [ :pointer, :string, :string, :int32, XmpPropsBits ], :bool
  attach_function :xmp_set_property_int64, [ :pointer, :string, :string, :int64, XmpPropsBits ], :bool
  attach_function :xmp_set_array_item, [ :pointer, :string, :string, :int32, :string, :uint32 ], :bool

  attach_function :xmp_append_array_item, [ :pointer, :string, :string, :uint32, :string, :uint32 ], :bool

  # Delete a property from the XMP Packet provided
  # @param xmp the XMP packet
  # @param schema the schema of the property
  # @param name the name of the property
  attach_function :xmp_delete_property, [ :pointer, :string, :string ], :bool

  # Determines if a property exists in the XMP Packet provided
  # @param xmp the XMP packet
  # @param schema the schema of the property. Can't be NULL or empty.
  # @param name the name of the property. Can't be NULL or empty.
  # @return true is the property exists
  attach_function :xmp_has_property, [ :pointer, :string, :string ], :bool

  # Get a localised text from a localisable property.
  # @param xmp the XMP packet
  # @param schema the schema
  # @param name the property name.
  # @param genericLang the generic language you may want as a fall back. 
  # Can be NULL or empty.
  # @param specificLang the specific language you want. Can't be NULL or empty.
  # @param actualLang the actual language of the value. Can be NULL if 
  # not wanted.
  # @param itemValue the localized value. Can be NULL if not wanted.
  # @param propBits the options flags describing the property. Can be NULL.
  # @return true if found, false otherwise.
  attach_function :xmp_get_localized_text, [ :pointer, :string, :string, :string, :string, :pointer, :pointer, :pointer ], :bool

  # Set a localised text in a localisable property.
  # @param xmp the XMP packet
  # @param schema the schema
  # @param name the property name.
  # @param genericLang the generic language you may want to set too. 
  # Can be NULL or empty.
  # @param specificLang the specific language you want. Can't be NULL or empty.
  # @param value the localized value. Cannot be NULL.
  # @param optionBits the options flags describing the property.
  # @return true if set, false otherwise.
  attach_function :xmp_set_localized_text, [ :pointer, :string, :string, :string, :string, :string, XmpPropsBits ], :bool

  attach_function :xmp_delete_localized_text, [ :pointer, :string, :string, :string, :string ], :bool

  # Instanciate a new string 
  # @return the new instance. Must be freed with 
  # xmp_string_free()
  attach_function :xmp_string_new, [  ], :pointer

  # Free a XmpStringPtr
  # @param s the string to free
  attach_function :xmp_string_free, [ :pointer ], :void

  # Get the C string from the XmpStringPtr
  # @param s the string object
  # @return the const char * for the XmpStringPtr. It 
  # belong to the object.
  attach_function :xmp_string_cstr, [ :pointer ], :string

  attach_function :xmp_iterator_new, [ :pointer, :string, :string, XmpIterOptions ], :pointer
  attach_function :xmp_iterator_free, [ :pointer ], :bool

  # Iterate to the next value
  # @param iter the iterator
  # @param schema the schema name. Pass NULL if not wanted
  # @param propName the property path. Pass NULL if not wanted
  # @param propValue the value of the property. Pass NULL if not wanted.
  # @param options the options for the property. Pass NULL if not wanted.
  # @return true if still something, false if none
  attach_function :xmp_iterator_next, [ :pointer, :pointer, :pointer, :pointer, :pointer ], :bool
  attach_function :xmp_iterator_skip, [ :pointer, XmpIterSkipOptions ], :bool

  # We do this first, before anything else!!
  xmp_init
end