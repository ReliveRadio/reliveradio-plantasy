# paged feeds
Feedjira::Feed.add_common_feed_element('atom:link', :value => :href, with: { rel: 'next' }, :as => :next_link)
Feedjira::Feed.add_common_feed_element('atom:link', :value => :href, with: { rel: 'first' }, :as => :first_link)
Feedjira::Feed.add_common_feed_element('atom:link', :value => :href, with: { rel: 'last' }, :as => :last_link)

# feed attributes
Feedjira::Feed.add_common_feed_element('itunes:summary', :as => :itunes_summary)
Feedjira::Feed.add_common_feed_element('itunes:image', :value => :href, :as => :logo_url)
Feedjira::Feed.add_common_feed_element('itunes:keywords', :as => :itunes_keywords)
Feedjira::Feed.add_common_feed_element('itunes:category', :value => :text, :as => :itunes_category)
Feedjira::Feed.add_common_feed_element('itunes:author', :as => :itunes_author)
Feedjira::Feed.add_common_feed_element('itunes:subtitle', :as => :itunes_subtitle)
Feedjira::Feed.add_common_feed_element('language', :as => :language)

# item attributes

#Feedjira::Feed.add_common_feed_entry_element('itunes:summary', :as => :itunes_summary)
#Feedjira::Feed.add_common_feed_entry_element('itunes:subtitle', :as => :itunes_subtitle)
Feedjira::Feed.add_common_feed_entry_element('itunes:keywords', :as => :itunes_keywords)
Feedjira::Feed.add_common_feed_entry_element('itunes:image', :value => :href, :as => :itunes_image)
Feedjira::Feed.add_common_feed_entry_element('enclosure', :value => :url, :as => :enclosure_url)
Feedjira::Feed.add_common_feed_entry_element('enclosure', :value => :length, :as => :enclosure_length)
Feedjira::Feed.add_common_feed_entry_element('itunes:duration', :as => :itunes_duration)
Feedjira::Feed.add_common_feed_entry_element('atom:link', :value => :href, with: { rel: 'payment' }, :as => :flattr_url)
