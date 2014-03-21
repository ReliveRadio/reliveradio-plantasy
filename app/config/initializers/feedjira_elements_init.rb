# feed attributes

Feedjira::Feed.add_common_feed_element('itunes:summary', :as => :itunes_summary)
Feedjira::Feed.add_common_feed_element('itunes:image', :value => :href, :as => :logo_url)

# item attributes

#Feedjira::Feed.add_common_feed_entry_element('itunes:keywords', :as => :tags)
Feedjira::Feed.add_common_feed_entry_element('itunes:image', :value => :href, :as => :icon_url)
Feedjira::Feed.add_common_feed_entry_element('enclosure', :value => :url, :as => :audio_file_url)
Feedjira::Feed.add_common_feed_entry_element('enclosure', :value => :length, :as => :filesize_in_bytes)
Feedjira::Feed.add_common_feed_entry_element('itunes:duration', :as => :duration)
Feedjira::Feed.add_common_feed_entry_element('atom:link', :value => :href, :as => :flattr_url)
