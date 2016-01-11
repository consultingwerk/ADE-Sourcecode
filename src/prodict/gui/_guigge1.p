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
