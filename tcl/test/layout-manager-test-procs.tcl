ad_library {
    Tests for the layout manager
}

# More element-procs tests
# Add theme-procs tests
# Add element-parameters-procs tests
# Add layout-procs tests

# We iterate through tests in an attempt to catch caching problems

aa_register_case -cats {api smoke} themes {
    Test the themes API
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {

            for { set i 1 } { $i <= 3 } { incr i } {
                layout::theme::new \
                    -name fake_theme \
                    -description "Fake Theme" \
                    -template fake_theme
                aa_log "Pass $i: new"
        
                layout::theme::delete -name fake_theme
                aa_log "Pass $i: delete"
        
                aa_log_result pass "pass $i: theme tests ran without failure"
            }
        }
}

aa_register_case -cats {api smoke} datasources {
    Test the includelets API
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
            for { set i 1 } { $i <= 3 } { incr i } {
                layout::datasource::new \
                    -name fake_datasource \
                    -description "Fake datasource" \
                    -package_key layout-manager
                aa_log "Pass $i: new"
                layout::datasource::delete \
                    -name fake_datasource
                aa_log "Pass $i: delete"
            }
    }
}

aa_register_case -cats {api smoke} includelets {
    Test the includelets API
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {

            for { set i 1 } { $i <= 3 } { incr i } {
                layout::datasource::new \
                    -name fake_datasource \
                    -description "Fake datasource" \
                    -package_key layout-manager
                layout::includelet::new \
                    -name fake_includelet \
                    -description "Fake Includelet" \
                    -title "Fake Includelet" \
                    -datasource fake_datasource \
                    -template fake 
                aa_log "Pass $i: new"
        
                layout::includelet::delete -name fake_includelet
                aa_log "Pass $i: delete"
                layout::datasource::delete \
                    -name fake_datasource
        
                aa_log_result pass "pass $i: includelet tests ran without failure"
            }
        }
}

aa_register_case -cats {api smoke} pagesets {
    Test the page sets API
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {

            for { set i 1 } { $i <= 3 } { incr i } {
                set pageset_id \
                    [layout::pageset::new -package_id [ad_conn package_id] -name Untitled -owner_id 0]
                aa_true "Pass $i: new" [exists_and_not_null pageset_id]
    
                array set t [layout::pageset::get -pageset_id $pageset_id]
                aa_true "Pass $i: get" { $t(pageset_id) ne "" }
    
                set get_pageset_id [layout::pageset::get_pageset_id \
                                       -package_id [ad_conn package_id] -owner_id 0]
                aa_equals "Pass $i: get_pageset_id" $pageset_id $get_pageset_id
    
                set name [layout::pageset::get_column_value -pageset_id $pageset_id -column name]
                aa_equals "Pass $i: get name" $name Untitled
    
                layout::pageset::set_column_value \
                    -pageset_id $pageset_id \
                    -column name \
                    -value Titled
                aa_equals "Pass $i: set name (and therefore set_values)" \
                    [layout::pageset::get_column_value -pageset_id $pageset_id -column name] Titled
    
                layout::pageset::delete -pageset_id $pageset_id
                aa_log "Pass $i: delete"
            }
        }
}

aa_register_case -cats {api smoke} pages {
    Test the pages API
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {

            for { set i 1 } { $i <= 3 } { incr i } {
                set pageset_id [layout::pageset::new -package_id [ad_conn package_id] -owner_id 0]
                set page_id [layout::page::new -pageset_id $pageset_id \
                                -name test -page_template 2_column]
                aa_true "Pass $i: new" [exists_and_not_null page_id]
    
                array set t [layout::page::get -page_id $page_id]
                aa_true "Pass $i: get" { $t(page_id) ne "" }
    
                aa_equals "Pass $i: get name" \
                    [layout::page::get_column_value -page_id $page_id -column name] test
    
                layout::page::set_column_value \
                    -page_id $page_id \
                    -column name \
                    -value tested
                aa_equals "Pass $i: set name (and therefore set_values)" \
                    [layout::page::get_column_value -page_id $page_id -column name] tested
    
                aa_equals "Pass $i: get page template name" \
                    [layout::page::get_column_value -page_id $page_id -column page_template] \
                    2_column
    
                aa_equals "Pass $i: get_pageset_id" \
                    [layout::page::get_column_value -page_id $page_id -column pageset_id] $pageset_id
    
                array set page [layout::page::get_render_data -page_id $page_id]
                aa_true "Pass $i: get_render_data" \
                    {$page(element_list) eq "" &&
                     $page(template) ne ""}
    
                layout::page::delete -page_id $page_id
                layout::pageset::delete -pageset_id $pageset_id
                aa_log "Pass $i: delete"
            }
        }
}

