ad_library {

    Implement the layout-pageset, layout-page, layout-element install.xml tags.

    @creation-date 2008-12-04
    @author Don Baccus (dhogaza@pacifier.com)
    @cvs-id $Id$
}

namespace eval install {}
namespace eval install::xml {}
namespace eval install::xml::util {}
namespace eval install::xml::action {}
namespace eval install::xml::object_id {}

ad_proc -public install::xml::action::layout-element {
    {-page_id ""}
    node
} {
    Create a new element.  Either the caller or the XML node may specify the
    page_id.
} { 
    set id [apm_attribute_value -default "" $node id]
    set package_id [::install::xml::object_id::package $node]
    set page_id [apm_attribute_value -default $page_id $node page-id]
    set page_column [apm_attribute_value -default "" $node page_column]
    set state [apm_attribute_value -default full $node state]
    set includelet_name [apm_attribute_value -default "" $node includelet-name]
    set name [apm_attribute_value -default "" $node name]
    set title [apm_attribute_value -default "" $node title]
    set parameters [apm_attribute_value -default "" $node parameters]
    set initialize [apm_attribute_value -default "" $node initialize]
    set theme [apm_attribute_value -default "" $node theme]

    set cmd layout::element::new
    
    if { $initialize ne "" } {
        if { ![string is boolean $initialize] } {
            error "layout-element: non-boolean value given for the \"initialize\" attribute"
        }
        lappend cmd -initialize=[string is true $initialize]
    }

    foreach param {package_id page_id theme page_column state
                   includelet_name name title parameters theme} {
        lappend cmd -$param [set $param]
    }
    set element_id [eval $cmd]

    if {$id ne ""} {
        set ::install::xml::ids($id) $element_id
    }

    return {}
}

ad_proc -public install::xml::action::layout-page {
    {-pageset_id ""}
    node
} {
    Create a new page.  Either the caller or the XML node may specify the
    pageset_id.
} {

    set id [apm_attribute_value -default "" $node id]
    set pageset_id [apm_attribute_value -default $pageset_id $node pageset-id]
    set name [apm_required_attribute_value $node name]
    set theme [apm_attribute_value -default "" $node theme]
    set page_template [apm_attribute_value -default 2_column $node page-template]

    set cmd layout::page::new
    foreach param {pageset_id name url_name page_template} {
        lappend cmd -$param [set $param]
    }
    set page_id [eval $cmd]

    if {$id ne ""} {
        set ::install::xml::ids($id) $page_id
    }

    foreach element [xml_node_get_children_by_name $node layout-element] {
        install::xml::action::layout-element -page_id $page_id $element
    }
    return
}

ad_proc -public install::xml::action::layout-pageset { node } {
    Create a new pageset, bound to a given
} { 
    set id [apm_attribute_value -default "" $node id]
    set package_id [::install::xml::object_id::package $node]
    set owner_id [apm_required_attribute_value $node owner-id]
    set theme [apm_attribute_value -default default $node theme]
    set context_id [apm_attribute_value -default "" $node context-id]
    set owner_privileges [apm_attribute_value -default "" $node owner-privileges]
    set page_list [apm_attribute_value -default "" $node page-list]

    set cmd layout::pageset::new
    foreach param {package_id owner_id theme context_id owner_privileges page_list} {
        lappend cmd -$param [set $param]
    }
    set pageset_id [eval $cmd]

    if {$id ne ""} {
        set ::install::xml::ids($id) $pageset_id
    }

    foreach page [xml_node_get_children_by_name $node layout-page] {
        install::xml::action::layout-page -pageset_id $pageset_id $page
    }

    return {}
}
