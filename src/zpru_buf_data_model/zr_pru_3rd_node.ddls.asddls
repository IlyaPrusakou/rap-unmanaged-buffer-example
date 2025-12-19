@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Third Node'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_PRU_3RD_NODE
  as select from ZI_PRU_3RD_NODE
  association to parent ZR_PRU_2ND_NODE as _par3to2 on  $projection.FirstKey  = _par3to2.FirstKey
                                                    and $projection.SecondKey = _par3to2.SecondKey
    composition [*] of ZR_PRU_4TH_NODE    as _par3to4
  association of many      to exact one Zr_PRU_1ST_NODE as _toRoot on  _toRoot.FirstKey = $projection.FirstKey                                                      
{
  key FirstKey,
  key SecondKey,
  key ThirdKey,
      ThirdField,
      /* Associations */
      //    _from3to2,
      //    _from3to4,
      _par3to4,
      _toRoot,
      _par3to2 // Make association public
}
