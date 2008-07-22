ad_page_contract {
    Let the admin configure whether or not we should create a portal for every visitor.
} {
}

ad_form -name configure-private-pagesets -form {
    {CreatePrivatePageSets:boolean(radio)
        {label "Create a page set for every user?"}
        {options {{Yes 1} {No 0}}}
    }
} -on_request {
    set CreatePrivatePageSets [parameter::get -boolean -parameter CreatePrivatePageSets]
    ad_set_form_values CreatePrivatePageSets
} -on_submit {
    parameter::set_value -parameter CreatePrivatePageSets -value $CreatePrivatePageSets
    template::wizard::forward
}

template::wizard::submit configure-private-pagesets -buttons {back next}
