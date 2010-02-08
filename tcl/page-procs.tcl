ad_library {

    layout page procs

    @creation-date 2008-07-05
    @version $Id$

}

namespace eval layout::page {}

ad_proc layout::page::unique_name {
    -name:required
    -pageset_id:required
    {-page_id -1}
} {
    Guarantee that name is unique in the given pageset.

    @param name Look for duplicates of this name
    @param pageset_id In this pageset
    @param page_id But ignore this page.  Default is a page_id that never exists
           (use this when creating a new page).
} {
    set try 2
    set original_name $name
    while { [db_0or1row try_name {}] } {
        set name "${original_name}($try)"
        incr try
    }
    return $name
}

ad_proc layout::page::unique_url_name {
    -url_name:required
    -pageset_id:required
    {-page_id -1}
} {
    Guarantee that url_name is unique in the given pageset.

    @param name Look for duplicates of this url_name
    @param pageset_id In this pageset
    @param page_id But ignore this page.  Default is a page_id that never exists
           (use this when creating a new page).
} {
    set try 2
    set original_name $url_name
    while { [db_0or1row try_url_name {}] } {
        set url_name "${original_name}-$try"
        incr try
    }
    return $url_name
}

ad_proc layout::page::new {
    -pageset_id:required
    -name:required
    {-url_name ""}
    {-page_template 2_column}
    {-theme ""}
} {
    Create a new page and associate it with the given page set.

    @param pageset_id The id of the page set the new page will be bound to.
    @param name The human-friendly page name.
    @param url_name The page name to use for navigation.  If blank, it will be automatically
           generated from the name.
    @param page_template The page template to use to render this page.
} {
    set page_id [db_nextval layout_seq]
    if { $url_name eq "" } {
        set url_name [util::name_to_path -name [lang::util::localize $name]]
    }

    set name [layout::page::unique_name -pageset_id $pageset_id -name $name]
    set url_name [layout::page::unique_url_name -pageset_id $pageset_id -url_name $url_name]

    db_dml insert_page {}
    layout::pageset::flush -pageset_id $pageset_id
    return $page_id
}

ad_proc layout::page::delete {
    -page_id:required
} {
    Delete a page.

    @param page_id The id of the page to delete.
} {
    set pageset_id [layout::page::get_column_value -page_id $page_id -column pageset_id]

    # Renumber pages that have a sort key greater than ours, then delete the page.
    db_transaction {
        set page_list [db_list_of_lists get_pages {}]
        db_dml delete_page {}
        foreach page $page_list {
            foreach {update_page_id sort_key} $page {}
            db_dml update_page {}
            layout::page::flush -page_id $update_page_id
        }
    }

    layout::pageset::flush -pageset_id $pageset_id
    layout::page::flush -page_id $page_id
}

ad_proc layout::page::clone {
    -page_id:required
    {-pageset_id ""}
    {-name ""}
    {-page_template ""}
    {-theme ""}
    {-sort_key ""}
} {
    Create a clone of an existing page and the elements it contains.  By default
    the new page will be appended to the existing page's pageset.

    @param page_id The id of the page to clone.
    @param pageset_id The id of the pageset to place the cloned page in.
    @param name The page name (used for navigation).
    @param page_template The page template to use to render this page.
    @param sort_key Where in the page order to put the page.
} {
    set new_page_id [db_nextval layout_seq]
    db_transaction {
        db_dml insert_page {}
        foreach element_id [layout::page::get_elements -page_id $page_id] {
            layout::element::clone -element_id $element_id -page_id $new_page_id
        }
    }
    layout::pageset::flush -pageset_id $pageset_id
    return $page_id
}

ad_proc -private layout::page::get_elements {
    -page_id:required
} {
    Return the elements bound to this page.

    @param page_id The id of the page
    @return A list of element_ids bound to the page
} {
    return [db_list -cache_key page_${page_id}_get_elements get_elements {}]
}

ad_proc -private layout::page::get {
    -page_id:required
} {
    Get the columns of a page in array get format.

    @param page_id The id of the page.
} {
    ns_cache eval db_cache_pool page_${page_id}_get {
        db_1row select_page {} -column_array page
        return [array get page]
    }
}

