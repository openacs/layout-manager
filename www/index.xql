<?xml version="1.0"?>

<queryset>

  <fullquery name="get_page_id">
    <querytext>
      select sort_key as page_num
      from layout_pages
      where url_name = :url_name
        and pageset_id = :pageset_id
    </querytext>
  </fullquery>

</queryset>
