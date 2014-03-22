# feed attributes

Feedjira::Feed.add_common_feed_element('itunes:summary', :as => :itunes_summary)
Feedjira::Feed.add_common_feed_element('itunes:image', :value => :href, :as => :logo_url)

# item attributes

Feedjira::Feed.add_common_feed_entry_element('itunes:keywords', :as => :itunes_keywords)
Feedjira::Feed.add_common_feed_entry_element('itunes:image', :value => :href, :as => :itunes_image)
Feedjira::Feed.add_common_feed_entry_element('enclosure', :value => :url, :as => :enclosure_url)
Feedjira::Feed.add_common_feed_entry_element('enclosure', :value => :length, :as => :enclosure_length)
Feedjira::Feed.add_common_feed_entry_element('itunes:duration', :as => :itunes_duration)
Feedjira::Feed.add_common_feed_entry_element('atom:link', :value => :href, :as => :flattr_url)
