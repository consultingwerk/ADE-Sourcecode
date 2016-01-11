/***********************************************************************
* Copyright (C) 2000-2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: _ldicont.p

Description:
    Creates the code needed by the "load internal procedure." Note: This
    function can be called during a RUN/SAVE etc as well as during the section
    editor. In that case the OP = ?.
    
Input Parameters:
                   
Output Parameters:
   Code  - The code string

Author: Wm.T.Wood

Date Created: 1995

Last Modified: 
  04/07/96 gfs - Changed to use 'real' control frame com-handle in control_load
  12/19/96 gfs - ported for use with OCX
  03/13/97 gfs - Add support for initialize-controls
  03/13/98 SLK - Add support for ADM2
---------------------------------------------------------------------------- */
define input  parameter winRecid   as recid     no-undo.
define input  parameter pu_status  as character no-undo.
define output parameter code       as character no-undo initial "".

{adeuib/pre_proc.i}
{adeuib/sharvars.i}
{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/layout.i}       /* Layout temp-table definitions                     */
{adecomm/adefext.i}

&Scoped-define EOL CHR(10)

define variable str         as character no-undo.
define variable loadSection as character no-undo initial "":U.
define variable errSection  as character no-undo.
define variable fName       as character no-undo initial ?.
define variable OCXBinary   as character no-undo.
define variable op          as character no-undo initial ?.
define variable junk        as character no-undo.
define variable heading     as character no-undo.
define variable init-code   as character no-undo initial "":U.
define variable isSMO       as logical   no-undo initial no.
define variable commentln   as character no-undo initial
  "------------------------------------------------------------------------------".
define variable assignCode  as character no-undo initial "":U.
define buffer x_U      for _U.

/*
 * Get the information about the file.
 */
FIND _P WHERE _P._u-recid = winRecid.
FIND _U WHERE RECID(_U) = winRecid.

OCXBinary = entry(1, _P._VBX-FILE).
if num-entries(_P._VBX-FILE) > 1 then
    assign
        op    = entry(2, _P._VBX-FILE)
        fName = entry(3, _P._VBX-FILE)
    .

/*
 * Create the heading
 */
 
heading   =
    "/*" + commentln + {&EOL} +
    "  Purpose:     Load the OCXs    "                                 + {&EOL} + 
    "  Parameters:  <none>"                                            + {&EOL} + 
    "  Notes:       Here we load, initialize and make visible the "    + {&EOL} +
    "               OCXs in the interface.                        "    + {&EOL} +
    commentln + "*/" + {&EOL} .
/*
 * Create the top of part of the procedure.
 */
 
assign
    str = "~{":U  + "~&":U + "OPSYS":U + "~}":U  

    code = heading + {&EOL}
         + '&IF ~"':U + str 
         + '" = "WIN32":U AND "~{~&WINDOW-SYSTEM~}" NE "TTY":U &THEN':U + {&EOL}
         + "DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.":U + {&EOL} 
         + "DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.":U + {&EOL} + {&EOL}
.

/*
 * For RUN or DEBUG, write out the full path of the temp file
 * name into the temp .w file. Otherwise use the
 * name provided or the vbx-file name.
 */
if op = "RUN":U or op = "DEBUG":U then
    str = fName.
else if op = ? then do:
    /*
     * The op can be NULL, say if the user is asking to see
     * the contents of the control_load function.
     */
        
        if OCXBinary = ? or length(OCXBinary) = 0 then do:

            run adeshar/_contbnm.p(true, _P._WINDOW-HANDLE, "PREVIEW":U, output fName).
            run adecomm/_osprefx.p(fName, output junk, output str).
        end.
        else
            str = OCXBinary.
    end.
else if OCXBinary = ? or length(OCXBinary) = 0 then
    run adecomm/_osprefx.p(fName, output junk, output str).
else
    str = OCXBinary.

/*
 * The following is to make .w load time as fast as
 * possible. Have the search function called only
 * once. Prepare an error message for the case if the
 * binary file can not be found
 */

code = code
     + 'OCXFile = SEARCH( "':U   
     + str + '":U ).':U + {&EOL}
     + 'IF OCXFile = ? THEN' + {&EOL}
     + '  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,' + {&EOL}
     + '                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).':U + {&EOL}
     + {&EOL}
.
errSection = 'MESSAGE ' + '"':u + str + '":U SKIP(1)':u + {&EOL} +
             '             "The binary control file could not be found. The controls cannot be loaded."' + {&EOL}
           + '             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".' + {&EOL}
.   

FOR EACH x_U WHERE x_U._WINDOW-HANDLE eq _U._HANDLE
               AND x_U._TYPE          eq "{&WT-CONTROL}":U
               AND x_U._STATUS        eq pu_status
            USE-INDEX _OUTPUT,
      EACH _F WHERE RECID(_F) eq x_U._x-recid:
   
  assignCode = assignCode
                + {&EOL} + '    ch':U + x_U._NAME + ' = ':U + x_U._NAME + ':COM-HANDLE':U
                + {&EOL} + '    UIB_S = ch':U + x_U._NAME
                + ':LoadControls( OCXFile, ':U 
                + '"' + x_U._NAME + '":U' + ')':U
                /*Bug# 20051202-051. If the object is a Window or Dialog (not smart), the name of the control-frame is assigned in the control_load procedure*/
                + (IF _P._adm-version NE "" THEN "" ELSE {&EOL} + '    ' + x_U._NAME + ':NAME = "' + x_U._NAME + '":U':U).
  /* With a lot of OCX controls, it is possible for this ASSIGN statement
     to get too large (i.e. > 4096), so if it is getting big, split it */
  IF LENGTH(assignCode) > 3700 THEN
    ASSIGN loadSection = loadSection + assignCode + {&EOL} + "  .":U + {&EOL} + "  ASSIGN":U
           assignCode  = "":U.                 
END. /* FOR EACH...OCX... */
      
/* Let's get the only assign code or the last piece of a broken up one */
IF length(assignCode) > 0 THEN 
  loadSection = loadSection + assignCode.
          
if length(loadSection) = 0 then do:
    code = "":U.
    return.
end.

/* Create the RUN statement to initialize OCX controls */
RUN adeuib/_isa.p(RECID(_P),"SmartObject":U, OUTPUT isSMO).
IF isSMO AND _P._adm-version LT "ADM2":U THEN
  init-code = '  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.':U.
ELSE
  init-code = "  RUN initialize-controls IN THIS-PROCEDURE NO-ERROR.":U.
   
loadSection = "  ASSIGN":U
            + loadSection + {&EOL}
            +  "  .":U + {&EOL}
            + init-code + {&EOL}
            .
 
/* Build the guts of the code. Since this function
 * takes on the responsibility of checking availability
 * it must display an error message.
 */        
code = code
	 + "IF OCXFile <> ? THEN":U + {&EOL}
	 + "DO:":U + {&EOL}
     + loadSection
     + "END.":U + {&EOL}
     + "ELSE ":U
     + errSection + {&EOL}
     + "&ENDIF":U + {&EOL}
.
