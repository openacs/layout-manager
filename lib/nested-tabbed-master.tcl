# Expects properties:
#   title
#   focus
#   header_stuff
#   section
#   subnavbar_link

if { ![info exists section] } {
    set section {}
}

if { ![info exists header_stuff] } {
    set header_stuff {}
}

if { ![info exists subnavbar_link] } {
    set subnavbar_link {}
}

if { ![info exists title] } {
    set title ""
}

set subsite_node_id [site_node::get_node_id_from_object_id -object_id [ad_conn subsite_id]]
set portal_url [lindex [site_node::get_children -node_id $subsite_node_id -package_key portal] 0]

set package_id [site_node::get_object_id -node_id [site_node::get_node_id -url $portal_url]]
set package_node_id [site_node::get_node_id_from_object_id -object_id $package_id]
set portal_page_p 0

set user_portal_id [portal::get_user_portal_id -package_id $package_id]
set which_navbar [parameter::get -package_id $package_id -parameter NavbarClass]
set portal_url [site_node::get_url_from_object_id -object_id $package_id]
array set theme [portal::theme::get -theme_id [portal::get_theme_id -portal_id $user_portal_id]]
set theme_template $theme(template)
set master_template [parameter::get -package_id $package_id -parameter SiteMasterTemplate]

db_multirow -unclobber -extend {url} portal_pages select_user_portal_pages {} {
    set url [export_vars -base $portal_url {portal_id page_num}]
    if { [string equal $url $portal_url] } {
        set portal_page_p 1
    }
}

if { [permission::permission_p \
         -object_id [portal::get_admin_portal_id -package_id $package_id] \
         -privilege admin] } {
    db_multirow -unclobber -append -extend {url} portal_pages select_admin_portal_pages {} {
        set url [export_vars -base $portal_url {portal_id page_num}]
        if { [string equal $url $portal_url] } {
            set portal_page_p 1
        }
    }
}

array set site_node [site_node::get_from_url \
                        -url [ad_conn package_url] \
                        -exact]

if { $site_node(parent_id) == $package_node_id } {
    set application $site_node(instance_name)
} elseif {$site_node(object_id) == $package_id } {
    set portal_page_p 1
}


# This will set 'sections' and 'subsections' multirows
subsite::define_pageflow -section $section
subsite::get_section_info -array section_info

# Find the subsite we belong to
set subsite_url [site_node_closest_ancestor_package_url]
array set subsite_sitenode [site_node::get -url $subsite_url]
set subsite_node_id $subsite_sitenode(node_id)
set subsite_name $subsite_sitenode(instance_name)

# Where to find the stylesheet
set css_url "/resources/acs-subsite/group-master.css"

if { [string equal [ad_conn url] $subsite_url] } {
    set subsite_url {}
}

