ad_library {

    Layout Manager Procs

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2008-07-05
    @version $Id$

}

namespace eval layout {}
       
ad_proc layout::package_id {} {
    Returns the package id of our instance (the closest ancestor which is a
    layout-manager instance or a package which extends it, i.e. layout-managed-subsite)
} {
    return [site_node::closest_ancestor_package \
               -include_self \
               -node_id [ad_conn node_id] \
               -package_key [concat layout-manager [apm_package_descendents layout-manager]]]
}
