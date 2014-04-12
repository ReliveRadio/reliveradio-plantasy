jQuery ->
	$('#playlist-entry-list').sortable
		axis: 'y'
		handle: '.handle'
		cursor: 'move'
		update: ->
			$.post($(this).data('update-url'), $(this).sortable('serialize'))