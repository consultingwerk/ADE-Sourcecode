/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _contbnm.p

Description:
    Decides to create the OCX binary and creates the binary.
    
Input Parameters:
   <none>                
Output Parameters:
   binaryName - The name of the full qualified OCX binary.
                This named is used when actually writing 
                the binary name. The vbx-file field stores
                the name of the binary as it is to appear
                in the .w file. It is NULL if the
                binary was not created or does not need to
                be deleted after the RUN of the .w file. 
                For example, a binary is needed when the 
                .w is saved, but that binary should not be
                deleted.
                
Author: D. Lee

Date Created: 1995

Last Modified: 
  04/21/99  tsm  Added support for Print Option
---------------------------------------------------------------------------- */

define input  parameter nameOnly   as logical   no-undo.
define input  parameter ph_win     as widget    no-undo.
define input  parameter p_status   as character no-undo.
define output parameter binaryName as character no-undo initial ?.
        
{adeuib/pre_proc.i}
{adeuib/sharvars.i}
{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/layout.i}       /* Layout temp-table definitions                     */
{adecomm/adefext.i}

/*
 * NOTE: This function should work on NON-WONDOWS platforms as well.
 *       On Motif, we want to get the name of the binary file to
 *       insure that the .w file can be written out properly
 */
 
define variable fName    as character no-undo.
define variable initName as character no-undo.
define variable flipExt  as logical   no-undo initial true.

/*
 * Deciding the filename and when to generate is not straight
 * forward.
 *
 *    SAVE, SAVEAS    use _save_file to write out "official" binary
 *
 *    RUN      use _comp_temp_file to write out binary
 *             This keeps the "official" version safe.
 *
 *    PREVIEW  Use _save_file to show up in the generated text.
 *             PREVIEW is supposed to represent the actual source.
 *
 *    PRINT    Use _save_file to show up in the generated text.
 *
 *    EXPORT   There are 2 flavors of export. "Cut/Copy" and
 *             "Copy to" THe file name depends on the type.
 *
 * At this time, UNDO doesn't come through this path.
 */

find _P where _P._WINDOW-HANDLE = ph_win.

        
if _P._VBX-FILE = ? then initName = _save_file.
                    else initName = _P._VBX-FILE.

if (p_status = "SAVE":U OR p_status = "SAVEAS":U) then
    assign
        flipExt = (_P._VBX-FILE = ?)
        fName = initName
    .
else if p_status = "EXPORT":U then
	fName = (IF _control_cb_op THEN _control_cut_file ELSE initName).
else if can-do("PREVIEW,PRINT":U,p_status) then
    if _P._save-as-file = ? then fName = "~{":U + "~&":U + "FILE-NAME":U + "~}":U + ".zzz":U.
                            else fName = _P._save-as-file.
else
    fName = _comp_temp_file.

/*
 * Change the extension, as long as the user didn't specify a
 * a different extension
 */

if flipExt then
    fName = substr(fName, 1, r-index(fName, ".":U) - 1) + {&STD_EXT_UIB_WVX}.

assign
    binaryName = fName
.

if not nameOnly then do:

    /*
     * The following is a workaround for writing out the internal
     * procedure to load VBXs. This is needed because the control
     * cna't be loaded until after the window is enabled. This
     * required a "code rearrangement". Some information needed
     * for the change isn't available without larger changes, so ...
     */

    if _P._VBX-FILE = ? then _P._VBX-FILE = "":U.  
    _P._VBX-FILE = _P._VBX-FILE + ",":U + p_status + ",":U + binaryName.
end.
