ad_page_contract {

    Edit the theme and title of an includelet.

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 
    @cvs-id $Id$
} {
    pageset_id:integer,notnull
    element_id:integer,notnull
    return_url:notnull
}

permission::require_permission -object_id $pageset_id -privilege write

set context [list "Edit Element"]

set themes [concat [list [list "" ""]] [db_list_of_lists select_themes {}]]

ad_form -export {pageset_id element_id return_url} -form {
    {title:text,optional {label "Title"}}
    {theme:text(select),optional
        {label "Theme"}
        {options $themes}}
} -on_request {
    set title [layout::element::get_column_value -element_id $element_id -column title]
    set theme [layout::element::get_column_value -element_id $element_id -column theme]
} -on_submit {

    layout::element::set_column_value -element_id $element_id -column title -value $title
    layout::element::set_column_value -element_id $element_id -column theme -value $theme
    layout::element::flush -element_id $element_id

    ad_returnredirect $return_url
    ad_script_abort

}
ad_return_template
