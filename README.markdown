GemTemplate
===========

A gem template for new projects.

Requirements
------------

<pre>
sudo gem install stencil --source http://gemcutter.org
</pre>

Setup the template
------------------

You only have to do this once.

<pre>
git clone git@github.com:winton/a_b.git
cd a_b
stencil
</pre>

Setup a new project
-------------------

Do this for every new project.

<pre>
mkdir my_project
git init
stencil a_b
rake rename
</pre>

The last command does a find-replace (gem\_template -> my\_project) on files and filenames.
