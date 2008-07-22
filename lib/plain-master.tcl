if { ![info exists header_stuff] } {
    set header_stuff {}
}

# Where to find the stylesheet
set css_url "/resources/acs-subsite/group-master.css"

# See if we're visiting a portal instance or an application mounted under a
# portal instance.  If so, build the portal navbar.

set package_id [site_node::closest_ancestor_package \
                   -node_id [ad_conn node_id] \
                   -package_key portal \
                   -include_self]

set show_single_button_navbar_p [parameter::get \
                                    -package_id $package_id \
                                    -parameter ShowSingleButtonNavbar]

if { ![string equal $package_id ""] } {

    set user_portal_id [portal::get_user_portal_id -package_id $package_id]
    set which_navbar [parameter::get -package_id $package_id -parameter NavbarClass]
    set portal_url [site_node::get_url_from_object_id -object_id $package_id]

    db_multirow -unclobber -extend {url} portal_pages select_user_portal_pages {} {
        set url [export_vars -base $portal_url {portal_id page_num}]
    }

    if { [permission::permission_p \
             -object_id [portal::get_admin_portal_id -package_id $package_id] \
             -privilege admin] } {
        db_multirow -unclobber -append -extend {url} portal_pages select_admin_portal_pages {} {
            set url [export_vars -base $portal_url {portal_id page_num}]
        }
    }

    array set site_node [site_node::get_from_url \
                            -url [ad_conn package_url] \
                            -exact]

    if { $site_node(object_id) != $package_id } {
        set application $site_node(instance_name)
    }

}

