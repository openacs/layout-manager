<?xml version="1.0"?>

<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

  <fullquery name="layout_manager::install::after_upgrade.add_url_name_nn">
    <querytext>
      alter table layout_pages modify column url_name not null
    </querytext>
  </fullquery>

</queryset>
