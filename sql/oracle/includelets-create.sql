-- create layout includelet
--
-- @author Don Baccus (dhogaza@pacifier.com)
-- @creation-date 2008-07-06
-- @version $Id$
--

create table layout_includelets (
    name                            varchar(100)
                                    constraint l_includelets_name_pk
                                    primary key,
    title                           varchar(100) default null,
    application                     varchar(100)
                                    constraint l_includelets_application_fk
                                    references apm_package_types (package_key)
                                    on delete cascade
                                    constraint l_includelets_app_nn
                                    not null,
    owner                           varchar(100)
                                    constraint l_includelets_owner_fk
                                    references apm_package_types (package_key)
                                    on delete cascade
                                    constraint l_includelets_owner_nn
                                    not null,
    template                        varchar(100)
                                    constraint l_includelets_template_nn
                                    not null,
    dotlrn_compat_p                 char(1) not null
                                    constraint layout_includelets_d_c_p_ck
                                    check (dotlrn_compat_p in ('t', 'f')),
    constructor                     varchar(100),
    destructor                      varchar(100),
    description                     varchar(1000),
    required_privilege              varchar(20) default 'read'
);

-- indexes for referential integrity checking

create index l_includelets_application_idx on layout_includelets(application);
create index l_includelets_owner_idx on layout_includelets(owner);

comment on table layout_includelets is '
    A layout includelet is the package of code that generates the content of a layout
    element. By convention, a package named foo-layout-includelets creates includelets
    for the package foo.
';

comment on column layout_includelets.name is '
    The name of this layout includelet.  We can''t arbitrarily use layout_includelet_key
    because many lincludelet packages will support at least two includelets, one user
    includelet and one admin includelet.  Includelet names, like package keys, must be
    unique throughout a single OpenACS instance.
';

comment on column layout_includelets.title is '
    The external name or message resource of this layout includelet.  We can''t arbitrarily
    use portlet_key because many portlet packages will support at least two portlets, one
    user portlet and one admin portlet.
';

comment on column layout_includelets.application is '
    The package key of the application that this includelet works with.  For instance the
    forums layout includelet works with the forums package.
';

comment on column layout_includelets.owner is '
    The package key of the package that implements this includelet.
';

comment on column layout_includelets.template is '
    The name of template that displays the layout includelet content.  Note this is not a full
    path, layout templates go in the standard package template library directory.
';

comment on column layout_includelets.dotlrn_compat_p is '
    If true, pass the includelet params in an array named "cf", rather than pass them
    directly.
';

comment on column layout_includelets.constructor is '
    The name of an optional constructor to run after the default constructor.
';

comment on column layout_includelets.destructor is '
    The name of an optional constructor to run after the default destructor.
';
