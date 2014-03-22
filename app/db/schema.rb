# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140322131328) do

  create_table "channel_playlists", force: true do |t|
    t.string   "author"
    t.string   "name"
    t.text     "description"
    t.string   "language"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "episodes", force: true do |t|
    t.string   "title"
    t.string   "link"
    t.datetime "pub_date"
    t.string   "guid"
    t.string   "subtitle"
    t.text     "content"
    t.integer  "duration"
    t.string   "flattr_url"
    t.string   "tags"
    t.string   "icon_url"
    t.string   "audio_file_url"
    t.boolean  "cached"
    t.string   "local_path"
    t.integer  "podcast_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "filesize"
  end

  create_table "playlist_entries", force: true do |t|
    t.datetime "start_time"
    t.boolean  "premiere"
    t.integer  "channel_playlist_id"
    t.integer  "episode_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "podcasts", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "logo_url"
    t.string   "website"
    t.string   "feed"
    t.string   "tags"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
