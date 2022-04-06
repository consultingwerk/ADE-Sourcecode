/*********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: adecomm/toolmenu.i

Description:

This file is part of the quartet of toolmenu.i, toolrun.i, toolsupp.i, _toollic.p.
These files together will build the standard tools menu used by all the
ADE applications.

Usage:

Include {adecomm/toolmenu.i} with your other menu defines. 

Include {adecomm/toolrun.i} after your menubar definition.  This file
should only be run once per menubar.  See toolrun.i for any arguments.

If you have any custom tools you want added to the tools menu

Arguments:

{ adecomm/toolmenu.i 
      /* &EXCLUDE_ADMIN=yes */
      /* &EXCLUDE_DICT=yes */
      /* &EXCLUDE_EDIT=yes */
      /* &CUSTOM_TOOLS =
               "MENU-ITEM mi_section_editor LABEL ""Section Editor...""
                RULE" */
}

&EXCLUDE_*    The calling tool should exclude itself from the menu.
&DEF_TRIGGERS Pass this argument to define menu triggers when the static
              menu items are defined. Pass as Yes or No.
&PERSISTENT   Pass in conjunction with DEF_TRIGGERS when you want triggers
              defined with menus to be persistent.

Author: 
Mike Pacholec

Date Created: 
May 21, 1993
          
Change Log:
06/29/99 jep   add trigger blocks for the static trigger definitions. Supports
               Advanced Editor features.
05/07/99 gfs   added Actuate products DWB and ARD
04/09/99 tsm   added run-dblist internal procedure to run protools/_dblist.w
               persistently
04-16-98 hd    added WTOOL_IDX for WebTools support
11/11/97 drh   Made the DEFINE SUB-MENU totally gone for UIB to accomodate
               9.0 "morphing menu", when called from UIB menus are mostly
               dynamic
01-29-96 jep   Removed PLIB_IDX / Proclib support
06-29-95 jep   added PTOOL_IDX for PRO*Tools support
05-21-93 mikep created and tested with Dictionary
05-26-92 mikep cache get-license, check call stack
05-26-92 wood  added &CUSTOM_TOOLS

----------------------------------------------------------------------------*/


/*-----------------------------  DEFINE MENUS   -----------------------------*/

&GLOB ADMIN_IDX  1
&GLOB DICT_IDX   2
&GLOB EDIT_IDX   3
&GLOB UIB_IDX    4
&GLOB RPT_IDX    5
&GLOB TRAN_IDX   6
&GLOB COMP_IDX   7
&GLOB DBG_IDX    8
&GLOB RB_IDX     9
&GLOB VTRAN_IDX  10
&GLOB PTOOL_IDX  11
&GLOB WTOOL_IDX  12
&GLOB DWB_IDX    13
&GLOB ARD_IDX    14
&GLOB APMT_IDX   15
&GLOB TOOL_COUNT 15

&GLOB NOT_AVAIL    0
&GLOB LICENSED     1
&GLOB INSTALLED    2

DEFINE NEW GLOBAL SHARED VARIABLE ade_licensed AS INTEGER EXTENT {&TOOL_COUNT} 
    INITIAL [ ? ] NO-UNDO.

/*-----------------------------  DEFINE MENUS   -----------------------------*/

&IF DEFINED(EXCLUDE_UIB) = 0 &THEN
DEFINE SUB-MENU mnu_Tools
    {&CUSTOM_TOOLS}   /* Add any special menu-items first */
&ENDIF
&IF DEFINED(EXCLUDE_DICT) = 0 AND DEFINED(EXCLUDE_UIB) = 0 &THEN
    MENU-ITEM mnu_dict     LABEL "&Data Dictionary"              
    &IF DEFINED(DEF_TRIGGERS) &THEN
    TRIGGERS:
      ON CHOOSE {&PERSISTENT} RUN _RunTool( INPUT "_dict.p" ).
    END.
    &ENDIF
&ENDIF
&IF DEFINED(EXCLUDE_EDIT) = 0 AND DEFINED(EXCLUDE_UIB) = 0 &THEN
    MENU-ITEM mnu_editor   LABEL "Procedure &Editor"
    &IF DEFINED(DEF_TRIGGERS) &THEN
    TRIGGERS:
      ON CHOOSE {&PERSISTENT} RUN _RunTool( INPUT "_edit.p" ).
    END.
    &ENDIF
