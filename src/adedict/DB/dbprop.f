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

File: dbprop.f

Description:   
   This file contains the form for displaying some database properties.
   This information will be read-only.

Author: Laura Stern

Date Created: 03/05/92 

History:
    tomn    01/10/96    Added codepage to DB Properties form (s_Db_Cp)
    
----------------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})

   s_CurrDb    	 LABEL "Logical Name" 	 colon 16 
                 FORMAT "x(32)" view-as TEXT       SKIP
   s_Db_Pname 	 LABEL "Physical Name"	 colon 16  
                 FORMAT "x(50)" view-as TEXT       SKIP
   s_Db_Holder	 LABEL "Schema Holder"	 colon 16  
                 FORMAT "x(32)" view-as TEXT       SKIP
   s_Db_Type 	 LABEL "Type"	      	 colon 16
                 FORMAT "x(12)" view-as TEXT        SKIP
   s_Db_Cp       LABEL "Codepage"        colon 16
                 FORMAT "x(32)" view-as TEXT       

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &HELP   = s_btn_Help}

   with frame dbprops SIDE-LABELS NO-BOX DEFAULT-BUTTON s_btn_OK.


