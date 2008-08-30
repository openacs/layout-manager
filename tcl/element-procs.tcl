ad_library {

    Layout Manager Element Procs

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2008-07-05
    @version $Id$

}

namespace eval layout::element {}

ad_proc layout::element::new {
    -pageset_id:required
    -package_id:required
    {-page_name ""}
    {-page_column ""}
    {-state full}
    -includelet_name:required
    {-name ""}
    {-title ""}
    {-parameters ""}
    -initialize:boolean
    {-theme ""}
} {
    Create a new layout manager element of type includelet_name on the given layout manager.

    @param pageset_id The page set to add this element to.
    @param package_id The object this element is bound to.
    @param page_name The name of the page to place it on (defaults to the first page.)
    @param name The internal name for this element
    @param title The external name or message resource for this element
    @param page_column The page page_column to placer the element on.
    @param includelet_name The layout manager includelet name
    @param name The name of the element
    @param parameters Optional args to set in array get format
    @param initialize If set, call the layout manager's default initializer
    @param theme Override page and pageset theme if set

    @return The element_id of the new portlet

    Note of the day: use of a parameter named "args" breaks ad_proc in very hard
    to debug ways ...

} {

    set page_id [layout::page::get_id -pageset_id $pageset_id -page_name $page_name]

    if { $page_column eq "" } {
            set page_column [layout::element::choose_page_column -page_id $page_id]
    }

    array set includelet [layout::includelet::get -name $includelet_name]

    # Default name to be the same as the includelet name
    if { $name eq "" } {
        set name $includelet_name
    }

    # Default the display title to the value given in the includelet definition
    if { $title eq "" } {
        set title $includelet(title)
    }

    set element_id [db_nextval layout_seq]

    db_dml insert_element {}

    layout::element::parameter::add_values \
        -element_id $element_id \
        -parameters $parameters

    if { $initialize_p && $includelet(initializer) ne "" } {
        $includelet(initializer) $element_id
    }

    layout::page::flush -page_id $page_id

    return $element_id
}

ad_proc layout::element::delete {
    -element_id:required
} {
    Delete the given element.

    @param element_id The id of the parameter to be deleted.
} {
    array set element [layout::element::get -element_id $element_id]
    set page_id $element(page_id)

    set uninitializer [layout::includelet::get_column_value \
                          -name $element(includelet_name) \
                          -column uninitializer]
    if { $uninitializer ne "" } {
        $uninitializer $element_id
    }

    db_dml delete_element {}
    layout::element::flush -element_id $element_id
    layout::page::flush -page_id $page_id
}

ad_proc layout::element::get {
    -element_id:required
} {
    Return element info in "array get" format.

    @param element_id The id of the element.
} {
    ns_cache eval db_cache_pool element_${element_id}_get {
        db_1row select_element {} -column_array element
        return [array get element]
    }
}

ad_proc layout::element::get_column_value {
    -element_id:required
    -column:required
} {
    Return one row column from a layout element.

    @param element_id The id of the element.
    @param column The name of the column in the layout_elements table.
} {
    array set element [layout::element::get -element_id $element_id]
    return $element($column)
}

ad_proc layout::element::set_values {
    -element:required
} {
    Set the fields of a layout manager element.

    @param element The new value of the element in array get format (including the element_id).
} {
    array set element_array $element
    template::util::array_to_vars element_array

    db_dml update_element {}
    layout::element::flush -element_id $element_id
}

ad_proc layout::element::set_column_value {
    -element_id:required
    -column:required
    -value:required
} {
    Set a column to a given value in a particular row.

    @param element_id The id of the element to modify.
    @param column The name of the column being set.
    @param value The new value for the column.
} {
    array set element [layout::element::get -element_id $element_id]
    set element($column) $value

    layout::element::set_values -element [array get element]
}

