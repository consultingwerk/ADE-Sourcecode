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

/*--------------------------------------------------------------------

File: prodict/gate/cmp_msg.i

Description:
    
    compares an attribute, and ev. creates and add an adequate message

        
Text-Parameters:
    &object    {Sequence|Table|Field|Index|Index-Field}  
    &o-name    foreign name of the object
    &attrbt    Label of attribute
    &msgidx    index of message
    &msgvar    message-variable
    &sh        value in the PROGRESS-schemaholder
    &ns        value in the nativ foreign schema

Output-Parameters:
    none
    
Included in:
    gate/_gat_cmp.p

History:
    hutegger    95/03   creation
    
--------------------------------------------------------------------*/        
/*h-*/

if {&sh} <> {&ns}
 then assign 
    l_{&msgvar}-msg = l_{&msgvar}-msg + "    " + "{&object} "
                    + {&o-name} + ": " + "{&attrbt}"
                    + ( if length(l_msg[{&msgidx}],"character") > 10
                            then chr(10) + chr(9)
                            else ""
                      )
                    + l_msg[{&msgidx}] + chr(10)
                    + chr(9) + "SH: " 
                    + ( if {&sh} = ?
                            then "?" 
                            else string({&sh})
                      )
                    + ( if length(string({&sh}) + string({&ns})
                                 ,"character"                  ) > 30
                            then chr(10)
                            else ""
                      )
                    + chr(9) + "NS: "
                    + ( if {&ns} = ?
                            then "?" 
                            else string({&ns})
                      )
                    + chr(10).

/*------------------------------------------------------------------*/
