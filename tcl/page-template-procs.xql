<?xml version="1.0"?>

<queryset>

  <fullquery name="layout::page_template::new.insert_page_template">
    <querytext>
      insert into layout_page_templates
        (name, description, columns, template)
      values
        (:name, :description, :columns, :template)
    </querytext>
  </fullquery>

  <fullquery name="layout::page_template::delete.delete_page_template">
    <querytext>
      delete from layout_page_templates
      where name = :name
    </querytext>
  </fullquery>

  <fullquery name="layout::page_template::get.select_page_template">
    <querytext>
      select *
      from layout_page_templates
      where name = :name
    </querytext>
  </fullquery>

</queryset>
