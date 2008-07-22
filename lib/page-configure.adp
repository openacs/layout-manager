
<table class="portal-page" cellpadding="0" cellspacing="4" width="100%">

  <tr width="100%">
    <td align="left" width="100%" colspan="0">
      <table>
        <tr>
          <td align="left">
            <form method="post" action="@package_url@pageset-configure-2">
              <strong>Page:</strong>
              <input type="hidden" name="return_url" value="@return_url@">
              <input type="hidden" name="pageset_id" value="@pageset_id@">
              <input type="hidden" name="page_id" value="@page_id@">
              <input type="text" name="name" value="@page.name@">
              <input type="hidden" name="op" value="rename_page">
              <input type=submit value="Rename">
            </form>
          </td>

          <td align="left">
            <form method="post" action="@package_url@pageset-configure-2">
              <strong>Theme:</strong>
              <input type="hidden" name="return_url" value="@return_url@">
              <input type="hidden" name="pageset_id" value="@pageset_id@">
              <input type="hidden" name="page_id" value="@page_id@">
              <input type="hidden" name="op" value="change_page_theme">
              <select name="page_theme">
                <option value=""<if @page.theme@ eq ""> selected</if>></option>
                <multiple name="page_themes">
                  <option value="@page_themes.name@"
                    <if @page_themes.name@ eq @page.theme@> selected</if>>
                    @page_themes.description@
                  </option>
                </multiple>
              </select>
              <input type=submit value="Update">
            </form>
          </td>

          <if @has_visible_elements_p@ false>
            <td align="left">
              <form method="post" action="@package_url@pageset-configure-2">
                <input type="hidden" name="return_url" value="@return_url@">
                <input type="hidden" name="pageset_id" value="@pageset_id@">
                <input type="hidden" name="page_id" value="@page_id@">
                <input type="hidden" name="op" value="change_page_template">
                <strong>Template:</strong>
                <select name="page_template">
                  <multiple name="page_templates">
                    <option value="@page_templates.name@"
                      <if @page_templates.name@ eq @page.page_template@> selected</if>>
                      @page_templates.description@
                    </option>
                  </multiple>
                </select>
                <input type=submit value="Update">
              </form>
            </td>
          </if>
        </tr>
      </table>
    </td>
  </tr>

  <tr width="100%">
    <if @has_visible_elements_p@ false>
      <td colspan="3">
        <center>
          No Elements on this page
          <if @page.sort_key@ ne 0>
            <form method="post" action="@package_url@pageset-configure-2">
              <input type="hidden" name="return_url" value="@return_url@">
              <input type="hidden" name="pageset_id" value="@pageset_id@">
              <input type="hidden" name="page_id" value="@page_id@">
              <input type="hidden" name="op" value="remove_page">
              <input type="submit" value="Remove Empty Page">
            </form>
          </if>
        </center>
      </td>
    </if>
    <else>
      <td align="left" width="100%">
        <table cellpadding="0" cellspacing="4" width="100%">
          <tr width="100%">
            <list name="column_list">
              <td valign="top" align="left" width="@column_width@">
                <include src="/packages/layout-manager/lib/column-configure"
                  &="page"
                  column_count="@page_template.columns@"
                  page_column="@column_list:item@">
              </td>
            </list>
          </tr>
        </table>
      </td>
    </else>
  </tr>
</table>

