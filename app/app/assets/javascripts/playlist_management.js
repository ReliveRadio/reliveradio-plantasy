$(function () {

	$(".add-episode").each(function() {
		$(this).click(function() {
			var episode_id = $(this).attr('id');
			addEpisode(episode_id);
		});
	});

	function addEpisode(episode_id) {
		//$.get(episodesURL, null, update_progressbar, 'script');
		$("#playlist").append("<div>" + episode_id + "</div>");
	}

});