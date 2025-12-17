CLASS zpru_cl_example_buffer DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_first_node,
             instance TYPE zr_pru_1st_node,
             cid      TYPE abp_behv_cid,
             pid      TYPE abp_behv_pid,
             changed  TYPE abap_bool,
             deleted  TYPE abap_bool,
           END OF ts_first_node.

    TYPES: BEGIN OF ts_second_node,
             instance TYPE zr_pru_2nd_node,
             changed  TYPE abap_bool,
             deleted  TYPE abap_bool,
           END OF ts_second_node.

    TYPES: BEGIN OF ts_third_node,
             instance TYPE zr_pru_3rd_node,
             changed  TYPE abap_bool,
             deleted  TYPE abap_bool,
           END OF ts_third_node.

    TYPES: BEGIN OF ts_fourth_node,
             instance TYPE zr_pru_4th_node,
             changed  TYPE abap_bool,
             deleted  TYPE abap_bool,
           END OF ts_fourth_node.

    TYPES tt_first_node  TYPE TABLE OF ts_first_node WITH EMPTY KEY.
    TYPES tt_second_node TYPE TABLE OF ts_second_node WITH EMPTY KEY.
    TYPES tt_third_node  TYPE TABLE OF ts_third_node WITH EMPTY KEY.
    TYPES tt_fourth_node TYPE TABLE OF ts_fourth_node WITH EMPTY KEY.

    CLASS-DATA st_first_node  TYPE tt_first_node.
    CLASS-DATA st_second_node TYPE tt_second_node.
    CLASS-DATA st_third_node  TYPE tt_third_node.
    CLASS-DATA st_fourth_node TYPE tt_fourth_node.

    TYPES: BEGIN OF ts_first_node_keys,
             firstkey TYPE zr_pru_1st_node-firstkey,
           END OF ts_first_node_keys.

    TYPES: BEGIN OF ts_second_node_keys,
             firstkey  TYPE zr_pru_2nd_node-firstkey,
             secondkey TYPE zr_pru_2nd_node-secondkey,
             full_key  TYPE abap_bool,
           END OF ts_second_node_keys.

    TYPES: BEGIN OF ts_third_node_keys,
             firstkey  TYPE zr_pru_3rd_node-firstkey,
             secondkey TYPE zr_pru_3rd_node-secondkey,
             thirdkey  TYPE zr_pru_3rd_node-thirdkey,
             full_key  TYPE abap_bool,
           END OF ts_third_node_keys.

    TYPES: BEGIN OF ts_fourth_node_keys,
             firstkey  TYPE zr_pru_4th_node-firstkey,
             secondkey TYPE zr_pru_4th_node-secondkey,
             thirdkey  TYPE zr_pru_4th_node-thirdkey,
             fourthkey TYPE zr_pru_4th_node-fourthkey,
             full_key  TYPE abap_bool,
           END OF ts_fourth_node_keys.

    TYPES tt_first_node_keys  TYPE TABLE OF ts_first_node_keys WITH EMPTY KEY.
    TYPES tt_second_node_keys TYPE TABLE OF ts_second_node_keys WITH EMPTY KEY.
    TYPES tt_third_node_keys  TYPE TABLE OF ts_third_node_keys WITH EMPTY KEY.
    TYPES tt_fourth_node_keys TYPE TABLE OF ts_fourth_node_keys WITH EMPTY KEY.

    CLASS-METHODS prep_first_node_buffer
      IMPORTING !keys TYPE tt_first_node_keys.

    CLASS-METHODS prep_second_node_buffer
      IMPORTING !keys TYPE tt_second_node_keys.

    CLASS-METHODS prep_third_node_buffer
      IMPORTING !keys TYPE tt_third_node_keys.

    CLASS-METHODS prep_fourth_node_buffer
      IMPORTING !keys TYPE tt_fourth_node_keys.

ENDCLASS.


