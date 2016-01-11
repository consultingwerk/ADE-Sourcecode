/*************************************************************/
/* Copyright (c) 2012 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : restbase.i
    Purpose     : deprecated main block of rest .p procedures
                 c<mode>_<collection> .p 
    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Fri Mar 16 13:43:48 EDT 2012
    Notes       :  
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */ 
  
define variable mMode       as char init "{1}" no-undo.
define variable mCollection as char init "{2}" no-undo.
 
if session:batch-mode and not this-procedure:persistent then 
do:
   output to value("get_administrators.log"). 
   run executeRequest(session:parameter).  
end.
finally:
    if session:batch-mode then output close.            
end finally.  

procedure executeRequest:
    define input parameter pcURL as character no-undo.
    define variable restRequest  as IRestRequest no-undo.
    define variable lupload      as logical no-undo.
    &if "{3}" = "upload" &then 
    lupload = true.
    &endif
    restRequest = new OpenEdge.DataAdmin.Rest.RestRequest(mMode,mCollection,pcUrl,lupload).  
    
    run execute in target-procedure(restRequest).  
end procedure.

 


