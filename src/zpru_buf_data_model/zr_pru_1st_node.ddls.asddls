@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'First Node'
@Metadata.ignorePropagatedAnnotations: true
define root view entity Zr_PRU_1ST_NODE as select from ZI_PRU_1ST_NODE
composition [ * ] of ZR_PRU_2ND_NODE as _par1to2
{
    key FirstKey,
    FirstField,
    /* Associations */
//    _from1to2,
    _par1to2 // Make association public
}
