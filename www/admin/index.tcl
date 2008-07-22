#
#  Copyright (C) 2001, 2002 MIT
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

ad_page_contract {

    Main administration page for the layout manager package

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 
    @cvs-id $Id$
} { }

if { ![layout::pageset::initialized] } {
    ad_returnredirect configure
    ad_script_abort
}

set context [list Admin]

ad_return_template
