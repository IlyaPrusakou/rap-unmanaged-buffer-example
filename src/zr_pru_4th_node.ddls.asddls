@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fourth Node'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_PRU_4TH_NODE
  as select from ZI_PRU_4th_NODE
  association to parent ZR_PRU_3RD_NODE as _par4to3 on  $projection.FirstKey  = _par4to3.FirstKey
                                                    and $projection.SecondKey = _par4to3.SecondKey
                                                    and $projection.ThirdKey  = _par4to3.ThirdKey
   association of many      to exact one Zr_PRU_1ST_NODE as _toRoot on  _toRoot.FirstKey = $projection.FirstKey                                                        
{
  key FirstKey,
  key SecondKey,
  key ThirdKey,
  key FourthKey,
      FourthField,
      /* Associations */
      _from4to3,
      _toRoot,
      _par4to3 // Make association public
}
