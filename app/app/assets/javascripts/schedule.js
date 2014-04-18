$(function() {
	// refresh time in milliseconds
	var intervalTime = 10 * 1000; // 10 seconds
	// start timer
	window.setInterval(function(){
		$.get($('#playlist-entry-list').data('fetch-url'), null, null, 'script');
	}, intervalTime);
});