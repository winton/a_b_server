function clearCookie() { $.cookie('a_b', null); }

module('visit', { setup: clearCookie });

test('should return the variant name', function() {
	equals(a_b('test').visit(), 'v1');
});