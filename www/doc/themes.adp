<master>
<property name="title">Theme Templates</property>
<h1>Theme Templates</h1>
Each <i>layout manager element</i> (a specific instance of a <i>layout manager includelet</i>) is
rendered with an individual master template, called a <i>theme template</i>,  which provides
decoration for the element title and content.
<p>
Each <i>page set</i> is created with a default theme to use for its elements.  Each page
within a page set may override this default, and each element within a page may override the
page's default theme.  This gives the page set administrator a great deal of freedom over
look-and-feel.  For instance, to recreate the .LRN style where user pages are decorated with
colored boxes, while elements on the admin page are undecorated, assign the <i>standard</i>
theme to the page set, create a page entitled "admin", and assign it the <i>no graphics</i>
theme.
<p>
Themes are declared through the <i>Layout Manager</i> Tcl API.
<p>Example:
<blockquote><pre>
layout::theme::new \
    -name default \
    -description "Default OpenACS Theme" \
    -template /packages/layout-manager/lib/themes/standard
</pre></blockquote>
The "name" parameter is used internally and must be unique through out the system, as it is
used as the primary key for themes.
<p>
The "description" parameter, preferably localized, is displayed to the user in select
widgets used to assign a theme to a pageset, page or element.
<p>
The "template" parameter points to the master template, which typically renders the element title and content, such as is done by the <i>standard</i> theme template:
<blockquote><pre>
@template@
</pre></blockquote>
The element content is rendered with the <i>slave</i> template tag.  Note that the
standard theme template references the standard portlet classes defined in the default openacs
theme's CSS.  These classes are also used by ACS core packages that render content in "boxes",
such as the "application" and "subsite" boxes displayed by the default acs-subsite index page.
Often you can "theme" your site simply by modifying these standard classes, maintaining
a consistent look to "boxes" generated manually by core packages and those generated by the
<i>Layout Manager</I> package.
