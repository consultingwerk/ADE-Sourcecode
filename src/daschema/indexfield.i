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
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 define temp-table ttIndexField no-undo serialize-name "indexFields" {1}
     field Number        as int       serialize-name "number"
     field TableName     as character serialize-name "tableName"
     field FieldName     as character serialize-name "fieldName"
     field IndexName     as character serialize-name "indexName"
     field tRowid        as rowid     serialize-hidden
     field DataType      as character serialize-name "dataType"
     field Description   as character serialize-name "description"
  
     field IsAscending   as logical serialize-name "IsAscending" init true
     field IsAbbreviate  as logical serialize-name "IsAbbreviate"

    {daschema/entity.i}
   
    index idxSeq       as  primary unique TableName IndexName Number
    index idxFld       as  unique TableName FieldName IndexName  
    index idxRid as unique  tRowid
  .
    
