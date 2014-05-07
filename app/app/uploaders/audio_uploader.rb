# encoding: utf-8

require 'audioinfo'
require 'taglib'

class AudioUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    Rails.root.to_s + "/audio/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    # "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  process :calc_duration
  process :tag_audiofile_process

  def calc_duration
    # read duration from audio file
    AudioInfo.open(current_path) do |info|
      #info.artist   # or info["artist"]
      #info.title    # or info["title"]
      model.duration = info.length   # playing time of the file
      #info.bitrate  # average bitrate
      #info.to_h     # { "artist" => "artist", "title" => "title", etc... }
    end
  end

  def tag_audiofile_process
    if model.is_a? Episode
      podcast = Podcast.find(model.podcast_id)
      tag_audiofile(model.title, podcast.author, podcast.title, model.pub_date.year, podcast.category)
    elsif model.is_a? Jingle
      tag_audiofile("Jingle", "ReliveRadio", "ReliveRadio Jingles", Time.zone.now.year, "Jingle")
    end
  end

  def tag_audiofile(title, artist, album, year, genre)
    # Set tags of the file based on feed data
    # this data is later used by mpd and transferred to icecast
    # users of webradio see this data as currently played song
    TagLib::FileRef.open(current_path) do |fileref|
      unless fileref.null?
        tag = fileref.tag

        tag.title = title
        tag.artist = artist
        tag.album = album
        tag.year = year
        #tag.track   #=> 7
        tag.genre = genre
        #tag.comment #=> nil

        fileref.save # store tags in file
      end
    end # File is automatically closed at block end
  end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # use here only what ruby-audioinfo supports
  def extension_white_list
    %w(mp3 ogg mpc ape wma flac aac mp4 m4a)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
