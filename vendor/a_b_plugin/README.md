a\_b\_plugin
============

Talk to <code>a\_b</code> from your Rails or Sinatra app.

[What the hell is <code>a_b</code>?](http://github.com/winton/a_b)

Install
-------

<pre>
sudo gem install a_b_plugin
</pre>

Setup
-----

### Configuration

Create <code>config/a_b.yml</code>:

<pre>
site: My Site
token: token_goes_here
url: http://ab.mydomain.com
</pre>

### Layout

<pre>
&lt;html&gt;
  &lt;body&gt;
    &lt;script src="http://github.com/winton/a_b/raw/master/public/js/a_b.js" type="text/javascript"&gt;&lt;/script&gt;
    &lt;%= a_b %&gt;
  &lt;/body&gt;
&lt;/html&gt;
</pre>

Usage
-----

Before using the examples below, create a test and some variants from the <code>a_b</code> admin.

### Ruby

<pre>
a_b(:my_category, :my_test) do |test|
  test.visit    # returns :my_variant
  test.convert  # returns :my_variant
end
</pre>

<pre>
a_b(:my_category, :my_test).visit   # returns :my_variant
a_b(:my_category, :my_test).convert # returns :my_variant
</pre>

<pre>
a_b(:my_category, :my_test).visit(:my_variant)        # returns :my_variant
a_b(:my_category, :my_test).convert(:my_variant)      # returns :my_variant
a_b(:my_category, :my_test).visit(:my_other_variant)  # returns nil (:my_variant already selected)
</pre>

<pre>
a_b(:my_category, :my_test).visit do |variant|
  # variant == :my_variant
end
a_b(:my_category, :my_test).convert do |variant|
  # variant == :my_variant
end
</pre>

<pre>
a_b(:my_category, :my_test).visit(:my_variant) do
  # executes if :my_variant selected
end
a_b(:my_category, :my_test).convert(:my_variant) do
  # executes if :my_variant selected
end
</pre>

You can use the <code>a\_b</code> method in the controller or the view.

### Javascript

<pre>
a_b('my_category', 'my_test', function(test) {
  test.visit();    # returns 'my_variant'
  test.convert();  # returns 'my_variant'
});
</pre>

<pre>
a_b('my_category', 'my_test').visit();   # returns 'my_variant'
a_b('my_category', 'my_test').convert(); # returns 'my_variant'
</pre>

<pre>
a_b('my_category', 'my_test').visit('my_variant');   # returns 'my_variant'
a_b('my_category', 'my_test').convert('my_variant'); # returns 'my_variant'
</pre>

<pre>
a_b('my_category', 'my_test').visit(function(variant) {
  // variant == 'my_variant'
});
a_b('my_category', 'my_test').convert(function(variant) {
  // variant == 'my_variant'
});
</pre>

<pre>
a_b('my_category', 'my_test').visit('my_variant', function() {
  // executes if 'my_variant' selected
});
a_b('my_category', 'my_test').convert('my_variant', function() {
  // executes if 'my_variant' selected
});
</pre>

Conditions
----------

With <code>a_b</code> it is possible to record, per variant, the percentage of visits or conversions that were recorded in a certain condition.

For example, to tell <code>a_b</code> if a user is logged in, was referred by Google, or is using Firefox:

### Ruby

<pre>
a_b('Logged in' => true, 'From Google' => true)
a_b('Firefox' => true)
  # Conditions now contain three values

a_b.reset
  # Conditions now contain no values
</pre>

### Javascript

<pre>
a_b({ 'Logged in': true, 'From Google': true });
a_b({ 'Firefox': true });
  // Conditions now contain three values

a_b.reset();
  // Conditions now contain no values
</pre>

* Conditions stick around for the entire session
* Conditions must be a hash with values that evaluate as boolean
* New conditions merge with existing conditions
* If a condition is specified in one session and not in another, all others are assumed to be false

You can also set conditions on a temporary (non-session) basis:

### Ruby

<pre>
a_b(:my_category, :my_test, 'My condition' => true).visit
a_b(:my_category, :my_test).convert
  # 'My condition' is assumed false for conversion
</pre>

### Javascript

<pre>
a_b('my_category', 'my_test', { 'My condition': true }).visit();
a_b('my_category', 'my_test').convert();
  # 'My condition' is assumed false for conversion
</pre>

That's it!
----------

Visits and conversions are sent directly from the end user to the <code>a\_b</code> server via JSON-P.

Because of this, your application's performance is never affected by <code>a\_b</code> transactions.