?xml version="1.0"?>

<queryset>

  <fullquery name="layout::pageset::new.get_elements">
    <querytext>
      select ld.name, le.element_id
      from layout_includelets ld, layout_elements le, layout_pages lp
      where lp.pageset_id = :pageset_id
        and le.page_id = lp.page_id
        and ld.includelet_id = le.includelet_id
      </querytext>
  </fullquery>

  <fullquery name="layout::pageset::delete.delete_permissions">
    <querytext>
      delete from acs_permissions
      where object_id = :pageset_id
    </querytext>
  </fullquery>

  <fullquery name="layout::pageset::get.select_pageset_info">
    <querytext>
      select *
      from layout_pagesets
      where pageset_id = :pageset_id
    </querytext>
  </fullquery>

  <fullquery name="layout::pageset::get_pageset_id.select_pageset_id">
    <querytext>
      select pageset_id
       from layout_pagesets
        where owner_id = :owner_id
          and package_id = :package_id
      </querytext>
  </fullquery>

  <fullquery name="layout::pageset::get_user_pageset_id.select_user_name">
    <querytext>
      select first_names || ' ' || last_name as user_name
      from persons
      where person_id = :owner_id
    </querytext>
  </fullquery>

  <fullquery name="layout::pageset::set_values.update_pageset">
    <querytext>
      update layout_pagesets
      set name = :name,
        theme = :theme,
        template_id = :template_id
      where pageset_id = :pageset_id
    </querytext>
  </fullquery>

  <fullquery name="layout::pageset::get_render_data.pageset_select">
    <querytext>
      select layout_pagesets.name,
        layout_pagesets.pageset_id,
        layout_pagesets.theme,
        layout_pages.page_id
      from layout_pagesets, layout_pages
      where layout_pagesets.pageset_id = :pageset_id
        and layout_pages.sort_key = :page_num
        and layout_pages.pageset_id = :pageset_id
    </querytext>
  </fullquery>

  <fullquery name="layout::pageset::configure.pageset_and_page_info_select">
    <querytext>
      select layout_pagesets.name,
        layout_pagesets.pageset_id,
        layout_pageset_layouts.template,
        layout_pages.name as page_name,
        layout_pages.layout_id as layout_id
      from layout_pagesets, layout_page_templates, layout_pages
      where layout_pages.pageset_id = :pageset_id
        and layout_pages.page_id = :page_id
        and layout_pages.pageset_id = layout_pagesets.pageset_id
        and layout_pages.layout_id = pageset_layouts.layout_id
    </querytext>
  </fullquery>

  <fullquery name="layout::pageset::configure_dispatch.hide_update">
    <querytext>
      update layout_elements
      set state = 'hidden'
      where element_id = :element_id
    </querytext>
  </fullquery>

  <fullquery name="layout::pageset::configure_dispatch.revert_max_page_id_select">
    <querytext>
      select max(page_id)
      from layout_pages
      where pageset_id = :pageset_id
    </querytext>
  </fullquery>

  <fullquery name="layout::pageset::configure_dispatch.revert_min_page_id_select">
    <querytext>
      select min(page_id)
      from layout_pages
      where pageset_id = :pageset_id
    </querytext>
  </fullquery>

  <fullquery name="layout::pageset::configure_dispatch.revert_move_elements_for_del">
    <querytext>
      select element_id
      from layout_elements
      where page_id = :max_page_id
    </querytext>
  </fullquery>

  <fullquery name="layout::pageset::configure_dispatch.revert_get_source_page_info">
    <querytext>
      select name, layout_id, sort_key
      from layout_pages
      where page_id = :source_page_id
    </querytext>
  </fullquery>

  <fullquery name="layout::pageset::configure_dispatch.revert_get_target_page_id">
    <querytext>
      select page_id
      from layout_pages
      where pageset_id = :pageset_id
        and sort_key = :sort_key
    </querytext>
  </fullquery>

  <fullquery name="layout::pageset::configure_dispatch.revert_page_update">
    <querytext>
      update layout_pages
      set name = :name,
        layout_id = :layout_id
      where page_id = :target_page_id
    </querytext>
  </fullquery>

  <fullquery name="layout::pageset::configure_dispatch.revert_get_source_elements">
    <querytext>
      select layout_elements.page_column, layout_elements.sort_key, layout_elements.state,
        layout_includelets.includelet_id, layout_includelets.name,
        layout_elements.name as pretty_name
      from layout_elements, layout_includelets
      where layout_elements.page_id = :source_page_id
        and layout_elements.includelet_id = layout_includelets.includelet_id
    </querytext>
  </fullquery>

  <fullquery name="layout::pageset::configure_dispatch.revert_get_target_element">
    <querytext>
      select layout_pages.element_id
      from layout_elements, layout_pages
      where layout_pages.pageset_id = :pageset_id
        and layout_elements.page_id = layout_pages.page_id
        and layout_elements.includelet_id = :includelet_id
        and layout_elements.name = :name
    </querytext>
  </fullquery>

  <fullquery name="layout::pageset::configure_dispatch.revert_element_update">
    <querytext>
      update layout_elements
      set page_column = :page_column,
        sort_key = :sort_key,
        state = :state,
        page_id = :target_page_id
      where element_id = :target_element_id
    </querytext>
 </fullquery>

 <fullquery name="layout::pageset::get_master_template_id.get_master_template_id">
   <querytext>
     select pageset_id as master_template_id
     from layout_pagesets
     where package_id = :package_id
       and owner_id = 0
   </querytext>
 </fullquery>

 <fullquery name="layout::pageset::get_page_count.select_page_count">
   <querytext>
     select count(*)
     from layout_pages
     where pageset_id = :pageset_id
   </querytext>
 </fullquery>

 <fullquery name="layout::pageset::get_page_list.select_page_ids">
   <querytext>
     select page_id
     from layout_pages
     where pageset_id = :pageset_id
     order by sort_key
   </querytext>
 </fullquery>

 <fullquery name="layout::pageset::navbar.list_page_nums_select">
   <querytext>
     select name, sort_key as page_num
     from layout_pages
     where pageset_id = :pageset_id
     order by sort_key
   </querytext>
 </fullquery>

 <fullquery name="layout::pageset::get_theme.get_theme_select">
   <querytext>
     select theme
     from layout_pagesets
     where pageset_id = :pageset_id
   </querytext>
 </fullquery>

</queryset>
