window.A_B = new function() {
	
	var $ = jQuery;
	var test, tests;
	
	window.a_b = function(name) {
		test = $.grep(tests, function(t) {
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
	
	function symbolize_name(name) {
		return name.downcase.replace(/[^a-z0-9\s]/gi, '').replace(/_/g, '');
	}
};