&ENDIF
&IF "{&WINDOW-SYSTEM}" <> "TTY" AND DEFINED(EXCLUDE_ADMIN) = 0 
                                AND DEFINED(EXCLUDE_UIB) = 0 &THEN
    MENU-ITEM mnu_admin    LABEL "Data &Administration" 
    &IF DEFINED(DEF_TRIGGERS) &THEN
    TRIGGERS:
      ON CHOOSE {&PERSISTENT} RUN _RunTool( INPUT "_admin.p" ).
    END.
    &ENDIF
&ENDIF
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    MENU-ITEM mnu_OS_Shell LABEL "&OS Shell"
&ENDIF
&IF "{&WINDOW-SYSTEM}" <> "TTY" AND DEFINED(EXCLUDE_UIB) = 0 &THEN
    MENU-ITEM mnu_ProTools LABEL "&PRO*Tools"
    TRIGGERS:
      ON CHOOSE PERSISTENT RUN run-protool.
    END TRIGGERS.
&ENDIF
/* APMT only available on GUI - data admin, data dict, Proc Editor and UIB only */
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    &if DEFINED(EXCLUDE_UIB) = 0 AND (DEFINED(EXCLUDE_ADMIN) <> 0 OR
                                      DEFINED(EXCLUDE_EDIT) <> 0 OR
                                      DEFINED(EXCLUDE_DICT) <> 0) &THEN
        MENU-ITEM mnu_apmt    LABEL "Audit Policy &Maintenance"  
        &IF DEFINED(DEF_TRIGGERS) &THEN
        TRIGGERS:
          ON CHOOSE {&PERSISTENT} RUN auditing/_apmt.p.
        END.
        &ENDIF
    &ENDIF
&ENDIF
/* Assembly References only available on GUI - Proc Editor only */
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    &if DEFINED(EXCLUDE_EDIT) <> 0 &THEN
        MENU-ITEM mnu_asmref    LABEL "A&ssembly References"  
        &IF DEFINED(DEF_TRIGGERS) &THEN
        TRIGGERS:
          ON CHOOSE {&PERSISTENT} RUN run-asmref.
        END.
        &ENDIF
    &ENDIF
&ENDIF
.

/* Define this procedure once and call it from the persistent procedure
   this is necessary to get around the problem of not being able to run
   a persistent procedure from a dynamic persistent trigger.              */
PROCEDURE run-protool:
  RUN "protools/_protool.p" PERSISTENT.
END.  /* PROCEDURE run-protool */

PROCEDURE run-dblist:
  RUN "protools/_dblist.w" PERSISTENT.
END.  /* PROCEDURE run-dblist */

PROCEDURE run-apmt:
    RUN auditing/_apmt.p.
END.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
PROCEDURE run-asmref:
    DEFINE VARIABLE dlcValue AS CHARACTER NO-UNDO. /* DLC */
    DEFINE VARIABLE retval AS INTEGER NO-UNDO.
    DEFINE VARIABLE exeValue AS CHARACTER NO-UNDO.

    IF OPSYS = "Win32":U THEN /* Get DLC from Registry */
      GET-KEY-VALUE SECTION "Startup":U KEY "DLC":U VALUE dlcValue.

    IF (dlcValue = "" OR dlcValue = ?) THEN DO:
      ASSIGN dlcValue = OS-GETENV("DLC":U). /* Get DLC from environment */
      IF (dlcValue = "" OR dlcValue = ?) THEN DO: /* Still nothing? */
        RETURN.
      END.
    END.

    exeValue = dlcValue + "\bin\proasmref.exe".

    RUN ProExec(exeValue,
                1 /* SW_SHOWNORMAL */,
                1 /* Wait (modal) */,
                1 /* unused */,
                OUTPUT retval).

    IF retval = 2 THEN
        MESSAGE "Assembly References tool not found:" exeValue
            VIEW-AS ALERT-BOX.
    ELSE
        IF retval <> 0 THEN
            MESSAGE "Error" retval "launching Assembly References tool:" 
                exeValue VIEW-AS ALERT-BOX.
END.

PROCEDURE ProExec EXTERNAL "PROEXEC.DLL" CDECL:
    DEFINE INPUT PARAMETER prog_name AS CHARACTER.
    DEFINE INPUT PARAMETER prog_style AS LONG.
    DEFINE INPUT PARAMETER wait_for_me as LONG.
    DEFINE INPUT PARAMETER num_seconds as SHORT.
    DEFINE RETURN PARAMETER return_value as LONG.
END.
&ENDIF /* "{&WINDOW-SYSTEM}" <> "TTY" */
