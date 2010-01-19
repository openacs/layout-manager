ad_library {

    Layout Manager Page Set Procs

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2008-07-05
    @version $Id$

}

namespace eval layout::pageset {}

ad_proc layout::pageset::new {
    -owner_id:required
    {-name Untitled}
    {-context_id ""}
    {-page_list ""}
    {-owner_privileges {read write admin}}
    {-theme default}
    {-package_id ""}
} {
    Create a new page set for the passed in owner_id. create pages passed in
    the page_list.

    @owner_id The object (usually a party) which owns the new page set
    @name The name of the page set
    @context_id  The new page set object's context_id (defaults to package_id)
    @page_list The list of pages to create within the page set
    @owner_privileges A list of privileges to grant the party on the new page set.
      Normally the default list (read, write, admin) will be correct if the party
      is a user but if the party is a group (say, members of a subsite) then it
      would make sense to only grant read to the party directly.
    @theme The theme to assign to this page set (unless copying from a template)
    @package_id The package id of the owning package (defaults to ad_conn package_id)

} {

    if { [string equal $package_id ""] } {
        set package_id [ad_conn package_id]
    }

    if { [string equal $context_id ""] } {
        set context_id $package_id
    }

    db_transaction {

        set var_list [subst {
            {p_name "$name"}
            {p_context_id $context_id}
            {p_owner_id $owner_id}
            {p_theme $theme}
            {p_package_id $package_id}}]

        set pageset_id [package_instantiate_object -var_list $var_list layout_pageset]

        foreach privilege $owner_privileges {
            permission::grant -party_id $owner_id -object_id $pageset_id -privilege $privilege
        }

        foreach page $page_list {
            layout::page::new \
                -pageset_id $pageset_id \
                -name [lindex $page 0] \
                -url_name [lindex $page 1] \
                -page_template [lindex $page 2]
        }
    }
    db_flush_cache -cache_key_pattern pageset_id_${package_id}_${owner_id}*
    return $pageset_id
}

ad_proc layout::pageset::clone {
    -pageset_id:required
    {-owner_id ""}
    {-name ""}
    {-theme ""}
    {-package_id ""}
    {-template_id ""}
    {-owner_privileges {read write admin}}
} {
    Clone the given pageset.  By default all of the existing pageset attributes
    will be copied into the new copy of the pageset.

    @param pageset_id The id of the pageset to clone.
    @param owner_id The optional owner of the new pageset.
    @param name The optional name of the new pageset.
    @param theme The optional theme name for the new pageset.
    @param package_id The optional id of the package the new pageset will be mapped to.
    @param owner_privilges List of privileges to assign to the owner of the new copy.
} {
    array set pageset [layout::pageset::get -pageset_id $pageset_id]
    if { $owner_id eq "" } {
        set owner_id $pageset(owner_id)
    }
    if { $name eq "" } {
        set name $pageset(name)
    }
    if { $theme eq "" } {
        set theme $pageset(theme)
    }
    if { $package_id eq "" } {
        set package_id $pageset(package_id)
    }
    db_transaction {
        set new_pageset_id [layout::pageset::new \
                               -owner_id $owner_id \
                               -name $name \
                               -theme $theme \
                               -package_id $package_id \
                               -owner_privileges $owner_privileges]
        foreach page_id [layout::pageset::get_pages -pageset_id $pageset_id] {
            layout::page::clone -page_id $page_id -pageset_id $new_pageset_id
        }
    }
    return $new_pageset_id
}

ad_proc layout::pageset::delete {
    -pageset_id:required
} {
    delete a page set
} {
    db_dml delete_permissions {}
    db_exec_plsql delete_pageset {}
    layout::pageset::flush -pageset_id $pageset_id
}

ad_proc layout::pageset::get_pages {
    -pageset_id:required
} {
    Return a list of page ids corresponding to the pages mapped to the given pageset.
} {
    return [db_list -cache_key pageset_${pageset_id}_get_pages get_pages {}]
}

ad_proc -private layout::pageset::get {
    -pageset_id:required
} {
    get page set info in "array get" format (not cached)
} {
    ns_cache eval db_cache_pool pageset_${pageset_id}_get {
        db_1row select_pageset_info {} -column_array pageset
        return [array get pageset]
    }
}

