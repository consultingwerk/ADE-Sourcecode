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
&GLOB TOOL_COUNT 14

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

