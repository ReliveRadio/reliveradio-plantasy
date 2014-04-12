function apply_sortable() {
	return $('#playlist-entry-list').sortable({
		axis: 'y',
		handle: '.handle',
		cursor: 'move',
		update: function() {
			return $.post($(this).data('update-url'), $(this).sortable('serialize'));
		}
	});
}


apply_sortable();
