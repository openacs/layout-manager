-- drop layout pagesets datamodel
--
-- @author Don Baccus (dhogaza@pacifier)
-- @creation-date 2008-07-05
-- @version $Id$
--

begin
acs_rel_type.drop_type('layout_pageset');
end;
/
show errors

drop table layout_pagesets;
