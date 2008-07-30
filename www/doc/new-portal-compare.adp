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
add itself to a new-portal page and to remove itself as well.  The new-portal package itself provides very limited management help.
<li>Likewise, in order to add an application which supports portlets, one must implement a .LRN applet or similar functionality.  new-portal provides no configuration help.
<li>Portlets are called with parameters passed in an array.  It's impossible to wrap an existing
template with a portlet definition and run it unchanged (i.e. share it with existing code)
without providing an intermediate interface template.
<li>There's a lot of magic HTML generated within the new-portal package's Tcl library.
</ul>
By comparison, the <b>Layout Manager</b> package:
<ul>
<li>Provides a simple Tcl API for defining a new <i>includelet</i>.  No SQL or service contract
implementation is required.  An <i>includelet</i> may provide an optional <i>initializer</i>
procedure, for instance to create a private calendar for a user if desired, etc.
<li>Parameters are defined directly, by name, when an includelet's template is rendered,
just as is true when they're passed using the template system's <i>&lt;include&gt;</i> tag.
<li>All rendering is done through use of <i>&lt;include&gt;</i> tags, and a simple Tcl API is
provided to allow the addition of custom page templates (which define page layout), themes,
etc.
<li>The <i>Layout Manager</i> is a service, and is not meant to be mounted, so provides no
User Interface for the customization of page layout, etc.  However, there is a library of
templates which are designed to be included (see the <i>Layout Subsite Integration</i> package
for an example of how to use these).
<li>Though the <i>Layout Manager</i> itself provides no assistance in the managing of
applications and their associated includelets, the <i>Layout Subsite Integration</i> package
provides a very flexible admin interface that can be used to build a subsite interactively,
with no programming required.  Alternatively, the <b>install.xml</b> facility, or a script
accesing the <i>Layout Manager</i> Tcl API directly, can be used for site building.
<li>All rendering operations are heavily cached, so performance should be much better than
new-portal's (queries required for page and navigation tab rendering are all cached).
