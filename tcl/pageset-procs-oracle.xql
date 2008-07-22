<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="layout::pageset::delete.delete_pageset">
        <querytext>
            begin
                layout_pageset.del(p_pageset_id => :pageset_id);
            end;
        </querytext>
    </fullquery>

</queryset>
