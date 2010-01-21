<master>
<property name="title">New Portal Comparison</property>
<h1>New Portal Comparison</h1>
<b>New Portal</b> is the original version of the OpenACS portals package written for
.LRN.  This package is inadequate for a variety of reasons:
<ul>
<li>Can't run standalone (is tied to .LRN)
<li>Defining a portlet requires the writing of dozens of lines of boilerplate SQL code
for Oracle and PostgreSQL.
<li>Defining a portlet requires the writing of dozens of lines of custom Tcl code to implement
a fairly complex service contract.  Among other things, the portal has to "know" how to
add itself to a new-portal page and to remove itself as well.  The new-portal package itself
provides very limited management help.
<li>Likewise, in order to add an application which supports portlets, one must implement a .LRN
applet or similar functionality.  new-portal provides no configuration help.
<li>Portlets are called with parameters passed in an array.  It's impossible to wrap an existing
template with a portlet definition and run it unchanged (i.e. share it with existing code)
without providing an intermediate interface template.
<li>There's a lot of dynamic HTML generated within the new-portal package's Tcl library.  Besides
making it more difficult to customize the output, the template engine is unable to cache the
compiled byte-code generated for dynamic HTML, which impacts efficiency.
<li>Theming is only available for portals, not pages or elements.
<li>Portal pages are referenced with URLs containing a page number variable, rather than
a symbolic URL.
</ul>
By comparison, the <b>Layout Manager</b> package:
<ul>
<li>Provides a simple Tcl API for defining a new <i>includelet</i>.  No SQL or service contract
implementation is required.  An <i>includelet</i> may provide an optional <i>initializer</i>
procedure, for instance to create a private calendar for a user if desired, etc.
<li>Parameters are defined directly, by name, when an includelet's template is rendered,
just as is typically true when they're passed using the template system's
<i>&lt;include&gt;</i> tag.
<li>All rendering is done through use of <i>&lt;include&gt;</i> tags, and a simple Tcl API is
provided to allow the addition of custom page templates (which define page layout), themes,
etc.  The template engine is able to cache the resulting compiled byte-code, for increased
performance.
<li>The <i>Layout Manager</i> is a service, and is not meant to be mounted.  However,
a library of templates and page configuration scripts are provided, which can easily be
integrated into an application through use of the new "extends package" facility built
into ACS Core versions starting with 5.5.0.  See the <i>Layout Managed Subsite</i> package
for an example.
<li>Commonly used database queries and associated computations are cached, so performance
should be better than new-portal's.
<li>Theming can be applied to a set of pages, or individual pages and elements.
<li>Pages are referenced with symbolic URLs.
