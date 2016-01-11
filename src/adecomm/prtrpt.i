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

File: prtrpt.i

Description:
   Code to set up correct output device and headers for printing.

Arguments:
   &Header - page header string
   &Flags  - Flags string
   &dev    - output device
   &app    - append option
   &siz    - page size
   &Func   - Call to routine that's generates report.
 
Author: Laura Stern

Date Created: 10/12/92

History:
    hutegger    95/05   Added PRINTER-support (output to printer...)
    
----------------------------------------------------------------------*/
/*h-*/

DEFINE VARIABLE h_datetime AS CHARACTER   NO-UNDO.

/* Header with Page specification */
FORM HEADER
   h_datetime FORMAT "x(17)" SPACE(7) "PROGRESS Report"
     "Page" AT 70 PAGE-NUMBER (rpt) FORMAT "ZZZ9" SKIP
   {&Header} FORMAT "x(80)" SKIP(1)
   {&Flags}  FORMAT "x(80)" SKIP
   WITH FRAME page_head_paged
   PAGE-TOP NO-LABELS NO-BOX NO-ATTR-SPACE NO-UNDERLINE USE-TEXT STREAM-IO.

/* Header for continuous output (no page #) */
FORM HEADER
   h_datetime FORMAT "x(17)" SPACE(7) "PROGRESS Report"
   SKIP
   {&Header} FORMAT "x(80)" SKIP(1)
   {&Flags}  FORMAT "x(80)" SKIP
   WITH FRAME page_head_cont
   PAGE-TOP NO-LABELS NO-BOX NO-ATTR-SPACE NO-UNDERLINE USE-TEXT STREAM-IO.

run adecomm/_setcurs.p ("WAIT").
DO ON STOP UNDO, LEAVE:
  IF {&dev} BEGINS "|"
   THEN OUTPUT STREAM rpt
        THROUGH VALUE(SUBSTRING({&dev},2,-1,"character":u)) 
	PAGE-SIZE VALUE({&siz}).
  ELSE IF {&dev} = "PRINTER"
   THEN OUTPUT STREAM rpt TO PRINTER.
  ELSE IF {&app}
   THEN OUTPUT STREAM rpt TO VALUE({&dev}) PAGE-SIZE VALUE({&siz}) APPEND.
   ELSE OUTPUT STREAM rpt TO VALUE({&dev}) PAGE-SIZE VALUE({&siz}).
  
  h_datetime = STRING(TODAY) + " " + STRING(TIME,"HH:MM:SS").
  
  if {&siz} = 0 then
     VIEW STREAM rpt FRAME page_head_cont.
  else	 
     VIEW STREAM rpt FRAME page_head_paged.
  
  RUN {&Func}.
  
  OUTPUT STREAM rpt CLOSE.
END.
run adecomm/_setcurs.p ("").

/*--------------------------------------------------------------------*/
