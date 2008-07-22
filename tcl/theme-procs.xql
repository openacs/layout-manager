<?xml version="1.0"?>

<queryset>

  <fullquery name="layout::theme::new.insert_theme">
    <querytext>
      insert into layout_themes
        (name, description, template)
      values
        (:name, :description, :template)
    </querytext>
  </fullquery>

  <fullquery name="layout::theme::delete.delete_theme">
    <querytext>
      delete from layout_themes
      where name = :name
    </querytext>
  </fullquery>

  <fullquery name="layout::theme::get.select_theme">
    <querytext>
      select *
      from layout_themes
      where name = :name
    </querytext>
  </fullquery>

</queryset>