ad_proc layout::pageset::get_column_value {
    -pageset_id:required
    -column:required
} {
    array set pageset [layout::pageset::get -pageset_id $pageset_id]
    return $pageset($column)
}

ad_proc layout::pageset::get_pageset_id {
    -package_id:required
    -owner_id:required
} {
    Get a pageset_id.

    @param package_id The package_id of the page set instance
    @param owner_id The owner of the page set
} {
    return [db_string -cache_key pageset_id_${package_id}_$owner_id \
               select_pageset_id {} -default 0]
}

ad_proc layout::pageset::get_user_pageset_id {
    -package_id
} {
    Get the pageset_id for a user.

    @param package_id The package_id of the page set instance (defaults to package_id)_
    @return The pageset_id for the user or the master template pageset_id if personal
        page sets are not enabled.
} {

    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    }

    if { [parameter::get -package_id $package_id -parameter CreatePrivatePageSets] } {
         set owner_id [ad_conn user_id]
    } else {
         set owner_id 0
    }
    
    set pageset_id [layout::pageset::get_pageset_id -package_id $package_id -owner_id $owner_id]

    if { $pageset_id == 0 } {
        if { ![layout::pageset::initialized -package_id $package_id] } {
            return ""
        }

        # At this point we know we're supposed to create a personal page set

        db_1row select_user_name {}

        set master_template_id [layout::pageset::get_master_template_id -package_id $package_id]

        set pageset_id [layout::pageset::clone \
                           -pageset_id $master_template_id \
                           -owner_id $owner_id \
                           -name "Portal for $user_name" \
                           -template_id $master_template_id]
    }
    return $pageset_id
}

ad_proc layout::pageset::set_values {
    -pageset:required
} {
    set the fields of a page set
} {
    array set pageset_array $pageset
    template::util::array_to_vars pageset_array
    db_dml update_pageset {}
    layout::pageset::flush -pageset_id $pageset_id
}

ad_proc layout::pageset::set_column_value {
    -pageset_id:required
    -column:required
    -value:required
} {
    array set pageset [layout::pageset::get -pageset_id $pageset_id]
    set pageset($column) $value

    layout::pageset::set_values -pageset [array get pageset]
}

ad_proc layout::pageset::get_master_template_id {
    -package_id
} {
    Get the master template id, i.e. the page set used to create all other page sets.

    @param package_id The package_id of the page set instance (defaults to ad_conn package_id)
    @return The pageset_id of the master page set template.

} {
    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    }

    if { [db_0or1row get_master_template_id {}] } {
        return $master_template_id
    } else {
        return ""
    }
}

ad_proc layout::pageset::is_master_template_p {
    -pageset_id:required
    -package_id
} {
    @return True if the given pageset_id is the master template for the given package_id.
} {
   if { ![info exists package_id] } {
       set package_id [ad_conn package_id]
    }

    return [expr { $pageset_id ==
                   [layout::pageset::get_master_template_id -package_id $package_id] }]
}

ad_proc -public layout::pageset::get_page_count {
    -pageset_id:required
} {
    Get the number of pages in this page set.

    @param pageset_id The id of the page set.
    @return The number of pages in the page set.
} {
    return [db_string select_page_count {}]
}

ad_proc layout::pageset::get_page_list {
    -pageset_id:required
} {
    @return list of page_ids associated with the given page set (in sort_key order).
} {
    return [db_list select_page_ids {}]
}

ad_proc layout::pageset::get_render_data {
    -pageset_id:required
    {-page_num ""}
} {
    returns metadata needed to render a page set

    @pageset_id The id of the page set you're interested in.
    @page_num The page within the page set (defaults to page 0).

    @return The page set metadata in array get format.
} {
    if { [string equal $page_num ""] } {
        set page_num 0
    }
    ns_cache eval db_cache_pool pageset_${pageset_id}_get_render_data_$page_num {
        # get the page set and layout
        db_1row pageset_select {} -column_array pageset

        array set theme [layout::theme::get -name $pageset(theme)]
        set pageset(theme_template) $theme(template)

        return [array get pageset]
    }
}

