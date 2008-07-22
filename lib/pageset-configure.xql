<?xml version="1.0"?>

<queryset>

    <fullquery name="select_themes">
        <querytext>
            select name, description
            from layout_themes
            order by name
        </querytext>
    </fullquery>

    <fullquery name="select_hidden_elements">
        <querytext>
            select le.element_id, le.title
            from layout_elements le, layout_pages lp
            where lp.pageset_id = :pageset_id
            and lp.page_id = le.page_id
            and le.state = 'hidden'
            order by le.name
        </querytext>
    </fullquery>

    <fullquery name="select_page_ids">
        <querytext>
            select page_id
            from layout_pages
            where pageset_id = :pageset_id
            order by sort_key
        </querytext>
    </fullquery>

</queryset>
