CLASS zpru_cl_example_buffer DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_first_node,
             instance TYPE zr_pru_1st_node,
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

    TYPES tt_first_node TYPE TABLE OF ts_first_node WITH EMPTY KEY.
    TYPES tt_second_node  TYPE TABLE OF ts_second_node WITH EMPTY KEY.
    TYPES tt_third_node   TYPE TABLE OF ts_third_node WITH EMPTY KEY.
    TYPES tt_fourth_node   TYPE TABLE OF ts_fourth_node WITH EMPTY KEY.

    CLASS-DATA st_first_node TYPE tt_first_node .
    CLASS-DATA st_second_node  TYPE tt_second_node.
    CLASS-DATA st_third_node   TYPE tt_third_node .
    CLASS-DATA st_fourth_node   TYPE tt_fourth_node .

    TYPES: BEGIN OF ts_first_node_keys,
             firstkey TYPE zr_pru_1st_node-firstkey,
           END OF ts_first_node_keys.

    TYPES: BEGIN OF ts_second_node_keys,
             firstkey  TYPE zr_pru_2nd_node-firstkey,
             secondkey TYPE zr_pru_2nd_node-secondkey,
           END OF ts_second_node_keys.

    TYPES: BEGIN OF ts_third_node_keys,
             firstkey  TYPE zr_pru_3rd_node-firstkey,
             secondkey TYPE zr_pru_3rd_node-secondkey,
             thirdkey  TYPE zr_pru_3rd_node-thirdkey,
           END OF ts_third_node_keys.

    TYPES: BEGIN OF ts_fourth_node_keys,
             firstkey  TYPE zr_pru_4th_node-firstkey,
             secondkey TYPE zr_pru_4th_node-secondkey,
             thirdkey  TYPE zr_pru_4th_node-thirdkey,
             fourthkey TYPE zr_pru_4th_node-fourthkey,
           END OF ts_fourth_node_keys.

    TYPES tt_first_node_keys TYPE TABLE OF ts_first_node_keys WITH EMPTY KEY.
    TYPES tt_second_node_keys  TYPE TABLE OF ts_second_node_keys WITH EMPTY KEY.
    TYPES tt_third_node_keys   TYPE TABLE OF ts_third_node_keys WITH EMPTY KEY.
    TYPES tt_fourth_node_keys   TYPE TABLE OF ts_fourth_node_keys WITH EMPTY KEY.

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
*    DATA ls_line TYPE zpru_axc_head.
*
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
*
*      IF line_exists( zpru_cl_example_buffer=>header_buffer[ instance-run_uuid = <ls_key>-run_uuid ] ).
*        " do nothing
*      ELSE.
*        SELECT SINGLE @abap_true FROM zpru_axc_head
*          WHERE run_uuid = @<ls_key>-run_uuid
*          INTO @DATA(lv_exists).
*        IF lv_exists = abap_true.
*          SELECT SINGLE * FROM zpru_axc_head
*            WHERE run_uuid = @<ls_key>-run_uuid
*            INTO CORRESPONDING FIELDS OF @ls_line.
*          IF sy-subrc = 0.
*            APPEND VALUE #( instance = ls_line ) TO zpru_cl_example_buffer=>header_buffer.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD.

  METHOD prep_second_node_buffer.