aa_register_case -cats {api smoke} elements {
    Test the elements API
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
            for { set i 1 } { $i <= 3 } { incr i } {
                set pageset_id [layout::pageset::new -package_id [ad_conn package_id] -owner_id 0]
                set page_id [layout::page::new -pageset_id $pageset_id \
                                -name test -page_template 2_column]
                set element_id [layout::element::new -pageset_id $pageset_id \
                                -package_id [ad_conn package_id] \
                                -page_name test -includelet_name subsites_includelet \
                                -name test -title Test]
                aa_true "Pass $i: new" [exists_and_not_null element_id]

                aa_equals "Pass $i: get name" \
                    [layout::element::get_column_value -element_id $element_id -column name] test

                aa_equals "Pass $i: get title" \
                    [layout::element::get_column_value -element_id $element_id -column title] Test

                aa_true "Pass $i: get page column" \
                    { [layout::element::get_column_value -element_id $element_id -column page_column] > 0 }

                layout::element::set_column_value \
                    -element_id $element_id \
                    -column name \
                    -value tested 
                aa_equals "Pass $i: set name (and therefore set_values)" \
                    [layout::element::get_column_value -element_id $element_id -column name] tested

                array set element [layout::element::get_render_data -element_id $element_id]
                aa_true "Pass $i: get_render_data" \
                    { $element(template_path) ne "" && 
                      $element(state) eq "full" && $element(page_id) ne "" &&
                      $element(includelet_name) eq "subsites_includelet" &&
                      [llength $element(config)] == 4 && $element(element_id) ne "" &&
                      $element(theme_template) ne "" && $element(sort_key) == 1 &&
                      $element(name) eq "tested" && $element(page_column) == 1 &&
                      $element(title) eq "Test" && $element(theme) eq "default" &&
                      $element(required_privilege) eq "read" }

                layout::element::delete -element_id $element_id
                layout::page::delete -page_id $page_id
                layout::pageset::delete -pageset_id $pageset_id
                aa_log "Pass $i: delete"
            }
        }
}

aa_register_case -cats {api smoke} element_parameters {
    Test the element parameterss API
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
            for { set i 1 } { $i <= 3 } { incr i } {
                set pageset_id [layout::pageset::new -package_id [ad_conn package_id] -owner_id 0]
                set page_id [layout::page::new -pageset_id $pageset_id \
                                -name test -page_template 2_column]
                set element_id [layout::element::new -pageset_id $pageset_id \
                                -package_id [ad_conn package_id] \
                                -page_name test -includelet_name subsites_includelet \
                                -name test -title Test]
                layout::element::parameter::add_values \
                    -element_id $element_id \
                    -parameters {p1 v1 p2 v2}

                aa_equals "Pass $i: get p1" \
                    [layout::element::parameter::get -element_id $element_id -key p1] v1

                aa_equals "Pass $i: get p2" \
                    [layout::element::parameter::get -element_id $element_id -key p2] v2

                layout::element::parameter::add_values \
                    -element_id $element_id \
                    -parameters {p2 vv2}
                aa_true "Pass $i: get p2 p2" \
                    { [llength [layout::element::parameter::get -element_id $element_id -key p2]] == 2 }

                layout::element::parameter::delete \
                    -element_id $element_id \
                    -key p2 \
                    -value v2
                aa_equals "Pass $i: delete p2 v2" \
                    [layout::element::parameter::get -element_id $element_id -key p2] vv2

                layout::element::parameter::add_values \
                    -element_id $element_id \
                    -parameters {p2 vv2}
                layout::element::parameter::set_values \
                    -element_id $element_id \
                    -parameters {p2 v2}
                aa_equals "Pass $i: /new/setvalues/get p2" \
                    [layout::element::parameter::get -element_id $element_id -key p2] v2

                  
                layout::element::parameter::delete \
                    -element_id $element_id \
                    -key p1
                layout::element::parameter::delete \
                    -element_id $element_id \
                    -key p2
                layout::element::delete -element_id $element_id
                layout::page::delete -page_id $page_id
                layout::pageset::delete -pageset_id $pageset_id
                aa_log "Pass $i: delete"
            }
        }
}
