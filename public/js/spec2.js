function clearCookie() { $.cookie('a_b', null); }

module('Server side visit', { setup: clearCookie });

test('should set the cookie, return the variant name, and increment visits', function() {
	expect(3);
	stop();
	
	$.get('/spec/visit', null, function(data) {
		data = JSON.parse(data);
		
		// set the cookie
		var visits = {};
		visits[tests[0].id] = tests[0].variants[0].id;
		same(JSON.parse($.cookie('a_b')).v, visits);
		
		// return the variant name
		equals(data.result, 'v1');
		
		// increment visits
		equals(data.tests[0].variants[0].visits, 1);
		
		start();
	});
});

module('Server side conversion', { setup: clearCookie });

test('should set the cookie, return the variant name, and increment visits', function() {
	expect(4);
	stop();
	
	$.get('/spec/convert', null, function(data) {
		data = JSON.parse(data);
		
		// set the cookie
		var conversions = {};
		conversions[tests[0].id] = tests[0].variants[0].id;
		same(JSON.parse($.cookie('a_b')).c, conversions);
		same(JSON.parse($.cookie('a_b')).v, conversions);
		
		// return the variant name
		equals(data.result, 'v1');
		
		// increment visits
		equals(data.tests[0].variants[0].visits, 1);
		
		start();
	});
});