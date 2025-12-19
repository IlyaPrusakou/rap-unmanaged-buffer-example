CLASS zpru_cl_buffer_test DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zpru_cl_buffer_test IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    MODIFY ENTITIES OF zr_pru_1st_node
           ENTITY first_node
           CREATE FIELDS (
           firstkey
  firstfield )
           WITH VALUE #( %control-firstkey   = if_abap_behv=>mk-on
                         %control-firstfield = if_abap_behv=>mk-on
                         ( %cid = '1' firstkey = '1' firstfield = 'c1' )
                         ( %cid = '2' firstkey = '2' firstfield = 'c2' ) )
           MAPPED DATA(ls_map).


    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lt_root_k TYPE TABLE FOR KEY OF zr_pru_1st_node\\first_node.

    " TODO: variable is assigned but never used (ABAP cleaner)
    COMMIT ENTITIES BEGIN RESPONSE OF zr_pru_1st_node FAILED DATA(ls_failed_commit) REPORTED DATA(ls_reported_commit).
    IF ls_failed_commit IS INITIAL.
      LOOP AT ls_map-first_node ASSIGNING FIELD-SYMBOL(<ls_order_mapped_early>).
        APPEND INITIAL LINE TO lt_root_k ASSIGNING FIELD-SYMBOL(<ls_order_k>).
        CONVERT KEY OF zr_pru_1st_node\\first_node
                FROM TEMPORARY VALUE #( %pid          = <ls_order_mapped_early>-%pky-%pid
                                        %tmp-FirstKey = <ls_order_mapped_early>-%pky-FirstKey ) TO <ls_order_k>.
      ENDLOOP.
    ENDIF.

    COMMIT ENTITIES END.
  ENDMETHOD.
ENDCLASS.
