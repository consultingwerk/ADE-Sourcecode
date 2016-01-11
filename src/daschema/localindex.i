/*************************************************************/
/* Copyright (c) 2014 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Author(s)   : hdaniels
    Created     :  
    Notes       : crossref for local indexes  
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 define temp-table ttLocalIndex no-undo serialize-name "localIndexes" {1} before-table ttLocalIndexCopy
     field PartitionPolicyName    as character serialize-name "partitionPolicyName"
     field TableName     as character serialize-hidden /*name "tableName"*/
     /* currently not used in index or find on client */
     field SchemaName     as character serialize-hidden /*name "schemaName"*/
     field IndexName     as character serialize-name "indexName"
     field IndexUrl     as character serialize-name "index_url"

    {daschema/entity.i}
   
    index idxPol  as  primary unique PartitionPolicyName IndexName   
    index idxTbl  as  unique TableName IndexName  
    .
    
