/*************************************************************/
/* Copyright (c) 2012 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : read and save design windows to  _uibmain 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
 
    Notes       :   
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using adeuib.ide.request.irequest from propath.

interface adeuib.ide.request.idesignrequest inherits irequest :  
    
    define public property IsSaved    as logical no-undo get.
    define public property IsRepositoryObject as logical no-undo get.
    define public property IsDynamic  as logical no-undo get.
    define public property IsNative   as logical no-undo get.
    define public property NewName    as character no-undo get.
    
end interface.