window.A_B = new function() {
	
	var $ = jQuery;
	var conversions, session_id, selections, tests, token, url, visits;
	var queue = $({});
	
	// Global methods
	
	window.a_b_convert = function(test_or_variant, fn, force) {
		if (force && active()) {
			convert(test_or_variant);
			delayedRequest();
		} else
			a_b_select(test_or_variant, fn, 'convert');
	};
	
	window.a_b_select = function(test_or_variant, fn, type) {
		if (!active()) return;
		
		var test_variant = select(test_or_variant);
		var test = test_variant[0];
		var variant = test_variant[1];
		
		if (test_or_variant == test || test_or_variant == variant) {
			if (type) {
				eval(type)(variant);
				delayedRequest();
			}
			if (fn) fn(test, variant);
		}
	};
	
	window.a_b_visit = function(test_or_variant, fn) {
		a_b_select(test_or_variant, fn, 'visit');
	};
	
	// Public class methods
	
	$.extend(this, {
		active: active,
		setup: setup,
		value: value
	});
	
	function active() {
		return (
			conversions &&
			selections &&
			session_id &&
			tests &&
			token &&
			url &&
			visits
		);
	}
	
	function setup(options) {
		conversions = options.conversions;
		selections = options.selections;
		session_id = options.session_id;
		tests = options.tests;
		token = options.token;
		url = options.url;
		visits = options.visits;
		if (!window.testing) delayedRequest();
	}
	
	function value(name) {
		return eval(name);
	}
	
	// Private class methods
	
	function convert(variant) {
		var test = find_test(variant);
		if (!test) return;
		
		conversions[test.name] = variant;
		return true;
	}
	
	function delayedRequest() {
		queue.queue(function() {
			setTimeout(function() {
				queue.dequeue();
				
				var params = {
					conversions: [],
					session_id: session_id,
					token: token,
					visits: []
				};

				$.each(conversions, function(test, variant) {
					params.conversions.push(variant);
				});
				$.each(visits, function(test, variant) {
					params.visits.push(variant);
				});

				conversions = {};
				visits = {};
				
				if (params.conversions.length || params.visits.length) {
					params.conversions = params.conversions.join(',');
					params.visits = params.visits.join(',');
					
					if (!params.conversions.length)
						delete params.conversions;
					if (!params.visits.length)
						delete params.visits;

					$.ajax({
						data: params,
						dataType: 'jsonp',
						type: 'GET',
						url: url + '/increment.js'
					});
				}
			}, 500);
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

	function test_names() {
		return $.map(tests, function(t) { return t.name; });
	}
	
	function variant_names() {
		var variants = function(t) {
			return $.map(t.variants, function(v) { return v.name; });
		}
		if (arguments.length)
			return variants(arguments[0]);
		else
			return $.map(tests, function(t) { return variants(t); }).flatten();
	}
	
	function visit(variant) {
		var test = find_test(variant);
		if (!test) return;
		
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