ad_library {

    Implement custom layout manager template tags 

    @creation-date 2008-07-11
    @version $Id$

}

# Include an includelet, passing a reference parameter to an array get list as a
# list of parameters to the includelet.  This allows a general-purpose template which
# takes a set of parameters to be called directly as a layout manager includelet as
# well as by the normal <include src="script" param="value" param1="value1"> mechanism

# Usage: <includelet src="template" &="name_of_variable_set_to_array_get_list">

# Note: if you're not implementing the layout-manager's render-element template, you
# probably don't want to use this tag.

template_tag layout_includelet { params } {

    if { [ns_set size $params] > 2 } {
        error "LAYOUT_INCLUDELET tag has too many parameters"
    }

    set src [ns_set iget $params src]

    #Start developer support frame around subordinate template.
    if { [llength [info procs ::ds_enabled_p]] && [llength [info procs ::ds_adp_start_box]] } {
        ::ds_adp_start_box -stub "\[template::util::url_to_file \"$src\" \"\$__adp_stub\"\]"
    }

    set command "template::adp_parse"
    append command " \[template::util::url_to_file \"$src\" \"\$__adp_stub\"\]"

    # We accept one reference parameter along with the src parameter.  We'll pass the
    # runtime (NOT compile time) value of that parameter as the list of parameters to
    # the template.  This has the effect of transforming the layout manager's configuration
    # array (kept for backwards compatibility with .LRN portlets) into a set of parameters
    # (for compatibility with "normal" library templates).

    for { set i 0 } { $i < [ns_set size $params] } { incr i } {
        set key [ns_set key $params $i]
        if {$key eq "src"} {
            continue
        } elseif { $key ne "&" } {
            error "LAYOUT_INCLUDELET tag requires a src parameter and one reference parameter"
        }
        set __config [ns_set value $params $i]
        append command " \$$__config"
    }
    
    # Everything from here on down is poached from the include tag code.
    # We explicitly test for ad_script_abort, so we don't dump that as an error, and don't catch it, either
    # (We do catch it, but then we re-throw it)
    template::adp_append_code "if { \[catch { append __adp_output \[$command\] } errmsg\] } {"
    template::adp_append_code "    global errorInfo errorCode"
    template::adp_append_code "    if { \[string equal \[lindex \$errorCode 0\] \"AD\"\] && \[string equal \[lindex \$errorCode 1\] \"EXCEPTION\"\] && \[string equal \[lindex \$errorCode 2\] \"ad_script_abort\"\] } {"
    template::adp_append_code "        ad_script_abort"
    template::adp_append_code "    } else {"
    template::adp_append_code "        append __adp_output \"Error in include template \\\"\[template::util::url_to_file \"$src\" \"\$__adp_stub\"\]\\\": \$errmsg\""
    # JCD: If we have the ds_page_bits cache maybe save the error for later
    if { [llength [info procs ::ds_enabled_p]] && [llength [info procs ::ds_page_fragment_cache_enabled_p]] } {
        template::adp_append_code "        if {\[::ds_enabled_p\]"
        template::adp_append_code "            && \[::ds_collection_enabled_p\] } {"
        template::adp_append_code "            set __include_errors {}"
        template::adp_append_code "            ns_cache get ds_page_bits \[ad_conn request\]:error __include_errors"
        template::adp_append_code "            ns_cache set ds_page_bits \[ad_conn request\]:error \[lappend __include_errors \[list \"$src\" \$errorInfo\]\]"
        template::adp_append_code "        }"
    }
    template::adp_append_code "        ns_log Error \"Error in include template \\\"\[template::util::url_to_file \"$src\" \"\$__adp_stub\"\]\\\": \$errmsg\n\$errorInfo\""
    template::adp_append_code "    }"
    template::adp_append_code "}"

    #End developer support frame around subordinate template.
    if { [llength [info procs ::ds_enabled_p]] && [llength [info procs ::ds_adp_end_box]] } {
        ::ds_adp_end_box -stub "\[template::util::url_to_file \"$src\" \"\$__adp_stub\"\]"
    }

  }

