namespace eval layout_manager {}
namespace eval layout_manager::install {}

ad_proc layout_manager::install::after_install {} {
    Package after installation callback proc
} {

    apm_source [acs_root_dir]/packages/layout-manager/tcl/includelet-procs.tcl
    apm_source [acs_root_dir]/packages/layout-manager/tcl/page-template-procs.tcl
    apm_source [acs_root_dir]/packages/layout-manager/tcl/theme-procs.tcl

    db_transaction {

        # Now define some default layouts.
    
        layout::page_template::new \
            -name 1_column \
            -description #layout-manager.simple_1column_layout_description# \
            -columns 1 \
            -template /packages/layout-manager/lib/page-templates/simple 
    
        layout::page_template::new \
            -name 2_column \
            -columns 2 \
            -description #layout-manager.simple_2column_layout_description# \
            -template /packages/layout-manager/lib/page-templates/simple
    
        layout::page_template::new \
            -name 3_column\
            -columns 3 \
            -description #layout-manager.simple_3column_layout_description# \
            -template /packages/layout-manager/lib/page-templates/simple 
    
        layout::page_template::new \
            -name thin_thick \
            -columns 2 \
            -description #layout-manager.left_sidebar_layout_description# \
            -template /packages/layout-manager/lib/page-templates/simple
    
        layout::page_template::new \
            -name thin_thick_thin \
            -columns 3 \
            -description #layout-manager.left_and_right_sidebar_layout_description# \
            -template /packages/layout-manager/lib/page-templates/simple 
    
        # And some themes
    
        layout::theme::new \
            -name default \
            -description "Default OpenACS Theme" \
            -template /packages/layout-manager/lib/themes/standard
    
        layout::theme::new \
            -name blank \
            -description "No Graphics" \
            -template /packages/layout-manager/lib/themes/blank
    }
}

ad_proc -private layout_manager::install::after_upgrade {
    {-from_version_name:required}
    {-to_version_name:required}
} {
    After upgrade callback for acs-subsite.
} {
    apm_upgrade_logic \
        -from_version_name $from_version_name \
        -to_version_name $to_version_name \
        -spec {
            1.1.0d1 1.1.0d2 {
                db_dml add_url_name {}
                db_foreach get_pages {} {
                    set url_name \
                        [util::name_to_path \
                            -name [lang::util::localize $name [lang::system::site_wide_locale]]]
                    db_dml update_url_name {}
                }
                db_dml add_url_name_nn {}
                db_dml add_unique_constraint {}
                db_dml add_unique_constraint_2 {}
            }
        }
}
