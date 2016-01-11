/*************************************************************/
/* Copyright (c) 2010 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : extent.i
    Author(s)   : hdaniels
    Created     : Fri Jun 11 20:16:59 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 define temp-table ttExtent no-undo serialize-name "extents" {1} before-table ttExtentCopy 
    field AreaName      as character serialize-name "areaName"
    field AreaNumber    as integer init ? serialize-hidden
    field Number        as integer   serialize-name "number"
    field FileName      as character serialize-name "fileName"
    field Path          as character serialize-name "path"
    field IsFixed       as logical   serialize-name "isFixed"
    field Size          as integer   serialize-name "size"
    {daschema/entity.i}
    index idxInternal  as primary unique AreaNumber Number 
    index idxName     as unique AreaName Number.
  
    
