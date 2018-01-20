$(document).ready(function () {
	$("#latestSermonModal").on('show.bs.modal', function (event) {
		var $iframe = $(this).find('iframe');
		var videoLink = $iframe.attr('src');
		$iframe.attr('src', videoLink + '?autoplay=1');
	});
	$("#latestSermonModal").on('hide.bs.modal', function (event) {
		var $iframe = $(this).find('iframe');
		var videoLink = $iframe.attr('src').replace('?autoplay=1', '');
		$iframe.attr('src', '');
		setTimeout(function () {
			$iframe.attr('src', videoLink);
		});
	});
});