<?xml version="1.0"?>

<queryset>

  <fullquery name="get_datasources">
    <querytext>
      select name as datasource, description
      from layout_datasources
      order by description
    </querytext>
  </fullquery>

  <fullquery name="get_includelets">
    <querytext>
      select title as includelet, name
      from layout_includelets
      where datasource = :datasource
      order by name
    </querytext>
  </fullquery>

  <fullquery name="get_instance_count">
    <querytext>
      select count(distinct le.package_id) as instances
      from layout_elements le, layout_includelets li
      where li.datasource = :datasource
        and le.includelet_name = li.name
    </querytext>
  </fullquery>

</queryset>
