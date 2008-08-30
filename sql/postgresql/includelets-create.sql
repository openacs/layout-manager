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
    description                     text,
    template                        text
                                    constraint l_includelets_template_nn
                                    not null,
    dotlrn_compat_p                 boolean
                                    constraint l_includelets_d_c_p_nn
                                    not null,
    initializer                     text,
    uninitializer                   text,
    required_privilege              text default 'read',
    application                     text
                                    constraint l_includelets_app_fk
                                    references apm_package_types(package_key)
                                    on delete cascade
                                    constraint l_includelets_app_nn
                                    not null,
    internally_managed_p            boolean
                                    constraint l_includelets_i_m_p_nn
                                    not null,
    singleton_p                     boolean
                                    default 't'
                                    constraint l_includelets_s_p_nn
                                    not null
);

-- indexes for referential integrity checking

create index l_includelets_application_idx on layout_includelets(application);

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
    forums includelet works with the forums package.
';

comment on column layout_includelets.template is '
    The name of template that displays the layout includelet content.
';

comment on column layout_includelets.dotlrn_compat_p is '
    If true, pass the includelet params in an array named "cf", rather than pass them
    directly.
';

comment on column layout_includelets.initializer is '
    The name of an optional initialization procedure to run when an element is created.
';

comment on column layout_includelets.uninitializer is '
    The name of an optional uninitialization procedure to run when an element is deleted.
';

comment on column layout_includelets.internally_managed_p is '
    If true, external application/includelet managers (like layout-subsite-integration) should
    ignore the existence of this includelet.  While this was added explicitly to port the
    rather quaint and eccentric xowiki portlet to the layout manager, which has its admin
    portlet create layout elements via a dynamically generated form in a very non-.LRN
    manner, it''s probably generally useful.
';

comment on column layout_includelets.singleton_p is '
    If true, only one instance of this includelet should be instantiated.
';
