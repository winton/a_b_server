window.testing = true;

module("Controller tests");
test("should yield to convert and visit blocks with correct test and variant", function() {
	ok(Tests.convert);
	ok(Tests.visit);
});

module("A_B.active");
test("should be true", function() {
	ok(A_B.active());
});

module("A_B.setup");
test("should receive the correct values", function() {
	same(A_B.value('conversions'), {"Test":"v1"});
	same(A_B.value('tests'), [{"name":"Test","variants":[{"name":"v1","visits":1},{"name":"v2","visits":0},{"name":"v3","visits":0}]},{"name":"Test2","variants":[{"name":"v4","visits":0},{"name":"v5","visits":0},{"name":"v6","visits":0}]}]);
	same(A_B.value('visits'), {"Test":"v1"});
});

module("window.a_b_visit (Test)");
test("should execute the callback with the correct test and variant", function() {
	expect(4);
	a_b_visit('v1', function(test, variant) {
		equals(test, 'Test');
		equals(variant, 'v1');
	});
	a_b_visit('Test', function(test, variant) {
		equals(test, 'Test');
		equals(variant, 'v1');
	});
});
test("should maintain the correct visit data", function() {
	same(A_B.value('visits'), {"Test":"v1"});
});

module("window.a_b_visit (Test2)");
test("should execute the callback with the correct test and variant", function() {
	expect(4);
	a_b_visit('v4', function(test, variant) {
		equals(test, 'Test2');
		equals(variant, 'v4');
	});
	a_b_visit('Test2', function(test, variant) {
		equals(test, 'Test2');
		equals(variant, 'v4');
	});
});
test("should maintain the correct visit data", function() {
	same(A_B.value('visits'), {"Test":"v1","Test2":"v4"});
});

module("window.a_b_convert (Test)");
test("should execute the callback with the correct test and variant", function() {
	expect(4);
	a_b_convert('v1', function(test, variant) {
		equals(test, 'Test');
		equals(variant, 'v1');
	});
	a_b_convert('Test', function(test, variant) {
		equals(test, 'Test');
		equals(variant, 'v1');
	});
});
test("should maintain the correct conversion data", function() {
	same(A_B.value('conversions'), {"Test":"v1"});
});

module("window.a_b_convert (Test2)");
test("should execute the callback with the correct test and variant", function() {
	expect(4);
	a_b_convert('v4', function(test, variant) {
		equals(test, 'Test2');
		equals(variant, 'v4');
	});
	a_b_convert('Test2', function(test, variant) {
		equals(test, 'Test2');
		equals(variant, 'v4');
	});
});
test("should maintain the correct conversion data", function() {
	same(A_B.value('conversions'), {"Test":"v1","Test2":"v4"});
});

module("Server-side conversions (v1)");
test("should equal 1", function() {
	expect(1);
	stop();
	setTimeout(function() {
		$.get('/spec/conversions', { variant: 'v1' }, function(data) {
			start();
			equals(data, '1');
		});
	}, 1000);
});

module("Server-side conversions (v4)");
test("should equal 1", function() {
	expect(1);
	stop();
	$.get('/spec/conversions', { variant: 'v4' }, function(data) {
		start();
		equals(data, '1');
	});
});

module("Server-side visits (v1)");
test("should equal 1", function() {
	expect(1);
	stop();
	$.get('/spec/visits', { variant: 'v1' }, function(data) {
		start();
		equals(data, '1');
	});
});

module("Server-side visits (v4)");
test("should equal 1", function() {
	expect(1);
	stop();
	$.get('/spec/visits', { variant: 'v4' }, function(data) {
		start();
		equals(data, '1');
	});
});