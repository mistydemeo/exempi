require 'exempi/consts'

require 'minitest/autorun'

describe "DateTime struct wrapper" do
  it "should be able to construct an XmpDateTime struct manually" do
    date = Exempi::XmpDateTime.new
    date[:year]  = 2012
    date[:month] = 9
    date[:day]   = 7
  end

  it "should be able to create an XmpDateTime struct from a DateTime object" do
    today = DateTime.now
    date = Exempi::XmpDateTime.from_datetime today

    date[:year].must_equal today.year
  end

  it "should be able to create an XmpDateTime struct from a string" do
    today = '2012-09-07'
    date = Exempi::XmpDateTime.from_datetime today

    date[:year].must_equal 2012
  end

  it "should be able to translate XmpDateTime structs into DateTime objects" do
    today = DateTime.now
    date = Exempi::XmpDateTime.from_datetime today

    date.to_datetime.strftime('%I:%M:%S %p').must_equal today.strftime('%I:%M:%S %p')
  end
end