&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/************************************************************************
  Product:  Copy of SmartPak super procedure for use with ICF

  File: afsuperp.p copied from SmartPak.p
        credit to original smartpak authors.

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&GLOBAL-DEFINE v9t-SUPER

DEFINE VARIABLE colour-table-key-list AS CHAR NO-UNDO.

DEFINE VARIABLE lv-rval AS CHARACTER NO-UNDO.

DEFINE VARIABLE x AS INT NO-UNDO.
DEFINE VARIABLE y AS INT NO-UNDO.

PROCEDURE SHBrowseForFolder EXTERNAL "shell32":U:
  DEFINE INPUT  PARAMETER  lpbi         AS LONG.
  DEFINE RETURN PARAMETER  lpItemIDList AS LONG.
END PROCEDURE.

PROCEDURE SHGetPathFromIDList EXTERNAL "shell32":U:
  DEFINE INPUT  PARAMETER  lpItemIDList AS LONG.
  DEFINE OUTPUT PARAMETER  pszPath      AS CHAR.
END PROCEDURE.

/* These two pre-processors are used for reading and writing registry
   entries for a defined application. To use the registry routines you
   should define these two values. The author is usually your company 
   name and the application is the name of your applicaton.

   They are given default values here, that you should replace with your own.

   See the registry routines in this procedure.
*/
&SCOPED-DEFINE REGKEY_AUTHOR Author
&SCOPED-DEFINE REGKEY_APPLICATION Application

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
   Compile into: gui/adm2/support
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
         HEIGHT             = 12
         WIDTH              = 42.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{af/sup2/afspcolour.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN {&SUPER-HDL} = THIS-PROCEDURE:HANDLE
       {&SUPER-UID} = THIS-PROCEDURE:UNIQUE-ID.

RUN setColourTable.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addColour) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addColour Procedure 
PROCEDURE addColour :
/*------------------------------------------------------------------------------
  Purpose:     Add a user-defined colour to the color-table and the private-data
  			   string.
  Parameters:  pcColourName : the unique name of the colour to be added
  		       pcRGBString  : can be either a single integer value, as returned
  		                      by the getSysColor() Windows API, or a space-delimited
  		                      string of RGB values, like "255 255 255".
			   piColour     : integer value of the colour in the color-table  		                      
  Notes:       * if the colour added already exists in the list of colours, then
    			 replace the RGB values with those passed in.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcColourName        as character          NO-UNDO.
    DEFINE INPUT  PARAMETER pcRGBString         as character          NO-UNDO.
    DEFINE OUTPUT PARAMETER piColour            as integer            NO-UNDO.
    
    /* setColourTable runs from the main block of this procedure, so we know that
       the colours have already been set up.
     */
    piColour = LOOKUP(pcColourName, THIS-PROCEDURE:private-data) no-error.
    
    /* Color doesn't exist private-data string. */
    if piColour eq 0 or piColour eq ? THEN    do:
        COLOR-TABLE:NUM-ENTRIES = COLOR-TABLE:NUM-ENTRIES + 1.
        /* The color-table is zero-based, so the first colour is 0.
           The nth colour is n - 1.
         */
        piColour = COLOR-TABLE:NUM-ENTRIES - 1.
        THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:PRIVATE-DATA + ',' + pcColourName.
    END.    /* no color set */
    
    COLOR-TABLE:SET-DYNAMIC(piColour, TRUE).
    if NUM-ENTRIES(pcRGBString, ' ') gt 1 THEN    do:
        COLOR-TABLE:SET-RED-VALUE(piColour, INTEGER(ENTRY(1, pcRGBString, ' '))).
        COLOR-TABLE:SET-GREEN-VALUE(piColour, INTEGER(ENTRY(2, pcRGBString, ' '))).
        COLOR-TABLE:SET-BLUE-VALUE(piColour, INTEGER(ENTRY(3, pcRGBString, ' '))).
    END.    /* string = 255 255 255 format */
    ELSE
        COLOR-TABLE:SET-RGB-VALUE(piColour, INTEGER(pcRGBString)).
        ERROR-STATUS:ERROR = no.
    return.
