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
            -description "Three columns" \
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
    
        # Now define a couple of datasource apps and includelets
    
        layout::datasource::new \
            -name layout_manager_includelets \
            -description "Layout Manager Includelets" \
            -package_key layout-manager \
            -constructor layout::datasource::constructor::closest_ancestor
    
        layout::includelet::new \
            -name layout_manager_admin_includelet \
            -description "Layout Manager Administration" \
            -title "Layout Manager Administration" \
            -datasource layout_manager_includelets \
            -template /packages/layout-manager/lib/layout-manager-admin-includelet \
            -required_privilege admin
    
        layout::datasource::new \
            -name subsite_includelets \
            -description "Subsite Includelets" \
            -package_key acs-subsite \
            -constructor layout::datasource::constructor::closest_ancestor
    
        layout::includelet::new \
            -name subsites_includelet \
            -description "Display Subsites" \
            -title "Subsites" \
            -datasource subsite_includelets \
            -template /packages/acs-subsite/lib/subsites
    }
}
