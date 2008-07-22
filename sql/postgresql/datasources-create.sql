-- create layout includelet
--
-- @author Don Baccus (dhogaza@pacifier.com)
-- @creation-date 2008-07-06
-- @version $Id$
--

-- ADD COMMENTS AND INDEXES!!!

create table layout_datasources (
    name                            text
                                    constraint l_ds_name_pk
                                    primary key,
    description                     text 
                                    constraint l_ds_description_nn
                                    not null,
    package_key                     text
                                    constraint l_ds_package_key_fk
                                    references apm_package_types(package_key),
    constructor                     text,
    destructor                      text
);
