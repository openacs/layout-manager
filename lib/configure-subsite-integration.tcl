ad_page_contract {
    Configure the portal package's interaction with the subsite package in the 'ole
    look and feel department.
} {
}

ad_form -name configure-subsite-integration -form {
    {template_style:integer(radio)
        {options {{"Tabbed navigation integrated with existing subsite theme" 0}
                  {"Use existing subsite theme (works best if there's only one portal page)" 1}}}
        {values {0}}
        {label "Choose navigation style?"}
    }
    {portal_index_page_p:boolean(radio)
        {options {{Yes 1} {No 0}}}
        {values {1}}
        {label "Should the parent subsite serve the portal package as its index page?"}
    }
    {show_single_button_navbar_p:boolean(radio)
        {options {{Yes 1} {No 0}}}
        {values {0}}
        {label "Should we show the navigation tabs when there's only one of them?"}
    }
} -on_submit {

    switch $template_style {

        0 {parameter::set_value \
               -parameter OldDefaultMaster \
               -package_id [ad_conn package_id] \
               -value [parameter::get -package_id [ad_conn subsite_id] \
                          -parameter DefaultMasterTemplate]
           parameter::set_value \
               -parameter DefaultMaster \
               -package_id [ad_conn subsite_id] \
               -value /packages/layout-manager/lib/tabbed-master
        }

        2 {parameter::set_value \
             -parameter OurMasterTemplate \
             -package_id [ad_conn package_id] \
             ""
        }

    }

    if { $portal_index_page_p } {
        parameter::set_value \
            -parameter IndexRedirectUrl \
            -package_id [ad_conn subsite_id] \
            -value [ad_conn package_url]
    }

    parameter::set_value \
        -parameter ShowSingleButtonNavbar \
        -package_id [ad_conn package_id] \
        -value $show_single_button_navbar_p

    template::wizard::forward
}

template::wizard::submit configure-subsite-integration -buttons {back next}
