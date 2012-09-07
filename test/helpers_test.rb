require 'exempi'

require 'minitest/autorun'

describe "Exempi helpers" do
  it "should be able to silence stderr for noisy blocks" do
    Exempi.verbose = false
    lambda do
      Exempi.send(:shutup!) { STDERR.puts "You should not see this" }
    end.must_be_silent
  end

  it "should wrap Exempi functions correctly" do
    Exempi.verbose = false
    lambda do
      # Exempi spews errors to stderr, so we've wrapped attach_function
      # in order to ensure that every function call is wrapped with
      # the silencing shutup! method
      Exempi.xmp_files_open_new('no_file_here', 0)
    end.must_be_silent
  end
end