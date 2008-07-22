ad_library {

    layout page templateprocs

    @creation-date 2008-07-07
    @version $Id$

}

namespace eval layout::page_template {}

ad_proc layout::page_template::new {
    -name:required
    {-description ""}
    -columns:required
    -template:required
} {
    Create a new page template.

    A page template defines the number of columns on a page, and a template
    to render the page and its component elements.

    @param name The name of this page template, which must be unique.
    @param description An optional description of this page template.
    @param columns The number of columns this page template expects.
    @param template The path (/packages/...) to the template source.
} {
    db_dml insert_page_template {}
}

ad_proc layout::page_template::delete {
    -name:required
} {
    Delete the given page template.

    @param name The name of the template to delete.
} {
    db_dml delete_page_template {}
}

ad_proc layout::page_template::get {
    -name:required
} {
    Returns information about the given page_template in array get format

    @param name The name of the page template.
} {
    # DRB: need to do CACHE
    db_1row select_page_template {} -column_array page_template
    return [array get page_template]
}

ad_proc layout::page_template::get_column_value {
    -name:required
    -column:required
} {
    Returns the requested column for the given page template.

    @param name The name of the page template.
    @param column The column of the page template to return
    @return The requested column
} {
    array set page_template [layout::page_template::get -name $name]
    return $page_template($column)
}