CLASS zpru_cl_example_buffer IMPLEMENTATION.
  METHOD prep_first_node_buffer.
    DATA lt_keys_2_read   LIKE keys.
    DATA lt_entity_result TYPE STANDARD TABLE OF zr_pru_1st_node WITH EMPTY KEY.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
      IF line_exists( zpru_cl_example_buffer=>st_first_node[ instance-firstkey = <ls_key>-firstkey ] ).
        CONTINUE.
      ELSE.
        APPEND INITIAL LINE TO lt_keys_2_read ASSIGNING FIELD-SYMBOL(<ls_key_2_read>).
        <ls_key_2_read>-firstkey = <ls_key>-firstkey.
      ENDIF.
    ENDLOOP.

    IF lt_keys_2_read IS NOT INITIAL.
      SELECT * FROM zr_pru_1st_node
        FOR ALL ENTRIES IN @lt_keys_2_read
        WHERE firstkey = @lt_keys_2_read-firstkey
        INTO TABLE @lt_entity_result.
      IF sy-subrc = 0.
        LOOP AT lt_entity_result ASSIGNING FIELD-SYMBOL(<ls_result>).
          APPEND INITIAL LINE TO zpru_cl_example_buffer=>st_first_node ASSIGNING FIELD-SYMBOL(<ls_buffer>).
          <ls_buffer>-instance = <ls_result>.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD prep_second_node_buffer.
    DATA lt_full_keys_2_read   LIKE keys.
    DATA lt_part_keys_2_read   LIKE keys.
    DATA lt_full_entity_result TYPE STANDARD TABLE OF zr_pru_2nd_node WITH EMPTY KEY.
    DATA lt_part_entity_result TYPE STANDARD TABLE OF zr_pru_2nd_node WITH EMPTY KEY.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key_child>).
      IF <ls_key_child>-full_key = abap_true.
        IF line_exists( zpru_cl_example_buffer=>st_second_node[ instance-firstkey  = <ls_key_child>-firstkey
                                                                instance-secondkey = <ls_key_child>-secondkey ] ).
          CONTINUE.
        ELSE.
          APPEND INITIAL LINE TO lt_full_keys_2_read ASSIGNING FIELD-SYMBOL(<ls_full_key_2_read>).
          <ls_full_key_2_read>-firstkey  = <ls_key_child>-firstkey.
          <ls_full_key_2_read>-secondkey = <ls_key_child>-secondkey.
        ENDIF.
      ELSE.
        IF     line_exists( zpru_cl_example_buffer=>st_first_node[ instance-firstkey = <ls_key_child>-firstkey ] )
           AND VALUE #( zpru_cl_example_buffer=>st_first_node[ instance-firstkey = <ls_key_child>-firstkey ]-deleted OPTIONAL ) IS NOT INITIAL.
          CONTINUE.
        ELSE.
          APPEND INITIAL LINE TO lt_part_keys_2_read ASSIGNING FIELD-SYMBOL(<ls_part_key_2_read>).
          <ls_part_key_2_read>-firstkey = <ls_key_child>-firstkey.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lt_full_keys_2_read IS NOT INITIAL.
      SELECT * FROM zr_pru_2nd_node
        FOR ALL ENTRIES IN @lt_full_keys_2_read
        WHERE firstkey  = @lt_full_keys_2_read-firstkey
          AND secondkey = @lt_full_keys_2_read-secondkey
        INTO TABLE @lt_full_entity_result.
      IF sy-subrc = 0.
        LOOP AT lt_full_entity_result ASSIGNING FIELD-SYMBOL(<ls_result>).
          APPEND INITIAL LINE TO zpru_cl_example_buffer=>st_second_node ASSIGNING FIELD-SYMBOL(<ls_buffer>).
          <ls_buffer>-instance = <ls_result>.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF lt_part_keys_2_read IS NOT INITIAL.
      SELECT * FROM zr_pru_2nd_node
        FOR ALL ENTRIES IN @lt_part_keys_2_read
        WHERE firstkey = @lt_part_keys_2_read-firstkey
        INTO TABLE @lt_part_entity_result.
      IF sy-subrc = 0.
        LOOP AT lt_part_entity_result ASSIGNING <ls_result>.
          IF NOT line_exists( zpru_cl_example_buffer=>st_second_node[ instance-firstkey  = <ls_result>-firstkey
                                                                      instance-secondkey = <ls_result>-secondkey ] ).
            APPEND INITIAL LINE TO zpru_cl_example_buffer=>st_second_node ASSIGNING <ls_buffer>.
            <ls_buffer>-instance = <ls_result>.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD prep_third_node_buffer.
    DATA lt_full_keys_2_read   LIKE keys.
    DATA lt_part_keys_2_read   LIKE keys.
    DATA lt_full_entity_result TYPE STANDARD TABLE OF zr_pru_3rd_node WITH EMPTY KEY.
    DATA lt_part_entity_result TYPE STANDARD TABLE OF zr_pru_3rd_node WITH EMPTY KEY.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key_child>).
      IF <ls_key_child>-full_key = abap_true.
        IF line_exists( zpru_cl_example_buffer=>st_third_node[ instance-firstkey  = <ls_key_child>-firstkey
                                                               instance-secondkey = <ls_key_child>-secondkey
                                                               instance-thirdkey  = <ls_key_child>-thirdkey ] ).
          CONTINUE.
        ELSE.
          APPEND INITIAL LINE TO lt_full_keys_2_read ASSIGNING FIELD-SYMBOL(<ls_full_key_2_read>).
          <ls_full_key_2_read>-firstkey  = <ls_key_child>-firstkey.
          <ls_full_key_2_read>-secondkey = <ls_key_child>-secondkey.
          <ls_full_key_2_read>-thirdkey  = <ls_key_child>-thirdkey.
        ENDIF.
      ELSE.
        IF     line_exists( zpru_cl_example_buffer=>st_second_node[ instance-firstkey  = <ls_key_child>-firstkey
                                                                    instance-secondkey = <ls_key_child>-secondkey ] )
           AND VALUE #( zpru_cl_example_buffer=>st_second_node[ instance-firstkey  = <ls_key_child>-firstkey
                                                                instance-secondkey = <ls_key_child>-secondkey ]-deleted OPTIONAL ) IS NOT INITIAL.
          CONTINUE.
        ELSE.
          APPEND INITIAL LINE TO lt_part_keys_2_read ASSIGNING FIELD-SYMBOL(<ls_part_key_2_read>).
          <ls_part_key_2_read>-firstkey = <ls_key_child>-firstkey.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lt_full_keys_2_read IS NOT INITIAL.
      SELECT * FROM zr_pru_3rd_node
        FOR ALL ENTRIES IN @lt_full_keys_2_read
        WHERE firstkey  = @lt_full_keys_2_read-firstkey
          AND secondkey = @lt_full_keys_2_read-secondkey
          AND thirdkey  = @lt_full_keys_2_read-thirdkey
        INTO TABLE @lt_full_entity_result.
      IF sy-subrc = 0.
        LOOP AT lt_full_entity_result ASSIGNING FIELD-SYMBOL(<ls_result>).
          APPEND INITIAL LINE TO zpru_cl_example_buffer=>st_third_node ASSIGNING FIELD-SYMBOL(<ls_buffer>).
          <ls_buffer>-instance = <ls_result>.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF lt_part_keys_2_read IS NOT INITIAL.
      SELECT * FROM zr_pru_3rd_node
        FOR ALL ENTRIES IN @lt_part_keys_2_read
        WHERE firstkey  = @lt_part_keys_2_read-firstkey
          AND secondkey = @lt_part_keys_2_read-secondkey
        INTO TABLE @lt_part_entity_result.
      IF sy-subrc = 0.
        LOOP AT lt_part_entity_result ASSIGNING <ls_result>.
          IF NOT line_exists( zpru_cl_example_buffer=>st_third_node[ instance-firstkey  = <ls_result>-firstkey
                                                                     instance-secondkey = <ls_result>-secondkey
                                                                     instance-thirdkey  = <ls_result>-thirdkey ] ).
            APPEND INITIAL LINE TO zpru_cl_example_buffer=>st_third_node ASSIGNING <ls_buffer>.
            <ls_buffer>-instance = <ls_result>.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD prep_fourth_node_buffer.
    DATA lt_full_keys_2_read   LIKE keys.
    DATA lt_part_keys_2_read   LIKE keys.
    DATA lt_full_entity_result TYPE STANDARD TABLE OF zr_pru_4th_node WITH EMPTY KEY.
    DATA lt_part_entity_result TYPE STANDARD TABLE OF zr_pru_4th_node WITH EMPTY KEY.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key_child>).
      IF <ls_key_child>-full_key = abap_true.
        IF line_exists( zpru_cl_example_buffer=>st_fourth_node[ instance-firstkey  = <ls_key_child>-firstkey
                                                                     instance-secondkey = <ls_key_child>-secondkey
                                                                     instance-thirdkey  = <ls_key_child>-thirdkey
                                                                     instance-fourthkey =  <ls_key_child>-fourthkey ] ).
          CONTINUE.
        ELSE.
          APPEND INITIAL LINE TO lt_full_keys_2_read ASSIGNING FIELD-SYMBOL(<ls_full_key_2_read>).
          <ls_full_key_2_read>-firstkey  = <ls_key_child>-firstkey.
          <ls_full_key_2_read>-secondkey = <ls_key_child>-secondkey.
          <ls_full_key_2_read>-thirdkey  = <ls_key_child>-thirdkey.
          <ls_full_key_2_read>-fourthkey  = <ls_key_child>-fourthkey.
        ENDIF.
      ELSE.
        IF     line_exists( zpru_cl_example_buffer=>st_third_node[ instance-firstkey  = <ls_key_child>-firstkey
                                                                   instance-secondkey = <ls_key_child>-secondkey
                                                                   instance-thirdkey  = <ls_key_child>-thirdkey ] )
           AND VALUE #( zpru_cl_example_buffer=>st_third_node[ instance-firstkey  = <ls_key_child>-firstkey
                                                                instance-secondkey = <ls_key_child>-secondkey
                                                                instance-thirdkey  = <ls_key_child>-thirdkey ]-deleted OPTIONAL ) IS NOT INITIAL.
          CONTINUE.
        ELSE.
          APPEND INITIAL LINE TO lt_part_keys_2_read ASSIGNING FIELD-SYMBOL(<ls_part_key_2_read>).
          <ls_part_key_2_read>-firstkey = <ls_key_child>-firstkey.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lt_full_keys_2_read IS NOT INITIAL.
      SELECT * FROM zr_pru_4th_node
        FOR ALL ENTRIES IN @lt_full_keys_2_read
        WHERE firstkey  = @lt_full_keys_2_read-firstkey
          AND secondkey = @lt_full_keys_2_read-secondkey
          AND thirdkey  = @lt_full_keys_2_read-thirdkey
          AND fourthkey = @lt_full_keys_2_read-fourthkey
        INTO TABLE @lt_full_entity_result.
      IF sy-subrc = 0.
        LOOP AT lt_full_entity_result ASSIGNING FIELD-SYMBOL(<ls_result>).
          APPEND INITIAL LINE TO zpru_cl_example_buffer=>st_fourth_node ASSIGNING FIELD-SYMBOL(<ls_buffer>).
          <ls_buffer>-instance = <ls_result>.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF lt_part_keys_2_read IS NOT INITIAL.
      SELECT * FROM zr_pru_4th_node
        FOR ALL ENTRIES IN @lt_part_keys_2_read
        WHERE firstkey  = @lt_part_keys_2_read-firstkey
          AND secondkey = @lt_part_keys_2_read-secondkey
          AND thirdkey  = @lt_part_keys_2_read-thirdkey
        INTO TABLE @lt_part_entity_result.
      IF sy-subrc = 0.
        LOOP AT lt_part_entity_result ASSIGNING <ls_result>.
          IF NOT line_exists( zpru_cl_example_buffer=>st_fourth_node[ instance-firstkey  = <ls_result>-firstkey
                                                                     instance-secondkey = <ls_result>-secondkey
                                                                     instance-thirdkey  = <ls_result>-thirdkey
                                                                     instance-fourthkey = <ls_result>-fourthkey ] ).
            APPEND INITIAL LINE TO zpru_cl_example_buffer=>st_fourth_node ASSIGNING <ls_buffer>.
            <ls_buffer>-instance = <ls_result>.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
