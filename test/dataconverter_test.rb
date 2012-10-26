require 'exempi/consts'

require 'minitest/autorun'

describe "dataconverter helper" do
	it "should be able to look up single symbol values" do
    Exempi::XmpOpenFileOptions.to_native(:XMP_OPEN_READ, nil).must_equal 0x00000001
  end

  it "should be able to look up an array of symbol values" do
    Exempi::XmpOpenFileOptions.to_native([:XMP_OPEN_USESMARTHANDLER,
      :XMP_OPEN_USEPACKETSCANNING], nil).must_equal 0x00000060
  end

  it "should be able to handle pure integer values" do
    Exempi::XmpOpenFileOptions.to_native(0x00000001, nil).must_equal 0x00000001
  end

  it "should return 0 when nil is passed" do
    Exempi::XmpOpenFileOptions.to_native(nil, nil).must_equal 0
  end

  it "should raise when invalid options are passed" do
    lambda do
      Exempi::XmpOpenFileOptions.to_native(:notanoption, nil)
    end.must_raise Exempi::InvalidOptionError

    lambda do
      Exempi::XmpOpenFileOptions.to_native([:notanoption, :notanoption], nil)
    end.must_raise Exempi::InvalidOptionError
  end

  it "should be able to translate integers into hashes of options" do
    hash = Exempi.parse_bitmask 0x00000060, Exempi::XMP_OPEN_FILE_OPTIONS

    assert hash[:XMP_OPEN_USESMARTHANDLER]
    assert hash[:XMP_OPEN_USEPACKETSCANNING]
    refute hash[:XMP_OPEN_FORUPDATE]
  end

  it "should optionally be able to return short option names" do
    hash = Exempi.parse_bitmask 0x00000060, Exempi::XMP_OPEN_FILE_OPTIONS, true

    assert hash[:usesmarthandler]
    assert hash[:usepacketscanning]
    refute hash[:forupdate]
  end
end