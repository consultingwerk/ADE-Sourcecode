/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _contbin.p

Description:
    Decides to create the ocx binary and creates the binary.
    
Input Parameters:
   <none>                
Output Parameters:
                
Author: D. Lee

Date Created: 1995

Last Modified: 
  12/19/96 gfs - ported for use with OCXs
---------------------------------------------------------------------------- */

define input  parameter ph_win     as widget    no-undo.
define input  parameter pu_status  as character no-undo.
define input  parameter p_status   as character no-undo.
define input  parameter fName      as character no-undo.
define output parameter madeBinary as logical   no-undo initial no.
define output parameter wStatus    as integer   no-undo initial 0.

{adeuib/pre_proc.i}
{adeuib/sharvars.i}
{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/layout.i}       /* Layout temp-table definitions                     */
{adecomm/adefext.i}

/* Should be converted to test for platfrom support of VBX or OCX.
   -jep 01/30/96 */
IF NOT SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN RETURN.

define variable s as integer no-undo.

if (   p_status = "RUN":U
    or p_status = "SAVE":U
    OR p_status = "SAVEAS":U
    or p_status = "DEBUG":U
    or p_status = "EXPORT":U) then do:
    
    define variable modeSave as integer no-undo.
    
    /*
     * Always go into design mode. This is needed due to UIB
     * architecture with disabling widgets for RUN as well
     * as other tools
     */
/* [gfs 12/17/96 - commented out this call because _h_controls was changed
                   to a COM-HANDLE. This will be ported later.    
    run ControlGetDesignMode in _h_controls(output modeSave, output s).
*/
    run adeshar/_cntrsdm.p(1, output s).
    
    /*
     * Walk the records. Only add bonafide OCX controls into the
     * binary.
     */
    OCXLOOP: 
    for each _U where _U._WINDOW-HANDLE = ph_win
                and   _U._TYPE          = "{&WT-CONTROL}":U
                and   _U._STATUS        = pu_status
                use-index _OUTPUT,
        each _F where recid(_F) = _U._x-recid
                and   _SPECIAL-DATA = ?:

/* [gfs 12/17/96 - commented out this call because _h_controls was changed
                   to a COM-HANDLE. This will be ported later.
        if    p_status = "SAVE":U 
           or p_status = "EXPORT":U then
            run ControlSaveControl in _h_controls(_U._HANDLE, fName, output s).
        else
            run ControlSaveControlKeepState in _h_controls(_U._HANDLE, fName, output s).
*/        
        /* 12/19/96
         * gfs note: According to the spec, the Control-Frame's dirty attribute is
         * read-only. So, it looks like we cannot keep it dirty like the VBX code did.
         */
        /* Save each OCX control to the binary file using it's name */
        s = _U._COM-HANDLE:SaveControls(fName, _U._NAME).

        /*
         * Let the user know if there are any problems. Generally, 2 things
         * can happen, the entire binary file can't be written. When this
         * happens abort the process. If an error occurs writing an
         * individual OCX control then notify the user but continue on. 
         */
                  
        if s = 2147500037 /*E_FAIL*/ THEN DO:
        
            message "There is a problem writing the entry for " _U._NAME skip
                    "into " fName + ". The remaining controls in" skip
                    "this interface will be written into the binary file." skip
            view-as alert-box error button ok title "Cannot Write VBX entry".
            
            wStatus = 2.
        
        end.
        ELSE if s = 2147680261 /*STG_E_ACCESSDENIED*/       OR
                s = 2147680264 /*STG_E_INSUFFICIENTMEMORY*/ OR
                s = 2147680260 /*STG_E_TOOMANYOPENFILES*/   THEN
        DO:
                  message "There is a problem writing" fName + ". No" skip
                    "binary information for any VBX control can be saved." skip
                    "Insure that the file name is correct, the directory exists," skip
                    "and you have permission to use the directory."
                  view-as alert-box error button ok title "Cannot Write Binary File".
        
                  assign
                    wStatus = 1
                    madeBinary = false
                  .
                  LEAVE OCXLOOP.
        END.        
        madeBinary = true.
    end.
    run adeshar/_cntrsdm.p(modeSave, output s).       
end.
