module Paperclip
  class SquishTo < Processor
    def initialize(file, options = {}, attachment = nil)
      super
      squish          = @attachment.options[:squish_to] || 500
      @file           = file
      @attachment     = attachment
      @basename       = File.basename(@file.path)
      @threshhold     = 1024 * squish
    end

    def make
      begin
        if is_jpeg?(@file.path)
          size = File.size(@file.path)

          if size > @threshhold
            temp_file = Tempfile.new(@basename)
            temp_file.binmode

            quality = 98

            while size > @threshhold && quality > 0
              convert("-strip -interlace Plane -quality #{quality}% #{fromFile} #{toFile(temp_file)}")
              size = File.size(temp_file)
              quality = quality - 2
            end

            temp_file
          else
            @file
          end
        else
          @file
        end
      rescue Cocaine::ExitStatusError => e
        raise Paperclip::Error, "Could not convert #{@basename}" if @whiny
      rescue Cocaine::CommandNotFoundError => e
        raise Paperclip::Errors::CommandNotFoundError.new("Command not found.")
      end
    end

    def fromFile
      File.expand_path(@file.path)
    end

    def toFile(destination)
      File.expand_path(destination.path)
    end

    def is_jpeg?(file)
      png = Regexp.new("\x89PNG".force_encoding("binary"))
      jpg = Regexp.new("\xff\xd8\xff\xe0\x00\x10JFIF".force_encoding("binary"))
      jpg2 = Regexp.new("\xff\xd8\xff\xe1(.*){2}Exif".force_encoding("binary"))
      case IO.read(file, 10)
      when /^#{jpg}/
        true
      when /^#{jpg2}/
        true
      else
        false
      end
    end
  end
end