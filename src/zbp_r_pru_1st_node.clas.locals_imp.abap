CLASS lhc_first_node DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR first_node RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR first_node RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE first_node.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE first_node.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE first_node.

    METHODS read FOR READ
      IMPORTING keys FOR READ first_node RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK first_node.

    METHODS rba_par1to2 FOR READ
      IMPORTING keys_rba FOR READ first_node\_par1to2 FULL result_requested RESULT result LINK association_links.

    METHODS cba_par1to2 FOR MODIFY
      IMPORTING entities_cba FOR CREATE first_node\_par1to2.

ENDCLASS.


CLASS lhc_first_node IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
    IF entities IS INITIAL.
      RETURN.
    ENDIF.

    zpru_cl_example_buffer=>prep_first_node_buffer( keys = CORRESPONDING #( entities ) ).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_create>).

      IF    NOT line_exists( zpru_cl_example_buffer=>st_first_node[ instance-firstkey = <ls_create>-firstkey ] )
         OR     line_exists( zpru_cl_example_buffer=>st_first_node[ instance-firstkey = <ls_create>-firstkey
                                                                    deleted           = abap_true ] ).

        ASSIGN zpru_cl_example_buffer=>st_first_node[ instance-firstkey = <ls_create>-firstkey
                                                      deleted           = abap_false ] TO FIELD-SYMBOL(<ls_old_buffer>).
        IF sy-subrc = 0.
          DELETE zpru_cl_example_buffer=>st_first_node
                 WHERE     instance-firstkey = <ls_old_buffer>-instance-firstkey
                       AND deleted           = abap_true.
        ENDIF.

        TRY.
            DATA(lv_pid) = cl_system_uuid=>create_uuid_x16_static( ).
          CATCH cx_uuid_error.
            " raise SHORTDUMP type CX_ABAP_BEHV_RUNTIME_ERROR.
            ASSERT 1 = 2.
        ENDTRY.

        APPEND INITIAL LINE TO zpru_cl_example_buffer=>st_first_node ASSIGNING FIELD-SYMBOL(<ls_target>).
        <ls_target>-instance-firstkey   = COND #( WHEN <ls_create>-%control-firstkey = if_abap_behv=>mk-on
                                                  THEN <ls_create>-firstkey ).
        <ls_target>-instance-firstfield = COND #( WHEN <ls_create>-%control-firstfield = if_abap_behv=>mk-on
                                                  THEN <ls_create>-firstfield ).
        <ls_target>-changed = abap_true.
        <ls_target>-deleted = abap_false.
        <ls_target>-cid     = <ls_create>-%cid.
        <ls_target>-pid     = lv_pid.

        APPEND INITIAL LINE TO mapped-first_node ASSIGNING FIELD-SYMBOL(<ls_map>).
        <ls_map>-%cid     = <ls_create>-%cid.
        <ls_map>-%pid     = <ls_target>-pid.
        <ls_map>-firstkey = <ls_target>-instance-firstkey.

      ELSE.

        " Filling FAILED and REPORTED response parameters
        APPEND VALUE #( %key        = <ls_create>-%key
                        %fail-cause = if_abap_behv=>cause-not_found )
               TO failed-first_node.

        APPEND VALUE #( %key = <ls_create>-%key
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text     = 'Create operation failed.' ) )
               TO reported-first_node.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    IF entities IS INITIAL.
      RETURN.
    ENDIF.

    zpru_cl_example_buffer=>prep_first_node_buffer( keys = CORRESPONDING #( entities ) ).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_update>).
      IF <ls_update>-%cid_ref IS NOT INITIAL.
        ASSIGN zpru_cl_example_buffer=>st_first_node[ cid     = <ls_update>-%cid_ref
                                                      deleted = abap_false ] TO FIELD-SYMBOL(<ls_buffer>).

      ELSE.
        ASSIGN zpru_cl_example_buffer=>st_first_node[ instance-firstkey = <ls_update>-firstkey
                                                      pid               = <ls_update>-%pid
                                                      deleted           = abap_false ] TO <ls_buffer>.
      ENDIF.

      IF sy-subrc = 0.
        <ls_buffer>-instance-firstfield = COND #( WHEN <ls_update>-%control-firstfield <> if_abap_behv=>mk-off
                                                  THEN <ls_update>-firstfield
                                                  ELSE <ls_buffer>-instance-firstfield ).

        <ls_buffer>-changed = abap_true.
        <ls_buffer>-deleted = abap_false.

      ELSE.

        APPEND VALUE #( %key        = <ls_update>-%key
                        %cid        = <ls_update>-%cid_ref
                        %fail-cause = if_abap_behv=>cause-not_found
                        %update     = if_abap_behv=>mk-on )
               TO failed-first_node.

        APPEND VALUE #( %key = <ls_update>-%key
                        %cid = <ls_update>-%cid_ref
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text     = 'Update operation failed.' ) )
               TO reported-first_node.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA lt_keys_2 TYPE zpru_cl_example_buffer=>tt_second_node_keys.
    DATA lt_keys_3 TYPE zpru_cl_example_buffer=>tt_third_node_keys.
    DATA lt_keys_4 TYPE zpru_cl_example_buffer=>tt_fourth_node_keys.

    zpru_cl_example_buffer=>prep_first_node_buffer( keys = CORRESPONDING #( keys ) ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_k>).
      APPEND INITIAL LINE TO lt_keys_2 ASSIGNING FIELD-SYMBOL(<ls_key_2>).
      <ls_key_2>-firstkey = <ls_k>-firstkey.
      <ls_key_2>-full_key = abap_false.
    ENDLOOP.

    zpru_cl_example_buffer=>prep_second_node_buffer( keys = lt_keys_2 ).

    LOOP AT lt_keys_2 ASSIGNING <ls_key_2>.
      LOOP AT zpru_cl_example_buffer=>st_second_node ASSIGNING FIELD-SYMBOL(<ls_second_node>)
           WHERE instance-firstkey = <ls_key_2>-firstkey.
        APPEND INITIAL LINE TO lt_keys_3 ASSIGNING FIELD-SYMBOL(<ls_key_3>).
        <ls_key_3>-firstkey  = <ls_second_node>-instance-firstkey.
        <ls_key_3>-secondkey = <ls_second_node>-instance-secondkey.
        <ls_key_3>-full_key  = abap_false.
      ENDLOOP.
    ENDLOOP.

    zpru_cl_example_buffer=>prep_third_node_buffer( keys = lt_keys_3 ).

    LOOP AT lt_keys_3 ASSIGNING <ls_key_3>.
      LOOP AT zpru_cl_example_buffer=>st_third_node ASSIGNING FIELD-SYMBOL(<ls_third_node>)
           WHERE     instance-firstkey  = <ls_key_3>-firstkey
                 AND instance-secondkey = <ls_key_3>-secondkey.
        APPEND INITIAL LINE TO lt_keys_4 ASSIGNING FIELD-SYMBOL(<ls_key_4>).
        <ls_key_4>-firstkey  = <ls_third_node>-instance-firstkey.
        <ls_key_4>-secondkey = <ls_third_node>-instance-secondkey.
        <ls_key_4>-thirdkey  = <ls_third_node>-instance-thirdkey.
        <ls_key_4>-full_key  = abap_false.
      ENDLOOP.
    ENDLOOP.

    zpru_cl_example_buffer=>prep_fourth_node_buffer( keys = lt_keys_4 ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_delete>).
      IF <ls_delete>-%cid_ref IS NOT INITIAL.
        ASSIGN zpru_cl_example_buffer=>st_first_node[ cid     = <ls_delete>-%cid_ref
                                                      deleted = abap_false ] TO FIELD-SYMBOL(<ls_buffer>).

      ELSE.
        ASSIGN zpru_cl_example_buffer=>st_first_node[ instance-firstkey = <ls_delete>-firstkey
                                                      pid               = <ls_delete>-%pid
                                                      deleted           = abap_false ] TO <ls_buffer>.
      ENDIF.
      IF sy-subrc = 0.

        <ls_buffer>-changed = abap_false.
        <ls_buffer>-deleted = abap_true.

        LOOP AT zpru_cl_example_buffer=>st_second_node ASSIGNING <ls_second_node>
             WHERE     instance-firstkey = <ls_buffer>-instance-firstkey
                   AND pidparent         = <ls_buffer>-pid.
          <ls_second_node>-changed = abap_false.
          <ls_second_node>-deleted = abap_true.

          LOOP AT zpru_cl_example_buffer=>st_third_node ASSIGNING <ls_third_node>
               WHERE     instance-firstkey  = <ls_second_node>-instance-firstkey
                     AND instance-secondkey = <ls_second_node>-instance-secondkey
                     AND pidparent          = <ls_second_node>-pid.
            <ls_third_node>-changed = abap_false.
            <ls_third_node>-deleted = abap_true.

            LOOP AT zpru_cl_example_buffer=>st_fourth_node ASSIGNING FIELD-SYMBOL(<ls_fourth_node>)
                 WHERE     instance-firstkey  = <ls_third_node>-instance-firstkey
                       AND instance-secondkey = <ls_third_node>-instance-secondkey
                       AND instance-thirdkey  = <ls_third_node>-instance-thirdkey
                       AND pidparent          = <ls_second_node>-pid.
              <ls_fourth_node>-changed = abap_false.
              <ls_fourth_node>-deleted = abap_true.
            ENDLOOP.
          ENDLOOP.
        ENDLOOP.
      ELSE.
        APPEND VALUE #( %key        = <ls_delete>-%key
                        %cid        = <ls_delete>-%cid_ref
                        %fail-cause = if_abap_behv=>cause-not_found
                        %delete     = if_abap_behv=>mk-on )
               TO failed-first_node.

        APPEND VALUE #( %key = <ls_delete>-%key
                        %cid = <ls_delete>-%cid_ref
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text     = 'Delete operation failed.' ) )
               TO reported-first_node.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_par1to2.
  ENDMETHOD.

  METHOD cba_par1to2.
  ENDMETHOD.