END PROCEDURE.  /* addColour */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disable_UI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Procedure  _DEFAULT-DISABLE
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
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColour) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getColour Procedure 
PROCEDURE getColour :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress colour-table colour number for each of
               the colour schema names supplied as input.
  Parameters:  INPUT comma-separated list of colour schema names
  Notes:       Returns an integer list of colour table entries or a list of 
               valid colour schema names when the input parameter is ?.
               Returns ? if the colour table could not be set.
------------------------------------------------------------------------------*/
/* Example:

   If your program needs to find the colour table entry that holds say, the 
   current Window title colour and the Button "shadow" colour, then call this
   routine as follows:

   RUN getColour("ActiveTitle,ButtonShadow").

   In the return value will be two integers (eg. "81,86") which are the 
   colour-table entries for the requested colours: 

   If you want to get a valid list of names to input, call the routine with
   an unknown value in the input parameter. The return-value will contain
   a list of all colour schema names that you can query with a further call
   (eg. "ActiveTitle,ButtonShadow,ButtonText,Hilight,..."). 

   RUN getColour(?).

   You can also get a list of names from the Windows 95 registry under 
   HKEY_CURRENT_USER\Control Panel\Colors

   or

   HKEY_USER\.Default\Control Panel\Colors
*/

DEFINE INPUT PARAMETER ip-colour-list AS CHARACTER NO-UNDO.

/* Initialise the colour table if necessary */
IF colour-table-key-list = "" THEN
    RUN setColourTable IN THIS-PROCEDURE.

IF ip-colour-list <> ? 
THEN DO:

    ASSIGN y = NUM-ENTRIES(ip-colour-list) lv-rval = FILL(",",y - 1).

    DO x = 1 TO y:
        ASSIGN ENTRY(x,lv-rval) = STRING(LOOKUP(ENTRY(x,ip-colour-list),colour-table-key-list)).
    END.
END.
ELSE 
    ASSIGN lv-rval = colour-table-key-list.

RETURN lv-rval.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFolder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFolder Procedure 
PROCEDURE getFolder :
/*------------------------------------------------------------------------------
  Purpose:     Popup Folder Selection Dialog
  Parameters:  INPUT Optional Text, OUTPUT Selected Folder & Result
  Notes:       Thanks to original author.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER DialogTitle$pr AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER FolderName$pr  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER Canceled$pr    AS LOGICAL   NO-UNDO.

/* Local Variable Definitions */
DEF VAR MAX_PATH$v       AS INT INIT 260.
DEF VAR lpbi$v           AS MEMPTR.
DEF VAR pszDisplayName$v AS MEMPTR.
DEF VAR lpszTitle$v      AS MEMPTR.
DEF VAR lpItemIDList$v   AS INT NO-UNDO.

ASSIGN SET-SIZE(lpbi$v)           = 32
       SET-SIZE(pszDisplayName$v) = MAX_PATH$v
       SET-SIZE(lpszTitle$v)      = LENGTH(DialogTitle$pr) + 1.

PUT-STRING(lpszTitle$v,1)  = DialogTitle$pr.

PUT-LONG(lpbi$v, 1) = 0.
PUT-LONG(lpbi$v, 5) = 0.
PUT-LONG(lpbi$v, 9) = GET-POINTER-VALUE(pszDisplayName$v).
PUT-LONG(lpbi$v,13) = GET-POINTER-VALUE(lpszTitle$v).
PUT-LONG(lpbi$v,17) = 1.
PUT-LONG(lpbi$v,21) = 0.
PUT-LONG(lpbi$v,25) = 0.
PUT-LONG(lpbi$v,29) = 0.

RUN SHBrowseForFolder(INPUT  GET-POINTER-VALUE(lpbi$v),
                      OUTPUT lpItemIDList$v ).

/* Parse the result */
IF lpItemIDList$v = 0 THEN
  DO:
   ASSIGN Canceled$pr   = TRUE.
          FolderName$pr = "":U.
  END.
ELSE
  DO:
   ASSIGN Canceled$pr   = FALSE.
          FolderName$pr = FILL(" ":U, MAX_PATH$v).

   RUN SHGetPathFromIDList(lpItemIDList$v, OUTPUT FolderName$pr).

   ASSIGN FolderName$pr = TRIM(FolderName$pr).
