/*************************************************************/
/* Copyright (c) 2013 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Author(s)   : hdaniels
    Created     : Fri Jun 11 20:16:59 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 define temp-table ttPartitionPolicyField no-undo serialize-name "partitionPolicyFields" {1} before-table ttPartitionPolicyFieldCopy
     field Number           as int       serialize-name "number"
     field PartitionPolicyName as character serialize-name "partitionPolicyName"
     field TableName        as character serialize-hidden /*serialize-name "tableName"*/
     field FieldName        as character serialize-name "fieldName"
     field DataType         as character serialize-name "dataType"
     field Description      as character serialize-name "description"
     
    {daschema/entity.i}
    /* important to export these in numbered order */
    index idxSeq       as  primary unique PartitionPolicyName Number
    index idxFld       as  unique PartitionPolicyName FieldName
  .
    
