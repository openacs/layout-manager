<master src="@master_template@">
  <if @title@ not nil>
    <property name="title">@title;noquote@</property>
  </if>
  <if @signatory@ not nil>
    <property name="signatory">@signatory;noquote@</property>
  </if>
  <if @focus@ not nil>
    <property name="focus">@focus;noquote@</property>
  </if>

<div id="subsite-name">
  <if @subsite_url@ not nil><a href="@subsite_url@" class="subsite-name">@subsite_name@</a></if>
  <else>@subsite_name@</else>
</div>

<!-- Top level navigation -->

<div id="navbar-div">
  <div id="navbar-container">
    <div id="navbar"> 
      <multiple name="sections">
        <if @sections.selected_p@ true>
          <div class="tab" id="navbar-here">
            <if @sections.link_p@ true>
              <a href="@sections.url@" title="@sections.title@">@sections.label@</a>
            </if>
            <else>        
              @sections.label@
            </else>
          </div>
        </if>
        <else>
          <div class="tab">
            <if @sections.link_p@ true>
              <a href="@sections.url@" title="@sections.title@">@sections.label@</a>
            </if>
            <else>        
              @sections.label@
            </else>
          </div>
        </else>
      </multiple>
    </div>
  </div>
</div>
<div id="navbar-body">

<!-- Second level navigation -->

  <if @subsections:rowcount@ gt 0 or @package_id@ ne "">
    <div id="subnavbar-div">
      <div id="subnavbar-container">
        <div id="subnavbar">
          <if @subsections:rowcount@ gt 0>
            <multiple name="subsections">
              <if @subsections.selected_p@ true>
                <div class="tab" id="subnavbar-here">
                  <if @subsections.link_p@ true>
                    <a href="@subsections.url@" title="@subsections.title@">@subsections.label@</a>
                  </if>
                  <else>        
                    @subsections.label@
                  </else>
                </div>
              </if>
              <else>
                <div class="tab">
                  <if @subsections.link_p@ true>
                    <a href="@subsections.url@" title="@subsections.title@">@subsections.label@</a>
                  </if>
                  <else>        
                    @subsections.label@
                  </else>
                </div>
              </else>
            </multiple>
          </if>
          <elseif @package_id@ ne "" and @page_num@ not nil>
            <multiple name="portal_pages">
              <if @portal_pages.page_num@ eq @page_num@
                 and @portal_id@ not nil and @portal_pages.portal_id@ eq @portal_id@>
                <div class="tab" id="subnavbar-here">
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
              <div class="tab" id="subnavbar-here">
                @application@
              </div>
            </if>
          </elseif>
        </div>
      </div>
    </div>
    <div id="subnavbar-body">
  </if>

  <!-- Body -->

  <if @portal_page_p@>
    <slave>
  </if>
  <else>
    <include src="@theme_template@" title="@title@" &="__adp_slave">
  </else>

  <div style="clear: both;"></div>

  <if @subsections:rowcount@ gt 0 or @package_id ne "">
    </div>
  </if>
</div>


 
