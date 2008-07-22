<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.2</version></rdbms>

    <fullquery name="layout::pageset::delete.delete_pageset">
        <querytext>
            select layout_pageset__del(:pageset_id);
        </querytext>
    </fullquery>

</queryset>
