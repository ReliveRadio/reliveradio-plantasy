module EpisodesHelper
	def remove_cache(episode)
		if episode.cached?
			# TODO check if it is in any future playlist

			# delete file from disk
			File.delete(episode.local_path)
			# update mpd database     
			mpd = MPD.new
			mpd.connect
			mpd.update
			# update database entry
			episode.cached = false
			episode.local_path = nil
			episode.save
		end
	end
end
