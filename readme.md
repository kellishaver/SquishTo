SquishTo
====

SquishTo is a Paperclip processor that allows you to compress JPG images to at or below a specified filesize (the default to 500k).

Obviously, this can result in poor quality images depending on the input file and the destination file size, so you should use SquishTo with caution.

SquishTo can also slow down attachment processing and may not be suitable for very large images.


###Installation

To install SquishTo, create a `paperclip_procesors` folder inside of your Rails application `lib` directory. Then simply place `squish_to.rb` inside of it.


###Usage

To use Squishto, you'll need to add it as a processor inside of your model, like so:

    has_attached_file :image, :styles => {
      res2048:  "2048x2048>",
      res960:   "960x960>"
    },
    processors: [:thumbnail, :squish_to]

    validates_attachment_content_type :image, content_type: [ 'image/jpg', 'image/jpeg', "image/png", "image/gif"]
    validates_attachment_size :image, less_than: 8.megabytes
    validates_attachment_presence :image


###Customizing

If you'd like to compress to a final output size other than 500kb, create a `paperclip.rb` file inside of your Rails Applications' `config/initializers` directory and set the SquishTo output size like so:

    Paperclip::Attachment.default_options[:squish_to] = 500

Please note that the `:squish_to` value is always specified in kilobytes.

