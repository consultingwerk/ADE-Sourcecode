/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : sequence.i
    Author(s)   : hdaniels
    Created     :  
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 define temp-table ttSequence no-undo serialize-name "sequences"  {1} before-table ttSequenceCopy
     field SchemaName        as character serialize-name "schema"
     field Name              as character serialize-name "name"
     field IsMultitenant     as logical   serialize-name "isMultitenant"
     field InitialValue      as int64   serialize-name "initialValue"
     field CurrentValue      as int64     serialize-name "currentValue"
     field IncrementValue    as int64   serialize-name "incrementValue"
     field MinimumValue      as int64   serialize-name "minimumValue"
     field MaximumValue      as int64   serialize-name "maximumValue"
     field Url               as character serialize-name "url"
     field IsCyclic          as logical   serialize-name "isCyclic"
     field SequenceValuesUrl as char serialize-name "sequenceValues_url"
     
 
/*    field DumpName      as character*/
/*    field DisplayName   as character*/
/*    field Description   as character*/
/*    field entity        as Progress.Lang.Object*/
     field tRowid   as rowid serialize-hidden
/*     field CurrentValuesUrl as char serialize-name "currentValuesUrl"*/
     {daschema/entity.i}
     index idxSchemaName as unique primary SchemaName Name
     index idxRid as unique tRowid
     index idxName Name.
    