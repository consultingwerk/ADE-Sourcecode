/*********************************************************************
* Copyright (C) 2106,2113 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
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
    fernando 06/06/06    Added large sequence and keys to DB Properties form
        
----------------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})

   s_CurrDb    	 LABEL "Logical Name" 	 colon 21
                 FORMAT "x(32)" view-as TEXT       SKIP
   s_Db_Pname 	 LABEL "Physical Name"	 colon 21  
                 FORMAT "x(50)" view-as TEXT       SKIP
   s_Db_Holder	 LABEL "Schema Holder"	 colon 21  
                 FORMAT "x(32)" view-as TEXT       SKIP
   s_Db_Type 	 LABEL "Type"	      	 colon 21
                 FORMAT "x(12)" view-as TEXT        SKIP
   s_Db_Cp       LABEL "Codepage"        colon 21
                 FORMAT "x(32)" view-as TEXT    SKIP      
   s_Db_Partition_Enabled label "Table Partitioning"  colon 21
                 FORMAT "x(32)" view-as TEXT    SKIP      
   s_Db_Multi_Tenancy label "Multi-tenancy"  colon 21
                 FORMAT "x(32)" view-as TEXT    SKIP      
   s_Db_CDC_Enabled label "Change Data Capture"  colon 21
                 FORMAT "x(32)" view-as TEXT    SKIP      
   s_Db_Large_Sequence LABEL "64-bit Sequences" colon 21
                 FORMAT "x(12)" view-as TEXT SKIP
   s_Db_Large_Keys LABEL "Large Key Entries"     colon 21 
                 FORMAT "x(12)" view-as TEXT    SKIP    
   s_Db_Description  LABEL "Description" colon 21
                FORMAT "X(70)" view-as FILL-IN size 30 BY 1
   s_Db_Add_Details LABEL "Additional Details" colon 21
                FORMAT "X(3000)" view-as EDITOR INNER-CHARS 50 INNER-LINES 3 
                SCROLLBAR-VERTICAL
               

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame dbprops SIDE-LABELS NO-BOX DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel.


