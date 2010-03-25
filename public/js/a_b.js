window.A_B = new function() {
	
	var test, tests, timer, url;
	
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
		if (load().s) delayedRequest();
	};
	
	$.extend(this, { overwriteFunction: overwriteFunction });
	
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
		// Don't forget to modify the tests if you modify this code
		clearTimeout(timer);
		timer = setTimeout(function() {
			$.ajax({
				data: { j: jsonForRequest() },
				dataType: 'jsonp',
				success: sent,
				type: 'GET',
				url: url + '/a_b.js'
			});
		}, 10);
	}
	
	function equiv(a, b) {
		var innerEquiv;
		// the real equiv function
		var callers = [];
		// stack to decide between skip/abort functions
		// Determine what is o.
		function hoozit(o) {
			if (o.constructor === String) {
				return "string";

			} else if (o.constructor === Boolean) {
				return "boolean";

			} else if (o.constructor === Number) {

				if (isNaN(o)) {
					return "nan";
				} else {
					return "number";
				}

			} else if (typeof o === "undefined") {
				return "undefined";

				// consider: typeof null === object
			} else if (o === null) {
				return "null";

				// consider: typeof [] === object
			} else if (o instanceof Array) {
				return "array";

				// consider: typeof new Date() === object
			} else if (o instanceof Date) {
				return "date";

				// consider: /./ instanceof Object;
				//			 /./ instanceof RegExp;
				//			typeof /./ === "function"; // => false in IE and Opera,
				//											true in FF and Safari
			} else if (o instanceof RegExp) {
				return "regexp";

			} else if (typeof o === "object") {
				return "object";

			} else if (o instanceof Function) {
				return "function";
			} else {
				return undefined;
			}
		}

		// Call the o related callback with the given arguments.
		function bindCallbacks(o, callbacks, args) {
			var prop = hoozit(o);
			if (prop) {
				if (hoozit(callbacks[prop]) === "function") {
					return callbacks[prop].apply(callbacks, args);
				} else {
					return callbacks[prop];
					// or undefined
				}
			}
		}

		var callbacks = function() {
			// for string, boolean, number and null
			function useStrictEquality(b, a) {
				if (b instanceof a.constructor || a instanceof b.constructor) {
					// to catch short annotaion VS 'new' annotation of a declaration
					// e.g. var i = 1;
					//		var j = new Number(1);
					return a == b;
				} else {
					return a === b;
				}
			}

			return {
				"string": useStrictEquality,
				"boolean": useStrictEquality,
				"number": useStrictEquality,
				"null": useStrictEquality,
				"undefined": useStrictEquality,

				"nan": function(b) {
					return isNaN(b);
				},

				"date": function(b, a) {
					return hoozit(b) === "date" && a.valueOf() === b.valueOf();
				},

				"regexp": function(b, a) {
					return hoozit(b) === "regexp" &&
					a.source === b.source &&
					// the regex itself
					a.global === b.global &&
					// and its modifers (gmi) ...
					a.ignoreCase === b.ignoreCase &&
					a.multiline === b.multiline;
				},

				// - skip when the property is a method of an instance (OOP)
				// - abort otherwise,
				//	 initial === would have catch identical references anyway
				"function": function() {
					var caller = callers[callers.length - 1];
					return caller !== Object &&
					typeof caller !== "undefined";
				},

				"array": function(b, a) {
					var i;
					var len;

					// b could be an object literal here
					if (! (hoozit(b) === "array")) {
						return false;
					}

					len = a.length;
					if (len !== b.length) {
						// safe and faster
						return false;
					}
					for (i = 0; i < len; i++) {
						if (!innerEquiv(a[i], b[i])) {
							return false;
						}
					}
					return true;
				},

				"object": function(b, a) {
					var i;
					var eq = true;
					// unless we can proove it
					var aProperties = [],
					bProperties = [];
					// collection of strings
					// comparing constructors is more strict than using instanceof
					if (a.constructor !== b.constructor) {
						return false;
					}

					// stack constructor before traversing properties
					callers.push(a.constructor);

					for (i in a) {
						// be strict: don't ensures hasOwnProperty and go deep
						aProperties.push(i);
						// collect a's properties
						if (!innerEquiv(a[i], b[i])) {
							eq = false;
						}
					}

					callers.pop();
					// unstack, we are done
					for (i in b) {
						bProperties.push(i);
						// collect b's properties
					}

					// Ensures identical properties name
					return eq && innerEquiv(aProperties.sort(), bProperties.sort());
				}
			};
		}();

		innerEquiv = function() {
			// can take multiple arguments
			var args = Array.prototype.slice.apply(arguments);
			if (args.length < 2) {
				return true;
				// end transition
			}

			return (function(a, b) {
				if (a === b) {
					return true;
					// catch the most you can
				} else if (a === null || b === null || typeof a === "undefined" || typeof b === "undefined" || hoozit(a) !== hoozit(b)) {
					return false;
					// don't lose time with error prone cases
				} else {
					return bindCallbacks(a, callbacks, [b, a]);
				}

				// apply transition with (1..n) arguments
			})(args[0], args[1]) && arguments.callee.apply(this, args.splice(1, args.length - 1));
		};

		return innerEquiv(a, b);
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
	
	function overwriteFunction(name, fn) {
		fn = fn || function() {};
		eval(name + ' = fn');
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
		
		if (!equiv(load(), data)) {
			data.s = 1; // Send flag
			cookie('a_b', toJson(data));
			delayedRequest();
		}
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