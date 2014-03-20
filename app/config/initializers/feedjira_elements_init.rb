Feedjira::Feed.add_common_feed_element('itunes:summary', :as => :itunes_summary)
Feedjira::Feed.add_common_feed_element('itunes:image', :value => :href, :as => :logo_url)