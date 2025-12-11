@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Second Node'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PRU_2ND_NODE
  as select from zpru_2nd_node
  association of many      to exact one ZI_PRU_1ST_NODE as _from2to1 on  _from2to1.FirstKey = $projection.FirstKey
  association of exact one to many ZI_PRU_3RD_NODE      as _from2to3 on  _from2to3.FirstKey  = $projection.FirstKey
                                                                     and _from2to3.SecondKey = $projection.SecondKey
{
  key first_key    as FirstKey,
  key second_key   as SecondKey,
      second_field as SecondField,
      _from2to1,
      _from2to3
}
