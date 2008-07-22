<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="layout::element::move_vertically.select_previous_element">
        <querytext>
            select sort_key as other_sort_key,
                   element_id as other_element_id
            from (select *
                  from layout_elements
                  where page_id = :page_id
                  and page_column = :page_column
                  and sort_key < :sort_key
                  order by sort_key desc)
            where rownum = 1
        </querytext>
    </fullquery>

    <fullquery name="layout::element::move_vertically.select_next_element">
        <querytext>
            select sort_key as other_sort_key,
                   element_id as other_element_id
            from (select *
                  from layout_elements
                  where page_id = :page_id
                  and page_column = :page_column
                  and sort_key > :sort_key
                  order by sort_key asc)
            where rownum = 1
        </querytext>
    </fullquery>

    <fullquery name="layout::element::move_horizontally.update_page_column">
        <querytext>
            update layout_elements
            set page_column = :page_column,
                sort_key = (select nvl((select max(sort_key) + 1
                                        from layout_elements
                                        where page_id = :page_id
                                        and page_column = :page_column),
                                       1)
                            from dual)
            where element_id = :element_id
        </querytext>
    </fullquery>

    <fullquery name="layout::element::move_to_page.update_element">
        <querytext>
            update layout_elements
            set page_id = :page_id,
                page_column = :page_column,
                sort_key = (select nvl((select max(sort_key) + 1
                                        from layout_elements
                                        where page_id = :page_id
                                        and page_column = :page_column),
                                       1)
                            from dual)
            where element_id = :element_id
        </querytext>
    </fullquery>

</queryset>
