ad_page_contract {

    Main administration page for the layout manager package.  Return to the script which
    has included us.

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 
    @cvs-id $Id$
} {
}

set package_id [ad_conn package_id]
set base_url [ad_conn package_url]
set return_url [ad_conn url]?[ad_conn query]

set package_edit_p [expr { ![info exists pageset_id] }]
if { $package_edit_p } {
    set pageset_id [layout::pageset::get_master_template_id -package_id $package_id]
}

set edit_pageset_template_url \
    [export_vars -base ${base_url}pageset-configure {return_url pageset_id}]
set configure_url [export_vars -base ${base_url}admin/configure {return_url pageset_id}] 
set add_datasources_url [export_vars -base ${base_url}add-datasources {return_url pageset_id}] 
set user_pagesets_p [expr { [parameter::get -parameter CreatePrivatePageSets] && $package_edit_p }]
if { $user_pagesets_p } {
    set user_pagesets_url [export_vars -base ${base_url}admin/user-portals {pageset_id return_url}]
}
db_1row count_datasources {}

