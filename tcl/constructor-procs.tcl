ad_library {

    Constructors for standard datasources. 

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2008-07-12
    @version $Id$

}

namespace eval layout::datasource::constructor {}

ad_proc layout::datasource::constructor::closest_ancestor {
    package_key
    node_id
} {
    Returns the package_id of the closest ancestor instance of package_key, including
    the current package as an ancestor.
} {
    return [site_node::closest_ancestor_package \
               -node_id $node_id \
               -package_key $package_key \
               -include_self]
}
