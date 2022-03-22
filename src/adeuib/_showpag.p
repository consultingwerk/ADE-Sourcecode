&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : adeuib/_showpag.p
    Purpose     : The page of a SmartContainer has changed. 
                  Hide SmartObjects on other pages and show
                  objects in the current page.  

    Parameters  : p_Precid - The recid of this procedure
                  pi_newPage - the number of the new page

    Author(s)   : Wm.T.Wood
    Created     : Feb. 16, 1996
    Notes       : A value of ? for newPage will display all pages.
    
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER p_Precid   AS RECID NO-UNDO.
DEFINE INPUT PARAMETER pi_newPage AS INTEGER NO-UNDO.

DEFINE VARIABLE iAdmVersion AS INTEGER    NO-UNDO.
/* Standard Include Files */

{ adeuib/sharvars.i } /* Shared variables */
{ adeuib/uniwidg.i }  /* Universal Widget Temp-Table      */
{ adeuib/links.i }    /* ADM Links temp-table */

/* ***************************  Main Block  *************************** */

/* Get the current Procedure record. */
FIND _P WHERE RECID(_P) eq p_Precid.
FIND _U WHERE RECID(_U) eq _P._u-recid.

/* Only Page 0 is allowed for alternate layouts. */
IF _U._LAYOUT-NAME ne 'Master Layout':U THEN pi_newPage = 0.

/* Set the current page. */

_P._page-current = pi_newPage.
        /* The format is adm2 with no period, but just in case... */
iAdmVersion = DEC(REPLACE(ENTRY(1,_P._adm-version,".":U),'ADM':U,'':U)) NO-ERROR.

  /* If there are any Page-Source for this procedure, and if there is a single
   design page then try setting the folder/tab page. */
IF _P._page-current ne ? THEN DO:
  FOR EACH _admlinks WHERE _admlinks._link-dest   eq STRING(p_Precid)
                       AND _admlinks._link-type   eq 'Page':U,
      FIRST _U WHERE RECID(_U) eq INTEGER(_admlinks._link-source)
                 AND _U._STATUS eq "NORMAL":U,
      FIRST _S WHERE RECID(_S) eq _U._x-recid:
    
      /* Changed from show-current-page to showCurrentPage (98-11-06-039) */
      RUN showCurrentPage IN _S._HANDLE (_P._page-current) NO-ERROR.
  END.
END. /* IF...page-current ne ? ... */

/* Hide objects that are NOT on this page, and show objects that are. */
FOR EACH _U WHERE _U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
              AND _U._TYPE eq "SmartObject":U
              AND _U._STATUS eq "NORMAL":U,
   FIRST _S WHERE RECID(_S) eq _U._x-recid:

  /* Show everything on this page or on page 0.
     NOTE: _P._page-current = ? implies "Show All Pages". */
  IF (_S._page-number eq 0) OR (_P._page-current eq ?) OR
     (_S._page-number eq _P._page-current)          THEN 
  DO:
    /* Object should be VISIBLE.  Tell objects with their own
       visualization to view themselves. */
    IF NOT _U._HANDLE:VISIBLE THEN 
    DO:
      IF _S._visual THEN 
      DO:

        IF iAdmVersion >= 2 THEN
          RUN viewObject IN _S._HANDLE NO-ERROR.
        ELSE
          RUN dispatch IN _S._HANDLE ("view":U) NO-ERROR. 
      END.        
      /* Made sure it really was viewed. */
      IF NOT _U._HANDLE:VISIBLE THEN _U._HANDLE:HIDDEN = no.
    END.
  END. /* IF Object should be VISIBLE...  */
  ELSE DO:
    /* Object should be hidden. */
    IF _U._HANDLE:VISIBLE THEN 
    DO:
      /* If it is SELECTED, then deselect it. PROGRAMMING NOTE: I don't like
         to APPLY events directly, but the procedure in uibmproe.i (setdeselection)
         does not take an arguement for the widget. */
      IF _U._SELECTEDib THEN DO:
        APPLY "DESELECTION":U TO _U._HANDLE.
        _U._HANDLE:SELECTED = FALSE.
      END.
      /* Hide the smartobject */
      IF _S._visual THEN
      DO:
        IF iAdmVersion >= 2 THEN
          RUN hideObject IN _S._HANDLE NO-ERROR.
        ELSE
          RUN dispatch IN _S._HANDLE ("hide":U) NO-ERROR.  
      END.
      /* Made sure it really was hidden. */
      IF _U._HANDLE:VISIBLE THEN _U._HANDLE:HIDDEN = yes. 
    END.
  END. /* IF...ELSE Object should be hidden... */
END. /* FOR EACH _U ... */

/* Display the current page in the UIB. */
RUN display_page_number IN _h_UIB.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


