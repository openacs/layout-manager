--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- create portal pages package
--
-- @author <a href="mailto:arjun@openforce.net">arjun@openforce.net</a>
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @creation-date 2001-10-01
-- @version $Id$
--

create or replace package portal_page
as

    function new (
        p_page_id                   in portal_pages.page_id%TYPE default null,
        p_name                      in portal_pages.name%TYPE default 'Untitled Page',
        p_portal_id                 in portal_pages.portal_id%TYPE,
        p_layout_id                 in portal_pages.layout_id%TYPE default null,
        p_object_type               in acs_objects.object_type%TYPE default 'portal_page',
        p_creation_date             in acs_objects.creation_date%TYPE default sysdate,
        p_creation_user             in acs_objects.creation_user%TYPE default null,
        p_creation_ip               in acs_objects.creation_ip%TYPE default null,
        p_context_id                in acs_objects.context_id%TYPE default null
    ) return portal_pages.page_id%TYPE;

    procedure del (
        p_page_id                   in portal_pages.page_id%TYPE
    );

end portal_page;
/
show errors

create or replace package body portal_page
as

    function new (
        p_page_id                   in portal_pages.page_id%TYPE default null,
        p_name                      in portal_pages.name%TYPE default 'Untitled Page',
        p_portal_id                 in portal_pages.portal_id%TYPE,
        p_layout_id                 in portal_pages.layout_id%TYPE default null,
        p_object_type               in acs_objects.object_type%TYPE default 'portal_page',
        p_creation_date             in acs_objects.creation_date%TYPE default sysdate,
        p_creation_user             in acs_objects.creation_user%TYPE default null,
        p_creation_ip               in acs_objects.creation_ip%TYPE default null,
        p_context_id                in acs_objects.context_id%TYPE default null
    ) return portal_pages.page_id%TYPE
    is
        v_page_id                   portal_pages.page_id%TYPE;
        v_layout_id                 portal_pages.layout_id%TYPE;
        v_sort_key                  portal_pages.sort_key%TYPE;
    begin

        v_page_id := acs_object.new(
            object_id => p_page_id,
            object_type => p_object_type,
            creation_date => p_creation_date,
            creation_user => p_creation_user,
            creation_ip => p_creation_ip,
            context_id => nvl(p_context_id, p_portal_id)
        );

        if p_layout_id is null then
            select min(layout_id)
            into v_layout_id
            from portal_layouts;
        else
            v_layout_id := p_layout_id;
        end if;

        select nvl(max(sort_key) + 1, 0)
        into v_sort_key
        from portal_pages
        where portal_id = p_portal_id;

        insert into portal_pages
        (page_id, name, portal_id, layout_id, sort_key)
        values
        (v_page_id, p_name, p_portal_id, v_layout_id, v_sort_key);

        return v_page_id;

    end new;

    procedure del (
        p_page_id                   in portal_pages.page_id%TYPE
    )
    is
        v_portal_id                 portal_pages.portal_id%TYPE;
        v_sort_key                  portal_pages.sort_key%TYPE;
        v_curr_sort_key             portal_pages.sort_key%TYPE;
        v_page_count_from_0         integer;
    begin

        -- IMPORTANT: sort keys MUST be an unbroken sequence from 0 to max(sort_key)

        select portal_id, sort_key
        into v_portal_id, v_sort_key
        from portal_pages
        where page_id = p_page_id;

        select (count(*) - 1)
        into v_page_count_from_0
        from portal_pages
        where portal_id = v_portal_id;

        for i in 0 .. v_page_count_from_0 loop

            if i = v_sort_key then

                delete
                from portal_pages
                where page_id = p_page_id;

            elsif i > v_sort_key then

                update portal_pages
                set sort_key = -1
                where sort_key = i;

                update portal_pages
                set sort_key = i - 1
                where sort_key = -1;

            end if;

        end loop;

        acs_object.del(p_page_id);

    end del;

end portal_page;
/
show errors

