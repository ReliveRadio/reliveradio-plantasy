ReliveRadio Changelog
===========================
This file is used to list changes made in each version.


v0.3
------
Foobar.

- support for paged feeds
- flash messages for ajax requests
- tagging for podcasts and episodes (manual & auto-tagging from feed)
- coverart for each channel
- webplayer for each channel

v0.2
------
Next alpha release. Basic features added. UX not optimal yet.

- show playlist schedule for user for each channel
- use mpd socket instead of websocket. configure socket in channel playlist
- all views with basic foundation design
- add controller testing + playlist management testing (access to running mpd required)
- add 'danger zone'. playlist entries currently played or in the past can not be deleted. also podcast episodes can not be destroyed when they are scheduled in danger zone.
- automatically tag audiofiles with data from the feed when they are downloaded
- cache podcast and episode logos when subscribing to a new feed
- refactor audio upload process
- fix some AJAX bugs in playlist management
- migrate to postgresql database
- update navigation bar to contain all basic links

v0.1
------
First early alpha release.

- Subscribe to podcasts
- Download episodes
- Background job management via [Sidekiq](https://github.com/mperham/sidekiq)
- Playlist / Channel management support
- Jingle support
- Podcast directory
- Authentication with [devise](https://github.com/plataformatec/devise)
- Sync to mpd automatically