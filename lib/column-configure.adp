<multiple name="elements">
  <div class="portlet-wrapper">
    <div class="portlet-header">
      <div class="portlet-title">
        <h1>@elements.title;noquote@</h1>
      </div>
      <div class="portlet-controls">
        <a href="@elements.hide_url@">
          <img src="/resources/layout-manager/images/delete.gif" border="0" alt="remove portlet">
        </a>
  
        <if @elements.up_url@ ne "">
          <a href="@elements.up_url@">
            <img src="/resources/layout-manager/images/arrow-up.gif" border="0" alt="move up">
          </a>
        </if>
  
        <if @elements.down_url@ ne "">
          <a href="@elements.down_url@">
            <img src="/resources/layout-manager/images/arrow-down.gif" border="0" alt="move down">
          </a>
        </if>
  
        <if @elements.right_url@ ne "">
          <a href="@elements.right_url@">
            <img src="/resources/layout-manager/images/arrow-right.gif" border="0" alt="move right">
          </a>
        </if>
  
        <if @elements.left_url@ ne "">
          <a href="@elements.left_url@">
            <img src="/resources/layout-manager/images/arrow-left.gif" border="0" alt="move left">
          </a>
        </if>
      </div>
    </div>
    <div class="portlet">
      <p>
        <center><a href="@elements.edit_url@">Edit Properties</a></center>
      <p>
    </div>
  </div>
</multiple>
