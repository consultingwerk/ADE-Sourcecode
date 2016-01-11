/*************************************************************/
/* Copyright (c) 2010 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : index.i
    Author(s)   : hdaniels
    Created     : Fri Jun 11 20:16:59 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 define temp-table ttIndex no-undo serialize-name "indexes" {1}
     field Name          as character serialize-name "name"
     field TableName     as character serialize-name "tableName"
     field Description   as character serialize-name "description"
     field AreaName      as character serialize-name "areaName"
     field AreaUrl       as character serialize-name "area_url"
     field IsMultitenant as logical   serialize-name "isMultitenant"
     field tRowid        as rowid     serialize-hidden
  
     field IsActive      as logical serialize-name "isActive"
     field IsUnique      as logical serialize-name "isUnique"
     field IsPrimary     as logical serialize-name "isPrimary"
     field IsWordIndex   as logical serialize-name "isWordIndex"

    {daschema/entity.i}
   
    index idxName       as  primary unique TableName Name
    index idxRid as unique  tRowid
    index idxTable Name
/*    index idxArea AreaName Name*/
  .
    