END.

/* free used memory */
ASSIGN SET-SIZE(lpbi$v)           = 0
       SET-SIZE(pszDisplayName$v) = 0
       SET-SIZE(lpszTitle$v)      = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRegistry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRegistry Procedure 
PROCEDURE getRegistry :
/*------------------------------------------------------------------------------
  Purpose:    Reads a key value from the registry under:
                'HKEY_CURRENT_USER\Software\{&REGKEY_AUTHOR}\{&REGKEY_APPLICATION}\Settings'

  Parameters: The registry key or identifier.

  Notes:      Returns the registry value if successful. Requires that two 4GL
              pre-processors are defined:

              {&REGKEY_AUTHOR}      The application author/company name

              {&REGKEY_APPLICATION} The application name
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip-key AS CHARACTER NO-UNDO.

&IF DEFINED(REGKEY_AUTHOR) <> 0 AND DEFINED(REGKEY_APPLICATION) <> 0
&THEN

DEFINE VARIABLE lv-environ AS CHARACTER NO-UNDO INITIAL 'HKEY_CURRENT_USER\Software\{&REGKEY_AUTHOR}\{&REGKEY_APPLICATION}':U.
DEFINE VARIABLE lv-section AS CHARACTER NO-UNDO INITIAL 'Settings':U.

DEFINE VARIABLE lv-value AS CHARACTER NO-UNDO.

LOAD lv-environ NO-ERROR.

IF ERROR-STATUS:ERROR THEN RETURN ?.

USE lv-environ.

GET-KEY-VALUE SECTION lv-section KEY ip-key VALUE lv-value.

UNLOAD lv-environ NO-ERROR.

RETURN lv-value.   

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColourTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setColourTable Procedure 
PROCEDURE setColourTable :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress colour table in the current environment to
               match the current MS-Windows colour scheme. Reads RGB values
               from the registry and duplicates them into the Progress colour
               table. Maps the colour scheme into the colour table from entry 
               {&COLOUR-MAP-BASE}. If no entries found, uses a default set. 
  Parameters:  None
  Notes:       Run from the getColour method when necessary. Can be run by 
               any requesting application during the session. See also procedure
               getColour in this procedure.
------------------------------------------------------------------------------*/
DEFINE VARIABLE key-value AS CHAR NO-UNDO.
DEFINE VARIABLE key-list  AS CHAR NO-UNDO.

DEFINE VARIABLE iEntry AS INTEGER NO-UNDO.
DEFINE VARIABLE iTable AS INTEGER NO-UNDO.
DEFINE VARIABLE iRed   AS INTEGER NO-UNDO.
DEFINE VARIABLE iGreen AS INTEGER NO-UNDO.
DEFINE VARIABLE iBlue  AS INTEGER NO-UNDO.

DEFINE VARIABLE result AS LOGICAL NO-UNDO.

DEFINE VARIABLE colour-table-rgb-vals AS CHARACTER NO-UNDO.

/* The base point in the colour table from which Windows colours are mapped. */
DEFINE VARIABLE iColourMapBase AS INTEGER    NO-UNDO.

ASSIGN colour-table-key-list = "ButtonHilight,ButtonFace,ButtonShadow,GrayText,ButtonText,Hilight"
       colour-table-rgb-vals = "255 255 255,192 192 192,128 128 128,128 128 128,0 0 0,0 0 128".
       
/* LOAD and USE the Windows registry Control Panel environment. */
LOAD "HKEY_CURRENT_USER\Control Panel" NO-ERROR.

IF NOT ERROR-STATUS:ERROR
THEN DO:
    USE "HKEY_CURRENT_USER\Control Panel" NO-ERROR.

    /* Get a list of all entries in the "Colors" section */
    IF NOT ERROR-STATUS:ERROR
    THEN
        GET-KEY-VALUE SECTION "Colors" KEY ? VALUE key-list.
END.