*    DATA lt_child_tab  TYPE TABLE OF zpru_axc_query WITH EMPTY KEY.
*    DATA ls_child_line TYPE zpru_axc_query.
*
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key_child>).
*      IF <ls_key_child>-full_key = abap_true.
*        IF line_exists( zpru_cl_example_buffer=>query_buffer[ instance-run_uuid   = <ls_key_child>-run_uuid
*                                                          instance-query_uuid = <ls_key_child>-query_uuid ] ).
*          " do nothing
*        ELSE.
*          SELECT SINGLE @abap_true FROM zpru_axc_query
*            WHERE run_uuid   = @<ls_key_child>-run_uuid
*              AND query_uuid = @<ls_key_child>-query_uuid
*            INTO @DATA(lv_exists).
*          IF lv_exists = abap_true.
*            SELECT SINGLE * FROM zpru_axc_query
*              WHERE run_uuid   = @<ls_key_child>-run_uuid
*                AND query_uuid = @<ls_key_child>-query_uuid
*              INTO CORRESPONDING FIELDS OF @ls_child_line.
*            IF sy-subrc = 0.
*              APPEND VALUE #( instance = ls_child_line ) TO zpru_cl_example_buffer=>query_buffer.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*
*      ELSE.
*        IF     line_exists( zpru_cl_example_buffer=>header_buffer[ instance-run_uuid = <ls_key_child>-run_uuid ] )
*           AND VALUE #( zpru_cl_example_buffer=>header_buffer[ instance-run_uuid = <ls_key_child>-run_uuid ]-deleted OPTIONAL ) IS NOT INITIAL.
*          " do nothing
*        ELSE.
*          SELECT SINGLE @abap_true FROM zpru_axc_query
*            WHERE run_uuid = @<ls_key_child>-run_uuid
*            INTO @DATA(lv_exists_ch).
*          IF lv_exists_ch = abap_true.
*            SELECT * FROM zpru_axc_query
*              WHERE run_uuid = @<ls_key_child>-run_uuid
*              INTO CORRESPONDING FIELDS OF TABLE @lt_child_tab.
*            IF sy-subrc = 0.
*              LOOP AT lt_child_tab ASSIGNING FIELD-SYMBOL(<ls_child>).
*                IF NOT line_exists( zpru_cl_example_buffer=>query_buffer[ instance-run_uuid   = <ls_child>-run_uuid
*                                                                      instance-query_uuid = <ls_child>-query_uuid ] ).
*                  APPEND VALUE #( instance = <ls_child> ) TO zpru_cl_example_buffer=>query_buffer.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD.

  METHOD prep_third_node_buffer.
*    DATA lt_child_tab  TYPE TABLE OF zpru_axc_step WITH EMPTY KEY.
*    DATA ls_child_line TYPE zpru_axc_step.
*
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key_child>).
*      IF <ls_key_child>-full_key = abap_true.
*        IF line_exists( zpru_cl_example_buffer=>step_buffer[ instance-query_uuid = <ls_key_child>-query_uuid
*                                                         instance-step_uuid  = <ls_key_child>-step_uuid ] ).
*          " do nothing
*        ELSE.
*          SELECT SINGLE @abap_true FROM zpru_axc_step
*            WHERE query_uuid = @<ls_key_child>-query_uuid
*              AND step_uuid  = @<ls_key_child>-step_uuid
*            INTO @DATA(lv_exists).
*          IF lv_exists = abap_true.
*            SELECT SINGLE * FROM zpru_axc_step
*              WHERE query_uuid = @<ls_key_child>-query_uuid
*                AND step_uuid  = @<ls_key_child>-step_uuid
*              INTO CORRESPONDING FIELDS OF @ls_child_line.
*            IF sy-subrc = 0.
*              APPEND VALUE #( instance = ls_child_line ) TO zpru_cl_example_buffer=>step_buffer.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*
*      ELSE.
*        IF     line_exists( zpru_cl_example_buffer=>query_buffer[ instance-query_uuid = <ls_key_child>-query_uuid ] )
*           AND VALUE #( zpru_cl_example_buffer=>query_buffer[ instance-query_uuid = <ls_key_child>-query_uuid ]-deleted OPTIONAL ) IS NOT INITIAL.
*          " do nothing
*        ELSE.
*          SELECT SINGLE @abap_true FROM zpru_axc_step
*            WHERE query_uuid = @<ls_key_child>-query_uuid
*            INTO @DATA(lv_exists_ch).
*          IF lv_exists_ch = abap_true.
*            SELECT * FROM zpru_axc_step
*              WHERE query_uuid = @<ls_key_child>-query_uuid
*              INTO CORRESPONDING FIELDS OF TABLE @lt_child_tab.
*            IF sy-subrc = 0.
*              LOOP AT lt_child_tab ASSIGNING FIELD-SYMBOL(<ls_child>).
*                IF NOT line_exists( zpru_cl_example_buffer=>step_buffer[ instance-query_uuid = <ls_child>-query_uuid
*                                                                     instance-step_uuid  = <ls_child>-step_uuid ] ).
*                  APPEND VALUE #( instance = <ls_child> ) TO zpru_cl_example_buffer=>step_buffer.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD.
  METHOD prep_fourth_node_buffer.

  ENDMETHOD.

ENDCLASS.
