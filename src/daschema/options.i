/*************************************************************/
/* Copyright (c) 2010 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : options.i
    Purpose     : 
    Description : 

    Author(s)   : hdaniels
    Created     : Oct 2010
    Notes       :
  ----------------------------------------------------------------------*/

define temp-table ttOptions no-undo serialize-name "options" {1}
    field Name as char format "x(12)" label "Name" serialize-name "name"
    field ForceCommit  as logical serialize-name "forceCommit"
    field AddObjectsOnline as logical serialize-name "addObjectsOnline"
    field ForceIndexDeactivate as logical serialize-name "forceIndexDeactivate"
    field ForceSharedSchema as logical serialize-name "forceSharedSchema"
    field ForceAllocation as char serialize-name "forceAllocation"
     
    {daschema/entity.i}
    index idxtask as primary unique Name  . 
 