function apply_sortable() {
	$('#playlist-entry-list').sortable({
		axis: 'y',
		handle: '.handle',
		cursor: 'move',
		update: function() {
			$.post($(this).data('update-url'), $(this).sortable('serialize'));
		}
	});
}

$(function() {
	apply_sortable();
	$('.pagination a').attr('data-remote', 'true');
});
