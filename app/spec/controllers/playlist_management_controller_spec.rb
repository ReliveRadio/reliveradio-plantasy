require 'spec_helper'

describe PlaylistManagementController do

	login_admin	

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
			end
		end
	end

	describe "remove playlist entries" do

	end

	describe "sort playlist entries" do

	end

	end
