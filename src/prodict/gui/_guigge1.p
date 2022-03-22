/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------

File: _guigge1.p

Description:   
    Select one or more objects from the list of records in the gatework
    temp-table. 
    This routnine gets called when the field gate-work.gate-flg2 should
    be part of the browse-widget's display.

Input: 
    Workfile gate-work contains info on all the gateway objects.
    p_Gate      Name of the gateway, e.g., "Oracle".
    p_sel-type  "Create"        when creating new schema
                "Differences"   to browse differences
                "Update"        when plain updating schema

Output:
    gatework.gate-flag = "yes"  object to be created/updated/deleted
 
Returns:
    "ok"     if 1 or more tables were chosen.
    "cancel" if user cancelled out.

Author: Laura Stern

Date Created : 07/28/93 

History:
    hutegger    95/03   extented functionality to get used for create, 
                        update and browse differences and browse differences and extracted
                        body of program into .i-file
    gfs         94/07   Install correct help contexts
    gfs         94/05   Changed Selection-List to Browse

----------------------------------------------------------------------*/

&SCOPED-DEFINE GATE_FLG2 YES
{ prodict/gui/guigget.i }
&UNDEFINE GATE_FLG2
  
/*--------------------------------------------------------------------*/
