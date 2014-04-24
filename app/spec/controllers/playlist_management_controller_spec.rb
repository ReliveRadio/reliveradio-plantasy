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
			# same as adding episodes but with jingles
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
				it "sets the playlist entry start_time and end_time correctly if there is no other playlist_entry " do
					channel_playlist = create(:channel_playlist)
					episode = create(:episode_cached)
					Timecop.freeze(Time.zone.now)
					xhr :get, :append_entry, {episode_id: episode.id, channel_playlist: channel_playlist.id}
					entry = PlaylistEntry.first
					expect(entry.start_time.to_i).to eq(Time.zone.now.to_i) # calling to_i because nanoseconds not stored in databse
					expect(entry.end_time.to_i).to eq((entry.start_time + entry.episode.duration.seconds).to_i)
				end
				it "sets the playlist entry start_time and end_time correctly if there are past playlist_entries" do
					channel_playlist = create(:channel_playlist)
					episode = create(:episode_cached)
					Timecop.freeze(Time.zone.now)

					# create older entry that is in the past!
					old_entry = create(:playlist_entry_episode, episode: episode, channel_playlist: channel_playlist, start_time: (Time.zone.now - episode.duration - 10.minutes))

					xhr :get, :append_entry, {episode_id: episode.id, channel_playlist: channel_playlist.id}
					entry = assigns(:playlist_entry)
					expect(entry.start_time.to_i).to eq(Time.zone.now.to_i) # calling to_i because nanoseconds not stored in databse
					expect(entry.end_time.to_i).to eq((entry.start_time + entry.episode.duration.seconds).to_i)
					expect(entry.position).to eq(old_entry.position + 1)
				end
				it "sets the playlist entry start_time and end_time correctly if there schedules playlist entries present" do
					channel_playlist = create(:channel_playlist)
					episode = create(:episode_cached)
					Timecop.freeze(Time.zone.now)

					# create older entry that is in the past!
					entry1 = create(:playlist_entry_episode, episode: episode, channel_playlist: channel_playlist, start_time: Time.zone.now)
					entry2 = create(:playlist_entry_episode, episode: episode, channel_playlist: channel_playlist, start_time: entry1.end_time)

					xhr :get, :append_entry, {episode_id: episode.id, channel_playlist: channel_playlist.id}
					entry = assigns(:playlist_entry)
					expect(entry.start_time.to_i).to eq(entry2.end_time.to_i) # calling to_i because nanoseconds not stored in databse
					expect(entry.end_time.to_i).to eq((entry.start_time + entry.episode.duration.seconds).to_i)
					expect(entry.position).to eq(entry2.position + 1)
				end
			end

			describe "with invalid params" do
				it "does not create a new PlaylistEntry" do
					channel_playlist = create(:channel_playlist)
					episode = create(:episode)
					expect {
						xhr :get, :append_entry, {episode_id: episode.id, channel_playlist: channel_playlist.id}
					}.not_to change(PlaylistEntry, :count).by(1)
				end
			end
		end
	end

	describe "update mpd" do

	end

	describe "remove playlist entries" do

	end

	describe "sort playlist entries" do

	end

	end
