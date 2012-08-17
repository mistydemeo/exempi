# Copyright 2002 Adobe Systems Incorporated
# All Rights Reserved.
#
# NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the terms
# of the Adobe license agreement accompanying it.
# 
# Copyright (c) 1999 - 2010, Adobe Systems IncorporatedAll rights reserved.
# 
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 
# * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 
# * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# 
# * Neither the name of Adobe Systems Incorporated, nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOTLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FORA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER ORCONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, ORPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OFLIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDINGNEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THISSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

module Exempi
  module Namespaces
    # Standard namespace URI constants
    # 
    # \name XML namespace constants for standard XMP schema.
    # @{
    #
    # \def XMP_NS_XMP
    # \brief The XML namespace for the XMP "basic" schema.
    #
    # \def XMP_NS_XMP_Rights
    # \brief The XML namespace for the XMP copyright schema.
    #
    # \def XMP_NS_XMP_MM
    # \brief The XML namespace for the XMP digital asset management schema.
    #
    # \def XMP_NS_XMP_BJ
    # \brief The XML namespace for the job management schema.
    #
    # \def XMP_NS_XMP_T
    # \brief The XML namespace for the XMP text document schema.
    #
    # \def XMP_NS_XMP_T_PG
    # \brief The XML namespace for the XMP paged document schema.
    #
    # \def XMP_NS_PDF
    # \brief The XML namespace for the PDF schema.
    #
    # \def XMP_NS_Photoshop
    # \brief The XML namespace for the Photoshop custom schema.
    #
    # \def XMP_NS_EXIF
    # \brief The XML namespace for Adobe's EXIF schema.
    #
    # \def XMP_NS_TIFF
    # \brief The XML namespace for Adobe's TIFF schema.

    XMP_NS_XMP        = "http://ns.adobe.com/xap/1.0/"

    XMP_NS_XMP_Rights = "http://ns.adobe.com/xap/1.0/rights/"
    XMP_NS_XMP_MM     = "http://ns.adobe.com/xap/1.0/mm/"
    XMP_NS_XMP_BJ     = "http://ns.adobe.com/xap/1.0/bj/"

    XMP_NS_PDF        = "http://ns.adobe.com/pdf/1.3/"
    XMP_NS_Photoshop  = "http://ns.adobe.com/photoshop/1.0/"
    XMP_NS_PSAlbum    = "http://ns.adobe.com/album/1.0/"
    XMP_NS_EXIF       = "http://ns.adobe.com/exif/1.0/"
    XMP_NS_EXIF_Aux   = "http://ns.adobe.com/exif/1.0/aux/"
    XMP_NS_TIFF       = "http://ns.adobe.com/tiff/1.0/"
    XMP_NS_PNG        = "http://ns.adobe.com/png/1.0/"
    XMP_NS_SWF        = "http://ns.adobe.com/swf/1.0/"
    XMP_NS_JPEG       = "http://ns.adobe.com/jpeg/1.0/"
    XMP_NS_JP2K       = "http://ns.adobe.com/jp2k/1.0/"
    XMP_NS_CameraRaw  = "http://ns.adobe.com/camera-raw-settings/1.0/"
    XMP_NS_DM         = "http://ns.adobe.com/xmp/1.0/DynamicMedia/"
    XMP_NS_Script     = "http://ns.adobe.com/xmp/1.0/Script/"
    XMP_NS_ASF        = "http://ns.adobe.com/asf/1.0/"
    XMP_NS_WAV        = "http://ns.adobe.com/xmp/wav/1.0/"
    XMP_NS_BWF        = "http://ns.adobe.com/bwf/bext/1.0/"

    XMP_NS_XMP_Note   = "http://ns.adobe.com/xmp/note/"

    XMP_NS_AdobeStockPhoto = "http://ns.adobe.com/StockPhoto/1.0/"
    XMP_NS_CreatorAtom = "http://ns.adobe.com/creatorAtom/1.0/"

    # \name XML namespace constants for qualifiers and structured property fields.
    # @{
    #
    # \def XMP_NS_XMP_IdentifierQual
    # \brief The XML namespace for qualifiers of the xmp:Identifier property.
    #
    # \def XMP_NS_XMP_Dimensions
    # \brief The XML namespace for fields of the Dimensions type.
    #
    # \def XMP_NS_XMP_Image
    # \brief The XML namespace for fields of a graphical image. Used for the Thumbnail type.
    #
    # \def XMP_NS_XMP_ResourceEvent
    # \brief The XML namespace for fields of the ResourceEvent type.
    #
    # \def XMP_NS_XMP_ResourceRef
    # \brief The XML namespace for fields of the ResourceRef type.
    #
    # \def XMP_NS_XMP_ST_Version
    # \brief The XML namespace for fields of the Version type.
    #
    # \def XMP_NS_XMP_ST_Job
    # \brief The XML namespace for fields of the JobRef type.

    XMP_NS_XMP_IdentifierQual = "http://ns.adobe.com/xmp/Identifier/qual/1.0/"
    XMP_NS_XMP_Dimensions     = "http://ns.adobe.com/xap/1.0/sType/Dimensions#"
    XMP_NS_XMP_Text           = "http://ns.adobe.com/xap/1.0/t/"
    XMP_NS_XMP_PagedFile      = "http://ns.adobe.com/xap/1.0/t/pg/"
    XMP_NS_XMP_Graphics       = "http://ns.adobe.com/xap/1.0/g/"
    XMP_NS_XMP_Image          = "http://ns.adobe.com/xap/1.0/g/img/"
    XMP_NS_XMP_Font           = "http://ns.adobe.com/xap/1.0/sType/Font#"
    XMP_NS_XMP_ResourceEvent  = "http://ns.adobe.com/xap/1.0/sType/ResourceEvent#"
    XMP_NS_XMP_ResourceRef    = "http://ns.adobe.com/xap/1.0/sType/ResourceRef#"
    XMP_NS_XMP_ST_Version     = "http://ns.adobe.com/xap/1.0/sType/Version#"
    XMP_NS_XMP_ST_Job         = "http://ns.adobe.com/xap/1.0/sType/Job#"
    XMP_NS_XMP_ManifestItem   = "http://ns.adobe.com/xap/1.0/sType/ManifestItem#"

    # Deprecated XML namespace constants
    XMP_NS_XMP_T     = "http://ns.adobe.com/xap/1.0/t/"
    XMP_NS_XMP_T_PG  = "http://ns.adobe.com/xap/1.0/t/pg/"
    XMP_NS_XMP_G_IMG = "http://ns.adobe.com/xap/1.0/g/img/"

    # XML namespace constants from outside Adobe.
    # @{
    #
    # \def XMP_NS_DC
    # \brief The XML namespace for the Dublin Core schema.
    #
    # \def XMP_NS_IPTCCore
    # \brief The XML namespace for the IPTC Core schema.
    #
    # \def XMP_NS_RDF
    # \brief The XML namespace for RDF.
    #
    # \def XMP_NS_XML
    # \brief The XML namespace for XML.

    XMP_NS_DC             = "http://purl.org/dc/elements/1.1/"

    XMP_NS_IPTCCore       = "http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/"

    XMP_NS_DICOM          = "http://ns.adobe.com/DICOM/"

    XMP_NS_PDFA_Schema    = "http://www.aiim.org/pdfa/ns/schema#"
    XMP_NS_PDFA_Property  = "http://www.aiim.org/pdfa/ns/property#"
    XMP_NS_PDFA_Type      = "http://www.aiim.org/pdfa/ns/type#"
    XMP_NS_PDFA_Field     = "http://www.aiim.org/pdfa/ns/field#"
    XMP_NS_PDFA_ID        = "http://www.aiim.org/pdfa/ns/id/"
    XMP_NS_PDFA_Extension = "http://www.aiim.org/pdfa/ns/extension/"

    XMP_NS_PDFX           = "http://ns.adobe.com/pdfx/1.3/"
    XMP_NS_PDFX_ID        = "http://www.npes.org/pdfx/ns/id/"

    XMP_NS_RDF            = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    XMP_NS_XML            = "http://www.w3.org/XML/1998/namespace"

  end
end