# feed attributes

Feedjira::Feed.add_common_feed_element('itunes:summary', :as => :itunes_summary)
Feedjira::Feed.add_common_feed_element('itunes:image', :value => :href, :as => :logo_url)

# item attributes

Feedjira::Feed.add_common_feed_entry_element('atom:link', :value => :href, :as => :flattr_url)