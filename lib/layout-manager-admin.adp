<ul>
  <li><a href="@configure_url@">Run the configuration wizard</a>
  <if @datasource_count@ gt 0>
    <li><a href="@add_datasources_url@">Add new datasources and includelets</a>
  </if>
  <li><a href="@edit_pageset_template_url@">Edit the layout manager master layout</a>
  <if @user_pagesets_p@>
    <li><a href="@user-pagesets@">Edit user pages ets</a>
  </if>
</ul>
