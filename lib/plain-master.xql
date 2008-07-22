<?xml version="1.0"?>

<queryset>

  <fullquery name="select_user_portal_pages">
    <querytext>
      select name, sort_key as page_num, portal_id
      from portal_pages
      where portal_id = :user_portal_id
      order by sort_key
    </querytext>
  </fullquery>


  <fullquery name="select_admin_portal_pages">
    <querytext>
      select name, 0 as page_num, portal_id
      from portals
      where owner_id = :package_id
    </querytext>
  </fullquery>

</queryset>
