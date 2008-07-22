ad_page_contract {
    Just a test script to display the pageset.

    @author AKS
    @creation-date 
    @cvs-id $Id$
} {
    {referer:notnull}
    {pageset_id:naturalnum,notnull}
    {page_num 0}
}

set name [layout::pageset::get_column_value -pageset_id $pageset_id -column name]
array set pageset [layout::pageset::get_render_data -pageset_id $pageset_id -page_num $page_num]

ad_return_template

