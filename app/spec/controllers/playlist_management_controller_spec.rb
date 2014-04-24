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
			get 'index', channel_playlist_id: channel_playlist.id
			response.should be_success
		end

		it "assigns jingles" do
			channel_playlist = create(:channel_playlist)
			jingle = create(:jingle)
			get 'index', channel_playlist_id: channel_playlist.id
			assigns(:jingles).should eq([jingle])
		end

		it "assigns playlist_entries" do
			playlist_entry = create(:playlist_entry_episode)
			get 'index', channel_playlist_id: playlist_entry.channel_playlist.id
			assigns(:playlist_entries).should eq([playlist_entry])
		end

		it "sets correct offset for playlist" do
			pending
		end

		it "only assigns playlist entries that are live and future" do
			pending
		end
	end

	describe "add playlist entries" do
		describe "add jingle" do
			describe "with valid params" do
				it "creates a new PlaylistEntry" do
					channel_playlist = create(:channel_playlist)
					jingle = create(:jingle)
					expect {
						xhr :get, :append_entry, {jingle_id: jingle.id, channel_playlist_id: channel_playlist.id}
					}.to change(PlaylistEntry, :count).by(1)
				end
				it "sets the playlist entry start_time and end_time correctly if there is no other playlist_entry " do
						channel_playlist = create(:channel_playlist)
						jingle = create(:jingle)
						Timecop.freeze(Time.zone.now)
						xhr :get, :append_entry, {jingle_id: jingle.id, channel_playlist_id: channel_playlist.id}
						entry = PlaylistEntry.first
					expect(entry.start_time.to_i).to eq(Time.zone.now.to_i) # calling to_i because nanoseconds not stored in databse
					expect(entry.end_time.to_i).to eq((entry.start_time + entry.jingle.duration.seconds).to_i)
				end
				it "sets the playlist entry start_time and end_time correctly if there are past playlist_entries" do
					channel_playlist = create(:channel_playlist)
					jingle = create(:jingle)
					Timecop.freeze(Time.zone.now)

					# create older entry that is in the past!
					old_entry = create(:playlist_entry_jingle, jingle: jingle, channel_playlist: channel_playlist, start_time: (Time.zone.now - jingle.duration - 10.minutes))

					xhr :get, :append_entry, {jingle_id: jingle.id, channel_playlist_id: channel_playlist.id}
					entry = assigns(:playlist_entry)
					expect(entry.start_time.to_i).to eq(Time.zone.now.to_i) # calling to_i because nanoseconds not stored in databse
					expect(entry.end_time.to_i).to eq((entry.start_time + entry.jingle.duration.seconds).to_i)
					expect(entry.position).to eq(old_entry.position + 1)
				end
				it "sets the playlist entry start_time and end_time correctly if there schedules playlist entries present" do
					channel_playlist = create(:channel_playlist)
					jingle = create(:jingle)
					Timecop.freeze(Time.zone.now)

					# create older entry that is in the past!
					entry1 = create(:playlist_entry_jingle, jingle: jingle, channel_playlist: channel_playlist, start_time: Time.zone.now)
					entry2 = create(:playlist_entry_jingle, jingle: jingle, channel_playlist: channel_playlist, start_time: entry1.end_time)

					xhr :get, :append_entry, {jingle_id: jingle.id, channel_playlist_id: channel_playlist.id}
					entry = assigns(:playlist_entry)
					expect(entry.start_time.to_i).to eq(entry2.end_time.to_i) # calling to_i because nanoseconds not stored in databse
					expect(entry.end_time.to_i).to eq((entry.start_time + entry.jingle.duration.seconds).to_i)
					expect(entry.position).to eq(entry2.position + 1)
				end
			end
		end
	end

	describe "add episode" do
		describe "with valid params" do
			it "creates a new PlaylistEntry" do
				channel_playlist = create(:channel_playlist)
				episode = create(:episode_cached)
				expect {
					xhr :get, :append_entry, {episode_id: episode.id, channel_playlist_id: channel_playlist.id}	
				}.to change(PlaylistEntry, :count).by(1)
			end
			it "sets the playlist entry start_time and end_time correctly if there is no other playlist_entry " do
					channel_playlist = create(:channel_playlist)
					episode = create(:episode_cached)
					Timecop.freeze(Time.zone.now)
					xhr :get, :append_entry, {episode_id: episode.id, channel_playlist_id: channel_playlist.id}
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

				xhr :get, :append_entry, {episode_id: episode.id, channel_playlist_id: channel_playlist.id}
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

				xhr :get, :append_entry, {episode_id: episode.id, channel_playlist_id: channel_playlist.id}
				entry = assigns(:playlist_entry)
				expect(entry.start_time.to_i).to eq(entry2.end_time.to_i) # calling to_i because nanoseconds not stored in databse
				expect(entry.end_time.to_i).to eq((entry.start_time + entry.episode.duration.seconds).to_i)
				expect(entry.position).to eq(entry2.position + 1)
			end
		end

		describe "with invalid params" do
			it "does not create a new PlaylistEntry if episode is not cached" do
				channel_playlist = create(:channel_playlist)
				episode = create(:episode)
				expect {
					xhr :get, :append_entry, {episode_id: episode.id, channel_playlist_id: channel_playlist.id}
				}.not_to change(PlaylistEntry, :count).by(1)
			end
		end
	end

	describe "update mpd" do
		pending
	end

	describe "remove playlist entries" do
	# danger zone: end_time < Time.now + 30.minutes
	
		it "destroys the playlist entry" do
			# create entry that is NOT in danger zone
			Timecop.freeze(Time.zone.now)
			channel_playlist = create(:channel_playlist)
			episode = create(:episode_cached, duration: 1.hour)

			entry = create(:playlist_entry_episode, start_time: Time.zone.now, episode: episode, channel_playlist: channel_playlist)
			for i in 0..10 do
				entry = create(:playlist_entry_episode, channel_playlist: channel_playlist, episode: episode, start_time: entry.end_time)
				entry_to_destroy = entry if i == 5
			end

			expect {
				xhr :get, :destroy_entry, {channel_playlist_id: entry.channel_playlist.id, playlist_entry_id: entry_to_destroy.id}
			}.to change(PlaylistEntry, :count).by(-1)
		end

		it "updates the playtimes of the following playlist entries" do
			Timecop.freeze(Time.zone.now)
			channel_playlist = create(:channel_playlist)
			episode = create(:episode_cached, duration: 1.hour)

			entry = create(:playlist_entry_episode, start_time: Time.zone.now, episode: episode, channel_playlist: channel_playlist)
			for i in 0..10 do
				entry = create(:playlist_entry_episode, channel_playlist: channel_playlist, episode: episode, start_time: entry.end_time)
				entry_to_destroy = entry if i == 5
			end

			xhr :get, :destroy_entry, {channel_playlist_id: entry.channel_playlist.id, playlist_entry_id: entry_to_destroy.id}
			playlist_entries = assigns(:playlist_entries)

			for i in 1..10 do
				expect(playlist_entries[i].start_time.to_i).to eq(playlist_entries[i-1].end_time.to_i)
			end
		end

		it "updates the position of the playlist entries" do
			Timecop.freeze(Time.zone.now)
			channel_playlist = create(:channel_playlist)
			episode = create(:episode_cached, duration: 1.hour)

			entry = create(:playlist_entry_episode, start_time: Time.zone.now, episode: episode, channel_playlist: channel_playlist)
			for i in 0..10 do
				entry = create(:playlist_entry_episode, channel_playlist: channel_playlist, episode: episode, start_time: entry.end_time)
				entry_to_destroy = entry if i == 5
			end

			xhr :get, :destroy_entry, {channel_playlist_id: entry.channel_playlist.id, playlist_entry_id: entry_to_destroy.id}
			playlist_entries = assigns(:playlist_entries)

			for i in 1..10 do
				expect(playlist_entries[i].position).to eq(playlist_entries[i-1].position + 1)
			end
		end

		#end_time < Time.now + 30.minutes
		it "does not remove playlist entries that are in danger zone" do
			Timecop.freeze(Time.zone.now)
			channel_playlist = create(:channel_playlist)
			episode = create(:episode_cached, duration: 10.minutes)

			entry = create(:playlist_entry_episode, start_time: Time.zone.now, episode: episode, channel_playlist: channel_playlist)
			for i in 0..10 do
				entry = create(:playlist_entry_episode, channel_playlist: channel_playlist, episode: episode, start_time: entry.end_time)
				entry_to_destroy = entry if i == 0
			end

			expect {
				xhr :get, :destroy_entry, {channel_playlist_id: entry_to_destroy.channel_playlist.id, playlist_entry_id: entry_to_destroy.id}
			}.not_to change(PlaylistEntry, :count)	
		end
	end

	describe "sort playlist entries" do
		it "does not allow changes in danger zone" do
			Timecop.freeze(Time.zone.now)
			channel_playlist = create(:channel_playlist)
			episode = create(:episode_cached, duration: 10.minutes)

			# create entries
			entry = create(:playlist_entry_episode, start_time: Time.zone.now, episode: episode, channel_playlist: channel_playlist)
			for i in 0..5 do
				entry = create(:playlist_entry_episode, channel_playlist: channel_playlist, episode: episode, start_time: entry.end_time)
			end

			# request index to get entries and offset
			get 'index', channel_playlist_id: channel_playlist.id
			offset = assigns(:offset)
			entries = assigns(:playlist_entries)

			# create array with current order
			new_order = Array.new
			entries.each_with_index do |entry, index| 
				new_order[index] = entry.id
			end

			swap_a = 1
			swap_b = 2
			changed_entry_1 = entries[swap_a]
			changed_entry_2 = entries[swap_b]

			# swap two entries
			tmp = new_order[swap_a]
			new_order[swap_a] = new_order[swap_b]
			new_order[swap_b] = tmp

			xhr :post, :sort, {channel_playlist_id: channel_playlist.id, offset: offset, playlist_entry: new_order}
			
			# check that positions did not change
			expect(PlaylistEntry.find(changed_entry_1.id).position).to eq(changed_entry_1.position)
			expect(PlaylistEntry.find(changed_entry_2.id).position).to eq(changed_entry_2.position)
			
			# check if positions are in a row
			get 'index', channel_playlist_id: channel_playlist.id
			entries = assigns(:playlist_entries)
			offset = assigns(:offset)
			entries.each_with_index do |entry, index| 
				expect(entry.position).to eq(index + offset)
			end
		end

		it "updates all playtimes" do
			Timecop.freeze(Time.zone.now)
			channel_playlist = create(:channel_playlist)
			episode = create(:episode_cached, duration: 10.minutes)

			# create entries
			entry = create(:playlist_entry_episode, start_time: Time.zone.now, episode: episode, channel_playlist: channel_playlist)
			for i in 0..5 do
				entry = create(:playlist_entry_episode, channel_playlist: channel_playlist, episode: episode, start_time: entry.end_time)
			end

			# request index to get entries and offset
			get 'index', channel_playlist_id: channel_playlist.id
			offset = assigns(:offset)
			entries = assigns(:playlist_entries)

			# create array with current order
			new_order = Array.new
			entries.each_with_index do |entry, index| 
				new_order[index] = entry.id
			end

			swap_a = 3
			swap_b = 5
			changed_entry_1 = entries[swap_a]
			changed_entry_2 = entries[swap_b]

			# swap two entries
			tmp = new_order[swap_a]
			new_order[swap_a] = new_order[swap_b]
			new_order[swap_b] = tmp

			xhr :post, :sort, {channel_playlist_id: channel_playlist.id, offset: offset, playlist_entry: new_order}
			
			# check if start_times are updated
			get 'index', channel_playlist_id: channel_playlist.id
			entries = assigns(:playlist_entries)
			for i in 1...entries.length do
				expect(entries[i].start_time.to_i).to eq(entries[i-1].end_time.to_i)
			end
		end

		it "updates all positions" do
			Timecop.freeze(Time.zone.now)
			channel_playlist = create(:channel_playlist)
			episode = create(:episode_cached, duration: 10.minutes)

			# create entries
			entry = create(:playlist_entry_episode, start_time: Time.zone.now, episode: episode, channel_playlist: channel_playlist)
			for i in 0..5 do
				entry = create(:playlist_entry_episode, channel_playlist: channel_playlist, episode: episode, start_time: entry.end_time)
			end

			# request index to get entries and offset
			get 'index', channel_playlist_id: channel_playlist.id
			offset = assigns(:offset)
			entries = assigns(:playlist_entries)

			# create array with current order
			new_order = Array.new
			entries.each_with_index do |entry, index| 
				new_order[index] = entry.id
			end

			swap_a = 3
			swap_b = 5
			changed_entry_1 = entries[swap_a]
			changed_entry_2 = entries[swap_b]

			# swap two entries
			tmp = new_order[swap_a]
			new_order[swap_a] = new_order[swap_b]
			new_order[swap_b] = tmp

			xhr :post, :sort, {channel_playlist_id: channel_playlist.id, offset: offset, playlist_entry: new_order}
			
			# check if swap worked
			expect(PlaylistEntry.find(changed_entry_1.id).position).to eq(changed_entry_2.position)
			expect(PlaylistEntry.find(changed_entry_2.id).position).to eq(changed_entry_1.position)
			
			# check if positions are in a row
			get 'index', channel_playlist_id: channel_playlist.id
			entries = assigns(:playlist_entries)
			offset = assigns(:offset)
			entries.each_with_index do |entry, index| 
				expect(entry.position).to eq(index + offset)
			end
		end
	end

end
