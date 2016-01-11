/*************************************************************/
/* Copyright (c) 2012 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : iideeventservice
    Purpose     : Service requests from the IDE
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
 
    Notes       : in this form this is almost unneccesary as we could
                  have just used the procedure handle, but
                  this allows us to use the same mechanism for the more
                  advanced dialog service that keeps track of  buttons nad
                  frame 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

interface adeuib.iideeventservice :  
 
    method public void RunEvent().
    method public void SetCurrentEvent(phHandle as handle,pevent as char).
    
end interface.