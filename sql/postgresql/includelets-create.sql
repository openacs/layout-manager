-- create layout includelet
--
-- @author Don Baccus (dhogaza@pacifier.com)
-- @creation-date 2008-07-06
-- @version $Id$
--

create table layout_includelets (
    name                            text
                                    constraint l_includelets_name_pk
                                    primary key,
    title                           text default null,
    template                        text
                                    constraint l_includelets_template_nn
                                    not null,
    dotlrn_compat_p                 boolean
                                    constraint l_includelets_d_c_p_nn
                                    not null,
    constructor                     text,
    destructor                      text,
    description                     text,
    required_privilege              text default 'read',
    datasource                      text
                                    constraint l_includelets_ds_fk
                                    references layout_datasources(name)
                                    on delete cascade
                                    constraint l_includelets_ds_nn
                                    not null
);

-- indexes for referential integrity checking

create index l_includelets_datasource_idx on layout_includelets(datasource);

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

comment on column layout_includelets.datasource is '
    The package key of the datasource that this includelet works with.  For instance the
    forums layout includelet works with the forums package.
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
