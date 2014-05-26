$(function() {

	init_livestream_player();

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


function init_livestream_player(){
	var player = document.getElementById("stream");

	// get all the available buttons
	var livestreambuttons = $(".livestreambutton");

	// initialize the buttons
	livestreambuttons.each(function() {
		$(this).click(liveStreamButtonClicked);
		$(this).html('<i class="fa fa-play"></i> Livestream starten');
	});

	var isLivestreamPlaying = false;

	function liveStreamButtonClicked() {
		if(isLivestreamPlaying) {
			// the button was clicked to STOP the livestream
			player.pause();
			livestreambuttons.each(function() {
				// change look and feel of the button
				$(this).html('<i class="fa fa-play"></i> Livestream starten');
				$(this).removeClass('playing');
				$(this).addClass('paused');
			});
			// remember status
			isLivestreamPlaying = false;
		} else {
			// the button was clicked to START the livestream
			player.play();
			livestreambuttons.each(function() {
				// change look and feel of the button
				$(this).html('<i class="fa fa-pause"></i> Livestream stoppen');
				$(this).removeClass('paused');
				$(this).addClass('playing');
			});
			// remember status
			isLivestreamPlaying = true;
		}
	}
};
