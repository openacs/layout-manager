ad_library {

    Layout Manager Theme Procs

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2008-07-05
    @version $Id$

}

namespace eval layout::theme {}

# We make no provision for flushing cached theme queries at the
# present time because once defined, they never change.

ad_proc layout::theme::new {
    -name:required
    {-description ""}
    -template:required
} {
    Create a new layout theme, which is just a master template which surrounds its
    slave with a bit of decoration.

    @param name The name of the theme, which must be unique.
    @param description An optional description of the theme.
    @param template The path (/packages/...) of the template.
} {
    db_dml insert_theme {}
}

ad_proc layout::theme::delete {
    {-name:required}
} {
    db_dml delete_theme {}
    layout::theme::flush -name $name
}

ad_proc layout::theme::get {
    -name:required
} {
    ns_cache eval db_cache_pool theme_${name}_get {
        db_1row select_theme {} -column_array theme
        return [array get theme]
    }
}

ad_proc layout::theme::get_column_value {
    -name:required
    -column:required
} {
    array set theme [layout::theme::get -name $name]
    return $theme($column)
}

ad_proc layout::theme::flush {
    -name:required
} {
    Flush all cached data for this page set
} {
    db_flush_cache -cache_key_pattern theme_${name}_*
}
