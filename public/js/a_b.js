window.A_B = new function() {
	
	// Global variables
	
	var categories, env, url;
	
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
						'e=', encodeURIComponent(env), '&',
						'i=', encodeURIComponent(identifier()), '&',
						'j=', encodeURIComponent(json)
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
				return (data[key] || (key == 'e' ? {} : []));
			}
			
			function objEmpty(obj) {
			  for(var i in obj)
			    return false;
			  return true;
			}

			function set(key, value, extras) {
				if (!value) return;
				data[key] = data[key] || [];
				// Store current version for later comparison
				var old = data[key].slice(0);
				// If hash, grab keys that have true values
				if (value.constructor == Object)
					data[key] = value;
				// Array
				else if (value.constructor == Array)
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
						if (!objEmpty(extras))
							send['e'] = extras;
					}
				}
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
				else
					json.push(obj + '');
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
	
	Test = function(c, t, e, fn) {
		return new function() {
			
			var category, data, extras, test;
			
			if (typeof c == 'object') {
				e = c;
				c = null;
			}
			
			data = Datastore();
			extras = data.get('e');
			
			if (e) {
				for (attr in e)
					extras[attr] = e[attr];
			}
			
			if (c && t) {
				category = findCategory(c);
				test = findTest(t);
			} else
				data.set('e', extras);
			
			if (category) {
				this.convert = convert;
				this.visit = visit;
			} else {
				this.convert = function() {};
				this.visit = function() {};
				return;
			}
			
			if (fn) fn(this);

			function convert(name, fn) {
				if (!test) return null;

				if (typeof name == 'function') {
					fn = name;
					name = null;
				}
				
				var conversion = findVariant(data.get('c'));
				var visit = findVariant(data.get('v'));
				var variant = findVariant(name);
				var visited = true;

				if (!visit) {
					visit = variant;
					visited = false;
				}

				if (!conversion)
					conversion = visit;

				if (conversion && (!name || conversion == variant)) {
					data.set('c', conversion.id, extras);
					if (!visited)
						data.set('v', conversion.id, extras);

					if (fn)
						fn(symbolizeName(conversion.name));

					return symbolizeName(conversion.name);
				}

				return null;
			}

			function visit(name, fn) {
				if (!test) return null;

				if (typeof name == 'function') {
					fn = name;
					name = null;
				}
				
				var visit = findVariant(data.get('v'));
				var variant = findVariant(name);

				if (!visit && test.variants.length) {
					if (window.testing)
						visit = test.variants[0];
					else
						visit = test.variants[
							Math.floor(Math.random() * test.variants.length)
						];
				}

				if (visit && (!name || visit == variant)) {
					data.set('v', visit.id, extras);

					if (fn)
						fn(symbolizeName(visit.name));

					return symbolizeName(visit.name);
				}

				return null;
			}

			// Private
			
			function findCategory(name) {
				return grep(categories, function(c) {
					return (
						c.name == name ||
						symbolizeName(c.name) == name
					);
				})[0];
			}
			
			function findTest(name) {
				if (!category)
					return null;
				return grep(category.tests, function(t) {
					return (
						t.name == name ||
						symbolizeName(t.name) == name
					);
				})[0];
			}

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
	
	window.a_b = function(c, t, e) {
		return Test(c, t, e);
	};
	
	window.a_b_setup = function(options) {
		categories = options.categories;
		env = options.env;
		url = options.url;
		API.request();
	};
};