ad_proc layout::page::get_column_value {
    -page_id:required
    -column:required
} {
    Return the value of a particular column value for a page.

    @param page_id The id of the page.
} {
    array set page [layout::page::get -page_id $page_id]
    return $page($column)
}

ad_proc layout::page::set_values {
    -page:required
} {
    Set the fields of a layout page.

    @param page The new value of the page in array get format (including page_id).
} {
    array set page_array $page
    template::util::array_to_vars page_array

    db_dml update_page {}
    layout::page::flush -page_id $page_id
}

ad_proc layout::page::set_column_value {
    -page_id:required
    -column:required
    -value:required
} {
    Set the value of a single column within a page.

    @param page_id The id of the page.
} {
    array set page [layout::page::get -page_id $page_id]
    set page($column) $value

    layout::page::set_values -page [array get page]
}

ad_proc layout::page::get_id {
    -pageset_id:required
    {-page_name ""}
    {-sort_key 0}
} {
    Get the page_id given a pageset_id and a page name or sort_key. if no name is given
    the page with the given sort_key is returned.

    @param pageset_id The pageset we're interested in.
    @param page_name The name of the page we want.
    @param sort_key If page_name is blank, grab the page with the given sort_key.
} {
    if {![empty_string_p $page_name]} {
        set page_id [db_string get_page_id_from_name {} -default ""]
        if {[empty_string_p $page_id]} {
            # there is no page by that name in the pageset, return page 0
            return [layout::page::get_id -pageset_id $pageset_id]
        } else {
            return $page_id
        }
    } else {
        return [db_string get_page_id_select {}]
    }
}

ad_proc layout::page::first_page_p {
    -pageset_id:required
    -page_id:required
} {
    Check if the given page_id is the first page in the given pageset.

    @param pageset_id The id of the page set.
    @param page_id The id of the page within the page set.
    @return 1 If the page is the first page in the page set.
} {
    return [expr {$page_id == [layout::page::get_id -pageset_id $pageset_id -sort_key 0]}]
}

ad_proc -private layout::page::has_visible_elements {
    -page_id:required
} {
    Check if a page has any visible elements.

    @param page_id The id of the page to check.
    @return 1 If the page has at least one element that's visible.
} {
    return [db_string select_visible_elements_p {} -default 0]
}

ad_proc -private layout::page::get_render_data {
    -page_id:required
} {
    Get the data needed to render a page in array get format.

    @param page_id The id of the page to render.
    @return The value of the page entry augmented with template and a list of element_ids,
            all in array get format.
} {
    set user_id [ad_conn user_id]
    ns_cache eval db_cache_pool page_${page_id}_get_render_data_$user_id {
        array set page [layout::page::get -page_id $page_id]
        set page_template [layout::page::get_column_value -page_id $page_id -column page_template]
        db_1row page_template_select {}
        set page(template) $template

        db_foreach element_select {} -column_array entry {
            lappend element_ids($entry(page_column)) $entry(element_id)
        } if_no_rows {
            set element_ids {}
        }

        set page(element_list) [array get element_ids]
        return [array get page]
    }
}

ad_proc layout::page::adjust_element_columns {
    -page_id:required
    -columns:required
} {
    Adjust the elements on the page so that their column values are less than or equal
    two the columns parameters.  Used when the number of columns on a page is changed.

    @parame page_id The id of the page we're interested in.
    @params columns The number of columns on the page.
} {
    foreach element_id [layout::page::get_elements -page_id $page_id] {
        if { [layout::element::get_column_value -element_id $element_id -column page_column]
             > $columns } {
            layout::element::set_column_value \
                -element_id $element_id \
                -column page_column \
                -value $columns
        }
    }
}

ad_proc -private layout::page::flush {
    -page_id:required
} {
    Flushes all cached data for this page.

    @param page_id The id of the page to flush from the cache.
} {
    db_flush_cache -cache_key_pattern page_${page_id}_*
}

