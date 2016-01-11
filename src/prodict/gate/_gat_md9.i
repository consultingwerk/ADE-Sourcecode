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
/*
File:    prodict/gate/_gat_md9.i

Description:
    loads in all data in all (apropriate) tables

Text-Parameters:
    &db-type        "ora", "odb" or "syb"
    &tmp-name       "osh", "odb" or "ssh"
    
Included in:
  prodict/odb/_odb_md9.p
  prodict/ora/_ora_md9.p
  prodict/syb/_syb_md9.p
  
History:
    94/08/09    hutegger    inserted sys.p-support and
                            extented where-clause for each _File
                            plus contracted ora- odb- & syb_md9.p to use
                            this include  
    94/02/11    hutegger    changed input-parameter of runload.i to "y"
    98/07/13    D. McMann   added _Owner to _file finds
    99/02/11    Mario B     bug 98-10-26-014, clean up empty .e files  
    99/02/24    D. McMann   Removed fix for 98-10-26-014
    99/03/05    Mario B     bug 98-10-26-014, clean up empty .e files revised
    00/05/31    D. McMann   Added check for MSS to use correct name for alias
    
*/

{ prodict/dictvar.i NEW }
{ prodict/{&db-type}/{&db-type}var.i }

DEFINE NEW SHARED STREAM   loaderr.
DEFINE NEW SHARED VARIABLE errs   AS INTEGER INITIAL 0 NO-UNDO.
DEFINE NEW SHARED VARIABLE recs   AS INTEGER INITIAL 0. /*UNDO*/
DEFINE NEW SHARED VARIABLE xpos   AS INTEGER INITIAL ? NO-UNDO.
DEFINE NEW SHARED VARIABLE ypos   AS INTEGER INITIAL ? NO-UNDO.
DEFINE            VARIABLE noload AS CHARACTER NO-UNDO.
DEFINE            VARIABLE wtype  AS CHARACTER NO-UNDO.

IF NOT SESSION:BATCH-MODE THEN
    OUTPUT TO VALUE ({&tmp-name}_dbname + "out.tmp") NO-MAP.
ASSIGN wtype = "{&db-type}".
IF wtype = "mss" THEN DO:
  CREATE ALIAS "DICTDB2" FOR DATABASE VALUE({&db-type}_pdbname).
  FIND DICTDB._Db WHERE DICTDB._Db._Db-name = {&db-type}_pdbname.
END.
ELSE DO:
  CREATE ALIAS "DICTDB2" FOR DATABASE VALUE({&db-type}_dbname).
  FIND DICTDB._Db WHERE DICTDB._Db._Db-name = {&db-type}_dbname.
END.
assign noload = "u".
{ prodict/dictgate.i
    &action = "undumpload"
    &dbtype = "_Db._Db-type"
    &dbrec  = "RECID(_Db)"
    &output = "noload"
    }
    
FOR EACH DICTDB._File OF DICTDB._Db
  WHERE NOT DICTDB._File._Hidden
  AND   _file._File-number > 0
  AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
  AND   (noload = "" OR NOT CAN-DO(noload,_File._For-type)) 
  BY DICTDB._File._File-name:

  OUTPUT STREAM loaderr TO VALUE(_Dump-name + ".e") NO-ECHO.
  INPUT FROM VALUE(_Dump-name + ".d") NO-ECHO NO-MAP.
  RUN prodict/misc/_runload.i (INPUT "y") _File-name 0 100 _File-name 0.
  INPUT  CLOSE.
  OUTPUT STREAM loaderr CLOSE.  
  IF errs < 1 THEN OS-DELETE VALUE(_Dump-name + ".e"). 

END.

IF NOT SESSION:BATCH-MODE THEN
    OUTPUT CLOSE.

RETURN.

