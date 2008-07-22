<?xml version="1.0"?>

<queryset>

    <fullquery name="layout::element::new.insert_element">
        <querytext>
          insert into layout_elements
            (element_id, includelet_name, name, title, page_id, page_column, theme,
             state, sort_key, required_privilege, package_id)
            select :element_id,
                   :includelet_name,
                   :name,
                   :title,
                   :page_id,
                   :page_column,
                   :theme,
                   :state,
                   coalesce((select max(layout_elements.sort_key) + 1
                        from layout_elements
                        where page_id = :page_id
                        and page_column = :page_column), 1),
                   layout_includelets.required_privilege,
                   :package_id
            from layout_includelets
            where layout_includelets.name = :includelet_name
        </querytext>
    </fullquery>

    <fullquery name="layout::element::delete.delete_element">
        <querytext>
            delete
            from layout_elements
            where element_id = :element_id
        </querytext>
    </fullquery>

    <fullquery name="layout::element::get.select_element">
        <querytext>
            select *
            from layout_elements
            where element_id = :element_id
        </querytext>
    </fullquery>

    <fullquery name="layout::element::set_values.update_element">
        <querytext>
            update layout_elements
            set includelet_name = :includelet_name,
                name = :name,
                title = :title,
                page_id = :page_id,
                page_column = :page_column,
                sort_key = :sort_key,
                theme = :theme,
                state = :state
            where element_id = :element_id
        </querytext>
    </fullquery>

    <fullquery name="layout::element::choose_page_column.select_page_column_count">
        <querytext>
            select count(*) as count
            from layout_elements pe,
                 layout_pages pp
            where pp.page_id = :page_id
            and pe.page_column = :page_column
            and pp.page_id = pe.page_id
        </querytext>
    </fullquery>

    <fullquery name="layout::element::get_id_list.select_element_ids">
        <querytext>
            select layout_elements.element_id
            from layout_elements,
                 layout_pages
            where layout_pages.pageset_id = :pageset_id
            and layout_elements.includelet_name = :includelet_name
            and layout_elements.page_id = layout_pages.page_id
            and layout_elements.name like :name
            and layout_elements.title like :title
        </querytext>
    </fullquery>

    <fullquery name="layout::element::get_id_from_unique_param.select_id">
        <querytext>
          select layout_elements.element_id
          from layout_elements, layout_element_parameters
          where layout_elements.page_id in (select page_id
                                            from layout_pages
                                            where layout_id = :layout_id)
            and layout_element_parameters.element_id = layout_elements.element_id
            and layout_element_parameters.key = :key
            and layout_element_parameters.value = :value
        </querytext>
    </fullquery>

    <fullquery name="layout::element::move_vertically.swap_sort_keys_1">
        <querytext>
            update layout_elements
            set sort_key = :dummy_sort_key
            where element_id = :element_id
        </querytext>
    </fullquery>

    <fullquery name="layout::element::move_vertically.swap_sort_keys_2">
        <querytext>
            update layout_elements
            set sort_key = :sort_key
            where element_id = :other_element_id
        </querytext>
    </fullquery>

    <fullquery name="layout::element::move_vertically.swap_sort_keys_3">
        <querytext>
            update layout_elements
            set sort_key = :other_sort_key
            where element_id = :element_id
        </querytext>
    </fullquery>

    <fullquery name="layout::element::get_id.element_id">
        <querytext>
            select pe.element_id
            from layout_elements pe, layout_includelets pd
            where pe.page_id = :page_id
              and pe.includelet_name= pd.includelet_name
              and pd.name = :includelet_name
        </querytext>
    </fullquery>

    <fullquery name="layout::element::get_id_from_name.element_id">
        <querytext>
            select pe.element_id
            from layout_elements pe, layout_pages pp
            where pe.page_id = pp.page_id
              and pe.name = :name
              and pp.layout_id = :layout_id
        </querytext>
    </fullquery>

</queryset>
