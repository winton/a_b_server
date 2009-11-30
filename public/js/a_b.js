window.A_B = new function() {
	
	var $ = jQuery;
	var conversions = { 'conversions': {}, 'visits': {} };
	var selections = {};
	var session_id, tests, token, url, selections;
	
	$.extend(this, {
		convert: convert,
		setup: setup,
		visit: visit
	});
	
	// Global functions
	
	window.a_b = function(variant, fn) {
		if (select_variant(variant))
			visit(variant) && fn();
	}
	
	// Public functions
	
	function convert(test_or_variant, visit) {
		var variant = selections[test_or_variant] || test_or_variant;
		var pair = test_variant_pair(variant);
		var type = visit ? 'visits' : 'conversions';
		if (!pair || !session_id || !token || !url)
			return;
		else if (conversions[type][pair[1].name])
			return;
		else
			conversions[type][pair[1].name] = true;
		var params = [
			'session_id=' + session_id,
			'token=' + token,
			type + '[]=' + pair[1].name
		];
		$.getJSON(url + '/increment.js?' + params.join('&'));
	}
	
	function setup(options) {
		selections = options.selections;
		session_id = options.session_id;
		tests = options.tests;
		token = options.token;
		url = options.url;
		// Visit selections
		$.each(selections, function(test, variant) {
			visit(variant);
		});
	}
	
	function visit(test_or_variant) {
		return convert(test_or_variant, true);
	}
	
	// Private functions
	
	function select_variant(variant) {
		var test = test_variant_pair(variant)[0];
		if (!test)
    	return [ selections, false ];
    if (!selections[test['name']]) {
      variants = test.variants.sort(function(a, b) {
				return (a.visits < b.visits);
			});
      variants[0].visits += 1;
      selections[test.name] = variants[0].name;
    }
    return (selections[test['name']] == variant);
  }
	
	function test_variant_pair(variant) {
		var result;
		$.each(tests, function(i, t) {
			$.each(t.variants, function(i, v) {
				if (v.name == variant) {
					result = [ t, v ];
					return false;
				}
			});
		});
		return result;
	}
}