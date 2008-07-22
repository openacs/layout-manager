ad_page_contract {

    Displays the given page set if specified.  Otherwise, figure out the proper page set
    to display based on the CreatePrivatePagesets parameter, creating the user's
    personal paget set if necessary.

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2004-01-02
    @version $Id$

} {
    {page_num:integer,optional 0}
    {pageset_id:integer,optional ""}
}

# This is a kludge for the rp_internal_indirect case, and will fail if more than one
# layout-manager instance is mounted under the current subsite.  There's gotta be a
# better way, but gotta think this through, first!

if { [ad_conn package_id] == [ad_conn subsite_id] } {
    set package_id [site_node::get_children -node_id [ad_conn subsite_node_id] \
                       -package_key layout-manager -element object_id]
} else {
    set package_id [ad_conn package_id]
}

set master_template [parameter::get -package_id $package_id -parameter OurMasterTemplate]
if { $master_template eq "" } {
    set master_template [parameter::get -package_id [ad_conn subsite_id] \
        -parameter DefaultMaster]
}

if { [string equal $pageset_id ""] } {
    set pageset_id [layout::pageset::get_user_pageset_id -package_id $package_id]
}

permission::require_permission -privilege read -object_id $pageset_id
set edit_p [permission::permission_p -object_id $pageset_id -privilege write]

ad_return_template

