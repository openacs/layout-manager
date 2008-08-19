ad_library {

    Layout Manager Includelet Procs

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2008-07-5
    @version $Id$

}

namespace eval layout::includelet {}

ad_proc layout::includelet::new {
    -name:required
    -title:required
    -application:required
    -template:required
    -description
    {-dotlrn_compat_p f}
    {-initializer ""}
    {-uninitializer ""}
    {-required_privilege read}
    {-internally_managed_p f}
} {
    Create a new layout manager includelet.

    @param name The internal name of the new includelet. Like package keys, this must
        be unique in a single OpenACS instance, so it is best to incorporate the includelet's
        package key in the name (forums_includelet, forums_admin_includelet, etc)
    @param title The external name (or message key) of the includelet
    @param owner The package that owns this portlet
    @param application The package the portlet works with, if any
    @param template The template the displays the portlet content
    @param description A human-readable description (defaults to name)
    @param constructor Custom constructor to run after the default constructor
    @param destructor Custom destructor to run before the default destructor
    @param required_privilege The default privilege the user needs to be able to see this
        includelet (defaults to 'read')
    @param internally_managed_p Controls whether or not application/includelet managers
           should touch this includelet.

    @author Don Baccus (dhogaza@pacifier.com)
} {
    # Default includelet description to its name
    if { ![info exists description] } {
        set description $name
    }

    db_dml insert_includelet {}
}

ad_proc -private layout::includelet::delete {
    -name:required
} {
    Delete an includelet and any layout element referencing it.
  
    @param name The name of the includelet to delete
} {
    db_dml delete_includelet {}
}


ad_proc layout::includelet::get {
    -name:required
} {
    Return the includelet in "array get" format.
} {
    db_1row select_includelet {} -column_array includelet
    return [array get includelet]
}

ad_proc layout::includelet::get_column_value {
    -name:required
    -column:required
} {
    Return one row column from a layout includelet.

    @param name The name of the includelet.
    @param column The name of the column in the layout_elements table.
} {
    array set includelet [layout::includelet::get -name $name]
    return $includelet($column)
}

