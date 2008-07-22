ad_page_contract {
    Let the admin configure whether or not to present shade and hide buttons on portlets.
} {
}

if { ![parameter::get -boolean -parameter CreatePrivatePortals] } {
    rp_form_put wizard_submit_next wizard_submit_next
    template::wizard::forward
}

ad_form -name configure-configurability -form {
    {ShowShadeButton:boolean(radio)
        {label "Show \"Shade\" button on portlet title bars?"}
        {options {{Yes 1} {No 0}}}
        {help_text "\"No\" will supress the display of \"shade\" widgets in portlet title bars"}
    }
    {ShowHideButton:boolean(radio)
        {label "Show \"Hide\" button on portlet title bars?"}
        {options {{Yes 1} {No 0}}}
        {help_text "\"No\" will supress the display of \"hide\" widgets in portlet title bars"}
    }
    {ThemeChangeable:boolean(radio)
        {label "Allow users to change the portlet decoration theme?"}
        {options {{Yes 1} {No 0}}}
        {help_text "\"Yes\" will allow the user to change the theme used to display their portal"}
    }
} -on_request {
    set ShowShadeButton [parameter::get -boolean -parameter ShowShadeButton]
    set ShowHideButton [parameter::get -boolean -parameter ShowHideButton]
    set ThemeChangeable [parameter::get -boolean -parameter ThemeChangeable]
    ad_set_form_values ShowShadeButton ShowHideButton
} -on_submit {
    parameter::set_value -parameter ShowShadeButton -value $ShowShadeButton
    parameter::set_value -parameter ShowHideButton -value $ShowHideButton
    parameter::set_value -parameter ThemeChangeable -value $ThemeChangeable
    template::wizard::forward
}

template::wizard::submit configure-configurability -buttons {back next}
