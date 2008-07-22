    if p_template_id is not null then
      -- now insert the pages from the layout template
      for v_page in select *
                    from layout_pages
                    where pageset_id = p_template_id
      loop

        v_page_id := layout_page__new(
          v_page.name,
          v_pageset_id,
          v_page.layout_template,
          v_pageset_id);

        -- now get the elements on the templates page and put them on the new page
        for v_element in select *
                         from layout_elements
                         where page_id = v_page.page_id
        loop

          select nextval(''layout_seq'')
          into v_new_element_id
          from dual;

          insert into layout_elements
            (element_id, name, title, page_id, includelet_id, page_column, sort_key, state)
          select v_new_element_id, name, title, v_page_id, includelet_id, page_column, sort_key,
            state
          from layout_elements
          where element_id = v_element.element_id;

          -- now for the elements params
          for v_param in select *
                         from layout_element_parameters
                         where element_id = v_element.element_id
          loop

            select nextval(''layout_seq'')
            into v_new_parameter_id
            from dual;

            insert into layout_element_parameters
              (parameter_id, element_id, key, value)
            select v_new_parameter_id, v_new_element_id, key, value
            from layout_element_parameters
            where parameter_id = v_param.parameter_id;

          end loop;

        end loop;

      end loop;

    end if;