ad_proc layout::element::get_id_list {
    -pageset_id:required
    -includelet_name:required
    {-name "%"}
    {-title "%"}
} {
    get a list of element_ids of type includelet_name on a particular pageset, restricted
    by the SQL LIKE patterns applied to the name and title columns.

    @param pageset_id The pageset to search
    @param includelet_name The portlet type
    @param name If present, SQL LIKE pattern that restricts the search by the element's name
    @param title If present, like name but on the title column
} {
    return [db_list select_element_ids {}]
}

ad_proc layout::element::get_id {
    -pageset_id:required
    -includelet_name:required
    {-name "%"}
    {-title "%"}
} {
    get an element_id of type includelet_name on a particular pageset, restricted
    by the SQL LIKE patterns applied to the name and title columns.  Give an error if
    more than one such element is found.

    @param pageset_id The pageset to search
    @param includelet_name The portlet type
    @param name If present, SQL LIKE pattern that restricts the search by the element's name
    @param title If present, like name but on the title column
} {
    set id_list [layout::element::get_id_list \
                    -pageset_id $id \
                    -includelet_name $includelet_name \
                    -name $name \
                    -title $title]
    if { [llength $id_list] != 1 } {
        ad_return -code error "Check for exactly one layout manager element failed"
    }
    return [lindex $id_list 0]
}

ad_proc -private layout::element::move {
    -page_id:required
    -element_id:required
    -direction:required
} {
    moves an element within a page
} {
    if {[string equal $direction up] || [string equal $direction down]} {
        move_vertically -element_id $element_id -direction $direction
    } elseif {[string equal $direction left] || [string equal $direction right]} {
        move_horizontally -element_id $element_id -direction $direction
    }
    layout::page::flush -page_id $page_id
}

ad_proc -private layout::element::move_vertically {
    -element_id:required
    -direction:required
} {
    swaps the element with either the previous or next one in the page_column,
    depending on the value of direction.
} {

    array set element [layout::element::get -element_id $element_id]
    template::util::array_to_vars element

    if {[string equal $direction up]} {
        if {![db_0or1row select_previous_element {}]} {
            return
        }
    } elseif {[string equal $direction down]} {
        if {![db_0or1row select_next_element {}]} {
            return
        }
    } else {
        ad_return_complaint 1 "layout::element::swap: bad direction: $direction"
    }

    db_transaction {
        # because of the uniqueness constraint on sort_keys we need to set
        # a dummy key, then do the swap.
        set dummy_sort_key -1

        # set the source element to the dummy key
        db_dml swap_sort_keys_1 {}

        # set the target's sort_key to the source's sort_key
        db_dml swap_sort_keys_2 {}

        # set the source's sort_key to the target's sort_key
        db_dml swap_sort_keys_3 {}
    }
    flush -element_id $element_id
    flush -element_id $other_element_id

}

ad_proc -private layout::element::move_horizontally {
    -element_id:required
    -direction:required
} {
    move a pageset element between page_columns
} {

    array set element [layout::element::get -element_id $element_id]
    template::util::array_to_vars element

    if {[string equal $direction left]} {
        incr page_column -1
    } elseif {[string equal $direction right]} {
        incr page_column 1
    }

    db_dml update_page_column {}
    flush -element_id $element_id

}

ad_proc -private layout::element::move_to_page {
    -element_id:required
    -page_id:required
    {-page_column ""}
} {
    move this element to another page
} {

    set from_page_id [layout::element::get_column_value -element_id $element_id -column page_id]
    set current_page_column $page_column
    if { $page_column eq "" } {
        set current_page_column \
            [layout::element::get_column_value -element_id $element_id -column page_column]
    }

    set target_n_page_columns [layout::page_template::get_column_value -column columns \
        -name [layout::page::get_column_value -page_id $page_id -column page_template]
    ]

    if {$current_page_column > $target_n_page_columns} {
        set page_column $target_n_page_columns
    } else {
        set page_column $current_page_column
    }

    db_dml update_element {}
    flush -element_id $element_id
    layout::page::flush -page_id $from_page_id
    layout::page::flush -page_id $page_id

}

