<if @master_template@ not nil>
 <master src="@master_template@">
</if>
<else>
 <master>
</else>

<property name="page_num">@page_num@</property>
<property name="pageset_id">@pageset_id@</property>

<include src="/packages/layout-manager/lib/render/render-pageset" &="pageset_id"
  &="page_num" &="edit_p">
