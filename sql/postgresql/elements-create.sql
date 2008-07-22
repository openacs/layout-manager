-- create layout manager elements datamodel
--
-- @author Don Baccus (dhogaza@pacifier.com)
-- @creation-date 2001-10-01
-- @version $Id$
--

create table layout_elements (
    element_id                      integer
                                    constraint layout_elements_pk
                                    primary key,
    includelet_name                 text
                                    constraint l_elements_includelet_name_fk
                                    references layout_includelets (name)
                                    on delete cascade
                                    constraint l_elements_includelet_name_nn
                                    not null,
    name                            text
                                    constraint l_elements_name_nn
                                    not null,
    title                           text default null,
    page_id                         integer
                                    constraint l_elements_page_id_fk
                                    references layout_pages
                                    on delete cascade
                                    constraint l_elements_page_id_nn
                                    not null,
    page_column                     integer
                                    constraint l_elements_column_nn
                                    not null,
    package_id                      integer
                                    constraint l_elements_package_Id_fk
                                    references apm_packages (package_id)
                                    on delete cascade
                                    constraint l_elements_package_Id_nn
                                    not null,
    theme                           text
                                    constraint l_elements_theme_fk
                                    references layout_themes (name),
    sort_key                        integer
                                    constraint l_elements_sort_key_nn
                                    not null,
    state                           text
                                    default 'full'
                                    constraint l_elements_state_ck
                                    check (state in ('full', 'shaded', 'hidden', 'pinned')),
    required_privilege              varchar(20) default 'read'
);

comment on table layout_elements is '
    The user-visible "box" on a layout page that displays the content of a includelet
';

comment on column layout_elements.includelet_name is '
    The name of the includelet to which this element is bound.
';

comment on column layout_elements.page_column is '
    The column to which this element has been assigned ("column" is a keyword in SQL)
';

comment on column layout_elements.sort_key is '
    An ordering of elements contained in the same column on a page starting from
    0 for the first element and increasing in a gapless integer sequence
';

comment on column layout_elements.theme is '
    Optional theme for this element.
';

comment on column layout_elements.state is '
    one of the set "full" (normal), "shaded" (title bar only), or "hidden" (not shown). 
';

create table layout_element_parameters (
    element_id                      integer
                                    constraint l_element_params_element_id_fk
                                    references layout_elements (element_id)
                                    on delete cascade
                                    constraint l_element_params_element_id_nn
                                    not null,
    key                             text
                                    constraint l_element_params_key_nn
                                    not null,
    value                           text
);

create index l_element_params_element_key_idx on layout_element_parameters (element_id, key);

comment on table layout_element_parameters is '
    Parameters for a given element. The data structure is that of a multiset (aka bag)
    where multiple entries with the same key are allowed.
';
