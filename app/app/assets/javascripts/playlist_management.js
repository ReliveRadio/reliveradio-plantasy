function apply_sortable() {
	$('#playlist-entry-list').sortable({
		axis: 'y',
		handle: '.handle',
		cursor: 'move',
		update: function() {
			$.post($('#changeable-entries-table').data('post-sort-url'), $(this).sortable('serialize'));
		}
	});
}

$(function() {
	apply_sortable();
	$('.pagination a').attr('data-remote', 'true');

	// refresh time in milliseconds
	var intervalTime = 10 * 1000; // 10 seconds
	// start timer
	window.setInterval(function(){
		update_url = $('#playlist').data('playlist-update-url');
		if(typeof update_url != 'undefined') {
			$.get(update_url, null, null, 'script');
		}
	}, intervalTime);
});
