-- drop the layout manager datamodel
--
-- @author Don Baccus (dhogaza@pacifier.com)

\i elements-drop.sql
\i pages-drop.sql
\i pagesets-drop.sql
\i themes-drop.sql
\i page-templates-drop.sql
\i includelets-drop.sql
\i datasources-drop.sql

drop sequence layout_seq;