ad_proc layout::element::choose_page_column {
    -page_id:required
} {
    select the page_column on the page with the fewest elements on it
} {
    set min_count 99999
    set min_page_column 0

    set page_template [layout::page::get_column_value -page_id $page_id -column page_template]
    set page_columns [layout::page_template::get_column_value -name $page_template -column columns]

    for { set page_column 1 } { $page_column <= $page_columns } { incr page_column } {
        set count [db_string select_page_column_count {}]
        if {$count < $min_count} {
            set min_count $count
            set min_page_column $page_column
        }
    }

    return $min_page_column
}

ad_proc -private layout::element::get_render_data {
    -element_id:required
} {
    Return all the good stuff a render template needs to render an element.

    @element_id The element in question
    @decorate_p If true decorate the element with the layout manager theme.

} {

    # Everything we call here caches their database queries, so we won't do any
    # caching of our own.  This (trust me) simplified the cache coherency problem.

    array set element [layout::element::get -element_id $element_id]
    array set page [layout::page::get -page_id $element(page_id)]
    array set pageset [layout::pageset::get -pageset_id $page(pageset_id)]

    # If the element has no custom theme assigned to it, inherit the
    # default theme from the page or page set that owns this element.

    if { $element(theme) eq "" } {
        set element(theme) $page(theme)
        if { $element(theme) eq "" } {
            set element(theme) $pageset(theme)
        }
    }

    array set theme [layout::theme::get -name $element(theme)]
    set element(theme_template) $theme(template)

    set config [list \
        element_id $element_id \
        package_id $element(package_id)
    ] 
 
    set config [concat $config [layout::element::parameter::get_all -element_id $element_id]]

    array set includelet [layout::includelet::get -name $element(includelet_name)]

    # Kludge to allow portlet templates to live in the package's lib directory
    # while remaining compatible with the existing .LRN portlet structure which has
    # them in www.  If you're porting an old portlet and are too lazy to move
    # it to lib, specify the full path when you declare your portlet.

    if { [string match /* $includelet(template)] } {
        set element(template_path) "$includelet(template)"
    } else {
        set element(template_path) "/packages/$includelet(owner)/lib/$includelet(template)"
    }
    set element(dotlrn_compat_p) $includelet(dotlrn_compat_p)

    set element(config) $config

    return [array get element]

}

ad_proc layout::element::copy {
    -element_id:required
    {-page_name ""}
    {-page_column ""}
    {-state full}
} {
    Make a copy of an existing element, including its parameters.

    @param element_id The existing element to copy from.
    @param page_name The name of the page to place the copy on.
    @param page_column The column in which to place the copy.
    @return The element_id of the new copy of the element.
} {
    set page_id [layout::element::get_column_value -element_id $element_id -column page_id]

    if { $page_column eq "" } {
            set page_column [layout::element::choose_page_column -page_id $page_id]
    }

    set new_element_id [db_nextval layout_seq]

    db_transaction {
        db_dml copy_element {}
        db_dml copy_element_parameters {}
    }

    return $new_element_id
}

ad_proc layout::element::configure {
    -element_id:required
    -op:required
    -return_url:required
} {
    dispatch on the element_id and op requested
} {

    set state [layout::element::get_column_value -element_id $element_id -column state]

    switch $op {
        shade {
            if {[string equal $state shaded]} {
                set new_state full
            } else {
                set new_state shaded
            }
        }
        hide {
            if {[string equal $state hidden]} {
                set new_state full
            } else {
                set new_state hidden
            }
        }
    }

    layout::element::set_column_value -element_id $element_id -column state -value $new_state
    ad_returnredirect $return_url

}

ad_proc layout::element::flush {
    -element_id:required
} {
    Flush all cache entries built for element_id
} {
    db_flush_cache -cache_key_pattern element_${element_id}_*
}
