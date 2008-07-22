<?xml version="1.0"?>

<queryset>

  <fullquery name="select_pageset_pages">
    <querytext>
      select lp.name as label, lp.sort_key as tabindex
      from layout_pages lp
      where lp.pageset_id = :pageset_id
        and exists (select 1
                    from layout_elements le
                    where le.page_id = lp.page_id
                      and exists (select 1
                                  from acs_object_party_privilege_map
                                  where object_id = le.package_id
                                    and party_id = :user_id
                                    and privilege = le.required_privilege))
      order by lp.sort_key
    </querytext>
  </fullquery>

</queryset>
