// Case-insensitive version of contains selector
jQuery.expr[':'].Contains = function(a,i,m){
  return jQuery(a).text().toUpperCase().indexOf(m[3].toUpperCase()) > -1;
};

jQuery(function($) {
	var h2 = $('h2');
	var new_test = $('#new_test');
	var tables = $('.table');
	
	// Toggle new test
	$('a', h2).click(toggleNewTest);
	$('.cancel', new_test).click(toggleNewTest);
	
	// New test submit
	$('form', new_test).submit(validate);
	
	// Search submit
	$('#search form').submit(function() {
		var value = $.trim($('input', this).val());
		tables.hide();
		$(".table:has(.search:Contains('" + value + "'))").show();
		return false;
	});
	
	// Delete test
	$('.title .last').click(function() {
		var question = [
			"Are you sure you want to delete this test?\n\n",
			"All variant data will be deleted.\n"
		].join('');
		if (confirm(question))
			window.location.href = '/tests/' + id($(this).parents('.ab_test')) + '/destroy';
	});
	
	// Delete variant
	$('.ab_variant .last').click(function() {
		if (confirm("Are you sure you want to delete this variant?"))
			window.location.href = '/variants/' + id($(this).parent()) + '/destroy';
	});
	
	// Edit test
	$('.ab_test .edit').click(function() {
		var container = $(this).parents('.ab_test');
		var rows = $('.rows', container);
		// Hide rows
		rows.hide();
		// Remove old edit container
		$('.edit_container', container).remove();
		// Create form
		rows.before($('#edit_template').val().replace(':id', id(container)));
		// Update form inputs
		var data = eval('(' + $('.data', container).html() + ')');
		var inputs = $('input[type=text]', container);
		$(inputs.get(0)).val(data.name);
		$(inputs.get(1)).val(data.ticket_url);
		$(inputs.get(2)).val(data.variant_names.join(', '));
		// Bind tooltips
		tooltip(container);
		// Bind form
		$('form', container).submit(validate);
		$('.cancel', container).click(function() {
			$('.edit_container', container).remove();
			rows.show();
			return false;
		});
		return false;
	});
	
	// Focus first input
	$('input:visible').get(0).focus();
	
	// Bind tooltip
	tooltip();
	
	// Methods
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
	
	function tooltip(el) {
		var x = 5, y = 15, el, html;
		$(".tooltip", el).hover(
			function(e) {
				html = $(this).data('title');
				$("#tooltip").remove();
				if (!html) {
					html = $('#tooltip_' + $(this).attr('title')).val();
					$(this).data('title', html);
					$(this).attr('title', '');
				}
				$("body").append("<div id='tooltip' class='notice'>" + html + "</div>");
				$("#tooltip")
					.css("top", (e.pageY + y) + "px")
					.css("left", (e.pageX + x) + "px")
					.fadeIn("fast");
			},
			function() {
				$("#tooltip").remove();
			}
		);
		$(".tooltip", el).mousemove(function(e) {
			$("#tooltip")
				.css("top", (e.pageY + y) + "px")
				.css("left", (e.pageX + x) + "px");
		});
	}
	
	function validate() {
		$('input:text', this).css('background-color', '#FFFFFF');
		var inputs = $('input:text[value=]', this)
			.css('background-color', '#FBE3E4');
		if (inputs.length) {
			inputs.get(0).focus();
			return false;
		}
	}
});