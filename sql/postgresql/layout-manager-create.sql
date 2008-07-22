-- create the layout manager datamodel
--
-- @author Don Baccus (dhogaza@pacifier.com)
-- @creation-date 2001-10-01
-- @version $Id$
--

create sequence layout_seq;

\i datasources-create.sql
\i includelets-create.sql
\i page-templates-create.sql
\i themes-create.sql
\i pagesets-create.sql
\i pages-create.sql
\i elements-create.sql
