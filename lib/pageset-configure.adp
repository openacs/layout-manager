<form method=post action="@package_url@pageset-configure-2">
  <input type="hidden" name="return_url" value="@return_url@">
  <input type="hidden" name="pageset_id" value="@pageset_id@">
  <input type="hidden" name="op" value="change_theme">
  <strong>#layout-manager.pageset_theme#:</strong>
  <select name="theme">
    <multiple name="themes">
      <option value="@themes.name@" <if @current_theme@ eq @themes.name@> selected</if>>@themes.description@</option>
    </multiple>
  </select>
  <input type=submit value="#layout-manager.Update#">
</form>

<if @hidden_elements:rowcount@ ne 0>
  <form method=post action="@package_url@pageset-configure-2">
    <input type="hidden" name="return_url" value="@return_url@">
    <input type="hidden" name="pageset_id" value="@pageset_id@">
    <input type="hidden" name="page_id" value="@first_page_id@">
    <input type="hidden" name="op" value="show_here">
    <select name="element_id">
      <multiple name="hidden_elements">
        <option value="@hidden_elements.element_id@">@hidden_elements.title@</option>
      </multiple>
    </select>
    <input type="submit" value="#layout-manager.add_hidden#">
  </form>
</if>

<multiple name="page_ids">
  <p>
  <include src="/packages/layout-manager/lib/page-configure" pageset_id="@pageset_id@" page_id="@page_ids.page_id@" page_count="@page_count@">
  <p>
</multiple>

<form method=post action="@package_url@pageset-configure-2">
  <input type="hidden" name="return_url" value="@return_url@">
  <input type="hidden" name="pageset_id" value="@pageset_id@">
  <b>#layout-manager.add_page#:</b>
  <input type="text" name="name" value="Page @new_page_num@">
  <input type="hidden" name=op value="add_page">
  <input type="submit" value="Add Page">
</form>

<if @template_id@ not nil>
  <form method=post action="@package_url@pageset-configure-2">
    <input type="hidden" name="return_url" value="@return_url@">
    <input type="hidden" name="pageset_id" value="@pageset_id@">
    <b>#layout-manager.revert_layout#:</b>
    <input type=submit name=op value="#layout-manager.Revert#">
  </form>
</if>

<if @wizard_p@ true>
  <formtemplate id="add-applications"></formtemplate>
</if>
