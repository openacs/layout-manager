ad_page_contract {

    Configure a portal page column

    @author Don Baccus (dhogaza@pacifier.com)

}

set return_url [ad_conn url]?[ad_conn query]

# queries need these as a bindvar ...
set page_id $page(page_id)
set pageset_id $page(pageset_id)

# See if there's a page before this one
if { $page(sort_key) > 0 } {
    db_1row select_prev_page_id {}
} else {
    set prev_page_id ""
}

# See if there's a page after this one (sort_key starts at zero)
if { $page(sort_key) + 1 < [layout::pageset::get_page_count -pageset_id $pageset_id] } {
    db_1row select_next_page_id {}
} else {
    set next_page_id ""
}

# Grab all the element information and compute the various motion options

set element_num 1
db_1row select_element_count {}
db_multirow -extend {edit_url hide_url up_url down_url left_url right_url} \
    elements select_elements {} {

    set edit_url [export_vars -base [ad_conn package_url]edit-element \
        {pageset_id element_id return_url}]

    set hide_url [export_vars -base [ad_conn package_url]pageset-configure-2 \
        {{op hide} pageset_id element_id page_id return_url}]

    # Set up the "move up" option if possible
    if { $element_num > 1} {
        set up_url \
            [export_vars -base [ad_conn package_url]pageset-configure-2 \
                {{op move_up} pageset_id element_id page_id return_url}]
    } elseif { ![string equal $prev_page_id ""] } {
        set up_url \
            [export_vars -base [ad_conn package_url]pageset-configure-2 \
                {{op move_to_page} pageset_id element_id {page_id $prev_page_id} return_url}]
    }

    # Set up the "move down" option if possible
    if { $element_num < $element_count } {
        set down_url \
            [export_vars -base [ad_conn package_url]pageset-configure-2 \
                {{op move_down} pageset_id element_id page_id return_url}]
    } elseif { ![string equal $next_page_id ""] } {
        set down_url \
            [export_vars -base [ad_conn package_url]pageset-configure-2 \
                {{op move_to_page} pageset_id element_id {page_id $next_page_id} return_url}]
    }

    # If there's more than one column, let the user move the portlet to the right or left
    if { $column_count > 1 } {

        # if there's space to the right, let them move the portlet right
        if { $page_column < $column_count } {
            set right_url \
                [export_vars -base [ad_conn package_url]pageset-configure-2 \
                    {{op move_right} pageset_id page_id element_id page_column return_url}]
        }

        # If there's space to the left, let them move the portlet left 
        if { $page_column > 1 } {
            set left_url \
                [export_vars -base [ad_conn package_url]pageset-configure-2 \
                    {{op move_left} pageset_id page_id element_id page_column return_url}]
        }
    }

    incr element_num
}
