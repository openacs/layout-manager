ad_page_contract {

    Display the user's page set for the current subsite.

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2004-01-02
    @version $Id$

} {
    {page_num:naturalnum,optional 0}
}

set master_template [parameter::get -package_id [ad_conn subsite_id] -parameter DefaultMaster]
set package_id [layout::package_id]
set pageset_id [layout::pageset::get_user_pageset_id -package_id $package_id]

# Check to see if this instance of the layout manager has been initialized, and if not,
# start up the wizard if the user's got admin rights on the package.
if { $pageset_id eq "" } {
    if { [permission::permission_p -object_id $package_id -privilege admin] } {
        ad_returnredirect [site_node::get_url_from_object_id -object_id $package_id]admin/layouts
        ad_script_abort
    } else {
        ad_return_exception_template -params {{custom_message "The page set package hasn't been configured yet."}} /packages/acs-subsite/www/shared/report-error
    }
}

permission::require_permission -privilege read -object_id $pageset_id
ad_return_template

