ad_page_contract {

    Main configuration page for the layout manager package.  Defines the configuration
    wizard and tracks state.

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 
    @cvs-id $Id$
} {
}

layout::pageset::initialize

# Now set up the wizard and off we go into configuration ecstasy!

template::wizard::create -action configure -name configure -params {} -steps {
    1 -label "Welcome to the Layout Manager Configuration Wizard" -url /packages/layout-manager/lib/configure-help
    2 -label "Configure Private Page Sets" -url /packages/layout-manager/lib/configure-private-pagesets
    3 -label "Configure User Control Over Appearance" -url /packages/layout-manager/lib/configure-configurability
    4 -label "Add Datasources" -url /packages/layout-manager/lib/add-datasources
    5 -label "Configure Master Page Set Layout" -url /packages/layout-manager/lib/pageset-configure
    6 -label "Configure Subsite Integration" -url /packages/layout-manager/lib/configure-subsite-integration
    100 -label "Congratulations! Configuration Is Complete" -url /packages/layout-manager/lib/configure-finish
}

template::wizard::get_current_step

# Beautify the context bar and title with the current wizard step's label.

array set current_info [array get wizard:${wizard:current_id}]]
set title $current_info(label)
set context [list $title]

ad_return_template
