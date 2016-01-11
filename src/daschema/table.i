/*************************************************************/
/* Copyright (c) 2010 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : table.i
    Author(s)   : hdaniels
    Created     : Fri Jun 11 20:16:59 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 define temp-table ttTable no-undo serialize-name "tables"  {1} before-table ttTableCopy
     field SchemaName      as character serialize-name "schemaName"
     field Name            as character serialize-name "name"
     field Description     as character serialize-name "description"
     field IsMultitenant   as logical   serialize-name "isMultitenant"
     field KeepDefaultArea as logical   serialize-name "keepDefaultArea"
     field tRowid          as rowid     serialize-hidden
     field AreaName        as character serialize-name "areaName"
     field AreaUrl         as character serialize-name "area_url"
     field PartitionsUrl   as character serialize-name "partitions_url"
  
/*    field DumpName      as character*/
/*    field DisplayName   as character*/
/*    field Description   as character*/
/*    field entity        as Progress.Lang.Object*/
    {daschema/entity.i}  
    index idxSchemaName as primary unique SchemaName Name
    index idxName Name
    index idxRid as unique  tRowid
    index idxArea AreaName.
    
    
