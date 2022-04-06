&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
/************************************************************************
* Copyright (C) 2000,2013 by Progress Software Corporation. All rights  *
* reserved. Prior versions of this work may contain portions            *
* contributed by participants of Possenet.                              *
*                                                                       *
************************************************************************/
/*------------------------------------------------------------------------

  File: Select DataSource

  Description: dialog boc that calls the persitent procedure to 
               update dataSource. (Also called from _wizds.w)  

  Input Parameters:
      <none>

  Output Parameters:
      <none>

   Author:  Haavard Danielsen
  Created: 13/7/98 
  
     Note: This procedure MUST NOT CREATE a widget-pool because a _U widget
           may be created  for the query
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/********* 

DON'T CREATE WIDGET-POOL.
BECAUSE THIS PROCEDURE MAY CREATE A QUERY WHICH NEEDS A WIDGET 

********/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

&GLOBAL-DEFINE WIN95-BTN YES

{adeuib/uibhlp.i}
define variable cTitle as character no-undo init "Select DataSource".



/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME gDialog

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */




/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     SPACE(55.06) SKIP(10.21)
    WITH 
 &if DEFINED(IDE-IS-RUNNING) = 0  &then  
    TITLE cTitle
    VIEW-AS DIALOG-BOX
 &else
    NO-BOX
 &endif 
    KEEP-TAB-ORDER 
    SIDE-LABELS 
    NO-UNDERLINE 
    THREE-D  
    SCROLLABLE .
         
  
 {adeuib/ide/dialoginit.i "FRAME gDialog:handle"}
 

/* ***********  Runtime Attributes   *********** */

 
&IF DEFINED(IDE-IS-RUNNING) = 0 &THEN
    ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.
&ENDIF 
 

/* ************************  Control Triggers  ************************ */
 
ON WINDOW-CLOSE OF FRAME gDialog /* Select DataSource */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.
 
/* ***************************  Main Block  *************************** */


def var hdl as handle.

RUN adeuib/_datasrc.w PERSISTENT SET hdl.

DYNAMIC-FUNCTION('setParent' in HDL, FRAMe {&FRAME-NAME}:HANDLE).
DYNAMIC-FUNCTION('setHTMLMapping' in HDL, TRUE).
DYNAMIC-FUNCTION('setIsFirst'    in HDL,TRUE).
&if DEFINED(IDE-IS-RUNNING) <> 0  &then
   FRAME {&FRAME-NAME}:scrollable = true.
   FRAME {&FRAME-NAME}:virtual-width = 57.57.
   FRAME {&FRAME-NAME}:virtual-height = 13.62.
   dialogService:SizeToFit().
&endif
RUN initializeObject in hdl.

ON GO OF FRAME {&FRAME-NAME} DO:
  RUN SaveData in hdl (true) no-error.
  IF ERROR-STATUS:ERROR THEN 
    RETURN NO-APPLY. 
END. 

 
{adecomm/okbar.i &TOOL    = "AB"
                 &CONTEXT = {&Help_on_DataSource} }



VIEW FRAME {&FRAME-NAME}. 
DO TRANSACTION ON ENDKEY UNDO,LEAVE ON ERROR  UNDO,LEAVE:
     &scoped-define CANCEL-EVENT U2
     {adeuib/ide/dialogstart.i btn_ok btn_cancel cTitle}
        &if DEFINED(IDE-IS-RUNNING) = 0  &then
        
          WAIT-FOR "GO" OF FRAME {&FRAME-NAME}.
        &ELSE
          WAIT-FOR "GO" OF FRAME {&FRAME-NAME} or "U2" of this-procedure.       
        if cancelDialog THEN UNDO, LEAVE.  
      &endif
END.

RUN destroyObject in hdl.



/* **********************  Internal Procedures  *********************** */

PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME gDialog.
END PROCEDURE.


PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.


