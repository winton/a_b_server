new function() {
	
	var disable_requests, test, tests, url;
	
	if (load().s)
		delayedRequest();
	
	// Public
	
	window.a_b = function(name) {
		if (!tests)
			throw('You must pass test data to a_b_setup before calling a_b');
		
		test = grep(tests, function(t) {
			return (t.name == name || symbolizeName(t.name) == name);
		})[0];
		
		return {
			convert: convert,
			visit: visit
		};
	};
	
	window.a_b_setup = function(options) {
		tests = options.tests;
		url = options.url;
	};
	
	// Protected
	
	function convert(name, extra, fn) {
		if (!test) return null;
		
		if (typeof name == 'function') {
			fn = name;
			name = null;
		}
		
		if (typeof name == 'object') {
			extra = name;
			name = null;
		}
		
		if (typeof extra == 'function') {
			fn = extra;
			extra = null;
		}

		var conversion = findVariant(get('conversions'));
		var visit = findVariant(get('visits'));
		var variant = findVariant(name);

		if (!visit)
			visit = variant;
			
		if (!conversion)
			conversion = visit;
		
		if (conversion && (!name || conversion == variant)) {
			set('conversions', conversion, extra);
			set('visits', conversion, extra);
			
			if (fn)
				fn(symbolizeName(conversion.name));
			
			return symbolizeName(conversion.name);
		}
		
		return null;
	}
	
	function visit(name, extra, fn) {
		if (!test) return null;
		
		if (typeof name == 'function') {
			fn = name;
			name = null;
		}
		
		if (typeof name == 'object') {
			extra = name;
			name = null;
		}
		
		if (typeof extra == 'function') {
			fn = extra;
			extra = null;
		}
		
		var visit = findVariant(get('visits'));
		var variant = findVariant(name);
		
		if (!visit && test.variants.length) {
			if (typeof test.variants[0].visits != 'undefined') {
				var variants = test.variants.sort(function(a, b) {
					return (a.visits - b.visits);
				});
				visit = variants[0];
			} else
				visit = test.variants[Math.floor(Math.random() * test.variants.length)];
		}
		
		if (visit && (!name || visit == variant)) {
			set('visits', visit, extra);
			
			if (fn)
				fn(symbolizeName(visit.name));
			
			return symbolizeName(visit.name);
		}
		
		return null;
	}
	
	// Private
	
	function cookie(name, value) {
		if (!name) return null;
		if (typeof value != 'undefined')
			document.cookie = [ name, '=', encodeURIComponent(value), '; path=/' ].join('');
		else {
			var cookie_value = null;
			if (document.cookie && document.cookie != '') {
				var cookies = document.cookie.split(';');
				for (var i = 0; i < cookies.length; i++) {
					var cookie = trim(cookies[i]);
					if (cookie.substring(0, name.length + 1) == (name + '=')) {
						cookie_value = decodeURIComponent(cookie.substring(name.length + 1));
						break;
					}
				}
			}
			return cookie_value;
		}
		return null;
	}
	
	function delayedRequest() {
		if (disable_requests) return;
		disable_requests = true;
		setTimeout(function() {
			$.ajax({
				data: { j: jsonForRequest() },
				dataType: 'jsonp',
				success: sent,
				type: 'GET',
				url: url + '/a_b.js'
			});
			disable_requests = false;
		}, 100);
	}
	
	function findVariant(id_or_name) {
		if (!id_or_name || !test) return null;
		return grep(test.variants, function(v) {
			return (
				v.id == id_or_name ||
				v.name == id_or_name ||
				symbolizeName(v.name) == id_or_name
			);
		})[0];
	}
	
	function get(type) {
		var data = load();
		type = type.substring(0, 1);
		
		if (data[type])
			return data[type][test.id + ''];
		else
			return null;
	}
	
	function grep(elems, callback, inv) {
		var ret = [];
		for (var i = 0, length = elems.length; i < length; i++) {
			if (!inv !== !callback(elems[i], i))
				ret.push(elems[ i ]);
		}
		return ret;
	}
	
	function jsonForRequest() {
		var data = load();
		delete data.s;
		return toJson(data);
	}
	
	function load() {
		return eval('(' + cookie('a_b') + ')') || {};
	}
	
	function set(type, variant, extra) {
		var data = load();
		var test_id = test.id + '';
		type = type.substring(0, 1);
		
		// Request id
		data.i = data.i || (Math.random() + '').substring(2);
		
		// Conversion or visit
		data[type] = data[type] || {};
		data[type][test_id] = variant['id'];
		
		// Extra variables
		if (extra) {
			data.e = data.e || {};
			data.e[variant['id']] = data.e[variant['id']] || {};
			for (attr in extra) {
				data.e[variant['id']][attr] = extra[attr];
			}
		}
		
		// Send flag
		data.s = 1;
		
		cookie('a_b', toJson(data));
		delayedRequest();
	}
	
	function sent() {
		var data = load();
		delete data.s;
		cookie('a_b', toJson(data));
	}
	
	function symbolizeName(name) {
		return name.toLowerCase().replace(/[^a-z0-9\s]/gi, '').replace(/_/g, '');
	}
	
	function toJson(obj) {
		var json = [ '{' ];
		for (var name in obj) {
			json.push('"' + name + '"');
			json.push(':');
			if (typeof obj[name] == 'object')
				json.push(toJson(obj[name]));
			else
				json.push(obj[name]);
			json.push(',');
		}
		json.pop();
		json.push('}');
		return json.join('');
	}
	
	function trim(text) {
		return (text || "").replace(/^(\s|\u00A0)+|(\s|\u00A0)+$/g, "");
	}
};