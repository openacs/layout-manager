<div id="main">
	
  <div id="main-content">
    <div class="main-content-padding">
      <list name="element_id_list" value="@columns.2@">
        <include src="/packages/layout-manager/lib/render/render-element"
          &="pageset"
          element_id="@element_id_list:item@">
       </list>
    </div> <!-- /main-content-padding -->
  </div> <!-- /main-content -->

  <div id="sidebar-1">
    <div class="sidebar-1-padding">
      <list name="element_id_list" value="@columns.1@">
        <include src="/packages/layout-manager/lib/render/render-element"
          &="pageset"
          element_id="@element_id_list:item@">
       </list>
    </div> <!-- /sidebar-1-padding -->
  </div> <!-- /sidebar-1 -->

</div> <!-- /main -->
