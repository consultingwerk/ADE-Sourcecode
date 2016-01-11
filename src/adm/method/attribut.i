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
/****************************************************************************
     PROCEDURE: attribut.i

       PURPOSE: holds general-use variable and table definitions
                for ADM Method Libraries

       REMARKS:

    PARAMETERS: NONE

      HISTORY:
*****************************************************************************/

&IF DEFINED (adm-attribut) = 0 &THEN   /* Make sure not already included */
&GLOB adm-attribut yes

&GLOB      adm-version ADM1.1

/* The new Progress widget attribute ADM-DATA is used to store ADM
   attributes and other ADM-specific information. This is new to 8.1, 
   so use PRIVATE-DATA to preserve the ability to compile with 8.0.
   Also there is a new keyword UNLESS-HIDDEN which allows a DISPLAY/ENABLE
   to bypass fields which are hidden. This is used in building alternate
   layouts. */
&SCOPED-DEFINE MinVersion "8.1 "
&IF INTEGER(SUBSTRING(PROVERSION,1,INDEX(PROVERSION,".":U) - 1)) >~
    INTEGER(SUBSTRING({&MinVersion},1,INDEX({&MinVersion},".":U) - 1))~
    OR~
   (INTEGER(SUBSTRING(PROVERSION,1,INDEX(PROVERSION,".":U) - 1)) =~
    INTEGER(SUBSTRING({&MinVersion},1,INDEX({&MinVersion},".":U) - 1))~
    AND~
    (INTEGER(SUBSTRING(PROVERSION,INDEX(PROVERSION,".":U) + 1,1)) >~
     INTEGER(SUBSTRING({&MinVersion},INDEX({&MinVersion},".":U) + 1,1))~
     OR~
     (INTEGER(SUBSTRING(PROVERSION,INDEX(PROVERSION,".":U) + 1,1)) =~
      INTEGER(SUBSTRING({&MinVersion},INDEX({&MinVersion},".":U) + 1,1))~
      AND~
      SUBSTRING(PROVERSION,INDEX(PROVERSION,".":U) + 1,2) >=~
      SUBSTRING({&MinVersion},INDEX({&MinVersion},".":U) + 1,2))))
&THEN
  &GLOB    adm-data      ADM-DATA
  &GLOB    unless-hidden UNLESS-HIDDEN
&ELSE
  &GLOB    adm-data      PRIVATE-DATA
  &GLOB    unless-hidden 
&ENDIF
&UNDEFINE MinVersion

DEFINE VAR adm-object-hdl       AS HANDLE NO-UNDO. /* current object's handle */
DEFINE VAR adm-query-opened        AS LOGICAL NO-UNDO INIT NO.
DEFINE VAR adm-row-avail-state     AS LOGICAL NO-UNDO INIT ?.
DEFINE VAR adm-initial-lock        AS CHARACTER NO-UNDO INIT "NO-LOCK":U.
DEFINE VAR adm-new-record          AS LOGICAL NO-UNDO INIT no.
DEFINE VAR adm-updating-record     AS LOGICAL NO-UNDO INIT no.
DEFINE VAR adm-check-modified-all  AS LOGICAL NO-UNDO INIT no.

DEFINE NEW GLOBAL SHARED VAR adm-broker-hdl    AS HANDLE  NO-UNDO.

&ENDIF

