$(function() {
	// refresh time in milliseconds
	var intervalTime = 10 * 1000; // 10 seconds
	// start timer
	window.setInterval(function(){
		$.get($('#episodes').data('update-url'), null, null, 'script');
	}, intervalTime);
});