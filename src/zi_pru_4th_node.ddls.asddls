@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fourth Node'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PRU_4th_NODE
  as select from zpru_4th_node
  association of many to exact one ZI_PRU_3RD_NODE as _from4to3 on  _from4to3.FirstKey  = $projection.FirstKey
                                                                and _from4to3.SecondKey = $projection.SecondKey
                                                                and _from4to3.ThirdKey  = $projection.ThirdKey
{
  key first_key   as FirstKey,
  key second_key  as SecondKey,
  key third_key   as ThirdKey,
  key Fourth_key   as FourthKey,
      Fourth_field as FourthField,
      _from4to3
}
