<master>
  <if @signatory@ not nil>
    <property name="signatory">@signatory;noquote@</property>
  </if>
  <if @focus@ not nil>
    <property name="focus">@focus;noquote@</property>
  </if>
  <property name="header_stuff">
    @header_stuff;noquote@
  </property>

  <if @package_id@ ne "">
    <if @show_single_button_navbar_p@ or @portal_pages:rowcount@ gt 1>
      <div id="@which_navbar@-div">
        <div id="@which_navbar@-container">
          <div id="@which_navbar@"> 
            <multiple name="portal_pages">
              <if @page_num@ not nil and @portal_pages.page_num@ eq @page_num@
                  and @portal_id@ not nil and @portal_pages.portal_id@ eq @portal_id@>
                <div class="tab" id="@which_navbar@-here">
                  @portal_pages.name@
                </div>
              </if>
              <else>
                <div class="tab">
                   <a href="@portal_pages.url@" title="@portal_pages.name@">@portal_pages.name@</a>
                </div>
              </else>
            </multiple>
            <if @application@ not nil>
              <div class="tab" id="@which_navbar@-here">
                @application@
              </div>
            </if>
          </div>
        </div>
      </div>
      <div id="@which_navbar@-body">
    </if>
  </if>

  <!-- Page Title -->

    <if @title@ not nil>
      <h1 class="page-title">@title@</h1>
    </if>

  <!-- Body -->
  
  <slave>

</master>
