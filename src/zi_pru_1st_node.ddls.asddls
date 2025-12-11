@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'First Node'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PRU_1ST_NODE
  as select from zpru_1st_node
  association of exact one to many ZI_PRU_2ND_NODE as _from1to2 on _from1to2.FirstKey = $projection.FirstKey
{
  key first_key   as FirstKey,
      first_field as FirstField,
      _from1to2
}
