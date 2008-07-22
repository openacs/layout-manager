-- create layout manager page sets datamodel
--
-- @author Don Baccus (dhogaza@pacifier.com)
-- @creation-date 2008-07-05
-- @version $Id$

create table layout_pagesets (
    pageset_id                      integer
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
    name                            varchar(100)
                                    default 'Untitled'
                                    constraint l_name_nn
                                    not null,
    theme                           varchar(100)
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

begin
 acs_object_type.create_type (
   object_type => 'layout_pageset',
   pretty_name => 'Layout Page Set',
   pretty_plural => 'Layout Page Sets',
   table_name => 'layout_pagesets',
   id_column => 'pageset_id',
   package_name => 'layout_pageset'
 );

end;
/
show errors
