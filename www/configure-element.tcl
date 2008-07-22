ad_page_contract {

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 1/12/2004
    @cvs_id $Id$
} {
    element_id:integer
    op:notnull
}

permission::require_permission \
    -party_id [ad_conn user_id] \
    -object_id [layout::page::get_pageset_id \
                   -page_id [portal::element::get_page_id -element_id $element_id]] \
    -privilege write

portal::element::configure \
    -element_id $element_id \
    -op $op \
    -return_url [get_referrer]
