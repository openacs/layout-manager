-- create layout page templates datamodel
--
-- @author Don Baccus (dhogaza@pacifier.com)
-- @creation-date 2008-07-05
-- @version $Id$
--

create table layout_page_templates (
    name                            varchar(100)
                                    constraint l_page_templates_name_un
                                    unique
                                    constraint l_page_templates_name_nn
                                    not null,
    columns                         integer
                                    constraint l_page_templates_column_nn
                                    not null
                                    constraint l_page_templates_column_ck
                                    check (columns > 0),
    description                     varchar(250),
    template                        varchar(100)
);


comment on table layout_page_templates is '
    a layout page template is a template used to render a page built of zero or more
    elements.  Examples of page page templates are the three column simple, or two column
    "Thin Thick" templates.
';

comment on column layout_page_templates.template is '
    The path relative to layout/lib to the page template.
';
