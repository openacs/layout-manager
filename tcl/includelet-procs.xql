<?xml version="1.0"?>

<queryset>

  <fullquery name="layout::includelet::new.insert_includelet">
    <querytext>
      insert into layout_includelets
        (name, title, application, template, initializer, uninitializer, required_privilege,
         description, dotlrn_compat_p, internally_managed_p, singleton_p)
      values
        (:name, :title, :application, :template, :initializer, :uninitializer, :required_privilege,
         :description, :dotlrn_compat_p, :internally_managed_p, :singleton_p)
    </querytext>
  </fullquery>

  <fullquery name="layout::includelet::delete.delete_includelet">
    <querytext>
      delete from layout_includelets
      where name = :name
    </querytext>
  </fullquery>

  <fullquery name="layout::includelet::get.select_includelet">
    <querytext>
      select *
      from layout_includelets
      where name = :name
    </querytext>
  </fullquery>

</queryset>
