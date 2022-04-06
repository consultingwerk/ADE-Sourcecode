/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: qidxrpt.p

Description:
   Quick and dirty area report for both the GUI and character dictionary.

Input Parameters:
   p_DbId    - Id of the _Db record corresponding to the current database
   p_PName   - Physical name of the database
   p_DbType  - Database type (e.g., PROGRESS)

 
Author: Donna McMann

Date Created: 1/5/98
     History:  09/22/99 Corrected help preprocessor variable

----------------------------------------------------------------------------*/

{adecomm/commeng.i}  /* Help contexts */

DEFINE INPUT PARAMETER p_DbId 	 AS RECID NO-UNDO.
DEFINE VAR header_str AS CHAR 	 NO-UNDO.


header_str =  " Storage Areas and extent information ".

RUN adecomm/_report.p 
   (INPUT p_DbId, 
    INPUT header_str,
    INPUT "Quick Storage Area Report",
    INPUT "",
    INPUT "",
    INPUT "adecomm/_qaredat.p",
    INPUT "",
    INPUT {&QUICK_STORAGE_AREA_REPORT}).


RETURN RETURN-VALUE.
