<master>
<property name="title">How to implement a Layout Manager Includelet</property>
<h1>How to implement a Layout Manager Includelet</h1>
It's an easy, two- or three-step process!
<ol>
  <li>Write a template which implements the functionality you want to declare as an
      <i>includelet</i> (or find a template within a package that already does what you
      want).  Implement it, if necessary.
  <li>If your <i>Includelet</i> requires parameters other than the package instance it
      will be bound to, write an initialization procedure to generate the necessary
      values, and store them in the <i>element</i> the <i>Layout Manager</i> will
      associate when the <i>includelet</i> is added to a <i>pageset</i>.
  <li>Call the <i>layout manager</i> Tcl API to declare your includelet.
</ol>
If a template already exists that does what you want, and requires no parameters other
than its associated package, only the last step is necessary.  For instance, here's the
Tcl API call that creates the <i>Subsites</i> includelet, which just calls the same
subsite-listing template included by the standard acs-subsite index page:
<blockquote><pre>
layout::includelet::new \
    -name subsites_includelet \
    -description "Display Subsites" \
    -title "Subsites" \
    -application acs-subsite \
    -template /packages/acs-subsite/lib/subsites \
    -required_privilege read
</pre></blockquote>
The "name" parameter is the internal name and primary key of the includelet, and must be unique
throughout the system.
<p>
The "description" parameter should be a human-readable description of what the includelet
does.
<p>
The "title" parameter provides a default title to use when creating an element from
the includelet.
<p>
The "application" parameter is the package key that this includelet supports.  When an element
is created from this includelet, it will be bound to a single instance of this apm package
type.
<p>
The "template" parameter is the path to the template which implements the includelet.
<p>
The "required_privilege" parameter is the privilege a user must have on the application
package an element is bound to in order to see the element.  If the user doesn't have
the required privilege on the relevant application package instance, the element won't be
displayed to them.  Defaults to "read", the implementer should set it to "admin" when
writing admin includelets.
<h2>Custom Initializer</h2>
It's often necessary to create an initialization procedure for an includelet.  The optional
parameter "initalizer" allows one to specify a procedure to be called after an element
is created from an includelet and placed on a layout manager page.  For an example, here's
the call which defines the content includelet, which provides a way to generate simple content
with version control (delete, publish, preview, edit):
<blockquote><pre>
layout::includelet::new \
    -name content_includelet \
    -description "Displays the content includelet" \
    -title "Content Includelet" \
    -application content-includelet \
    -template /packages/content-includelet/lib/content-includelet \
    -initializer content_includelet_utilities::configure_content_id
</pre></blockquote>
The initalizer procedure will be called with a single parameter, the id of the element which
is being initalized.  This example is slightly simplified from the actual initalizer procedure,
which is generalized a bit for use outside the <i>Layout Manager</i>:
<blockquote><pre>
ad_proc content_includelet_utilities::configure_content_id {
    element_id
} {
    Create the includelet's item and set the content_id param.

    @param element_id The element to initialize.

} {

    # Get our application's package_id from the element.
    set package_id [layout::element::get_column_value \
                       -element_id $element_id \
                       -column package_id]

    # Create a new content item.
    set content_id [content::item::new \
                       -name "Content For $package_id's $parameter" \
                       -parent_id $package_id \
                       -context_id $package_id \
                       -content_type content_includelet_revision \
                       -storage_type text]

    # Add the content_id parameter to the element.
    layout::element::parameter::add_values \
        -element_id $element_id \
        -parameters [list content_id $content_id]
}
</pre></blockquote>
When an includelet is executed, the local variables <i>package_id</i> and <i>element_id</i>
are always set, along with includelet-supplied parameters defined for the element.  In this case,
the local variable <i>content_id</i> will be set when the content-includelet script is
executed.


