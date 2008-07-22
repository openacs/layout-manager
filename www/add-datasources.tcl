ad_page_contract {

    Generate a list of applications that have supporting includelets that have not
    yet been added to this portal package instance.

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 
    @cvs-id $Id$
} {
    pageset_id:notnull,integer
    return_url:notnull
}

permission::require_permission -object_id $pageset_id -privilege admin

set context [list "Add Applications"]

ad_return_template
