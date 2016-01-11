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

interface adeuib.ide.request.irequest :  
    
    define public property Name       as character no-undo get.
    define public property DialogId   as int no-undo get.
    
    method public logical Execute(UIBHandle as handle,ContextHandle as handle).
    method public character GetResponse( ).
   
end interface.