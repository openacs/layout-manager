<master>
<property name="title">Page Templates</property>
<h1>Page Templates</h1>
A page template renders a page with a fixed number of columns, optionally declaring custom CSS
to do so.  The standard templates included with the <i>Layout Manager</i> package are designed
to work with the standard OpenACS css classes which were implemented in the core release 5.3,
and derived from the earlier <i>Theme Zen</i> package released with .LRN.
<h2>Declarating a Page Template</h2>
<blockquote><pre>
layout::page_template::new \
    -name 1_column \
    -description #layout-manager.simple_1column_layout_description# \
    -columns 1 \
    -template /packages/layout-manager/lib/page-templates/simple
</pre></blockquote>
The "name" parameter must be unique across the system and is used internally as the
page template's primary key.
<p>
The "description" parameter is the text displayed to the user when they choose a format for a page.
<p>
The "columns" parameter declares the number of columns this template expects.  The layout manager ensures that the number of columns built for a page is less than or equal to this parameter (it will be less if there are fewer elements than columns placed on a page).
<p>
The "template" parameter is the full path to the template which will build the page.  It is
possible to write a single script to handle a family of page template declarations, indeed
the provided "simple" template script does just that.  It dynamically assigns a CSS file
associated with the declared page template's name, and dynamically chooses an ADP file to
render the page.

