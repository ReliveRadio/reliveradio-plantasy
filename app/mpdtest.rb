require 'ruby-mpd'

mpd = MPD.new
mpd.connect
status = mpd.status
puts "playlist length: " + status[:playlistlength].to_s
puts "current played element pos in playlist: " + status[:song].to_s
puts "elapsed time of current element: " + status[:time][0].to_s + "s"

# delete all played entries
if status[:song] > 0
	mpd.delete 0...status[:song]
end
# update status because positions changed
status = mpd.status
# delete all future entries
start = status[:song] + 1
mpd.delete start...status[:playlistlength]