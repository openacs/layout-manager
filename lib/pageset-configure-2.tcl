ad_page_contract {
    Do the actual moving/removing of the elements, or redirect to add.

    @author Don Baccus
    @creation-date 2/26/2004
    @cvs_id $Id$
} {
    pageset_id:integer,notnull
    page_id:integer,optional
    element_id:integer,optional
    theme:optional
    page_theme:optional
    page_template:optional
    name:notnull,optional
    op:notnull
    return_url:notnull
    {anchor ""}
}

permission::require_permission -object_id $pageset_id -privilege write

switch $op {

    move_up {
        layout::element::move \
            -page_id $page_id \
            -element_id $element_id \
            -direction up
    }

    move_down {
        layout::element::move \
            -page_id $page_id \
            -element_id $element_id \
            -direction down
    }

    move_left {
        layout::element::move \
            -page_id $page_id \
            -element_id $element_id \
            -direction left
    }

    move_right {
        layout::element::move \
            -page_id $page_id \
            -element_id $element_id \
            -direction right
    }

    show_here {
        db_transaction {
            layout::element::move_to_page \
                -page_id $page_id \
                -element_id $element_id \
                -page_column 1
            layout::element::set_column_value \
                -element_id $element_id \
                -column state \
                -value full
        }
    }

    move_to_page {
        layout::element::move_to_page \
            -page_id $page_id \
            -element_id $element_id \
            -page_column 1
    }

    hide {
        layout::element::set_column_value \
            -element_id $element_id \
            -column state \
            -value hidden
    }

    change_theme {
        layout::pageset::set_column_value \
            -pageset_id $pageset_id \
            -column theme \
            -value $theme
    }

    change_page_theme {
        layout::page::set_column_value \
            -page_id $page_id \
            -column theme \
            -value $page_theme
    }

    add_page {
        layout::page::new -pageset_id $pageset_id -name $name
    }

    remove_page {
        layout::page::delete -page_id $page_id
    }

    change_page_template {
        layout::page::adjust_element_columns \
            -page_id $page_id \
            -columns [layout::page_template::get_column_value \
                         -name $page_template \
                         -column columns]
        layout::page::set_column_value \
            -page_id $page_id \
            -column page_template \
            -value $page_template
    }

    rename_page {
        layout::page::set_column_value -page_id $page_id -column name -value $name
    }

    default {
        ad_return_complaint 1 "\"$op\" is not a valid operator for portal configuration"
    }
}

# Flush the world.

layout::pageset::flush -pageset_id $pageset_id
if { [exists_and_not_null page_id] } {
    layout::page::flush -page_id $page_id
}
if { [exists_and_not_null element_id] } {
    layout::element::flush -element_id $element_id
}

ad_returnredirect $return_url
