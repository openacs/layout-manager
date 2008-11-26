<master>
<property name="title">Layout Manager Documentation</property>
<h1>Layout Manager Documentation</h1>
<h2>Introduction</h2>
The <i>Layout Manager</i> package is a rewrite of .LRN's new-portal package that, as
its name implies, handles page layout for sets of application <i>includelets</i>.
<p>Nomenclature has been changed (pagesets rather than portals, etc) to avoid confusion,
and datamodel/script name clashes, with the existing new-portal package.  It can be run
in parallel with .LRN/new-portal.
<p>Client applications can build page layouts through the Tcl API, or can use the "extend
package" facility of ACS Core to access a user interface that allows the management of pages
and includelets similarly to .LRN.
<p>For a complete (and useful) example of how to do so, see the documentation for
the <i>Layout Managed Subsite</i> package, which provides seamless integration between
ACS Subsite and the Layout Manager.
<h2>Table of Contents</h2>
<ul>
  <li><a href="new-portal-compare">Comparison with New Portal</a>
  <li><a href="page-templates">Page Templates</a>
  <li><a href="themes">Themes</a>
  <lI><a href="render">Rendering Templates</a>
  <li><a href="includelets">Includelets</a>
  <li><a href="page-config">Page Configuration User Interface</a>
</ul> 
