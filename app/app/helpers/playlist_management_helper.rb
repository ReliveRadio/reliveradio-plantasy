require 'ruby-mpd'

module PlaylistManagementHelper
	def first_x_words(str, n=20, finish=' ...')
		if !str.blank?
			if str.split(' ').length > n
				return str.split(' ')[0,n].inject{|sum,word| sum + ' ' + word} + finish
			else
				return str
			end
		else
			return ""
		end
	end

	def update_mpd(channel_playlist)

		# collect all future entries
		playlist_entries = channel_playlist.playlist_entries.order(start_time: :desc)
		# TODO do this in SQL!!!
		playlist_entries.delete_if { |entry| entry.end_time < Time.now } # remove past entries
		playlist_entries.delete_if { |entry| (entry.start_time < Time.now) && (entry.end_time > Time.now) } # remove live entry		

		mpd = MPD.new
		mpd.connect

		# delete all mpd entries but not the currently playling one
		length = mpd.queue.length - 1
		mpd.delete 1..length if length > 0

		# TODO add check if all episodes are cached!
		
		playlist_entries.each do |entry|
			mpd.add File.basename(entry.episode.local_path)
		end		
		mpd.play
	end
end
