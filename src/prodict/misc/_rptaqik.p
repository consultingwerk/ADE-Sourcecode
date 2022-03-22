/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _rptaqik.p

Description:
   Quick and dirty area report for character dictionary.
 
Author: Donna McMann

Date Created: 1/5/98

----------------------------------------------------------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

RUN adecomm/_qarerpt.p
   (INPUT drec_db).