ENDCLASS.


CLASS lhc_second_node DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE second_node.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE second_node.

    METHODS read FOR READ
      IMPORTING keys FOR READ second_node RESULT result.

    METHODS rba_par2to1 FOR READ
      IMPORTING keys_rba FOR READ second_node\_par2to1 FULL result_requested RESULT result LINK association_links.

    METHODS rba_par2to3 FOR READ
      IMPORTING keys_rba FOR READ second_node\_par2to3 FULL result_requested RESULT result LINK association_links.

    METHODS cba_par2to3 FOR MODIFY
      IMPORTING entities_cba FOR CREATE second_node\_par2to3.

ENDCLASS.


CLASS lhc_second_node IMPLEMENTATION.
  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_par2to1.
  ENDMETHOD.

  METHOD rba_par2to3.
  ENDMETHOD.

  METHOD cba_par2to3.
  ENDMETHOD.
ENDCLASS.


CLASS lhc_third_node DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE third_node.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE third_node.

    METHODS read FOR READ
      IMPORTING keys FOR READ third_node RESULT result.

    METHODS rba_par3to2 FOR READ
      IMPORTING keys_rba FOR READ third_node\_par3to2 FULL result_requested RESULT result LINK association_links.

    METHODS rba_par3to4 FOR READ
      IMPORTING keys_rba FOR READ third_node\_par3to4 FULL result_requested RESULT result LINK association_links.

    METHODS rba_toroot FOR READ
      IMPORTING keys_rba FOR READ third_node\_toroot FULL result_requested RESULT result LINK association_links.

    METHODS cba_par3to4 FOR MODIFY
      IMPORTING entities_cba FOR CREATE third_node\_par3to4.

