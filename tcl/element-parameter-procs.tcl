ad_library {

    Page Set Element Parameter Procs

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2008-07-05
    @version $Id$

}

namespace eval layout::element::parameter {}

ad_proc layout::element::parameter::add_values {
    -element_id:required
    -parameters:required
} {
    Create new parameter values

    @param element_id The element to add the parameters to.
    @param parameters The parameter keys and values in array get format
} {
    foreach {key value} $parameters {
        db_dml insert_parameter {}
    }
    layout::element::flush -element_id $element_id
}

ad_proc -private layout::element::parameter::delete {
    -element_id:required
    -key:required
    -value
} {
    Removes a value for a parameter or all values for that parameter.

    @param element_id The element the parameter(s) belong to
    @param key The key of the parameter
    @param value If set, only delete keys with this value, if not, all parameters
           for the element with the given key.
} {
    if {[info exists value]} {
        db_dml delete_one_parameter_value {}
    } else {
        db_dml delete_parameter {}
    }
    layout::element::flush -element_id $element_id
}

ad_proc layout::element::parameter::get {
    -element_id:required
    -key:required
} {
    returns a list of values for this element/key combination
} {
    return [db_list select_parameters {}]
}

ad_proc layout::element::parameter::set_values {
    -element_id:required
    -parameters:required
} {
    Overwrite existing values of parameters with the given keys and element_id.
    Use with great care.

    @param element_id The element the parameter(s) belong to
    @param parameters The parameter keys and values in array get format

} {
    foreach {key value} $parameters {
        db_dml delete_parameter {}
        db_dml insert_parameter {}
    }
    layout::element::flush -element_id $element_id
}

ad_proc layout::element::parameter::get_all {
    -element_id:required
} {
    Return all parameters for element_id in "array get" format
} {
    db_foreach select_parameters {} {
        lappend parameters($key) $value
    }

    return [array get parameters]
}
