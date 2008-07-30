ad_page_contract {

    This template handles predefined page templates via name magic.  Probably too
    clever to be a useful model for how to write your own custom page template, particularly
    if you want it to be aware of different media types, etc.

    @version $Id$

} -properties {
    element_list:onevalue
}

set column_count [layout::page_template::get_column_value \
                     -name $page(page_template) \
                     -column columns]

# The page(element_list) array only contains data for elements actually placed on
# the page.  We initialize the array elements of the regions array to the empty list
# to simplify the various templates.

for { set i 1 } { $i <= $column_count } { incr i } {
    set columns($i) [list]
}

foreach {column element_id_list} $page(element_list) {
    set columns($column) $element_id_list
}

set name [layout::page_template::get_column_value -name $page(page_template) -column name]

template::head::add_css -href /resources/layout-manager/page-templates/${name}.css -media all

ad_return_template /packages/layout-manager/lib/page-templates/simple${column_count}
