window.A_B = new function() {
	
	var $ = jQuery;
	var conversions, session_id, selections, tests, token, url, visits;
	var queued = false;
	
	// Global methods
	
	window.a_b_convert = function(test_or_variant, fn) {
		a_b('convert', test_or_variant, fn);
	};
	
	window.a_b_visit = function(test_or_variant, fn) {
		a_b('visit', test_or_variant, fn);
	};
	
	// Public class methods
	
	$.extend(this, { setup: setup });
	
	function setup(options) {
		conversions = options.conversions;
		selections = clone(options.visits);
		session_id = options.session_id;
		tests = options.tests;
		token = options.token;
		url = options.url;
		visits = options.visits;
	}
	
	// Private class methods
	
	function a_b(type, test_or_variant, fn) {
		if (!active()) return;
		
		var test_variant = select(test_or_variant);
		var test = test_variant[0];
		var variant = test_variant[1];
		
		if (test_or_variant == test || test_or_variant == variant) {
			this[type](variant);
			if (fn) fn(test, variant);
			delayedRequest();
		}
	}
	
	function active() {
		return (conversions && session_id && tests && token && url && visits);
	}
	
	function clone(hash) {
		var x = {};
		for (i in hash)
			x[i] = hash[i];
		return x;
	}
	
	function convert(test_or_variant) {
		var test_variant = selected_variant(test_or_variant);
		if (!test_variant) return;
	
		var test = test_variant[0];
		var variant = test_variant[1];
		
		conversions[test.name] = variant;
		visits[test.name] = variant;
		
		return true;
	}
	
	function delay(time, callback) {
		jQuery.fx.step.fake_step_method = function() {};
		return this.animate({ fake_step_method: 1 }, time, callback);
	}
	
	function delayedRequest() {
		if (queued) return;
		queued = true;
		delay(500, function() {
			queued = false;
			
			var params = {
				session_id: session_id,
				token: token
			};
			var variant = function(test, variant) {
				return variant;
			};
			
			params.conversions = $.map(conversions, variant).join(',');
			params.visits = $.map(visits, variant).join(',');
			
			conversions = {};
			visits = {};
			
			$.getJSON(url + '/increment.js', params);
		});
	}
	
	function find_test(test_or_variant) {
		if (!tests) return;
		
		return $.grep(tests, function(t) {
			return (
				t.name == test_or_variant ||
				variant_names(t).indexOf(test_or_variant) > -1
			);
		})[0];
	}
	
	function select(test_or_variant) {
		var test = find_test(test_or_variant);
		if (!test) return;

		if (!selections[test.name]) {
			var variants = test.variants.sort(function(a, b) {
				return (a.visits < b.visits);
			});
			
			if (variants[0]) {
				variants[0].visits += 1;
				selections[test.name] = variants[0].name;
			}
		}

		return [ test.name, selections[test.name] ];
	}
	
	function selected_variant(test_or_variant) {
		var test = find_test(test_or_variant);
		if (!test) return;
		return [ test, selections[test['name']] ];
	}

	function test_names() {
		return $.map(tests, function(t) { return t.name; });
	}
	
	function variant_names() {
		var variants = function(t) {
		 $.map(t.variants, function(v) { return v.name; });
		}
		if (arguments.length)
			return variants(arguments[0]);
		else
			return $.map(tests, function(t) { return variants(t); }).flatten();
	}
	
	function visit(test_or_variant) {
		var test_variant = selected_variant(test_or_variant);
		if (!test_variant) return;
		
		var test = test_variant[0];
		var variant = test_variant[1];
		
		visits[test.name] = variant;
		return true;
	}
};

Array.prototype.flatten = function() {
	var flat = [];
	
	for (var i = 0, l = this.length; i < l; i++) {
		var type = Object.prototype.toString
			.call(this[i])
			.split(' ')
			.pop()
			.split(']')
			.shift()
			.toLowerCase();
		
		if (type)
			flat = flat.concat(/^(array|collection|arguments|object)$/.test(type) ?
				flatten.call(this[i]) :
				this[i]);
	}
	
	return flat;
};