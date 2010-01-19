<?xml version="1.0"?>

<queryset>
  <rdbms><type>postgresql</type><version>7.2</version></rdbms>

  <fullquery name="layout_manager::install::after_upgrade.add_url_name_nn">
    <querytext>
      alter table layout_pages alter url_name set not null
    </querytext>
  </fullquery>

</queryset>