ENDCLASS.


CLASS lhc_third_node IMPLEMENTATION.
  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_par3to2.
  ENDMETHOD.

  METHOD rba_par3to4.
  ENDMETHOD.

  METHOD rba_toroot.
  ENDMETHOD.

  METHOD cba_par3to4.
  ENDMETHOD.
ENDCLASS.


CLASS lhc_fourth_node DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE fourth_node.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE fourth_node.

    METHODS read FOR READ
      IMPORTING keys FOR READ fourth_node RESULT result.

    METHODS rba_par4to3 FOR READ
      IMPORTING keys_rba FOR READ fourth_node\_par4to3 FULL result_requested RESULT result LINK association_links.

    METHODS rba_toroot FOR READ
      IMPORTING keys_rba FOR READ fourth_node\_toroot FULL result_requested RESULT result LINK association_links.

ENDCLASS.


CLASS lhc_fourth_node IMPLEMENTATION.
  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_par4to3.
  ENDMETHOD.

  METHOD rba_toroot.
  ENDMETHOD.
ENDCLASS.


CLASS lsc_zr_pru_1st_node DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS adjust_numbers    REDEFINITION.

    METHODS save              REDEFINITION.

    METHODS cleanup           REDEFINITION.

    METHODS cleanup_finalize  REDEFINITION.

ENDCLASS.


CLASS lsc_zr_pru_1st_node IMPLEMENTATION.
  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD adjust_numbers.
    LOOP AT zpru_cl_example_buffer=>st_first_node ASSIGNING FIELD-SYMBOL(<ls_first>).
      APPEND INITIAL LINE TO mapped-first_node ASSIGNING FIELD-SYMBOL(<ls_first_target>).
      <ls_first_target>-firstkey = <ls_first>-instance-firstkey.
      <ls_first_target>-%pre-%pid = <ls_first>-pid.
      <ls_first_target>-%pre-%tmp-firstkey = <ls_first>-instance-firstkey.
    ENDLOOP.
  ENDMETHOD.

  METHOD save.
    DATA lt_mod TYPE STANDARD TABLE OF zpru_1st_node WITH EMPTY KEY.

    LOOP AT zpru_cl_example_buffer=>st_first_node ASSIGNING FIELD-SYMBOL(<ls_buffer>).

      APPEND INITIAL LINE TO lt_mod ASSIGNING FIELD-SYMBOL(<ls_mod>).
      <ls_mod>-first_key   = <ls_buffer>-instance-firstkey.
      <ls_mod>-first_field = <ls_buffer>-instance-firstfield.
    ENDLOOP.

    IF lt_mod IS NOT INITIAL.
      MODIFY zpru_1st_node FROM TABLE @lt_mod.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.
