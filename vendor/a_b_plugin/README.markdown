a\_b\_plugin
============

Talk to <code>a\_b</code> from your Rails or Sinatra app.

[What the hell is <code>a_b</code>?](http://github.com/winton/a_b)

Install
-------

<pre>
sudo gem install a_b_plugin --source http://gemcutter.org
</pre>

Setup
-----

### Assets

Copy [this javascript file](http://github.com/winton/a_b/raw/master/public/js/a_b.js) into the directory where you keep your javascript assets.

### Configuration

Execute the following code when you app boots.

<pre>
ABPlugin.token = 'kTJkI8e56OisQrexuChW' // Persistence token from one of your a_b users
ABPlugin.url = 'http://ab.mydomain.com' // The URL to your a_b server
</pre>

For Rails apps, you would place this at the bottom of your <code>environment.rb</code> file.

### Layout

In your HTML layout, you will need a call to <code>a\_b\_script_tag</code> with the path to the javascript file you created earlier.

<pre>
&lt;html&gt;
  &lt;body&gt;
    &lt;%= a_b_script_tag '/javascripts/a_b.js' %&gt;
  &lt;/body&gt;
&lt;/html&gt;
</pre>

Usage
-----

Before using the examples below, create a test and some variants from the <code>a_b</code> admin.

### Ruby

<pre>
a_b_visit('my variant') do
  # Record a visit and execute code if this variant is selected
end
a_b_convert('my variant') # Record a conversion if this variant is selected
a_b_convert('my test')    # Record a conversion for the selected variant of this test
</pre>

You can use the <code>a\_b</code> method in the controller or the view.

### Javascript

<pre>
a_b_visit('my variant', function() {
  # Record a visit and execute code if this variant is selected
});
a_b_convert('my variant'); # Record a conversion if this variant is selected
a_b_convert('my test');    # Record a conversion for the selected variant of this test
</pre>

That's it!
----------

Visits and conversions are sent directly from the end user to the <code>a\_b</code> server via JSON-P.

Because of this, your application's performance is never affected by <code>a\_b</code> transactions.