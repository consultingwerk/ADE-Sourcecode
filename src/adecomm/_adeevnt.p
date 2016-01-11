/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _adeevnt.p

Description:
    This is the special file that provided hooks into the ADE.
    
    By modifying _adeevnt.p, you can intercept or filter various events
    that occur in an Application Development Environment session.  The 
    ADE tools call this routine when certain processing occurs.  Generally
    these events are file oriented (eg. OPEN, SAVE, CLOSE), but they can
    be more general (eg. UIB STARTUP or UIB SHUTDOWN).

    
Input Parameters:
    p_product : The ADE product code. (eg. "UIB" , "Editor")  
    p_event   : The name of the event (eg. "Close", "Open", "Before-Save")
    p_context : A unique context string that can be used to compare the
                object, or context, of an event. (eg. This might be a
                RECID or HANDLE of the object being closed or opened).
                NOTE: this context string will be unique for a given
                class of events in a given product, but not necessarily
                across products or events.  That is, a "UIB/Save" event  
                for a given window will always have the same context id,
                even if the name of the window changes.
   p_other    : Additional information passed about an event. (eg. a
                save event normally passes the File Name for the save).
                
Output Parameters:
    p_ok      : On a case by case basis, this procedure allows you to
                cancel various ADE events.  For example, you can return
                a FALSE here from a "UIB/Before-Save" event if you want
                to cancel the save.
   
