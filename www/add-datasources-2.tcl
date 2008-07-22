ad_page_contract {

    Add one or more datasources to this instance of the portals package

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 
    @cvs-id $Id$

} {
    datasource:multiple
    return_url:notnull,optional
    pageset_id:integer,notnull
}

permission::require_permission -object_id $pageset_id -privilege admin
set package_id [db_1row get_package_id {}]
set node_id [site_node::get_node_id_from_object_id -object_id $package_id]

set added_datasources [list]

db_transaction {
    foreach one_datasource $datasource {

        # For some reason I'm getting dupes in my datasource list from the checkboxes
        # set up by the list widget on the previous page.

        if { [lsearch -exact $added_datasources $one_datasource] == -1 } {

            lappend added_datasources $one_datasource

            set package_id [layout::datasource::construct \
                               -name $one_datasource \
                               -node_id [ad_conn node_id] \
                               -package_key [layout::datasource::get_column_value \
                                                -name $one_datasource \
                                                -column package_key]]

            set user_includelets [db_list get_user_includelets {}]

            foreach user_includelet $user_includelets {
                layout::element::new \
                    -pageset_id $pageset_id \
                    -state hidden \
                    -includelet_name $user_includelet \
                    -package_id $package_id \
                    -initialize
            }
        }
    }
}

if { [info exists return_url] } {
    ad_returnredirect $return_url
}
