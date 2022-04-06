/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _edtmstr.p

Description: Edits the Master File for a SmartObject (or puts up a message
             if the Master cannot be found).

Input Parameters:  uRecId - RecID of object of interest.

Output Parameters: <None>

Author: William T. Wood

Date Created: 1 June 1995

----------------------------------------------------------------------------*/
define input parameter uRecId as recid no-undo.

{adeuib/uniwidg.i}   /* Universal Widget Records */
{adecomm/oeideservice.i}

&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

define new global shared variable gshSessionManager    as handle  no-undo.
define new global shared variable gshRepositoryManager as handle  no-undo.

define variable cnt                                 as integer    no-undo.
define variable FILE-NAME                           as char       no-undo.
define variable file-prfx                           as char       no-undo.
define variable file-base                           as char       no-undo.
define variable file-ext                            as char       no-undo.
define variable lEditMaster                         as logical    no-undo.
define variable src-file                            as char       no-undo.
define variable lIDEIntegrated                      as logical    no-undo.
define variable cMsg                                as character no-undo.
/* Find the information about this SmartObject. */
find _U       where recid(_U)       eq uRecId.
find _S       where recid(_S)       eq _U._x-recid.


/* Assume the master can be editted. */
assign lEditMaster = yes
       file-name   = _S._FILE-NAME.

/* Break the file name into its component parts. For example:
    c:\bin.win\gui\test.r => file-prfx "c:\bin.win\gui\",  file-base "test.r"
                             file-ext  "r" 
 */
run adecomm/_osprefx.p (input file-name, output file-prfx, output file-base).

if can-do("dynlookup.w,dyncombo.w":U, file-base) then do:
  /* Dynamic lookup or combo -- launch the apropriate editor */

  define variable lMultiInstance          as logical    no-undo.
  define variable cChildDataKey           as character  no-undo.
  define variable cRunAttribute           as character  no-undo.
  define variable cSDFFilename            as character  no-undo.
  define variable hContainerWindow        as handle     no-undo.
  define variable hContainerSource        as handle     no-undo.
  define variable hObject                 as handle     no-undo.
  define variable ghSDFMaintWindow        as handle     no-undo.
  define variable cRunContainerType       as character  no-undo.

  assign
    lMultiInstance    = no
    cChildDataKey     = "":U
    cRunAttribute     = string(this-procedure)
    hContainerWindow  = ?
    hContainerSource  = ?
    hObject           = ?
    hContainerWindow  = ?
    cRunContainerType = "":U
    .

  if valid-handle(gshSessionManager) and VALID-HANDLE(gshRepositoryManager) then do:
    cSDFFileName = dynamic-function("getSDFFileName" in _S._HANDLE).

    /* If there is no SDFFileName and we are dealing with a Static viewer then
       pass in "NOMASTER".                                                     */
    if cSDFFileName eq "":U or cSDFFileName = ? then
        assign cSDFFileName = "NOMASTER".
                                 
    run clearClientCache in gshRepositoryManager.
    run launchContainer in gshSessionManager 
                        (input  "rysdfmaintw"        /* object filename if physical/logical names unknown */
                        ,input  "":U                 /* physical object name (with path and extension) if known */
                        ,input  "":U                 /* logical object name if applicable and known */
                        ,input  (not lMultiInstance) /* run once only flag YES/NO */
                        ,input  "":U                 /* instance attributes to pass to container */
                        ,input  cChildDataKey        /* child data key if applicable */
                        ,input  cSDFFileName         /* run attribute if required to post into container run */
                        ,input  "":U                 /* container mode, e.g. modify, view, add or copy */
                        ,input  hContainerWindow     /* parent (caller) window handle if known (container window handle) */
                        ,input  hContainerSource     /* parent (caller) procedure handle if known (container procedure handle) */
                        ,input  hObject              /* parent (caller) object handle if known (handle at end of toolbar link, e.g. browser) */
                        ,output ghSDFMaintWindow     /* procedure handle of object run/running */
                        ,output cRunContainerType    /* procedure type (e.g ADM1, Astra1, ADM2, ICF, "") */
                         ).
    /* Set the super procedure in the container so that it can write out properties using 'set' */
    if valid-handle(ghSDFMaintWindow) and VALID-HANDLE(_S._HANDLE) then
       dynamic-function("setSDFProcHandle":U in ghSDFMaintWindow, _S._HANDLE).
     
  end.  /* If the repository manager is running */
  return.
end.
assign cnt      = num-entries(file-base, ".")
       file-ext = if cnt < 2 then "" else entry(cnt, file-base, "." ).

/* Look for a related .w file if the user asked for a .r.  We will use
   this to Edit the Master. */
if file-ext eq "r" then do:
  /* Replace the .r at the end of the file name. */
  assign file-name = file-base
         entry(cnt, file-name, ".") = "w"
         file-name = file-prfx + file-name.
  if search(file-name) eq ? then lEditMaster = no.
end.
/* Otherwise, just look for the file. */
else do:
  if search(file-name) eq ? then lEditMaster = no.
end.

/* Does the source exist in the DLC/src directory? */
if (replace(file-prfx, "~\":U, "~/") eq "adm/objects/":U) or (replace(file-prfx, "~\":U, "~/") eq "adm2/":U)
then do: src-file = search("src/":U + file-name).
end.
else src-file = ?.
if lEditMaster then 
do:
    run adeuib/_open-w.p (file-name, "","WINDOW":U).
end.
else do:
   /* Open the window for the SmartObject if we can find it.  
      Otherwise report an error if we cannot edit the master. */
   
   if OEIDEIsRunning then 
   do:
       run getIsIDEIntegrated in hOEIDEService (output lIDEIntegrated).
   end.
   
   cMsg = "Source code for this SmartObject could not be found.~n~n"       
         + "You cannot edit the master until you move a copy of the "
         + "source file (i.e. " + file-name + ") into your PROPATH." 
         + (if src-file ne ? 
            then  "~n~n" 
                + "[Note: The source code for this built-in PROGRESS object "
                + "can be found in " + src-file + ".]"
             else "").
   
   if not lIdeintegrated then 
   do:
      message cMsg 
            view-as alert-box error.
   end.
   else do:
      run ShowOkMessage in hOEIDEService(cmsg,"error",?).
   end.    
end.