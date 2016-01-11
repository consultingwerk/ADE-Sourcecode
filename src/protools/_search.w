&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
/***********************************************************************
* Copyright (C) 2000,2007,2012 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File: _search.w

  Description: Finds all copies of a file in the PROGRESS PROPATH 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: David Lee

  Created: 5/12/95
  
  Modified by GFS on 11/06/98 - Added ability to list the reference to a 
                                .PL if the file searched for was in one.
           by tsm on 07/02/99 - Added ability to handle date formats other
                                than "mdy"
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

define variable foundCount as integer no-undo.
         
DEFINE variable ipTitle AS CHARACTER NO-UNDO INITIAL "Propath File Search". 
    
   &if DEFINED(IDE-IS-RUNNING) <> 0 &then
define variable gFiles as character no-undo.
/* somewhat random - probably more to add */
define variable xNoOpen as character init "r,pl,dll,exe,class" no-undo.
define variable gSelectedFile as character no-undo.
   &endif    
   
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
{adecomm/fileinfo.i}

DEFINE VARIABLE file-year AS INTEGER.
DEFINE VARIABLE file-mon AS INTEGER.
DEFINE VARIABLE file-day AS INTEGER.
DEFINE VARIABLE file-hour AS INTEGER.
DEFINE VARIABLE file-min AS INTEGER.
DEFINE VARIABLE file-sec AS INTEGER.
DEFINE VARIABLE file-size AS INTEGER.    
DEFINE VARIABLE error AS INTEGER.

&ENDIF




/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Close AUTO-GO 
     LABEL "&Close" 
     SIZE 12 BY 1.1
     BGCOLOR 8 .

DEFINE BUTTON doIt 
     LABEL "&Search" 
     SIZE 12 BY 1.1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OpenFile AUTO-GO 
     LABEL "&Open File" 
     SIZE 12 BY 1.1
     BGCOLOR 8 .

DEFINE VARIABLE whichFile AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY 1.1 NO-UNDO.

DEFINE VARIABLE foundFile AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 64 BY 4.1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */



DEFINE FRAME Dialog-Frame

    "Search for File:" VIEW-AS TEXT
          SIZE 18 BY .67 AT ROW 1.29 COL 2   
          SPACE(47.19)
     whichFile AT ROW 2 COL 2 NO-LABEL
     doIt AT ROW 1.95 COL 54
  &if DEFINED(IDE-IS-RUNNING) = 0 &then   
     foundFile AT ROW 5.05 COL 2 NO-LABEL
     Btn_Close AT ROW 3.43 COL 54
     "Can be Found In:" VIEW-AS TEXT
          SIZE 18 BY .67 AT ROW 4.24 COL 2
   
      SKIP(4.46)
  &ELSE
     "Can be Found In:" VIEW-AS TEXT
          SIZE 18 BY .67 AT ROW 3.43 COL 2 
       foundFile AT ROW 4.24 COL 2 NO-LABEL
       Btn_Openfile AT ROW 8.56 COL 41
       Btn_Close AT ROW 8.56 COL 54
       SKIP(0.38)
       
  &ENDIF     
 
     WITH  
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
 
 &if DEFINED(IDE-IS-RUNNING) = 0 &then
         TITLE ipTitle 
         VIEW-AS DIALOG-BOX    
 &else
         no-box
 &endif        
         KEEP-TAB-ORDER DEFAULT-BUTTON Btn_Close.

{adeuib/ide/dialoginit.i "FRAME Dialog-Frame:handle"}

/* *********************** Procedure Settings ************************ */





/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   Custom                                                               */
    &if DEFINED(IDE-IS-RUNNING) = 0 &then
    ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.
    &endif
/* SETTINGS FOR FILL-IN whichFile IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
/* funcs not forward declared for now */

function GetFileExtension returns char(pcfile as char):
     define variable i as integer no-undo.
     i = r-index(pcfile,".").
     if i > 0 then
         return substring(pcfile,i + 1).
     else
         return "".    
end .

 &if DEFINED(IDE-IS-RUNNING) <> 0 &then

function CanOpenFile returns logical(pcfile as char):
     define variable cExt as char no-undo.
     cExt = GetFileExtension(pcFile).
     return cExt > "" AND lookup(cExt,xNoOpen) = 0.      
end .

