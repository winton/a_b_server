window.A_B = new function() {
	
	var $ = jQuery;
	var session_id, token, url;
	
	$.extend(this, {
		convert: convert,
		setup: setup
	});
	
	function convert(variant) {
		if (session_id && token && variant)
			$.getJSON(
				url + '/convert.js?' +
				[ 'session_id=' + session_id,
					'token=' + token,
					'variant=' + variant
				].join('&')
			);
	}
	
	function setup(options) {
		session_id = options.session_id;
		token = options.token;
		url = options.url;
	}
}