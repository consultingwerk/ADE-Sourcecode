/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------
File: advice.i
      
      Contains array that says which advisors should be displayed, and which
      the user never wants to see again.
      
 By: Wm.T.Wood   - March 8, 1995
 Modified: 03/24/98 SLK Added NA-Foreign-Fields-advslnk
           06/24/98 SLK Added NA-Signature-Mismatch-advslnk
----------------------------------------------------------------------------*/

&Global-define Advisor-Count 11

DEFINE {1} SHARED VAR _never-advise AS LOGICAL NO-UNDO EXTENT {&Advisor-Count}.

/* Advisors -- define each preprocessor as
      NA-function-name-file
   For example NA-Edit-Query-vrfyqry is the variable to decide that we
   Never Again want to ask about Editing the Query (in vrfyqry). 
   NOTE: the file name is optional if the advise appears in many places.
   
   NOTE: If you change the array order, you must make the corresponding
         change in adeuib/_putpref.p and adeuib/_getpref.p.
*/
   
&Global-define NA-Edit-Query-vrfyqry     _never-advise[1]
&Global-define NA-Add-Link1-advslnk      _never-advise[2]
&Global-define NA-Add-Link2-advslnk      _never-advise[3]
&Global-define NA-No-Query-advslnk       _never-advise[4]
&Global-define NA-OK-Links-run-advsrun   _never-advise[5]
&Global-define NA-Not-On-0-drwsmar       _never-advise[6]  
/* NA-Key-Choice is also used in _linkadd.w */
&Global-define NA-Key-Choice-advslnk     _never-advise[7]
&Global-define NA-Run-TTY-in-GUI         _never-advise[8]
&Global-define NA-Foreign-Fields-advslnk _never-advise[9]
/* NA-Signature-Mismatch-advslnk is also used in _linkadd.w */
&Global-define NA-Signature-Mismatch-advslnk _never-advise[10]
&Global-define NA-OK-Links-save-advsrun   _never-advise[11]
