
create or replace package layout_pageset
as
    function new (
        p_owner_id                  in acs_objects.object_id%TYPE,
       	p_package_id                in apm_packages.package_id%TYPE,
        p_name                      in layout_pagesets.name%TYPE default 'Untitled',
        p_theme                     in layout_pagesets.theme%TYPE default null,
        p_template_id               in layout_pagesets.template_id%TYPE default null
    ) return layout_pagesets.pageset_id%TYPE;

    procedure del (
        p_pageset_id                 in layout_pagesets.pageset_id%TYPE
    );

end layout_pageset;
/
show errors

create or replace package body layout_pageset
as

    function new (
        p_owner_id                  in acs_objects.object_id%TYPE,
       	p_package_id                in apm_packages.package_id%TYPE,
        p_name                      in layout_pagesets.name%TYPE default 'Untitled',
        p_theme                     in layout_pagesets.theme%TYPE default null,
        p_template_id               in layout_pagesets.template_id%TYPE default null,
        p_context_id                in acs_objects.context_id%TYPE
    ) return layout_pagesets.pageset_id%TYPE
    is
        v_pageset_id                layout_pagesets.pageset_id%TYPE;
    begin

        v_pageset_id := acs_object.new(
            object_type => 'layout_pageset',
            context_type => p_context_id
        );

        insert into layout_pagesets
          (pageset_id, owner_id, package_id, name, theme)
        values
          (v_pageset_id, p_owner_id, p_package_id, p_name, p_theme);

        return v_pageset_id;

    end new;

    procedure del (
        p_pageset_id                 in layout_pagesets.pageset_id%TYPE
    )
    is
      v_page_id                      layout_pages.page_id%TYPE;
    begin
        delete from layout_pagesets
        where pageset_id = p_pageset_id;
        acs_object.del(p_pageset_id);
    end del;

end layout_pageset;
/
show errors

