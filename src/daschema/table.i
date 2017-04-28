/*************************************************************/
/* Copyright (c) 2010-2016 by progress Software Corporation  */
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
     field SchemaName            as character serialize-name "schemaName"
     field Name                  as character serialize-name "name"
     field Id                    as integer  serialize-hidden
     field Description           as character serialize-name "description"
     field IsMultitenant         as logical   serialize-name "isMultitenant"
     field IsPartitioned         as logical   serialize-name "isPartitioned"
     field IsCDCEnabled          as logical   serialize-name "isCDCEnabled"
     field IsChangeTable         as logical   serialize-name "isChangeTable"
     field HasType1Area          as logical   serialize-hidden
     field PartitionPolicyName   as character serialize-name "partitionPolicyName"
     field CdcTablePolicyName   as character serialize-name "cdcTablePolicyName"
     field KeepDefaultArea as logical   serialize-name "keepDefaultArea"
     field tRowid          as rowid     serialize-hidden
     field AreaName        as character serialize-name "areaName"
     field AreaUrl         as character serialize-name "area_url"
     field PartitionPolicyUrl   as character serialize-name "partitionPolicy_url"
     field CdcTablePolicyUrl   as character serialize-name "cdcTablePolicy_url"
     field PartitionsUrl   as character serialize-name "partitions_url"
     field IndexUrl        as character serialize-name "indexes_url"
     field FieldUrl        as character serialize-name "fields_url"
     field Url             as character serialize-name "url"
     field Hidden          as logical   serialize-hidden 
    
/*    field DumpName      as character*/
/*    field DisplayName   as character*/
/*    field Description   as character*/
/*    field entity        as Progress.Lang.Object*/
    {daschema/entity.i}  
    index idxSchemaName as primary unique SchemaName Name
    index idxName Name
    index idxRid as unique  tRowid
    index idxArea AreaName.
    
    
