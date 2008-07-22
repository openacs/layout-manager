<?xml version="1.0"?>

<queryset>

  <fullquery name="select_page_templates">
    <querytext>
      select name, description
      from layout_page_templates
      order by description
    </querytext>
  </fullquery>

  <fullquery name="select_page_themes">
    <querytext>
      select name, description
      from layout_themes
      order by description
    </querytext>
  </fullquery>

</queryset>
