jQuery.cookie = function(key, value, options) {
	
	options = options || {};
	
	if (!key)
		return null;
	
	if (typeof value != 'undefined') {
		
		if (value === null)
			options.expires = -1;
		
		if (typeof options.expires === 'number') {
			var days = options.expires, t = options.expires = new Date();
			t.setDate(t.getDate() + days);
		}
		
		document.cookie = [
			key + '=' + encodeURIComponent(value),
			'path=' + (options.path ? options.path : '/'),
			options.domain ? 'domain=' + options.domain : '',
			options.expires ? 'expires=' + options.expires.toUTCString() : '',
			options.secure ? 'secure' : ''
		].join('; ');
	
	} else
		options = value || options;
	
  var result = new RegExp('(?:^|; )' + encodeURIComponent(key) + '=([^;]*)')
		.exec(document.cookie);
	
  return result ? decodeURIComponent(result[1]) : null;
};