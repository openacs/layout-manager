ad_page_contract {

    Configure one page within a page set.

    @author Don Baccus (dhogaza@pacifier.com)

}

set return_url [ad_conn url]?[ad_conn query]
set package_url [ad_conn package_url]

array set page [layout::page::get -page_id $page_id]
array set page_template [layout::page_template::get -name $page(page_template)]

# Get the layouts for the change layout widget
db_multirow page_templates select_page_templates {}
db_multirow page_themes select_page_themes {}

# Build the column list since the template engine has no way to generate an
# iterator

set column_list [list]
for { set i 1 } { $i <= $page_template(columns) } { incr i } {
    lappend column_list $i
}

# Compute the column widths for the region table

set column_width [expr {100/$page_template(columns)}]%

set has_visible_elements_p [layout::page::has_visible_elements -page_id $page_id]
