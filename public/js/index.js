jQuery(function($) {
	var h2 = $('h2');
	var new_test = $('#new_test');
	
	$('a', h2).click(toggleNewTest);
	$('.cancel', new_test).click(toggleNewTest);
	
	$('form', new_test).submit(function() {
		var inputs = $('input:text[value=]', this);
		$('input:text', this).css('background-color', '#FFFFFF');
		inputs.css('background-color', '#FBE3E4');
		if (inputs.length) {
			inputs.get(0).focus();
			return false;
		}
	});
	
	$('.title .last').click(function() {
		var question = "Are you sure you want to delete this test?\n\n";
		question += "All variant data will be deleted."
		if (confirm(question))
			window.location.href = '/tests/destroy/' + id($(this).parents('.ab_test'));
	});
	
	$('input:visible').get(0).focus();
	tooltip();
	
	function id(el) {
		return $(el).attr("id").replace(/\D/g, "");
	}
	
	function toggleNewTest() {
		h2.toggle();
		new_test.toggle();
		if (new_test.is(':visible'))
			$('input:first', new_test).focus();
		return false;
	}
	
	function tooltip() {
		var x = 10, y = 20, title;
		$("a.tooltip").hover(
			function(e) {											  
				title = this.title;
				this.title = "";
				$("body").append("<p id='tooltip' class='notice'>" + title + "</p>");
				$("#tooltip")
					.css("top", (e.pageY - x) + "px")
					.css("left", (e.pageX + y) + "px")
					.fadeIn("fast");
	    },
			function() {
				this.title = title;
				$("#tooltip").remove();
			}
		);
		$("a.tooltip").mousemove(function(e) {
			$("#tooltip")
				.css("top", (e.pageY - x) + "px")
				.css("left", (e.pageX + y) + "px");
		});
	}
});