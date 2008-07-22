# ad_form doesn't like an empty -form block so we've got to provide a dummy
# field ...

ad_form -name configure-help -form {
    foo:text(hidden),optional
} -on_submit {
    template::wizard::forward
}

template::wizard::submit configure-help -buttons {back next}
