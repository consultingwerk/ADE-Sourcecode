/*************************************************************/
/* Copyright (c) 2010 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : field.i
    Purpose     : 
    Created     : Fri Jun 11 20:22:56 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define temp-table ttField no-undo serialize-name "lobFields" {1}
    field Name          as character serialize-name "name"
    field TableName     as character serialize-name "tableName"
    field Description   as character serialize-name "description"
    field AreaName      as character serialize-name "areaName"
    field AreaUrl       as character serialize-name "area_url"
    field IsMultitenant as logical   serialize-name "isMultitenant"
 
/*     field IsMandatory     as logical  */
/*     field IsCaseSensitive as logical  */
    field tRowid          as rowid     serialize-hidden
    field DataType        as character serialize-name "dataType"
/*     field DisplayFormat   as character*/
/*     field SideLabel       as character*/
/*     field ColumnLabel     as character*/
/*     field initialValue    as character*/
/*     field Order           as integer  */
/*     field NumDecimals     as integer  */
/*     field NumExtents      as integer  */
/*     field Position        as integer  */
   
/*     field HelpText        as character*/
     
    {daschema/entity.i} 
      index idxName          Name
    index idxRid as unique  tRowid
    index idxTable as primary unique TableName Name
/*     index idxArea AreaName Name*/
    .
