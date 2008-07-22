ad_library {

    Layout Manager Application Datasources

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2008-07-5
    @version $Id$

}

namespace eval layout::datasource {}
namespace eval layout::datasource::binding {}

ad_proc layout::datasource::new {
    -name:required
    {-description ""}
    {-package_key ""}
    {-constructor ""}
    {-destructor ""}
} {
    Create a new layout manager application binding..

    @param name The unique internal name of the new application binding.
    @param description A human-readable description (defaults to name)
    @param package_key The package to associate with client includelets
    @param constructor Custom constructor to run after the default constructor
    @param destructor Custom destructor to run before the default destructor

    @author Don Baccus (dhogaza@pacifier.com)
} {
    # Default datasource description to its name
    if { ![info exists description] } {
        set description $name
    }

    db_dml insert_datasource {}
}

ad_proc layout::datasource::get {
    -name:required
} {
    Return the datasource in "array get" format.
} {
    db_1row select_datasource {} -column_array datasource
    return [array get datasource]
}

ad_proc layout::datasource::get_column_value {
    -name:required
    -column:required
} {
    Return the value of one column for one row in the datasources table.
} {
    array set datasource [layout::datasource::get -name $name]
    return $datasource($column)
}

ad_proc layout::datasource::delete {
    -name:required
} {
    db_dml delete_datasource {}
}

ad_proc layout::datasource::construct {
    -name:required
    -node_id:required
    -package_key:required
} {
    set constructor [layout::datasource::get_column_value -name $name -column constructor]
    if { $constructor ne "" } {
        return [$constructor $package_key $node_id]
    } else {
        return ""
    }
}
