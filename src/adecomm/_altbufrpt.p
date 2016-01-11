/*********************************************************************
* Copyright (C) 2009 by Progress Software Corporation. All rights    *
* reserved.                                                          *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _altbufrpt.p

Description:
   Alternate buffer pool report for both the GUI and character dictionaries.
 
Input Parameters:
   /*p_LName  - Logical name of the database*/
   p_DbId    - Id of the _Db record corresponding to the current database

Author: Fernando de Souza

Date Created: 04/07/09

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/commeng.i}  /* Help contexts */

DEFINE INPUT PARAMETER p_DbId 	 AS RECID NO-UNDO.

DEFINE VAR header_str AS CHAR 	 NO-UNDO.


header_str =  " Alternate Buffer Pool information".

RUN adecomm/_report.p 
   (INPUT p_DbId,
    INPUT header_str,
    INPUT "Quick Alternate Buffer Pool Report",
    INPUT "",
    INPUT "",
    INPUT "adecomm/_altbufdat.p",
    INPUT "",
    INPUT {&Quick_Alternate_Buffer_Pool_Report}).


RETURN RETURN-VALUE.
