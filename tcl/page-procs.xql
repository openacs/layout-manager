<?xml version="1.0"?>

<queryset>

  <fullquery name="layout::page::new.insert_page">
    <querytext>
    insert into layout_pages
      (page_id, name, pageset_id, page_template, sort_key)
    select :page_id, :name, :pageset_id, :page_template,
      coalesce(max(sort_key) + 1, 0)
    from layout_pages
    where pageset_id = :pageset_id
    </querytext>
  </fullquery>

  <fullquery name="layout::page::delete.get_pages">
    <querytext>
      select page_id, sort_key
      from layout_pages
      where pageset_id = :pageset_id
        and sort_key > (select sort_key
                        from layout_pages
                        where page_id = :page_id)
      order by sort_key
    </querytext>
  </fullquery>

  <fullquery name="layout::page::delete.update_page">
    <querytext>
      update layout_pages
      set sort_key = :sort_key - 1
      where page_id = :update_page_id
    </querytext>
  </fullquery>

  <fullquery name="layout::page::delete.delete_page">
    <querytext>
      delete from layout_pages
      where page_id = :page_id
    </querytext>
  </fullquery>

  <fullquery name="layout::page::get.select_page">
    <querytext>
      select *
      from layout_pages
      where page_id = :page_id
    </querytext>
  </fullquery>

  <fullquery name="layout::page::set_values.update_page">
    <querytext>
      update layout_pages
      set name = :name,
        pageset_id = :pageset_id,
        page_template = :page_template,
        sort_key = :sort_key,
        theme = :theme
      where page_id = :page_id
    </querytext>
  </fullquery>

  <fullquery name="layout::page::has_visisble_elements.select_visible_elements">
    <querytext>
      select case when count(*) = 0 then 0 else 1 end
      from layout_elements
      where page_id = :page_id
      and state != 'hidden'
    </querytext>
  </fullquery>

  <fullquery name="layout::page::get_id.get_page_id_select">
    <querytext>
      select page_id
      from layout_pages
      where pageset_id = :pageset_id
        and sort_key = :sort_key
    </querytext>
  </fullquery>

  <fullquery name="layout::page::get_id.get_page_id_from_name">
    <querytext>
      select page_id
      from layout_pages
      where pageset_id = :pageset_id
        and name = :page_name
    </querytext>
  </fullquery>

  <fullquery name="layout::page::has_visible_elements.select_visible_elements_p">
    <querytext>
      select 1
      from dual
       where exists (select 1
                     from layout_elements
                     where page_id = :page_id
                       and state != 'hidden')
    </querytext>
  </fullquery>

  <fullquery name="layout::page::get_render_data.page_template_select">
    <querytext>
      select layout_page_templates.template
      from layout_page_templates
      where layout_page_templates.name = :page_template
    </querytext>
  </fullquery>

  <fullquery name="layout::page::get_render_data.element_select">
    <querytext>
      select le.element_id,
        le.page_column,
        le.sort_key
      from layout_elements le, layout_pages lp
      where lp.page_id = :page_id
        and le.page_id = lp.page_id
        and le.state != 'hidden'
        and exists (select 1
                    from acs_object_party_privilege_map
                    where object_id = le.package_id
                      and party_id = :user_id
                      and privilege = le.required_privilege)
      order by le.page_column, le.sort_key
    </querytext>
  </fullquery>

</queryset>
