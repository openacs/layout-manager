ad_page_contract {

  Build two-level tabbed navigation multirows for a pageset.

  @author Don Baccus (dhogaza@pacifier.com)

  $Id$
}

set user_id [ad_conn user_id]

set subsite_node_id [site_node::get_node_id_from_object_id -object_id [ad_conn subsite_id]]
set layout_manager_url \
    [lindex [site_node::get_children -node_id $subsite_node_id -package_key layout-manager] 0]

set package_id [site_node::get_object_id -node_id [site_node::get_node_id -url $layout_manager_url]]
set package_node_id [site_node::get_node_id_from_object_id -object_id $package_id]

set pageset_id [layout::pageset::get_user_pageset_id -package_id $package_id]

# set a default title in case an included application page doesn't set it.  Should move
# to the doc() array approach in the future.
set title ""

# Create the multirow so other code that add to this can do so with multirow append
template::multirow create navigation group label href target \
    title lang accesskey class id tabindex 

# Grab the pages for the user portal
db_multirow -cache_key pageset_${pageset_id}_multirow_${user_id} -append \
    -unclobber -extend {group href target title lang accesskey class id} \
     navigation select_pageset_pages {} {
    set group main
    set href [export_vars -base $layout_manager_url {{pageset_id $pageset_id} \
                                             {page_num $tabindex}}]
}

subsite_navigation::define_pageflow -group main -subgroup sub -initial_pageflow "" \
    -navigation_multirow navigation -show_applications_p 0

if { [site_node::get_element -url [ad_conn package_url] -element parent_id] == \
      $package_node_id } {
    set instance_name [site_node::get_element -url [ad_conn package_url] \
                          -element instance_name]
    template::multirow append navigation main $instance_name [ad_conn package_url] \
        "" $instance_name "" [template::multirow size navigation] "" \
        main-navigation-active [template::multirow size navigation]
}

set pageset_page_p 0
if { [info exists page_num] } {
    for { set i 1 } { $i <= [template::multirow size navigation] } { incr i } {
        if { [template::multirow get navigation $i tabindex] == $page_num } {
            template::multirow set navigation $i id "main-navigation-active"
            set pageset_page_p 1
            break
        }
    }
}

if { !$pageset_page_p } {
    array set theme \
        [layout::theme::get \
            -name [layout::pageset::get_column_value -pageset_id $pageset_id -column theme]]
}

# No expr tag in the templating system ...
set main_content_p [expr { !$pageset_page_p }]
