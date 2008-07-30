ad_page_contract {

    Render a layout element.

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date
    @cvs_id $Id$

}

array set element [layout::element::get_render_data -element_id $element_id]

set config $element(config)
