function cookieToJson() {
	var data = JSON.parse($.cookie('a_b'));
	delete data.i; // request id
	delete data.s; // sent flag
	return data;
}

function setup() {
	reset_a_b();
	$.cookie('a_b', null);
}

module('visit', { setup: setup });

test('should return the variant name', function() {
	equals(a_b('test').visit(), 'v1');
});

test('should return the variant name every time', function() {
  a_b('test').visit();
  equals(a_b('test').visit(), 'v1');
});

test('should set cookie', function() {
	a_b('test').visit();
	same(cookieToJson(), { "v": { "1": 2 } });
});

test("should maintain state if called more than once", function() {
	a_b('test').visit();
	a_b('test').visit();
	same(cookieToJson(), { "v": { "1": 2 } });
});

test("should return the variant name if variant specified and selected", function() {
  equals(a_b('test').visit(), 'v1');
});

test("should return nil if variant specified and not selected", function() {
	a_b('test').visit('v1');
	equals(a_b('test').visit('v2'), null);
});

test("should accept a block and pass the selected variant name to it", function() {
	expect(1);
	a_b('test').visit(function(variant) {
		equals(variant, 'v1');
	});
});

test("should accept a block for a specific variant", function() {
	expect(1);
	a_b('test').visit('v1', function() {
		ok(true);
	});
});

test("should not call a block for a specific variant if the variant is not selected", function() {
	a_b('test').visit('v2', function() {
		ok(false);
	});
});

test("should accept a hash with extra boolean values", function() {
	a_b('test').visit('v1', { e: true });
	same(cookieToJson(), { "v": { "1": 2 }, "e": { "2": { "e": true } } });
	a_b('test').visit({ e2: true });
	same(cookieToJson(), { "v": { "1": 2 }, "e": { "2": { "e": true, "e2": true } } });
});

module('convert', {
	setup: function() {
		setup();
		a_b('test').visit();
	}
});

test("should return the variant name", function() {
	equals(a_b('test').convert(), 'v1');
});

test("should return the variant name every time", function() {
	a_b('test').convert();
	equals(a_b('test').convert(), 'v1');
});

test("should set cookie", function() {
	a_b('test').convert();
	same(cookieToJson(), { "v": { "1": 2 }, "c": { "1": 2 } });
});

test("should maintain state if called more than once", function() {
	a_b('test').convert();
	a_b('test').convert();
	same(cookieToJson(), { "v": { "1": 2 }, "c": { "1": 2 } });
});

test("should return the variant name if variant specified and selected", function() {
  equals(a_b('test').convert('v1'), 'v1');
});

test("should return nil if variant specified and not selected", function() {
	a_b('test').convert('v1');
	equals(a_b('test').convert('v2'), null);
});

test("should accept a block and pass the selected variant name to it", function() {
	expect(1);
	a_b('test').convert(function(variant) {
		same(variant, 'v1');
	});
});

test("should accept a block for a specific variant", function() {
	expect(1);
	a_b('test').convert('v1', function() {
		ok(true);
	});
});

test("should not call a block for a specific variant if the variant is not selected", function() {
	a_b('test').convert('v2', function() {
		ok(false);
	});
});

test("should accept a hash with extra boolean values", function() {
	a_b('test').convert('v1', { e: true });
	same(cookieToJson(), { "v": { "1": 2 }, "c": { "1": 2 }, "e": { "2": { "e": true } } });
	a_b('test').convert({ e2: true });
	same(cookieToJson(), { "v": { "1": 2 }, "c": { "1": 2 }, "e": { "2": { "e": true, "e2": true } } });
});

var called, requested, timer;
module('delayedRequest', {
	setup: function() {
		setup();
		called = 0;
		requested = 0;
		// This should resemble delayedRequest without the json-p call
		A_B.overwriteFunction('delayedRequest', function() {
			called += 1;
			clearTimeout(timer);
			timer = setTimeout(function() { requested += 1; }, 10);
		});
	}
});

test("should be called when the data structure changes", function() {
	expect(1);
	a_b('test').visit('v1');
	a_b('test').visit('v2');
	a_b('test').convert('v1');
	a_b('test').convert('v2');
	equals(called, 2);
});

test("should only send one request after a number of simultaneous calls", function() {
	expect(1);
	stop();
	a_b('test').visit('v1');
	a_b('test').convert('v1');
	setTimeout(function() {
		start();
		equals(requested, 1);
	}, 100);
});