/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/******************************************************************************

Procedure: _proedit.p

Syntax:
        RUN adeedit/_proedit.p
            ( INPUT p_File_List , INPUT p_Edit_Command ).

Purpose:          
    PROGRESS Procedure Editor.

Description:
       This PROGRESS procedure is the "engine" of the PROGRESS Procedure Editor. 
       Other modules call it with a list of files for the editor to open
       for editing purposes.
       
       The PROGRESS Editor executes in its own base window.  From the PROGRESS
       Editor, you may write and change PROGRESS programs, such as procedures
       and includes.

       The PROGRESS Editor is a window-based application that provides both
       mouse pointer operations and keyboard accelerators for editing text.

       The editor operates via a pull-down menu and through keyboard commands.
       
Parameters:

    INPUT p_FileList   (CHAR)
        - Comma-delimited list of os files for the Editor to open for
          editing.  
        
        - If NULL (""), sets current buffer to (Untitled).
        
        - If a file cannot be found, a warning message is given in an alert box.

    INPUT p_Edit_Command
        - Edit Command. See adeedit/dsystem.i for details.

Notes:
        - If the user stops editor execution before reaching the WAIT-FOR,
          the calling module must handle the STOP.

Author: John Palazzo

Date Created: 01.15.92 

*****************************************************************************/

/*-----------------------------  DEFINE VARS  -------------------------------*/

/* ADE Standards Include. */
&GLOBAL-DEFINE WIN95-BTN YES
{ adecomm/adestds.i }
IF NOT initialized_adestds
THEN RUN adecomm/_adeload.p.

/*--------------------------------------------------------------------------
                       System-Wide Defines for Editor 
--------------------------------------------------------------------------*/
{adeedit/dsystem.i}

/*--------------------------------------------------------------------------
             Buffer List-Related Defines for Editor 
--------------------------------------------------------------------------*/
{adeedit/dbuffers.i}

/*--------------------------------------------------------------------------
             File Commands-Related Defines for Editor 
--------------------------------------------------------------------------*/
{adeedit/dfile.i}

/*--------------------------------------------------------------------------
             Edit Commands-Related Defines for Editor 
--------------------------------------------------------------------------*/
/* ED_POPUP tells dedit.i to define a popup menu for editor. */
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
&SCOPED-DEFINE ED_POPUP     "PE_POPUP"
&ENDIF
{adecomm/dedit.i}


/*--------------------------------------------------------------------------
             Search Commands-Related Defines for Editor 
--------------------------------------------------------------------------*/
{adecomm/dsearch.i}

/*--------------------------------------------------------------------------
             Compile Commands-Related Defines for Editor 
--------------------------------------------------------------------------*/
{adeedit/dcompile.i}

/*--------------------------------------------------------------------------
                        Tools Menu Defines
--------------------------------------------------------------------------*/
{adeedit/dtools.i}

/*--------------------------------------------------------------------------
             Help Commands-Related Defines for Editor 
--------------------------------------------------------------------------*/
{adeedit/dhelp.i}

/*-------------------------  DEFINE MENUS AND MENU TRIGGERS  -------------*/
{adeedit/dmenus.i}

/*--------------------------------------------------------------------------
             .cls File Compile Commands-Related defines for Editor 
--------------------------------------------------------------------------*/
{adecomm/dcmpcls.i}

/*-------------------------  INTERNAL PROCEDURES ----------------------------*/

/*--------------------------------------------------------------------------
             System-wide  Procedures for Editor 
--------------------------------------------------------------------------*/
{adeedit/psystem.i}

/*--------------------------------------------------------------------------
             Buffer List-Related Procedures for Editor 
--------------------------------------------------------------------------*/
{adeedit/pbuffers.i}

/*--------------------------------------------------------------------------
             File Commands-Related Procedures for Editor 
--------------------------------------------------------------------------*/
{adeedit/pfile.i}

/*--------------------------------------------------------------------------
             Edit Commands-Related Procedures for Editor 
--------------------------------------------------------------------------*/
{adecomm/pedit.i}

/*--------------------------------------------------------------------------
             Search Commands-Related Procedures for Editor 
--------------------------------------------------------------------------*/
{adecomm/psearch.i}

/*--------------------------------------------------------------------------
             Compile Commands-Related Procedures for Editor 
--------------------------------------------------------------------------*/
{adeedit/pcompile.i}

/*--------------------------------------------------------------------------
             .cls File Compile Commands-Related Procedures for Editor 
--------------------------------------------------------------------------*/
{adecomm/pcmpcls.i}

/*--------------------------------------------------------------------------
             Tools Commands-Related Procedures for Editor 
--------------------------------------------------------------------------*/
{adeedit/ptools.i}

/*--------------------------------------------------------------------------
             Help Commands-Related Procedures for Editor 
--------------------------------------------------------------------------*/
{adeedit/phelp.i}

/*--------------------------------------------------------------------------
             Procedures to support Menus
--------------------------------------------------------------------------*/
{adeedit/pmenus.i}

/*--------------------------------------------------------------------------
             Procedures for Editor Initialization.
--------------------------------------------------------------------------*/
{adeedit/pinit.i}

/*--------------------------------------------------------------------------
             Procedures for Misc Editor operations.
--------------------------------------------------------------------------*/
{adeedit/peditor.i}

/* proc-main */
DO ON STOP UNDO, LEAVE:
    /* If this ADE Tool is already running, don't run again. Return. */
    /* The adecomm tool routine sets tool_bomb. */
    IF ( tool_bomb = TRUE ) THEN RETURN.

    /*----------------------------------------------------------------
        Create unnamed widget-pool so any dynamic widgets created by 
        editor (eg, edit buffers, view windows, etc ) are certain  to
        be deleted when the editor ends.
    ----------------------------------------------------------------*/
    CREATE WIDGET-POOL.
    /*----------------------------------------------------------------
        Run editor's initilization routines.
    ----------------------------------------------------------------*/
    RUN InitEditor.

    /* Trap all CTRL-C's, STOP's, END-ERRORS.  Prevents Editor from exiting. */
    REPEAT ON STOP UNDO, RETRY ON ERROR UNDO, RETRY ON ENDKEY UNDO, RETRY:
       
        WAIT-FOR "U9":U OF win_ProEdit
            FOCUS ProEditor .
        
        IF ( Saved_File = ? )
        THEN DO:
            Quit_Pending = FALSE.  /* Always reset to false. */
            NEXT.
        END.
        
        /* Close PROGRESS Help Window if open. */
        DO ON STOP UNDO, LEAVE: /* ON STOP prevents infinite RETRY loop. */
            RUN adecomm/_adehelp.p ( INPUT "edit" , INPUT "QUIT" , 
                                     INPUT ? , INPUT ? ).
        END.
        
        LEAVE. /* REPEAT ON STOP */
        
    END. /* REPEAT */
    
    /*----------------------------------------------------------------
        Not really needed - when this .p ends, the created unnamed
        widget-pool gets deleted by Progress.  Just for symmetry.
    ----------------------------------------------------------------*/
    DELETE WIDGET-POOL.
 
END. /* proc-main */
