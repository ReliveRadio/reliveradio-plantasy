$(function() {
	// refresh time in milliseconds
	var intervalTime = 10 * 1000; // 10 seconds
	// start timer
	window.setInterval(function(){
		update_url = $('#episodes').data('schedule-update-url');
		if(typeof update_url != 'undefined') {
			$.get(update_url, null, null, 'script');
		}
	}, intervalTime);
});