/* ***********************************************************/
/* Copyright (c) 2015-2016 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------
    File        : cdcfieldpolicy.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : mkondra
    Created     : Tue Nov 24 16:03:54 IST 2015
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define temp-table ttCdcFieldPolicy no-undo serialize-name "cdcFieldPolicies" {1} before-table ttCdcFieldPolicyCopy
    field CdcFieldId           as character         serialize-hidden
    field CdcPolicyId          as character         serialize-name "cdcPolicyId"
    field CdcTablePolicyName   as character       serialize-name "cdcTablePolicyName"
    field ObjectNumber         as integer         serialize-hidden
    field TableName            as char            serialize-hidden
    field SourceTableOwner     as char            serialize-hidden  // used to find field of a table for specific owner 
    field FieldName            as char            serialize-name "fieldName"
    field IndexName            as char            serialize-hidden
    field IdentifyingField     as integer         serialize-name "identifyingField" init ?
    field FieldPosition        as int         serialize-name "fieldPosition"  
    field FieldRecId           as recid         serialize-name "fieldRecId"  
    field Misc                 as character extent 16       serialize-hidden
    field InternalSort         as int             serialize-hidden /* remove */
     
    {daschema/entity.i}
   
    index idxName       as primary unique FieldName  
    //index idxIdentifyingField       as  unique IdentifyingField    
    index idxPolicy         CdcTablePolicyName
    index idxObj            ObjectNumber  
 .
