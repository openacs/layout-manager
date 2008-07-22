<?xml version="1.0"?>

<queryset>

    <fullquery name="layout::page_template::::get_column_values.select_columns">
        <querytext>
            select columns
            from layout_page_templates
            where name = :name
        </querytext>
    </fullquery>

    <fullquery name="layout::page_template::::get_list.select_list">
        <querytext>
            select name, description
            from layout_page_templates
        </querytext>
    </fullquery>

</queryset>
