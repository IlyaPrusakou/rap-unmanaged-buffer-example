@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Second Node'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_PRU_2ND_NODE
  as select from ZI_PRU_2ND_NODE
  association to parent Zr_PRU_1ST_NODE as _par2to1 on _par2to1.FirstKey = $projection.FirstKey
  composition [*] of ZR_PRU_3RD_NODE    as _par2to3
  association of many      to exact one ZI_PRU_1ST_NODE as _toRoot on  _toRoot.FirstKey = $projection.FirstKey

{
  key FirstKey,
  key SecondKey,
      SecondField,
      /* Associations */
      _par2to1,
      _par2to3,
      _toRoot
}
