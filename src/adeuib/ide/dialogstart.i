/*************************************************************/
/* Copyright (c) 2012 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : dialogstart
    Purpose     : Set frame info for dialogService and view the hosted window
                   
                  Use dialoginit.i to start the service  

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Fri Feb 03 22:25:53 EST 2012
    Preprocessor param 
     &CANCEL-EVENT use when the dialog need to run 
                   as child. If the wait-for is in an undo, leave or
                   transaction block endkey does not work.
        
                The WAIT-FOR need to be edited as follows
      
                &if DEFINED(IDE-IS-RUNNING) = 0  &then
                    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
                &else
                    WAIT-FOR GO OF FRAME {&FRAME-NAME} or "{&CANCEL-EVENT}" of this-procedure.       
                    if cancelDialog THEN UNDO, LEAVE.  
                &endif
    
    NOTE       : Use together with dialoginit.i and add this right before 
                 the WAIT-FOR
  ----------------------------------------------------------------------*/
 &if DEFINED(IDE-IS-RUNNING) <> 0  &then
     &if DEFINED(IDE-DIALOG-START) = 0 &THEN
      define variable cancelDialog as logical no-undo. 
      &GLOBAL-DEFINE IDE-DIALOG-START  
     &ENDIF

     dialogService:View().
     dialogService:SetOkButton({1}:handle {4}).
     dialogService:SetCancelButton({2}:handle {4}).
     dialogService:Title = {3}.
   
   &if "{&CANCEL-EVENT}" <> "" &then
     /* endkey does not work it seems when we are a child of 
        another dialog running from ide */
     ON CHOOSE OF {2} {4} DO:
         cancelDialog = true.
         apply "{&CANCEL-EVENT}" to this-procedure.
     END.
   &endif
 &endif
 