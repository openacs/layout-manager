<?xml version="1.0"?>

<queryset>

  <fullquery name="select_prev_page_id">
    <querytext>
        select page_id as prev_page_id
        from layout_pages
        where pageset_id = :pageset_id
          and sort_key = (select sort_key - 1
                          from layout_pages
                          where page_id = :page_id)
    </querytext>
  </fullquery>

  <fullquery name="select_next_page_id">
    <querytext>
        select page_id as next_page_id
        from layout_pages
        where pageset_id = :pageset_id
          and sort_key = (select sort_key + 1
                          from layout_pages
                          where page_id = :page_id)
    </querytext>
  </fullquery>

  <fullquery name="select_element_count">
    <querytext>
      select count(*) as element_count
      from layout_elements
      where page_id = :page_id
        and page_column = :page_column
        and state <> 'hidden'
    </querytext>
  </fullquery>

  <fullquery name="select_elements">
    <querytext>
      select element_id, name, title, sort_key, state
      from layout_elements
      where page_id = :page_id
        and page_column = :page_column
        and state <> 'hidden'
      order by sort_key
    </querytext>
  </fullquery>

</queryset>
