<?xml version="1.0"?>

<queryset>

    <fullquery name="get_portal_count">
        <querytext>

           select count(*) as portal_count
           from portals
           where portal_id = :portal_id

        </querytext>
    </fullquery>

</queryset>
