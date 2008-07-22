ad_page_contract {

    Generate a list of datasources that have supporting portlets.

    The user's returned to the current page after installing the select datasource(s).

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 
    @cvs-id $Id$

} { }

set package_id [ad_conn package_id]
if { ![info exists pageset_id] } {
    set pageset_id [layout::pageset::get_master_template_id -package_id $package_id]
}

if { ![info exists return_url] } {
    set return_url [ad_conn url]?[ad_conn query]
}

db_multirow -extend {add_url includelets instances} datasources get_datasources {} {
    set add_url [export_vars -base [ad_conn package_url]add-datasources-2 \
                    { pageset_id datasource return_url }]
    set includelets [join [db_list get_includelets {}] ", "]
    db_1row get_instance_count {}
}

set wizard_p [template::wizard::exists]

# If we're in the wizard and have no datasources or includelets just skip to the next step.

if { $wizard_p && ${datasources:rowcount} == 0 && ${includelets:rowcount} == 0 } {
    rp_form_put wizard_submit_next wizard_submit_next
    template::wizard::forward
}

# Build the list-builder list.

# First, build a list of datasources to add

template::list::create \
    -name datasources \
    -multirow datasources \
    -key datasource \
    -elements {
        description {
            label Datasource
        }
        instances {
            label Instances
        }
        includelets {
            label Includelets
        }
        add {
            label Add
            link_url_col add_url
            link_html { title "Add datasource" }
            display_template {Add}
        }
    }

# Now, if we're in the template wizard, generate the wizard form and buttons.
 
if { $wizard_p } {

    ad_form -name add-datasources -form {
        foo:text(hidden),optional
    } -on_submit {
        template::wizard::forward
    }

    template::wizard::submit add-datasources -buttons {back next}
}

ad_return_template
