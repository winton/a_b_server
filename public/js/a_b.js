window.A_B = new function() {
	
	var test, tests;
	
	// Public
	
	window.a_b = function(name) {
		test = grep(tests, function(t) {
			return (t.name == name || symbolize_name(t.name) == name);
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

		var conversion = variant(get('conversions'));
		var visit = variant(get('visits'));
		var variant = variant(name);

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
				fn(symbolize_name(conversion.name));
			
			return symbolize_name(conversion.name);
		}
		
		return null;
	}
	
	function visit(name, fn) {
		if (!test) return null;
		
		var visit = variant(get('visits'));
		var variant = variant(name);
		
		var already_recorded = (visit && visit == variant) || (!name && visit);
		
		if (!visit && variants.length) {
			if (variants[0].visits) {
				var variants = test.variants.sort(function(a, b) {
					return (a.visits - b.visits);
				});
				visit = variants[0];
			} else
				visit = variants[Math.floor(Math.random() * variants.length)];
		}
		
		if (visit && (!name || visit == variant)) {
			if (!already_recorded) {
				visit.visits += 1;
				set('visits', visit);
			}
			
			if (fn)
				fn(symbolize_name(visit.name));
			
			return symbolize_name(visit.name);
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
	
	function data() {
		return eval('(' + cookie('a_b') + ')');
	}
	
	function get(type) {
		type = type.substring(0, 1);
		var data = data();
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
	
	function set(type, variant) {
		type = type.substring(0, 1);
		var data = data();
		data[type][test.id + ''] = variant['id'];
		cookie('a_b', to_json(data));
	}
	
	function symbolize_name(name) {
		return name.downcase.replace(/[^a-z0-9\s]/gi, '').replace(/_/g, '');
	}
	
	function to_json(obj) {
		var json = [ '{' ];
		for (var name in obj) {
			json.push("'" + name + "'");
			json.push(':');
			if (typeof obj[name] == 'object')
				json.push(to_json(obj[name]));
			else
				json.push(obj[name]);
		}
		json.push('}');
		return json.join('');
	}
	
	function trim(text) {
		return (text || "").replace(/^(\s|\u00A0)+|(\s|\u00A0)+$/g, "");
	}
	
	function variant(id_or_name) {
		if (!id_or_name || !test) return null;
		return grep(test.variants, function(v) {
			return (
				v.id == id_or_name ||
				v.name == id_or_name ||
				symbolize_name(v.name) == id_or_name
			);
		})[0];
	}
};