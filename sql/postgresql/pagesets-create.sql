-- create layout manager page sets datamodel
--
-- @author Don Baccus (dhogaza@pacifier.com)
-- @creation-date 2008-07-05
-- @version $Id$

create table layout_pagesets (
    pageset_id                     integer
                                    constraint l_pageset_id_fk
                                    references acs_objects (object_id)
                                    on delete cascade
                                    constraint layout_pagesets_pk
                                    primary key,
    owner_id                        integer
                                    constraint l_owner_id_fk
                                    references acs_objects (object_id)
                                    constraint l_owner_id_nn
                                    not null,
    package_id                      integer
                                    constraint l_package_id_fk
                                    references apm_packages (package_id)
                                    on delete cascade
                                    constraint l_package_id_nn
                                    not null,
    name                            text
                                    default 'Untitled'
                                    constraint l_name_nn
                                    not null,
    theme                           name
                                    constraint l_theme_fk
                                    references layout_themes (name),
    template_id                     integer
                                    constraint l_template_id_fk
                                    references layout_pagesets (pageset_id)
);

create index layout_pagesets_owner_id_idx on layout_pagesets(owner_id);
create index layout_pagesets_package_id_idx on layout_pagesets(package_id);

comment on table layout_pagesets is '
    layout_pagesets are containers of one or more portal pages mapped to a party.
';

comment on column layout_pagesets.package_id is '
    The portal instance that ownns this portal
';

comment on column layout_pagesets.template_id is '
    A portal may have a template (another portal)
';

comment on column layout_pagesets.theme is '
    The default theme to use for pages in this page set, if not null.
';

select acs_object_type__create_type(
    'layout_pageset',
    'Layout Page Set',
    'Layout Page Sets',
    'acs_object',
    'LAYOUT_PAGESETS',
    'PAGESET_ID',
    'layout_pageset',
    'f',
    null,
    null
);


-- DRB template id needs to be implemented by copy pageset, which copies pages, which
-- copies elements, which copies element parameters ...

select define_function_args('layout_pageset__new', 'p_owner_id,p_package_id,p_name,p_theme,p_context_id');

create or replace function layout_pageset__new (integer, integer, varchar, varchar, integer)
returns integer as '
declare
    p_owner_id                     alias for $1;
    p_package_id                   alias for $2;
    p_name                         alias for $3;
    p_theme                        alias for $4;
    p_context_id                   alias for $5;
    v_pageset_id                   layout_pagesets.pageset_id%TYPE;
begin

    v_pageset_id := acs_object__new(
        null,
        ''layout_pageset'',
        null,
        p_owner_id,
        null,
        p_context_id
    );

    insert into layout_pagesets
      (pageset_id, owner_id, package_id, name, theme)
    values
      (v_pageset_id, p_owner_id, p_package_id, p_name, p_theme);

    return v_pageset_id;

end;' language 'plpgsql';

select define_function_args('layout_pageset__del', 'p_pageset_id');

create or replace function layout_pageset__del(integer)
returns void as '
declare
    p_pageset_id                    alias for $1;
begin
    delete from layout_pagesets
    where pageset_id = p_pageset_id;
    perform acs_object__delete(p_pageset_id);
end;' language 'plpgsql';
