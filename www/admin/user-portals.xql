<?xml version="1.0"?>

<queryset>

    <fullquery name="get_portals">
        <querytext>
           select pageset_id, name
           from layout_pagesets
           where package_id = :package_id
             and template_id is not null
        </querytext>
    </fullquery>

</queryset>
