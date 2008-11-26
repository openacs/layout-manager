<master>
<property name="title">Page Configuration User Interface</property>
<h1>Page Configuration User Interface</h1>
Though the <i>Layout Manager</i> package is a service, and not meant to be mounted, configuration
of pagesets is something any client of the package will want to implement.  Therefore, a UI
is provided that can easily be enabled by a client package through use of the ACS Core
"extend package" facility.
<h2>Structure</h2>
The UI templates and scripts are structured much like the set of templates that render a page set,
 i.e.  hierarchically.  The pageset-configure template allows one to set pageset specific
parameters (i.e. theme, name) and then includes the page-configure template once for each of
the pages that make up the pageset.  The page-configure template in turn allows one to set
page-specific parameters (i.e. page template, theme, name) and includes column-configure for
each column that makes up the page.  The column configure page includes an admin version of each
element in the column, which allows one to move the element to another column or page, to
change the theme associated with the element, and its title.
<p>To see it in action, mount and explore the <i>Layout Managed Subsite</i> package.
