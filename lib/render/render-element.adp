<master src="@element.theme_template@">
  <property name="title">@element.title;noquote@</property>
  <property name="element_id">@element.element_id;noquote@</property>

  <if @element.dotlrn_compat_p@>
    <include src="@element.template_path@" cf="@element.config@">
  </if>
  <else>
    <layout_includelet src="@element.template_path@" &="config">
  </else>