Details on Specific Events:
   
   p_product = "UIB"
   =================
     The following events are all related to file operations. 
     p_event  
     -------  
     New            Called after a new window/dialog-box is created
                    or after a new code-block is creating in the section
                    editor.  If p_other is "_PROCEDURE", "_FUNCTION"
                    or "_CONTROL" then this call is a new code-block.
     Before-Open    Called before a file is opened
                    Returning p_ok = FALSE can cancel the open.
     Open           Called after a window has been opened
     Before-Close   Called before a window is to be closed - Returning
                    p_ok = FALSE can cancel the close.
     Close          Called after a window has been closed
     Before-Save    Called immediately before a window has been saved 
                    (but after the name for the save has been decided on).
                    Returning p_ok = FALSE can cancel the save.
     Save           Called after a window has been saved
     Before-Compile Called before a file has been compiled by the UIB.  If
                    a UIB file is "Compile on Save", this event is called
                    after the SAVE has occured. 
                    Returning p_ok = FALSE can cancel the compile.
     Compile        Called after COMPILE of file has ended.
     Before-Run     Called before a file has been written to disk for a
                    run. [p_ok = FALSE can cancel the run]
     Run            Called after RUN of file has ended.
     Before-Debug   Same as Before-Run (except Debug has been chosen).
     Debug          Same as Run (except Debug has been chosen)
                    [p_ok = FALSE can cancel the operation]
     Before-Check-Syntax  
                    Called before a Check Syntax 
                    [p_ok = FALSE can cancel the check]
     Check-Syntax   Called after a Check Syntax
     Before-Check-Syntax-Partial  
                    Called before a Check Syntax is done on 
                    part of a file from the UIB.  For example, in the Section
                    Editor, or in the Query Builder, the user can ask to have
                    only a portion of a file checked. 
                    [p_ok = FALSE can cancel the check]
     Check-Syntax-Partial   
                    Called after a partial file Check Syntax
     
     In all these cases:
       p_context - a string associated with the window/dialog-box being
                   editted in the UIB. A specific file will have the 
                   same Context number for all its NEW, OPEN, SAVE, RUN, 
                   CLOSE, etc. operations.  However, if you close a file
                   and then open it again, the context number will change.
                   (FYI - this will be based on an internal RECID).
                   If the call is for a NEW section code block, then this
                   is the RECID of the record containing the code block.
       p_other -   the current filename associated with the window.  The
                   name will be unknown (?) if it has not been set
                   (e.g. after a File/New...).  If the call to _adeevnt.p
                   if for a new section code block, then p_other is either
                   "_PROCEDURE" (for a new internal procedure), "_FUNCTION"
                   (for a new user defined function) or "_CONTROL" (for a 
                   new trigger code block.)

     The following events are related to the UIB startup and shutdown:
       p_event = "Startup"
       ===================
         Called when the UIB has been loaded and initialized.  This call
         occurs immediately before user input is allowed.  In this case:
            p_context = STRING(procedure handle of the UIB main routine)
            p_other   = STRING(widget handle of the UIB main window)
       
       p_event = "Shutdown"
       ====================
          Called when a user requests that the UIB shutdown. (But before
          and settings have been saved or items destroyed).
            p_context = STRING(procedure handle of the UIB main routine)
            p_other   = STRING(widget handle of the UIB main window)
           
      The following additional comments apply to the UIB's usage:
         1. BEFORE-CLOSE and CLOSE:  technically, p_other should be ?
            after a file has been closed.  However, it still shows the
            last available file name for the .w file.  Unknown (?) is 
            only shown if there is no file name.
         2. BEFORE-RUN, RUN, BEFORE-DEBUG, DEBUG,  BEFORE-CHECK-SYNTAX,
            CHECK-SYNTAX all use the last specified file name as p_other.
            (Technically the actual file being run or checked is a temporary 
            file with a name like p01928384.uib. This name is NOT used).
         3. If the user tries to close a window, then the UIB first asks 
            the user if a save is desired.  The entire save operation events
            fire prior to the call to BEFORE-CLOSE. 
         4. NEW is called after the window is created.  You will see the 
            window before the NEW event is called.  (Note: this is not
            unusual.  All events are called after the event has finished.  
            However, some users feel this is unusual.).
            
 The Section Editor (in the UIB)
         The UIB's Section Editor issues a Startup event the first time
         it is called and also issues a Shutdown event when it deletes
         itself during UIB exit. In both cases, here are its SCM values:

            p_product = "Section Editor"
            p_event   = "Startup" or "Shutdown"
            p_context = STRING(procedure handle of the Section Editor)
            p_other   = STRING(widget handle of the Section Editor window)

 The Procedure Window and Procedure Editor
     p_product = "Procedure Window", p_product = "Editor"
     ====================================================
     p_event
     -------
      Same as for UIB file operations:
         New 
         Before-Open 
         Open
         Close & Before-Close
         Save &  Before-Save
         Run &   Before-Run
         Debug & Before-Debug
         Check-Syntax & Before-Check-Syntax 

     In all these cases: 
     
       p_context - a string associated with the file being editted.
                   A specific file will have the same Context number for 
                   all its file operations.  However, if you close a file
                   and then open it again, the context number will change
                   for the Procedure Editor product only. The context
                   number for a Procedure Window remains the same for all
                   operations on that Procedure Window.
                   (NOTE - p_context is based on the widget handle of the
                   editor widget of the buffer).
       p_other -   the current filename associated with the window.  The
                   name will be unknown (?) if it has not been set (e.g. 
                   after a File/New...).
      
     The Procedure Editor handles p_event = "Startup" and p_event = 
     "Shutdown" and assigns p_context and p_other the same way the UIB
     does.
     
     A Procedure Window handles the "Startup" and "Shutdown" events the
     same as the UIB and Procedure Editor, but assigns p_context and
     p_other (for both events) as follows:
            p_context = STRING(Procedure Window window handle)
            p_other   = STRING(Procedure Window Parent ID)
     
     The comments related to UIB usage of _adeevnt.p also apply to the 
     Procedure Editor.

     The following additional comments apply to Procedure Window’s usage:
         1. For file operations, p_context does not change for a Procedure
            Window. It is not sufficient to track whether this number has 
            changed to determine Open or Close status of a file in a 
            Procedure Window.
         2. BEFORE-RUN, RUN, BEFORE-DEBUG, DEBUG, BEFORE-CHECK-SYNTAX, 
            CHECK-SYNTAX all use the last specified file name as p_other. 
            (Technically the actual being run or checked is a temporary file 
            with a name like p123456r.ped. This name is NOT used).
         3. If the user tries to close a file, then the Procedure Window 
            first asks the user if a save is desired.  The entire save 
            operation events fire prior to the call to BEFORE-CLOSE. 
         4. NEW is called after the window is created.  You will see the
            window before the NEW event is called.

Author: John Palazzo, Wm.T.Wood

Date Created: December, 1994

Modified:
  8/10/95 gfs Added BEFORE-OPEN
----------------------------------------------------------------------------*/

DEFINE INPUT        PARAMETER p_product  AS CHAR    NO-UNDO.
DEFINE INPUT        PARAMETER p_event    AS CHAR    NO-UNDO.
DEFINE INPUT        PARAMETER p_context  AS CHAR    NO-UNDO.
DEFINE INPUT        PARAMETER p_other    AS CHAR    NO-UNDO.
DEFINE       OUTPUT PARAMETER p_ok       AS LOGICAL NO-UNDO INITIAL TRUE.

/* By default, we always return after doing nothing */

/* The following debugging code can be uncommented... */
/*
MESSAGE "Product:" p_product SKIP
        "Event:" p_event SKIP
        "Context:" p_context SKIP
        "Other Data:" p_other
           VIEW-AS ALERT-BOX QUESTION 
                   BUTTONS OK-CANCEL
                   TITLE "adecomm/_adeevnt.p"
                   UPDATE p_ok.
*/
