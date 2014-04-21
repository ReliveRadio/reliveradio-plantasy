require 'spec_helper'
require 'ruby-mpd'

describe PlaylistManagementController do

	login_admin

	# clear mpd playlist before each test
	before(:each) do
      mpd = MPD.new "/home/vagrant/.mpd/socket/mix"
      mpd.connect
      mpd.clear
      mpd.disconnect
    end

    # clear after all tests
    after(:all) do
      mpd = MPD.new "/home/vagrant/.mpd/socket/mix"
      mpd.connect
      mpd.clear
      mpd.disconnect
    end

	describe "GET 'index'" do
		it "returns http success" do
			channel_playlist = create(:channel_playlist)
			get 'index', channel_playlist: channel_playlist.id
			response.should be_success
		end

		it "assigns jingles" do
			channel_playlist = create(:channel_playlist)
			jingle = create(:jingle)
			get 'index', channel_playlist: channel_playlist.id
			assigns(:jingles).should eq([jingle])
		end

		it "assigns playlist_entries" do
			playlist_entry = create(:playlist_entry_episode)
			get 'index', channel_playlist: playlist_entry.channel_playlist.id
			assigns(:playlist_entries).should eq([playlist_entry])
		end
	end

	describe "add playlist entries" do
		describe "add jingle" do

		end

		describe "add episode" do
			describe "with valid params" do
				it "creates a new PlaylistEntry" do
					channel_playlist = create(:channel_playlist)
					episode = create(:episode_cached)
					expect {
						xhr :get, :append_entry, {episode_id: episode.id, channel_playlist: channel_playlist.id}
					}.to change(PlaylistEntry, :count).by(1)
				end
				it "sets the playlist entry start_time and end_time correctly if there is no playing playlist_entry" do
					channel_playlist = create(:channel_playlist)
					episode = create(:episode_cached)
					Timecop.freeze(Time.zone.now)
					xhr :get, :append_entry, {episode_id: episode.id, channel_playlist: channel_playlist.id}
					entry = PlaylistEntry.first
					expect(entry.start_time.to_i).to eq(Time.zone.now.to_i) # calling to_i because nanoseconds not stored in databse
					expect(entry.end_time.to_i).to eq((entry.start_time + entry.episode.duration.seconds).to_i)
				end
			end
		end
	end

	describe "remove playlist entries" do

	end

	describe "sort playlist entries" do

	end

	end
