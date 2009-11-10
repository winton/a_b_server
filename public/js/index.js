jQuery(function($) {
	var h2 = $('h2');
	var new_test = $('#new_test');
	
	$('a', h2).click(toggleNewTest);
	$('.cancel', new_test).click(toggleNewTest);
	
	function toggleNewTest() {
		h2.toggle();
		new_test.toggle();
		if (new_test.is(':visible'))
			$('input:first', new_test).focus();
		return false;
	}
});