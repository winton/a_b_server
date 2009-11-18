/*
How this should work:
* Plugin generates visit() calls based on @a_b_selections
* convert() with a test looks 
*/

window.A_B = new function() {
	
	var $ = jQuery;
	var conversions = {};
	var visits = {};
	var session_id, tests, token, url, visits;
	
	$.extend(this, {
		convert: convert,
		setup: setup
	});
	
	window.a_b = function(variant) {
		// TODO: Make this work like the Rails version
	}
	
	function convert(test_or_variant) {
		var pair = test_variant_pair(test_or_variant);
		console.log(pair);
		if (!pair || !session_id || !token || !url)
			return;
		var params = [
			'session_id=' + session_id,
			'token=' + token,
			'variant=' + pair[1].name
		];
		$.getJSON(url + '/convert.js?' + params.join('&'));
	}
	
	// Returns a [ test, variant ] pair given a test or variant
	// Only returns if the variant has been used in a test (visited)
	function test_variant_pair(test_or_variant) {
		var result;
		var v = visits[test_or_variant] || test_or_variant;
		$.each(tests, function(i, test) {
			$.each(test.variants, function(i, variant) {
				if (variant.name == v && visits[test.name] == v) {
					result = [ test, variant ];
					return false;
				}
			});
		});
		return result;
	}
	
	function setup(options) {
		session_id = options.session_id;
		tests = options.tests;
		token = options.token;
		url = options.url;
		visits = options.visits;
	}
}