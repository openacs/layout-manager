set template "<div class=\"portlet-wrapper\">
  <if @title@ not nil>
    <div class=\"portlet-header\">
      <div class=\"portlet-title\">
        <h1>@title;noquote@</h1>
      </div>
    </div>
  </if>
  <div class=\"portlet\">
    <slave>
  </div>
</div>"