ad_proc layout::pageset::configure_dispatch {
    {-template_p f}
    -pageset_id:required
    -form:required
} {
    Dispatches the configuration operation.
    We get the target page_column number from the op.

    DRB: This is only kept for the revert code at the moment, i.e. until I
    get time to move it to the configure template where it belongs. Also
    the template (copy) stuff doesn't work.

    @param pageset_id the page set to edit
    @param formdata an ns_set with all the formdata
} {

    permission::require_permission -object_id $pageset_id -privilege write

    set op [ns_set get $form op]

    switch $op {
        "Revert" {
            db_transaction {
                set template_id [layout::pageset::get_template_id -pageset_id $pageset_id]

                # revert theme
                set_theme -pageset_id $pageset_id -theme [layout::pageset::get_theme -pageset_id $template_id]

                # revert pages
                # first equalize number of pages in the target
                set template_page_count [layout::pageset::get_page_count -pageset_id $template_id]
                set target_page_count [layout::pageset::get_page_count -pageset_id $pageset_id]
                set difference [expr $template_page_count - $target_page_count]

                if {$difference > 0} {
                    # less pages in target
                    for {set x 0} {$x < $difference} {incr x} {

                        set name "page set revert dummy page $x"
                        layout::page::new \
                            -pageset_id $pageset_id \
                            -name $name \
                    }
                } elseif {$difference < 0} {
                    # more pages in target, delete them from the end,
                    # putting any elements on them on the first page,
                    # we put them in the right place later
                    for {set x 0} {$x < [expr abs($difference)]} {incr x} {

                        set max_page_id [db_string revert_max_page_id_select {}]
                        set page_id [db_string revert_min_page_id_select {}]
                        set page_column 1

                        db_foreach revert_move_elements_for_del {} {
                            pageset::element::move_to_page \
                                -page_id $page_id \
                                -element_id $element_id \
                                -page_columncolumn 1
                        }

                        layout::page::delete -page_id $max_page_id
                    }
                }

                # now that they have the same number of pages, get to it
                foreach source_page_id [layout::pageset::get_page_list -pageset_id $template_id] {

                    db_1row revert_get_source_page_info {}

                    set target_page_id [db_string revert_get_target_page_id {}]

                    db_dml revert_page_update {}

                    # revert elements in two steps like "swap"
                    db_foreach revert_get_source_elements {} {
                        # the element might not be on the target page...
                        set target_element_id \
                                [db_string revert_get_target_element {}]

                        db_dml revert_element_update {}
                    }
                }
            }
        }
    }
}


ad_proc -private layout::pageset::generate_action_string {
} {
    Portal configuration pages need this to set up
    the target for the generated links. It's just the
    current location with "-2" appended to the name of the
    page.
} {
    return "[lindex [ns_conn urlv] [expr [ns_conn urlc] - 1]]-2"
}

ad_proc includelet_list {
} {
    Returns a list of page set includelets which have been mapped to the given page set
    package instance.
} {
    set package_id [ad_conn package_id]
    return [db_list_of_lists select_includelets {}]
}

ad_proc layout::pageset::initialized {
    -package_id
} {
    @param package_id The package_id of this page set instance (default ad_conn package_id)
    @return True if we've already initialized this instance of the page set package.
} {
    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    }

    return [expr {[layout::pageset::get_master_template_id -package_id $package_id] ne ""}]
}

ad_proc layout::pageset::initialize {
    -package_id
    {-page_list {{{Page 1} page-1 2_column}}}
} {
    Initialize this instance of the page set package if we've not already done so.  This
    consists of creating the master template, which is assigned to party 0 and will be
    the page set returned to users who aren't logged in, or all users if the page set package
    is configured to disallow personal page sets.

    @param package_id The page set instance we're initializing, default's to current package_id
    @param page_list A list of lists of page titles and layouts to for the new user page set
} {
    if { ![info exists package_id] } {
        set package_id [layout::package_id]
    }

    if { ![initialized -package_id $package_id] } {
 
        # create the master template

        set master_pageset_id [layout::pageset::new \
                                 -name "Shared Page Set" \
                                 -owner_id 0 \
                                 -package_id $package_id \
                                 -page_list $page_list \
                                 -theme [parameter::get \
                                                 -package_id $package_id \
                                                 -parameter DefaultThemeName] \
                                 -owner_privileges {}]
    }
}

ad_proc layout::pageset::flush {
    -pageset_id:required
} {
    Flush all cached data for this page set
} {
    db_flush_cache -cache_key_pattern pageset_${pageset_id}_*
}
