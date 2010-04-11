window.A_B = new function() {
	
	// Global variables
	
	var tests, url;
	
	// Classes
	
	var API, Cookies, Datastore, Test;
	
	API = new function() {
		this.request = request;
		
		var timer;
		
		function identifier() {
			var id = Cookies.get('a_b_i');
			if (!id) {
				id = (Math.random() + '').substring(2);
				Cookies.set('a_b_i', id);
			}
			return id;
		}
		
		function request() {
			clearTimeout(timer);
			timer = setTimeout(function() {
				var json = Cookies.get('a_b_s');
				if (json) {
					Cookies.set('a_b_s', null);
					var src = [
						url, '/a_b.js?',
						'j=', encodeURIComponent(json), '&',
						'i=', encodeURIComponent(identifier())
					].join('');
					var head = document.getElementsByTagName("head")[0] ||
						document.documentElement;
					var script = document.createElement('script');
					script.setAttribute('src', src);
					head.appendChild(script); 
				}
			}, 10);
		}
	};
	
	Cookies = new function() {
		
		this.get = cookie;
		this.set = cookie;
		
		function cookie(name, value) {
			if (!name) return null;
			if (typeof value != 'undefined') {
				if (value === null)
					document.cookie = [
						name, '=', '; expires=-1; path=/'
					].join('');
				else
					document.cookie = [
						name, '=', encodeURIComponent(value), '; path=/'
					].join('');
			} else {
				var cookie_value = null;
				if (document.cookie && document.cookie != '') {
					var cookies = document.cookie.split(';');
					for (var i = 0; i < cookies.length; i++) {
						var cookie = trim(cookies[i]);
						if (cookie.substring(0, name.length + 1) == (name + '=')) {
							cookie_value = decodeURIComponent(
								cookie.substring(name.length + 1)
							);
							break;
						}
					}
				}
				return cookie_value;
			}
			return null;
		}
		
		function trim(text) {
			return (text || "")
				.replace(/^(\s|\u00A0)+|(\s|\u00A0)+$/g, "");
		}
	};
	
	Datastore = function() {
		return new function() {
			
			this.get = get;
			this.set = set;
			
			var data, send;
			
			// Get cookie
			data = Cookies.get('a_b');
			send = Cookies.get('a_b_s');
			
			// Convert from JSON
			data = eval('(' + (data || '{}') + ')');
			send = eval('(' + (send || '{}') + ')');
			
			function diffArray(a1, a2) {
				var a = [], diff = [];
				for(var i = 0; i < a1.length; i++)
					a[a1[i]] = a1[i];
				for(i = 0; i < a2.length; i++) {
					if (a[a2[i]]) delete a[a2[i]];
					else a[a2[i]] = a2[i];
				}
				for(var k in a)
					diff.push(a[k]);
				return diff;
			}

			function get(key) {
				return (data[key] || []);
			}
			
			function objEmpty(obj) {
			  for(var i in obj)
			    return false;
			  return true;
			}

			function set(key, value, no_api) {
				if (!value) return;
				data[key] = data[key] || [];
				// Store current version for later comparison
				var old = data[key].slice(0);
				// If hash, grab keys that have true values
				if (value.constructor == Object) {
					var new_value = [];
					for(var k in value) {
						if (value[k]) new_value.push(k);
					}
					value = new_value;
				}
				// Array
				if (value.constructor == Array)
					data[key] = data[key].concat(value);
				// Other value
				else
					data[key].push(value);
				data[key] = uniqArray(data[key]);
				var diff = [];
				if (key != 'e') {
					// Add difference to send
					diff = diffArray(data[key], old);
					if (diff.length) {
						send[key] = send[key] || [];
						send[key] = send[key].concat(diff);
						send[key] = uniqArray(send[key]);
					}
				}
				if (!objEmpty(send) && data['e'])
					send['e'] = data['e'];
				// Export data to cookies
				toCookies();
				// Make request
				if (diff.length)
					API.request();
			}

			function toCookies() {
				if (!objEmpty(data))
					Cookies.set('a_b', toJson(data));
				if (!objEmpty(send))
					Cookies.set('a_b_s', toJson(send));
			}
	
			function toJson(obj) {
				var json = [];
				if (obj.constructor == Object) {
					json.push('{');
					for (var name in obj) {
						json.push('"' + name + '"');
						json.push(':');
						json.push(toJson(obj[name]));
						json.push(',');
					}
					if (json[json.length - 1] == ',')
						json.pop();
					json.push('}');
				} else if (obj.constructor == Array) {
					json.push('[');
					for(var i = 0, l = obj.length; i < l; i++) {
						json.push(toJson(obj[i]));
						json.push(',');
					}
					if (json[json.length - 1] == ',')
						json.pop();
					json.push(']');
				} else if (typeof obj == 'string')
					json.push('"' + obj + '"');
				else if (typeof obj == 'number')
					json.push(obj);
				return json.join('');
			}
			
			function uniqArray(array) {
				 var u = {}, a = [];
				 for(var i = 0, l = array.length; i < l; i++) {
						if (u[array[i]]) continue;
						a.push(array[i]);
						u[array[i]] = 1;
				 }
				 return a;
			};
		};
	};
	
	Test = function(name) {
		return new function() {
			
			var data = Datastore();
			var test = grep((tests || []), function(t) {
				return (
					t.name == name ||
					symbolizeName(t.name) == name
				);
			})[0];
			
			if (test) {
				this.convert = convert;
				this.extra = extra;
				this.visit = visit;
			} else {
				this.convert = function() {};
				this.extra = function() {};
				this.visit = function() {};
				return;
			}

			function convert(name, extras, fn) {
				if (!test) return null;

				if (typeof name == 'function') {
					fn = name;
					name = null;
				}

				if (typeof name == 'object') {
					extras = name;
					name = null;
				}

				if (typeof extras == 'function') {
					fn = extras;
					extras = null;
				}
				
				var conversion = findVariant(data.get('c'));
				var visit = findVariant(data.get('v'));
				var variant = findVariant(name);

				if (!visit)
					visit = variant;

				if (!conversion)
					conversion = visit;

				if (conversion && (!name || conversion == variant)) {
					data.set('c', conversion.id);
					data.set('v', conversion.id);
					data.set('e', extras);

					if (fn)
						fn(symbolizeName(conversion.name));

					return symbolizeName(conversion.name);
				}

				return null;
			}
			
			function extra(extras) {
				if (test)
					data.set('e', extras);
				return null;
			}

			function visit(name, extras, fn) {
				if (!test) return null;

				if (typeof name == 'function') {
					fn = name;
					name = null;
				}

				if (typeof name == 'object') {
					extras = name;
					name = null;
				}

				if (typeof extras == 'function') {
					fn = extras;
					extras = null;
				}
				
				var visit = findVariant(data.get('v'));
				var variant = findVariant(name);
				
				var already_recorded = (
					(visit && visit == variant) ||
					(!name && visit)
				);

				if (!visit && test.variants.length) {
					if (typeof test.variants[0].visits != 'undefined') {
						var variants = test.variants.sort(function(a, b) {
							return (a.visits - b.visits);
						});
						visit = variants[0];
					} else
						visit = test.variants[
							Math.floor(Math.random() * test.variants.length)
						];
				}

				if (visit && (!name || visit == variant)) {
					if (!already_recorded)
						visit.visits += 1;
					
					data.set('v', visit.id);
					data.set('e', extras);

					if (fn)
						fn(symbolizeName(visit.name));

					return symbolizeName(visit.name);
				}

				return null;
			}

			// Private

			function findVariant(ids_or_name) {
				if (!ids_or_name || !test) return null;
				return grep(test.variants, function(v) {
					if (ids_or_name.constructor == Array)
						return grep(ids_or_name, function(id) {
							return (id == v.id);
						})[0];
					else
						return (
							v.name == ids_or_name ||
							symbolizeName(v.name) == ids_or_name
						);
				})[0];
			}

			function grep(elems, callback, inv) {
				var ret = [];
				for (var i = 0, length = elems.length; i < length; i++) {
					if (!inv !== !callback(elems[i], i))
						ret.push(elems[ i ]);
				}
				return ret;
			}

			function symbolizeName(name) {
				return name
					.toLowerCase()
					.replace(/[^a-z0-9\s]/gi, '')
					.replace(/\s+/g, '_');
			}
		};
	};
	
	this.API = API;
	this.Cookies = Cookies;
	this.Datastore = Datastore;
	this.Test = Test;
	
	// Global methods
	
	window.a_b = function(name) {
		return Test(name);
	};
	
	window.a_b_setup = function(options) {
		tests = options.tests;
		url = options.url;
		API.request();
	};
};