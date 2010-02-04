<?xml version="1.0"?>

<queryset>

  <fullquery name="layout_manager::install::after_upgrade.add_url_name">
    <querytext>
      alter table layout_pages add url_name varchar(100)
    </querytext>
  </fullquery>

  <fullquery name="layout_manager::install::after_upgrade.get_pages">
    <querytext>
      select page_id, name
      from layout_pages
    </querytext>
  </fullquery>

  <fullquery name="layout_manager::install::after_upgrade.update_url_name">
    <querytext>
      update layout_pages
      set url_name = :url_name
      where page_id = :page_id
    </querytext>
  </fullquery>

  <fullquery name="layout_manager::install::after_upgrade.add_unique_constraint">
    <querytext>
      alter table layout_pages
      add constraint l_pages_pageset_id_name_un
      unique (name, pageset_id)
    </querytext>
  </fullquery>

  <fullquery name="layout_manager::install::after_upgrade.add_unique_constraint_2">
    <querytext>
      alter table layout_pages
      add constraint l_pages_pageset_id_url_name_un
      unique (url_name, pageset_id)
    </querytext>
  </fullquery>

</queryset>
