ad_page_contract {

    Configure a page set

    @author Don Baccus (dhogaza@pacifier.com)

} {
}

set return_url [ad_conn url]?[ad_conn query]
set package_url [ad_conn package_url]

# If we're called from the configuration wizard, pageset_id is not defined but we
# know we're configuting the master template.

if { ![info exists pageset_id] } {
    set pageset_id [layout::pageset::get_master_template_id]
}

set current_theme [layout::pageset::get_column_value -pageset_id $pageset_id -column theme]
set first_page_id [lindex [layout::pageset::get_page_list -pageset_id $pageset_id] 0]
db_multirow themes select_themes {}
db_multirow hidden_elements select_hidden_elements {}
db_multirow page_ids select_page_ids {}
set page_count [layout::pageset::get_page_count -pageset_id $pageset_id]
set new_page_num [expr {$page_count + 1}]

# Now, if we're in the template wizard, generate the wizard form and buttons.
 
set wizard_p [template::wizard::exists]
if { $wizard_p } {

    ad_form -name add-applications -form {
        foo:text(hidden),optional
    } -on_submit {
        template::wizard::forward
    }

    template::wizard::submit add-applications -buttons {back next}
}

ad_return_template
