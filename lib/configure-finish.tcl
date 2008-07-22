# ad_form doesn't like an empty -form block so we've got to provide a dummy
# field ...

ad_form -name configure-finish -form {
    foo:text(hidden),optional
} -on_submit {
    ad_returnredirect index
    ad_script_abort
}

template::wizard::submit configure-finish -buttons {finish}
