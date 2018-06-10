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
 define temp-table ttIndex no-undo serialize-name "indexes" {1} before-table ttIndexCopy 
     field Name          as character serialize-name "name"
     /* not used in index or join - only for serve lookup*/
     field SchemaName    as character  serialize-hidden  
 
     field TableName     as character serialize-name "tableName"
     field Description   as character serialize-name "description"
     field AreaName      as character serialize-name "areaName"
      /* areanumber is optional and not in use as of current 
      - can be used to avoid find of area in datasource if Lazy support for index */
     field AreaNumber    as integer   serialize-hidden  
     field AreaUrl       as character serialize-name "area_url"
     field IsMultitenant as logical   serialize-name "isMultitenant"
     field tRowid        as rowid     serialize-hidden
     field IndexFieldUrl as char      serialize-name "indexfields_url"
     field FieldUrl      as char      serialize-name "fields_url"
     field IsLocal       as logical serialize-name "isLocal"
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
    
