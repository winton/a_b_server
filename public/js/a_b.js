new function() {
	
	var test, tests;
	
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
	};
	
	// Protected
	
	function convert(name, fn) {
		if (!test) return null;

		var conversion = findVariant(get('conversions'));
		var visit = findVariant(get('visits'));
		var variant = findVariant(name);

		var already_recorded = (visit && visit == conversion) || (!name && conversion);
		
		if (!visit)
			visit = variant;
			
		if (!conversion)
			conversion = visit;
		
		if (conversion && (!name || conversion == variant)) {
			if (already_recorded) {
				set('conversions', conversion);
				set('visits', conversion);
			}
			
			if (fn)
				fn(symbolizeName(conversion.name));
			
			return symbolizeName(conversion.name);
		}
		
		return null;
	}
	
	function visit(name, fn) {
		if (!test) return null;
		
		var visit = findVariant(get('visits'));
		var variant = findVariant(name);
		
		var already_recorded = (visit && visit == variant) || (!name && visit);
		
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
			if (!already_recorded) {
				visit.visits += 1;
				set('visits', visit);
			}
			
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
	
	function get(type) {
		type = type.substring(0, 1);
		var data = load();
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
	
	function load() {
		return eval('(' + cookie('a_b') + ')') || {};
	}
	
	function set(type, variant) {
		type = type.substring(0, 1);
		var data = load();
		data[type] = data[type] || {};
		data[type][test.id + ''] = variant['id'];
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
		}
		json.push('}');
		return json.join('');
	}
	
	function trim(text) {
		return (text || "").replace(/^(\s|\u00A0)+|(\s|\u00A0)+$/g, "");
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
};