<master>
<property name="title">Welcome to the Layout Manager</property>

<if @pagesets:rowcount@ eq 0>
    There are no personal pagesets in the system.
</if>
<else>
  Pagesets in the system:
  <p>
  <ul>
    <multiple name=pagesets>
      <li><a href="pageset-show.tcl?pageset_id=@pagesets.pageset_id@&referer=index">@pagesets.name@</a> 
      <small>[<a href="../pageset-configure?pageset_id=@pagesets.pageset_id@&referer=index">edit</a>]</li></small>
    </multiple>
  </ul>
</else>
