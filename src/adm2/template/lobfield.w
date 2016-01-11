&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
/* Procedure Description
"ADM2 SmartLOB Template.

Use this template as a starting point for creating SmartLOB Objects. A SmartLOB can be constructed to allow visual components and objects to use local variables for visualization and editing of LOB data, and can be inserted into a SmartViewer."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS lobObject 
/*------------------------------------------------------------------------

  File:

  Description: - Template for ADM2 SmartLOBField object

  Created: April 2004 -- Progress Version 10.0B

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Instance variables used fro LOBData*/
DEFINE VARIABLE gmValue         AS MEMPTR    NO-UNDO.
DEFINE VARIABLE gcLongcharValue AS LONGCHAR  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartLOBField
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fillData lobObject 
FUNCTION fillData RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fillLongcharValue lobObject 
FUNCTION fillLongcharValue RETURNS LOGICAL
  ( pcColumn AS CHAR,
    phSource AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLongcharValue lobObject 
FUNCTION getLongcharValue RETURNS LONGCHAR
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPointerValue lobObject 
FUNCTION getPointerValue RETURNS MEMPTR
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 50 BY 6.52.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartLOBField Template
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW lobObject ASSIGN
         HEIGHT             = 6.52
         WIDTH              = 50.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB lobObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/lobfield.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW lobObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartObjectCues" lobObject _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartObject,ab,247
Create a SmartLOBField Object to represent a SmartDataObject LOB field in a non-standard visualization.

* Creating a SmartDataField Object
1) Add visualization for the LOB field.
2) Add code for the enableField and disableField procedures.
3) Add code to set the DataModified property when the field value changes.
4) Add code in fillData that uses the LOB value
4) Save and close the object.

*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK lobObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearField lobObject 
PROCEDURE clearField :
/*------------------------------------------------------------------------------
  Purpose:   Called from viewer when there is no record available   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /* Add code to empty visual objects                                                           
  Example:   MyImage:LOAD-IMAGE('empty.bmp').
  */                                                 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableField lobObject 
PROCEDURE disableField :
/*------------------------------------------------------------------------------
  Purpose:   Disable the field   
  Parameters:  <none>
  Notes:    SmartDataViewer:disableFields will call this for all Objects of type
            PROCEDURE that it encounters in the EnableFields Property.  
            The developer must add logic to disable the actual SmartField.    
------------------------------------------------------------------------------*/
   
   {set FieldEnabled FALSE}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI lobObject  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableField lobObject 
PROCEDURE enableField :
/*------------------------------------------------------------------------------
  Purpose:   Enable the field   
  Parameters:  <none>
  Notes:    SmartDataViewer:enableFields will call this for all Objects of type
            PROCEDURE that it encounters in the EnableFields Property.  
            The developer must add logic to enable the SmartField.    
------------------------------------------------------------------------------*/
   
   {set FieldEnabled TRUE}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fillData lobObject 
FUNCTION fillData RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: This event fills the LOB data to the object's TempLocation and is 
           fired on each record change if AutoFill is true. 
           If AutoFill is false it must be run manually.               
    Notes: clearField is being run when no record is available 
------------------------------------------------------------------------------*/
   
   SUPER().

   /* 
   Use getLOBfileName or getPointerValue to get access to the data if 
   TempLocation is 'File'  or 'Memptr'.
   Example:   MyImage:LOAD-IMAGE({fn getLOBFileName}) NO-ERROR.
   If TempLocation is 'Longchar' then getLongcharValue returns the 
   data, but in this case it may be more efficient to do the data filling 
   in the fillLongcharValue event handler and delete this override  */
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fillLongcharValue lobObject 
FUNCTION fillLongcharValue RETURNS LOGICAL
  ( pcColumn AS CHAR,
    phSource AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: This is fired from the fillData event when the TempLocation 
           is 'longchar'.  
    Notes: The longchar variable need to be defined in each instance, so there
           event handler is not defined in the class. (no super).              
------------------------------------------------------------------------------*/                                                                    
  
 /* If for example a progress large longchar editor is used to visualize the LOB
    then the screen-value can be assigned directly instead of using the instance
    variable. NOTE getLongcharValue must be changed accordingly   
  MyEditor:screen-value = {fnarg columnLongCharValue pcColumn phSource}.*/ 

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLongcharValue lobObject 
FUNCTION getLongcharValue RETURNS LONGCHAR
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns this instance Longchar Value 
    Notes:  
------------------------------------------------------------------------------*/  
  
   /* This function needs to return the data from the longchar field/object 
      that fillLongcharValue() is filling. 
      If for example fillLongcharValue is assigning the screen-value of 
      a large longchar editor then this could:       
     RETURN MyEditor:input-value */

  RETURN gcLongcharValue. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPointerValue lobObject 
FUNCTION getPointerValue RETURNS MEMPTR
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: Returns this instance Memory Pointer 
           Used by FillData if TempLocation is 'Memptr'  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN gmValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

