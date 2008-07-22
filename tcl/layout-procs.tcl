ad_library {

    Layout Manager Procs

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2008-07-05
    @version $Id$

}

namespace eval layout {}
       
ad_proc layout::package_id {} {
    Returns our package_id.  Works with acs-subsite's internal redirect parameter.
} {
    if { [ad_conn package_key] eq "layout-manager" } {
        return [ad_conn package_id]
    } elseif { [ad_conn package_key] eq "acs-subsite" } {
        return [site_node::get_children \
                   -package_key layout-manager \
                   -node_id [ad_conn node_id] \
                   -element object_id]
    }
    return -code error "pageset::package_id called with package_key not acs-subsite or layout-manager"
}

ad_proc layout::mount_point {} {
    Caches the mount point
} {
    return [lindex [site_node::get_url_from_object_id -object_id [ad_conn package_id]] 0]
}
