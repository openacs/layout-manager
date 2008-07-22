<?xml version="1.0"?>

<queryset>

  <fullquery name="layout::datasource::new.insert_datasource">
    <querytext>
      insert into layout_datasources
        (name, description, package_key, constructor, destructor)
      values
        (:name, :description, :package_key, :constructor, :destructor)
    </querytext>
  </fullquery>

  <fullquery name="layout::datasource::get.select_datasource">
    <querytext>
      select *
      from layout_datasources
      where name = :name
    </querytext>
  </fullquery>

  <fullquery name="layout::datasource::delete.delete_datasource">
    <querytext>
      delete from layout_datasources
      where name = :name
    </querytext>
  </fullquery>

</queryset>
