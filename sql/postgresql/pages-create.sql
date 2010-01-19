-- create layout pages datamodel
--
-- @author Don Baccus (dhogaza@pacifier.com)
-- @creation-date 2008-07-05
-- @version $Id$
--

create table layout_pages (
    page_id                         integer
                                    constraint layout_pages_pk
                                    primary key,
    name                            text
                                    constraint l_pages_name_nn
                                    not null,
    url_name                        text
                                    constraint l_pages_url_name_nn
                                    not null,
    pageset_id                      integer
                                    constraint l_pages_pageset_id_fk
                                    references layout_pagesets (pageset_id)
                                    on delete cascade
                                    constraint l_pages_pageset_id_nn
                                    not null,
    page_template                   text
                                    constraint l_page_template_fk
                                    references layout_page_templates (name)
                                    constraint l_page_template_nn
                                    not null,
    theme                           text
                                    constraint l_page_theme_fk
                                    references layout_themes (name),
    sort_key                        integer
                                    constraint l_pages_sort_key_nn
                                    not null,
    constraint l_pages_pageset_id_sort_key_un
    unique (pageset_id, sort_key),
    constraint l_pages_pageset_id_name_un
    unique (url_name, name, pageset_id)
);

create index layout_pages_page_idx on layout_pages (pageset_id, page_id);

comment on table layout_pages is '
    layout pages are containers for portal elements. They can be thought of
    as the "tabs" of a page set.
';

comment on column layout_pages.page_template is '
    The name of the template to be used when rendering this page.
';

comment on column layout_pages.theme is '
    The default theme to use for elements on this page, if not null.
';

comment on column layout_pages.sort_key is '
    An ordering of the pages contained in the same page set starting from
    0 for the first page and increasing in an gapless integer sequence
';
