<?xml version="1.0"?>

<queryset>

  <fullquery name="select_themes">
    <querytext>
      select theme_id, name || ' - ' || description as name
      from layout_themes
      order by name
    </querytext>
  </fullquery>

  <fullquery name="select_hidden_elements">
    <querytext>
      select element_id, pe.name
      from layout_elements pe, layout_pages pp
      where pp.pageset_id = :pageset_id
        and pp.page_id = pe.page_id
        and pe.state = 'hidden'
      order by pe.name
    </querytext>
  </fullquery>

  <fullquery name="select_page_ids">
    <querytext>
      select page_id
      from layout_pages
      where pageset_id = :pageset_id
      order by sort_key
    </querytext>
  </fullquery>

</queryset>
