@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Third Node'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PRU_3RD_NODE
  as select from zpru_3rd_node
  association of many      to exact one ZI_PRU_2ND_NODE as _from3to2 on  _from3to2.FirstKey  = $projection.FirstKey
                                                                     and _from3to2.SecondKey = $projection.SecondKey
  association of exact one to many ZI_PRU_4th_NODE      as _from3to4 on  _from3to4.FirstKey  = $projection.FirstKey
                                                                     and _from3to4.SecondKey = $projection.SecondKey
                                                                     and _from3to4.ThirdKey  = $projection.ThirdKey

{
  key first_key   as FirstKey,
  key second_key  as SecondKey,
  key third_key   as ThirdKey,
      third_field as ThirdField,
      _from3to2,
      _from3to4
}
