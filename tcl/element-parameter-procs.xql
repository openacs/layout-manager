<?xml version="1.0"?>

<queryset>

  <fullquery name="layout::element::parameter::add_values.insert_parameter">
    <querytext>
      insert into layout_element_parameters
        (element_id, key, value)
      values
        (:element_id, :key, :value)
    </querytext>
  </fullquery>

  <fullquery name="layout::element::parameter::delete.delete_one_parameter_value">
    <querytext>
      delete from layout_element_parameters
      where element_id = :element_id
        and key = :key
        and value = :value
    </querytext>
  </fullquery>

  <fullquery name="layout::element::parameter::delete.delete_parameter">
    <querytext>
      delete from layout_element_parameters
      where element_id = :element_id
        and key = :key
    </querytext>
  </fullquery>

  <fullquery name="layout::element::parameter::get.select_parameters">
    <querytext>
      select value
      from layout_element_parameters
      where element_id = :element_id
        and key = :key
    </querytext>
  </fullquery>

  <fullquery name="layout::element::parameter::set_values.delete_parameter">
    <querytext>
      delete from layout_element_parameters
      where element_id = :element_id
        and key = :key
    </querytext>
  </fullquery>

  <fullquery name="layout::element::parameter::set_values.insert_parameter">
    <querytext>
      insert into layout_element_parameters
        (element_id, key, value)
      values
        (:element_id, :key, :value)
    </querytext>
  </fullquery>

  <fullquery name="layout::element::parameter::get_all.select_parameters">
    <querytext>
      select key, value
      from layout_element_parameters
      where element_id = :element_id
    </querytext>
  </fullquery>

</queryset>
