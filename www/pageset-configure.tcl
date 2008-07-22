ad_page_contract {

    Configure a portal

    @author Don Baccus (dhogaza@pacifier.com)

} {
    pageset_id:integer,notnull
}

permission::require_permission -object_id $pageset_id -privilege write

set title "Configure"
set context [list $title]
set return_url [ad_conn url]?[ad_conn query]

ad_return_template
