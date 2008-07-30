<master>
<property name="title">Rendering a Pageset</property>
<h1>Rendering a Pageset</h1>
Rendering of a page set is done with a simple hierarchical set of templates, which can be
found in the <i>/layout-manager/lib/render</i> directory.  Rendering consists of the following
steps:
<ul>
<li><i>include</i> the render pageset template, which gets an array of render data for the
given pageset and then
<li><i>includes</i> the render page template, which gets an array of render data for the current
page within the pageset and then
<li><i>includes</i> the page template for the given page, which sets the proper CSS for (say)
a thin column on the left and a thick column on the right, and generates the proper HTML for
the number of columns on the page, and then
<li><i>includes</i> the render element template for each element on the page, which gets an
array of render data for the given element.  The <i>includelet</i> referenced by the element
is included, while the <i>theme</i> assigned to the element is declared as the master template.
If the <i>includelet</i> is declared to be .LRN-compatible, parameters are passed in an
array named "cf", otherwise parameters are set directly in the scope of the <i>includelet</i>.
</ul>
You can safely treat this process as a "black box" when writing an <i>includelet</i>, as
will be obvious when you study some examples.