/* For each entry in the list, get the value and store in a local comma-separated
   list for later processing. The actual RGB colour values stored in the registry
   are in the format "R G B", delimited by spaces.
*/
DO iEntry = 1 TO NUM-ENTRIES(key-list):
    GET-KEY-VALUE SECTION "Colors" KEY ENTRY(iEntry,key-list) VALUE key-value.

    ASSIGN colour-table-rgb-vals = IF iEntry = 1 THEN key-value 
                                   ELSE colour-table-rgb-vals + "," + key-value 

           colour-table-key-list = IF iEntry = 1 THEN ENTRY(iEntry,key-list)
                                   ELSE colour-table-key-list + "," + ENTRY(iEntry,key-list).
END.
 
/* Revert back to the default environment settings */
UNLOAD "HKEY_CURRENT_USER\Control Panel" NO-ERROR.

/* Update the Progress colour-table with the RGB values extracted from the Windows
   registry. Make sure that there are enough colour table entries available and 
   calculate the start point based on the number of entries.
*/
IF COLOR-TABLE:NUM-ENTRIES + NUM-ENTRIES(colour-table-key-list) > 256 THEN
    ASSIGN iColourMapBase = 16.
ELSE
    ASSIGN iColourMapBase = COLOR-TABLE:NUM-ENTRIES
           COLOR-TABLE:NUM-ENTRIES = iColourMapBase + NUM-ENTRIES(colour-table-key-list).

/* Set the colour table RGB values of each entry, as extracted from the registry */
DO iEntry = 1 TO NUM-ENTRIES(colour-table-key-list):

    ASSIGN key-value = REPLACE(REPLACE(ENTRY(iEntry,colour-table-rgb-vals),"  "," "),"  "," ") 

           iTable = MAX(16, iColourMapBase) + (iEntry - 1)

           iRed   = INTEGER(ENTRY(1,key-value," "))
           iGreen = INTEGER(ENTRY(2,key-value," "))
           iBlue  = INTEGER(ENTRY(3,key-value," ")).

    IF NUM-ENTRIES(key-value," ") = 3 
    THEN
        ASSIGN result = COLOR-TABLE:SET-DYNAMIC(iTable,TRUE)
               result = COLOR-TABLE:SET-RED-VALUE(iTable,iRed)
               result = COLOR-TABLE:SET-GREEN-VALUE(iTable,iGreen)
               result = COLOR-TABLE:SET-BLUE-VALUE(iTable,iBlue).
END.

/* This is where the COLOR-OF function, in afspcolour.i gets its values from */
ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "{&COLOR-LIST}" + FILL(",",iColourMapBase - 15) + colour-table-key-list.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRegistry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRegistry Procedure 
PROCEDURE setRegistry :
/*------------------------------------------------------------------------------
  Purpose:    Writes a key value into the registry under:
                'HKEY_CURRENT_USER\Software\{&REGKEY_AUTHOR}\{&REGKEY_APPLICATION}\Setttings'

  Parameters: The regkey/identifier and the value to set.

  Notes:      Returns the input value if successful
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip-key   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER ip-value AS CHARACTER NO-UNDO.

&IF DEFINED(REGKEY_AUTHOR) <> 0 AND DEFINED(REGKEY_APPLICATION) <> 0
&THEN

DEFINE VARIABLE lv-environ AS CHARACTER NO-UNDO INITIAL 'HKEY_CURRENT_USER\Software\{&REGKEY_AUTHOR}\{&REGKEY_APPLICATION}':U.
DEFINE VARIABLE lv-section AS CHARACTER NO-UNDO INITIAL 'Settings':U.

LOAD lv-environ NO-ERROR.

IF NOT ERROR-STATUS:ERROR THEN
    USE lv-environ.
ELSE DO:
    /* Handles first-time writes. Creates the \{&REGKEY_AUTHOR}\{&REGKEY_APPLICATION}\Settings area. */
    ASSIGN lv-environ = 'HKEY_CURRENT_USER\Software':U.

    LOAD lv-environ NO-ERROR.

    IF ERROR-STATUS:ERROR THEN RETURN ?.

    USE lv-environ.

    ASSIGN lv-section = '{&REGKEY_AUTHOR}\{&REGKEY_APPLICATION}\Settings':U.
END.

PUT-KEY-VALUE SECTION lv-section KEY ip-key VALUE ip-value.

UNLOAD lv-environ NO-ERROR.

RETURN ip-value.   
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

