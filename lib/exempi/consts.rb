# These constants and comments are taken from Exempi's xmp.h
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

require 'exempi/exceptions'

require 'date'
require 'ffi'

module Exempi
  extend FFI::Library

  # Option bits for xmp_files_open()
  XMP_OPEN_FILE_OPTIONS = enum [
    :XMP_OPEN_NOOPTION,           0x00000000, # No open option
    :XMP_OPEN_READ,               0x00000001, # Open for read-only access.
    :XMP_OPEN_FORUPDATE,          0x00000002, # Open for reading and writing.
    :XMP_OPEN_ONLYXMP,            0x00000004, # Only the XMP is wanted, allows space/time optimizations.
    :XMP_OPEN_CACHETNAIL,         0x00000008, # Cache thumbnail if possible, GetThumbnail will be called.
    :XMP_OPEN_STRICTLY,           0x00000010, # Be strict about locating XMP and reconciling with other forms.
    :XMP_OPEN_USESMARTHANDLER,    0x00000020, # Require the use of a smart handler.
    :XMP_OPEN_USEPACKETSCANNING,  0x00000040, # Force packet scanning, don't use a smart handler.
    :XMP_OPEN_LIMITSCANNING,      0x00000080, # Only packet scan files "known" to need scanning.
    :XMP_OPEN_REPAIR_FILE,        0x00000100, # Attempt to repair a file opened for update, default is to not open (throw an exception).
    :XMP_OPEN_INBACKGROUND,       0x10000000  # Set if calling from background thread.
  ]

  # Option bits for xmp_files_close()
  XMP_CLOSE_FILE_OPTIONS = enum [
    :XMP_CLOSE_NOOPTION,   0x0000,
    :XMP_CLOSE_SAFEUPDATE, 0x0001
  ]

  # File formats
  XMP_FILE_TYPE = enum [
    :XMP_FT_PDF,     0x50444620,  # 'PDF '
    :XMP_FT_PS,      0x50532020,  # 'PS  ', general PostScript following DSC conventions.
    :XMP_FT_EPS,     0x45505320,  # 'EPS ', encapsulated PostScript.

    :XMP_FT_JPEG,    0x4A504547,  # 'JPEG'
    :XMP_FT_JPEG2K,  0x4A505820,  # 'JPX ', ISO 15444-1
    :XMP_FT_TIFF,    0x54494646,  # 'TIFF'
    :XMP_FT_GIF,     0x47494620,  # 'GIF '
    :XMP_FT_PNG,     0x504E4720,  # 'PNG '
    
    :XMP_FT_SWF,     0x53574620,  # 'SWF '
    :XMP_FT_FLA,     0x464C4120,  # 'FLA '
    :XMP_FT_FLV,     0x464C5620,  # 'FLV '

    :XMP_FT_MOV,     0x4D4F5620,  # 'MOV ', Quicktime
    :XMP_FT_AVI,     0x41564920,  # 'AVI '
    :XMP_FT_CIN,     0x43494E20,  # 'CIN ', Cineon
    :XMP_FT_WAV,     0x57415620,  # 'WAV '
    :XMP_FT_MP3,     0x4D503320,  # 'MP3 '
    :XMP_FT_SES,     0x53455320,  # 'SES ', Audition session
    :XMP_FT_CEL,     0x43454C20,  # 'CEL ', Audition loop
    :XMP_FT_MPEG,    0x4D504547,  # 'MPEG'
    :XMP_FT_MPEG2,   0x4D503220,  # 'MP2 '
    :XMP_FT_MPEG4,   0x4D503420,  # 'MP4 ', ISO 14494-12 and -14
    :XMP_FT_WMAV,    0x574D4156,  # 'WMAV', Windows Media Audio and Video
    :XMP_FT_AIFF,    0x41494646,  # 'AIFF'

    :XMP_FT_HTML,    0x48544D4C,  # 'HTML'
    :XMP_FT_XML,     0x584D4C20,  # 'XML '
    :XMP_FT_TEXT,    0x74657874,  # 'text'

    # Adobe application file formats.
    :XMP_FT_PHOTOSHOP,        0x50534420,  # 'PSD '
    :XMP_FT_ILLUSTRATOR,      0x41492020,  # 'AI  '
    :XMP_FT_INDESIGN,         0x494E4444,  # 'INDD'
    :XMP_FT_AEPROJECT,        0x41455020,  # 'AEP '
    :XMP_FT_AEPROJTEMPLATE,   0x41455420,  # 'AET ', After Effects Project Template
    :XMP_FT_AEFILTERPRESET,   0x46465820,  # 'FFX '
    :XMP_FT_ENCOREPROJECT,    0x4E434F52,  # 'NCOR'
    :XMP_FT_PREMIEREPROJECT,  0x5052504A,  # 'PRPJ'
    :XMP_FT_PREMIERETITLE,    0x5052544C,  # 'PRTL'

    # Catch all.
    :XMP_FT_UNKNOWN, 0x20202020
  ]

  XMP_FILE_FORMAT_OPTIONS = enum [
    :XMP_FMT_CAN_INJECT_XMP,        0x00000001,
    :XMP_FMT_CAN_EXPAND,            0x00000002,
    :XMP_FMT_CAN_REWRITE,           0x00000004,
    :XMP_FMT_PREFERS_IN_PLACE,      0x00000008,
    :XMP_FMT_CAN_RECONCILE,         0x00000010,
    :XMP_FMT_ALLOWS_ONLY_XMP,       0x00000020,
    :XMP_FMT_RETURNS_RAW_PACKET,    0x00000040,
    :XMP_FMT_HANDLER_OWNS_FILE,     0x00000100,
    :XMP_FMT_ALLOW_SAFE_UPDATE,     0x00000200,
    :XMP_FMT_NEEDS_READONLY_PACKET, 0x00000400,
    :XMP_FMT_USE_SIDECAR_XMP,       0x00000800,
    :XMP_FMT_FOLDER_BASED_FORMAT,   0x00001000,
    :_XMP_FMT_LAST
  ]

  XMP_ITER_OPTIONS = enum [
    :XMP_ITER_CLASSMASK,      0x00FF,  # The low 8 bits are an enum of what data structure to iterate.
    :XMP_ITER_PROPERTIES,     0x0000,  # Iterate the property tree of a TXMPMeta object.
    :XMP_ITER_ALIASES,        0x0001,  # Iterate the global alias table.
    :XMP_ITER_NAMESPACES,     0x0002,  # Iterate the global namespace table.
    :XMP_ITER_JUSTCHILDREN,   0x0100,  # Just do the immediate children of the root, default is subtree.
    :XMP_ITER_JUSTLEAFNODES,  0x0200,  # Just do the leaf nodes, default is all nodes in the subtree.
    :XMP_ITER_JUSTLEAFNAME,   0x0400,  # Return just the leaf part of the path, default is the full path.
    :XMP_ITER_INCLUDEALIASES, 0x0800,  # Include aliases, default is just actual properties.
    :XMP_ITER_OMITQUALIFIERS, 0x1000   # Omit all qualifiers.
  ]

  XMP_ITER_SKIP_OPTIONS = enum [
    :XMP_ITER_SKIPSUBTREE,   0x0001, # Skip the subtree below the current node.
    :XMP_ITER_SKIPSIBLINGS,  0x0002 # Skip the subtree below and remaining siblings of the current node.
  ]

  XMP_PROPS_BITS = enum [
    # Options relating to the XML string form of the property value.
    :XMP_PROP_VALUE_IS_URI,     0x00000002, # The value is a URI, use rdf:resource attribute.
                                           # DISCOURAGED

    # Options relating to qualifiers attached to a property.
    :XMP_PROP_HAS_QUALIFIERS,   0x00000010, # The property has qualifiers, includes rdf:type and xml:lang.
    :XMP_PROP_IS_QUALIFIER,     0x00000020, # This is a qualifier, includes rdf:type and xml:lang.
    :XMP_PROP_HAS_LANG,         0x00000040, # Implies XMP_PropHasQualifiers, property has xml:lang.
    :XMP_PROP_HAS_TYPE,         0x00000080, # Implies XMP_PropHasQualifiers, property has rdf:type.
    
    # Options relating to the data structure form.
    :XMP_PROP_VALUE_IS_STRUCT,  0x00000100, # The value is a structure with nested fields.
    :XMP_PROP_VALUE_IS_ARRAY,   0x00000200, # The value is an array (RDF alt/bag/seq).
    :XMP_PROP_ARRAY_IS_UNORDERED, 0x00000200,  # The item order does not matter. (e.g. same as XMP_PROP_VALUE_IS_ARRAY)
    :XMP_PROP_ARRAY_IS_ORDERED, 0x00000400, # Implies XMP_PropValueIsArray, item order matters.
    :XMP_PROP_ARRAY_IS_ALT,     0x00000800, # Implies XMP_PropArrayIsOrdered, items are alternates.
    
    # Additional struct and array options.
    :XMP_PROP_ARRAY_IS_ALTTEXT,    0x00001000, # Implies kXMP_PropArrayIsAlternate, items are localized text.
    :XMP_PROP_ARRAY_INSERT_BEFORE, 0x00004000, # Used by array functions.
    :XMP_PROP_ARRAY_INSERT_AFTER,  0x00008000, # Used by array functions.
    
    # Other miscellaneous options.
    :XMP_PROP_IS_ALIAS,         0x00010000, # This property is an alias name for another property.
    :XMP_PROP_HAS_ALIASES,      0x00020000, # This property is the base value for a set of aliases.
    :XMP_PROP_IS_INTERNAL,      0x00040000, # This property is an "internal" property, owned by applications.
    :XMP_PROP_IS_STABLE,        0x00100000, # This property is not derived from the document content.
    :XMP_PROP_IS_DERIVED,       0x00200000, # This property is derived from the document content.

    # Note that these are commented out in Exempi
    # kXMPUtil_AllowCommas,   0x10000000UL,  ! Used by TXMPUtils::CatenateArrayItems and ::SeparateArrayItems.
    # kXMP_DeleteExisting,    0x20000000UL,  ! Used by TXMPMeta::SetXyz functions to delete any pre-existing property.
    # kXMP_SchemaNode,        0x80000000UL,  ! Returned by iterators - #define to avoid warnings

    # Original values of these bitmasks noted; we can't access them by name
    # XMP_PROP_ARRAY_FORM_MASK  = XMP_PROP_VALUE_IS_ARRAY | XMP_PROP_ARRAY_IS_ORDERED | XMP_PROP_ARRAY_IS_ALT | XMP_PROP_ARRAY_IS_ALTTEXT,
    :XMP_PROP_ARRAY_FORM_MASK,  0x00000200 | 0x00000400 | 0x00000800 | 0x00001000,

    # XMP_PROP_COMPOSITE_MASK   = XMP_PROP_VALUE_IS_STRUCT | XMP_PROP_ARRAY_FORM_MASK,  /* Is it simple or composite (array or struct)? */
    :XMP_PROP_COMPOSITE_MASK,   0x00000100 | 0x00001E00,
    :XMP_IMPL_RESERVED_MASK,    0x70000000   # Reserved for transient use by the implementation.
  ]

  # These values are used in the enum below
  XMP_LITTLEENDIAN_BIT    = 0x0001  # ! Don't use directly, see the combined values below!
  XMP_UTF16_BIT           = 0x0002
  XMP_UTF32_BIT           = 0x0004

  # Options for xmp_serialize
  # Unnamed in exempi, named :XmpSerialOptions here
  XMP_SERIAL_OPTIONS = enum [
    :XMP_SERIAL_OMITPACKETWRAPPER,   0x0010,  # Omit the XML packet wrapper. */
    :XMP_SERIAL_READONLYPACKET,      0x0020,  # Defat is a writeable packet. */
    :XMP_SERIAL_USECOMPACTFORMAT,    0x0040,  # Use a compact form of RDF. */
    
    :XMP_SERIAL_INCLUDETHUMBNAILPAD, 0x0100,  # Include a padding allowance for a thumbnail image. */
    :XMP_SERIAL_EXACTPACKETLENGTH,   0x0200,  # The padding parameter is the overall packet length. */
    :XMP_SERIAL_WRITEALIASCOMMENTS,  0x0400,  # Show aliases as XML comments. */
    :XMP_SERIAL_OMITALLFORMATTING,   0x0800,  # Omit all formatting whitespace. */
    
    :XMP_SERIAL_ENCODINGMASK,        0x0007,
    :XMP_SERIAL_ENCODEUTF8,          0,
    :XMP_SERIAL_ENCODEUTF16BIG,      XMP_UTF16_BIT,
    :XMP_SERIAL_ENCODEUTF16LITTLE,   XMP_UTF16_BIT | XMP_LITTLEENDIAN_BIT,
    :XMP_SERIAL_ENCODEUTF32BIG,      XMP_UTF32_BIT,
    :XMP_SERIAL_ENCODEUTF32LITTLE,   XMP_UTF32_BIT | XMP_LITTLEENDIAN_BIT
  ]

  # Values used for tzSign field.
  # Another unnamed enum, used in XmpDateTime below
  TzSignValues = enum [
    :XMP_TZ_WEST, -1, # West of UTC
    :XMP_TZ_UTC,  0,  # UTC
    :XMP_TZ_EAST, +1  # East of UTC
  ]

  class XmpDateTime < FFI::Struct
    layout(
           :year,       :int32,
           :month,      :int32, # 1..12
           :day,        :int32, # 1..31
           :hour,       :int32, # 0..23
           :minute,     :int32, # 0..59
           :second,     :int32, # 0..59
           :tzSign,     Exempi::TzSignValues, # -1..+1, 0 means UTC, -1 is west, +1 is east.
           :tzHour,     :int32, # 0..23
           :tzMinute,   :int32, # 0..59
           :nanoSecond, :int32
    )

    # Converts a XmpDateTime struct into a Ruby object
    # @return [DateTime] A new Ruby DateTime object
    def to_datetime
      sign = self[:tzSign] == :XMP_TZ_WEST ? '-' : '+'
      zone = "%s%02d:%02d" % [sign, self[:tzHour], self[:tzMinute]]

      second = self[:second] + Rational(self[:nanoSecond],1000000000)

      DateTime.new self[:year], self[:month], self[:day], self[:hour],
        self[:minute], second, zone
    end

    # Creates an XmpDateTime struct using a Ruby DateTime object,
    # or a date string which is parseable by DateTime
    # @param [DateTime, String] source the date to convert
    # @return [Exempi::XmpDateTime] an XmpDateTime struct
    def self.from_datetime source
      if source.is_a? String
        source = DateTime.parse source
      end

      struct = self.new
      [:year, :month, :day, :hour, :minute, :second].each do |field|
        struct[field] = source.send field
      end
      struct[:nanoSecond] = source.to_time.nsec

      match = source.zone.match /(?<sign>[-+]){1}(?<hour>\d\d){1}:(?<minute>\d\d){1}/
      if match
        if match[:sign] == '-' then struct[:tzSign] = -1
        elsif match[:hour] == '00' && match[:minute] == '00' then struct[:tzSign] = 0
        else struct[:tzSign] = 1
        end

        struct[:tzHour] = match[:hour].to_i
        struct[:tzMinute] = match[:minute].to_i
      end

      struct
    end
  end

  # Creates DataConverter classes from each of these enums
  [ "XMP_OPEN_FILE_OPTIONS", "XMP_CLOSE_FILE_OPTIONS", "XMP_FILE_TYPE",
    "XMP_FILE_FORMAT_OPTIONS", "XMP_ITER_OPTIONS", "XMP_ITER_SKIP_OPTIONS",
    "XMP_PROPS_BITS", "XMP_SERIAL_OPTIONS" ].each do |enum|
      klass = Class.new do
        extend FFI::DataConverter
        native_type FFI::Type::INT
        @enum = enum

        def self.to_native(values, ctx)
          case values
          when Symbol
            val = Exempi.const_get(@enum)[values]
            if not val
              raise Exempi::InvalidOptionError,
                "#{values} is not a valid option for #{@enum}"
            else
              val
            end
          when Fixnum then values
          when NilClass then 0
          else
            invalid_opt = values.find {|v| Exempi.const_get(@enum)[v].nil?}
            if invalid_opt
              raise Exempi::InvalidOptionError,
                "#{invalid_opt} is not a valid option for #{@enum}"
            end

            values.inject(0) {|mask, value| mask |= Exempi.const_get(@enum)[value]}
          end
        end
      end

      klass_name = enum.split("_").map {|str| str.capitalize}.join
      const_set klass_name, klass
    end

  # Converts a bitfield into a hash of named options via bitwise AND.
  # @param [Integer] int the bitfield integer
  # @param [FFI::Enum] enum the enum with which to compare
  # @param [Boolean] short_name true to return shortened option names
  # @return [Hash] a hash which includes symbol representations of the included options
  def self.parse_bitmask int, enum, short_name=false
    enum_hash = enum.to_hash
    opt_hash = {}
    enum_hash.each do |k,v|
      if short_name
        option = k.to_s.split("_")[2..-1].join("_").downcase.to_sym
      else
        option = k
      end

      opt_hash[option] = ((int & v) == v)
    end

    opt_hash
  end
end