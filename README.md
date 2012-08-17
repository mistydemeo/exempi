# Exempi

Exempi is an ultra-thin [FFI](https://github.com/ffi/ffi)-based wrapper for the [Exempi](http://libopenraw.freedesktop.org/wiki/Exempi) C library. It wraps Exempi's functions in the Exempi module.

Don't like dealing with C functions directly? Check out [Fasttrack](https://github.com/mistydemeo/fasttrack), an object-oriented wrapper around Exempi.

## Installation

Add this line to your application's Gemfile:

    gem 'exempi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exempi

## Usage samples

Opening a file:

```ruby
# create an empty file pointer
file_ptr = Exempi.xmp_files_new
Exempi.xmp_files_open file_ptr, "myfile.jpg", :XMP_OPEN_READ
```

Extracting XMP from a file:

```ruby
xmp_ptr = Exempi.files_get_new_xmp file_ptr
```

Fetching an XMP property from a file:

```ruby
# Exempi provides a set of standard namespace URIs for you
exif_ns = Exempi::Namespaces::XMP_NS_EXIF
xmp_string = Exempi.xmp_string_new

Exempi.xmp_get_property xmp_ptr, exif_ns, 'DateTimeOriginal', xmp_string
datetime = Exempi.xmp_string_cstr xmp_string
Exempi.xmp_string_free xmp_string
```

For more information see Exempi's function documentation, included in lib/exempi/exempi.rb.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

3-clause BSD, identical to the license used by Exempi and Adobe XMP Toolkit. For the license text, see LICENSE.