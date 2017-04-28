
/*------------------------------------------------------------------------
    File        : cdctablepolicyfield.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : mkondra
    Created     : Thu Nov 19 12:30:19 IST 2015
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

define temp-table ttCdcTablePolicyField no-undo serialize-name "cdcTablePolicyFields" {1} before-table ttCdcTablePolicyFieldCopy
    field Number           as int       serialize-name "number"
    field CdcTablePolicyName as character serialize-name "cdcTablePolicyName"
    field CdcPolicyId   as int       serialize-hidden
    field TableName        as character serialize-hidden
    field FieldName         as character serialize-name "fieldName"
    field DataType         as character serialize-name "dataType"
    field IdentifyingField as character serialize-name "identifyingField"
     
     
    {daschema/entity.i}
    /* important to export these in numbered order */
    index idxSeq as primary unique CdcTablePolicyName Number
    index idxFld as unique         CdcTablePolicyName FieldName
    .