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
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
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

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS adjust_numbers REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zr_pru_1st_node IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD adjust_numbers.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