function GetSelectedFile returns char():
     define variable i as integer no-undo.
     if gFiles > "" then
     do with frame {&frame-name}:
         i = foundFile:lookup(foundFile:screen-value).
         if i > 0 and num-entries(gFiles) >= i then
             return entry(i,gFiles).
     end.
     return "".
end .


&endif

/* ************************  Control Triggers  ************************ */

ON GO OF FRAME Dialog-Frame /* Propath File Search */
DO:
  run adecomm/_setcurs.p("WAIT"). 
END.

ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Propath File Search */
DO:
  run adecomm/_setcurs.p(""). 
 APPLY "END-ERROR":U TO SELF.
END.

ON CHOOSE OF Btn_Close IN FRAME Dialog-Frame /* Close */
DO:
 Apply "CLOSE" to FRAME {&FRAME-NAME}. 
END.

ON CHOOSE OF doIt IN FRAME Dialog-Frame /* Search */
DO:
    
    
    
    define variable s   as logical   no-undo.
    define variable str as character no-undo.
    define variable rel as logical   no-undo.
    
    &if DEFINED(IDE-IS-RUNNING) <> 0 &then
    
    gfiles = "":U.
    
    &endif    
    
    ASSIGN whichfile.
    foundFile:LIST-ITEMS = "".
    foundCount = 1.
        
    if length(whichFile) > 1 then do:
        run adecomm/_setcurs.p("WAIT").
       
        /* 
         * Full path name, don't use propath
         */        
        if index(":", whichFile) > 0 then run addFile(search(whichFile)).
        else do:
            define variable i         as integer   no-undo.
            define variable rCodeName as character no-undo.
            define variable ext       as character no-undo.
 

            do i = 1 to num-entries(propath):

                /*
                 * Don't want a slash if starting from
                 * a local directory
                 */
                 
                if entry(i, propath) = "" then
                    assign
                        str = whichFile
                        rel = yes.
                else
                    assign
                        str = entry(i, propath) + "~/" + whichFile
                        rel = no
                    .
                
                /*
                 * Replace all the slashes
                 */
                
                &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                
                   str = replace(str, "~/", "~\").   
                    
                &ELSE
                     str = replace(str, "~\", "~/").               
                &ENDIF 
                 /*
                 * Look for r-code if a.p or .w or .cls
                 */
            
                ext = GetFileExtension(str).
                IF ext = "p" OR ext = "w" OR ext = "cls" THEN DO:                
                  run makeRCodeName(str, output rCodeName).
                  if rCodeName <> ? then run addFile(rCodeName).
                END.
                                                                           
                file-info:file-name = str.
                
                /*
                 * If we're working with a relative file then
                 * the check is different
                 */

                if rel then do:
                
                    if search(str) = str then
                           run addFile(str).                
                end.
                else do: 
                    if     file-info:pathname <> ? 
                       and file-info:pathname = str then
                           run addFile(str).    
                end.
            end.
        end.
        /* Also, see if it's in a .pl file */
        IF LIBRARY(SEARCH(whichFile)) NE ? THEN RUN addFile(LIBRARY(SEARCH(whichFile))).
        
        /* Report if nothing were found. */
        IF foundFile:NUM-ITEMS eq 0 THEN foundFile:LIST-ITEMS = "[No files found]".
        run adecomm/_setcurs.p ("").
    end.
    else
        foundFile:SCREEN-VALUE = "".    
END.

ON LEAVE OF whichFile IN FRAME Dialog-Frame
DO:
    if whichFile = whichFile:SCREEN-VALUE then return.
    
    whichFIle = whichFile:SCREEN-VALUE.  
END.



ON RETURN OF whichFile IN FRAME Dialog-Frame
DO:
    if whichFile = whichFile:SCREEN-VALUE then return.
    
    whichFile = whichFile:SCREEN-VALUE.
    apply "CHOOSE" to doIt.  
END.

&if DEFINED(IDE-IS-RUNNING) <> 0 &then
 
ON CHOOSE OF Btn_OpenFile IN FRAME Dialog-Frame  
DO:
    run handleFileSelection.     
END.


ON DEFAULT-ACTION OF foundFile IN FRAME Dialog-Frame /* foundFile */
DO:
    run handleFileSelection.
END.

ON VALUE-CHANGED OF foundFile IN FRAME Dialog-Frame /* foundFile */
DO:
    Btn_OpenFile:sensitive in frame Dialog-Frame = CanOpenFile(GetSelectedFile()) .
END.
&ENDIF

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.
  
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:

DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  
  /*
   * Load the file information
   */
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
      run LoadFileInfo.
  &ENDIF.
 
 &scoped-define CANCEL-EVENT U2
      &if DEFINED(IDE-IS-RUNNING) <> 0 &then
 ipTitle = ipTitle +  " - " + getProjectDisplayName().
      &endif
 {adeuib/ide/dialogstart.i  Btn_Close Btn_Close iptitle}
      &if DEFINED(IDE-IS-RUNNING) <> 0 &then
  dialogService:SizeToFit().
      &endif
  run adecomm/_setcurs.p("").
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  
  run adecomm/_setcurs.p("").
END.
RUN disable_UI.

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  RUN UnloadDLL.
&ENDIF.

&if DEFINED(IDE-IS-RUNNING) <> 0 &then
   return gSelectedFile.
&endif
 


/* **********************  Internal Procedures  *********************** */

PROCEDURE addFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter fName as character no-undo.

define variable cDate   as character no-undo.
define variable i       as integer   no-undo initial 1.
define variable str     as character no-undo.
define variable s       as logical   no-undo.
define variable dateStr as character no-undo initial "".
define variable modDate as date      no-undo.
define variable modTime as character no-undo.
define variable preStr  as character no-undo.
define variable cExt    as character no-undo.

if fName = ? then return.
if length(fName) < 0 then return.

preStr = string(foundCount) + ". " + fName.

&if DEFINED(IDE-IS-RUNNING) <> 0 &then
   gFiles = gFiles
          + (if foundCount = 1 then "" else ",")
          + fname.  
&endif

do with frame {&FRAME-NAME}:
    &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
         run file_info (fName, output file-year,
                               output file-mon,
                               output file-day,
                               output file-hour,
                               output file-min,
                               output file-sec,
                               output file-size,
                               output error).
        
        /* We need to build the date string based on the users date format */
        do while i <= 3:        
          case substring(session:date-format, i, 1):
            when "m":U then cDate = cDate + string(file-mon,"99").
            when "d":U then cDate = cDate + string(file-day,"99").
            when "y":U then cDate = cDate + substring(string(file-year),3,2,"fixed").
          end case.
          i = i + 1.
        end.  /* do while i <= 3 */

        IF error = 0 THEN
        assign
            cDate = substring(cDate, 1, 2) 
                  + "/" + substring(cDate, 3, 2) 
                  + "/" + substring(cDate, 5, 2)
            modDate = date(cDate)         
            modTime = string(file-hour,"99")
                    + ":"
                    + string(file-min,"99")
                    + ":"
                    + string(file-sec,"99")

            dateStr = string(modDate) + " " + modTime.
        
        /*
         * Try to get the dates/teims to lineup. But never
         * allow a filename to be clipped!
         */
         
        if length(preStr) < 55 then preStr = string(preStr, "X(55)").
    &ENDIF
    assign
        str = preStr + " " + dateStr
        s = foundFile:ADD-LAST(str)
        foundCount = foundCount + 1
    .
end.

END PROCEDURE.


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
  HIDE FRAME Dialog-Frame.
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
  DISPLAY whichFile foundFile 
      WITH FRAME Dialog-Frame.
  ENABLE whichFile doIt foundFile Btn_Close 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

&if DEFINED(IDE-IS-RUNNING) <> 0 &then
procedure handleFileSelection:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define variable cFile as character no-undo.
    cFile = GetSelectedFile().
    if CanOpenFile(cFile) then 
    do:
        gSelectedFile = cFile.
        apply "go" to FRAME {&FRAME-NAME}.
    end.   
end procedure.
&endif

PROCEDURE makeRCodeName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input  parameter fName as character no-undo.
define output parameter rName as character no-undo initial ?.

define variable str as character no-undo.

if num-entries(fName, ".") > 1 then

     str = substr(fName, 1, r-index(fName, ".") - 1) + ".r".
else
     str = fName + ".r". 

file-info:file-name = str.

if     file-info:pathname <> ? 
   and file-info:pathname = str then rName = str.
END PROCEDURE.


