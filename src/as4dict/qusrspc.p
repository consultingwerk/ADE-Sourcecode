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

/* qusrspc.p
   Donna L. McMann
   June 30, 1997

   Procedure to CHANGE OR RETRIEVE an entry from the specified user space.
   
   Modified:  08/22/97 OS400 section had ) after str-pos in error D. McMann
              06/09/98 D. McMann Added find for dictdb._file 98-06-08-023
              06/30/98 D. McMann Added  (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                                 to _file Find.
   
*/
DEFINE INPUT        PARAMETER oper        AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER uspace-name AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER lib-name    AS CHARACTER NO-UNDO. 
DEFINE INPUT        PARAMETER strt-pos    AS INTEGER   NO-UNDO.
DEFINE INPUT        PARAMETER dta-length  AS INTEGER   NO-UNDO. 
DEFINE INPUT-OUTPUT PARAMETER data-val    AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER stat        AS INTEGER   NO-UNDO.

DEFINE VARIABLE arecid AS RECID NO-UNDO.


&IF "{&OPSYS}" = "OS400" &THEN
    DEFINE NEW SHARED VARIABLE area          AS CHARACTER          NO-UNDO.
    DEFINE NEW SHARED VARIABLE lib           AS CHARACTER          NO-UNDO.
    DEFINE NEW SHARED VARIABLE str-pos       AS INTEGER            NO-UNDO.
    DEFINE NEW SHARED VARIABLE data-lgth     AS INTEGER            NO-UNDO.
    DEFINE NEW SHARED VARIABLE data-buffer   AS CHARACTER          NO-UNDO.
    DEFINE NEW SHARED VARIABLE operation     AS CHARACTER          NO-UNDO.
    DEFINE NEW SHARED VARIABLE sts           AS INTEGER            NO-UNDO.
    DEFINE NEW SHARED VARIABLE msgarr        AS CHARACTER EXTENT 1 NO-UNDO.
    DEFINE NEW SHARED VARIABLE msgID         AS CHARACTER          NO-UNDO.

    ASSIGN operation     = CAPS(oper)
           area          = CAPS(uspace-name)
           lib           = CAPS(lib-name)
           str-pos       = strt-pos
           data-lgth     = dta-length
           data-buffer   = (IF CAPS(oper) = "C" THEN data-val ELSE "")
           msgID         = "".
           
    OS400 EPI STATUS(sts) MESSAGES(msgarr)
        CALL PGM(usrusrspc)
           PARM(operation      AS CHARACTER(1) USE INPUT)
           PARM(area           AS CHARACTER(10) USE INPUT)
           PARM(lib            AS CHARACTER(10) USE INPUT)
           PARM(str-pos        AS INTEGER(4) USE INPUT)
           PARM(data-lgth      AS INTEGER(4) USE INPUT-OUTPUT)
           PARM(data-buffer    AS CHARACTER(2048) USE INPUT-OUTPUT)
           PARM(msgID          AS CHARACTER(7) USE OUTPUT).

    IF OS-ERROR > 0 THEN
      ASSIGN data-val = ""
             stat = -6.
    ELSE DO:
      IF msgID = "" THEN
          ASSIGN data-val = data-buffer
                 stat = data-lgth.
      ELSE
          ASSIGN data-val = ""
             stat = -6.   
    END.                 
    RETURN.

&ELSE
    IF oper = "C" THEN DO:
    
    FIND FIRST DICTDB._File WHERE DICTDB._File._File-name = "qusrspc"
                              AND  (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
               NO-LOCK NO-ERROR.

    IF NOT AVAILABLE DICTDB._File THEN DO:
      ASSIGN stat = -2.
      RETURN.
    END.  
     
      ASSIGN uspace-name = CAPS(uspace-name)
             lib-name = CAPS(lib-name).

      CREATE as4dict.qusrspc.
      ASSIGN as4dict.qusrspc.usrspc-name = uspace-name
             as4dict.qusrspc.Library-Name = lib-name
             as4dict.qusrspc.start-pos =  strt-pos
             as4dict.qusrspc.Data-length = dta-length
             as4dict.qusrspc.Data-value = data-val.
           
      ASSIGN arecid = RECID(as4dict.qusrspc).           
           
      IF arecid > 0 THEN
            ASSIGN stat = INTEGER(arecid).
      ELSE
            ASSIGN stat = 0.
    END.
    ELSE DO:
       ASSIGN uspace-name = CAPS(uspace-name)
           lib-name = CAPS(lib-name).

       FIND FIRST as4dict.qusrspc WHERE as4dict.qusrspc.usrspc-name = uspace-name
                                    AND as4dict.qusrspc.Library-Name = lib-name
                                    AND as4dict.qusrspc.start-pos =  strt-pos
                                    AND as4dict.qusrspc.Data-length = dta-length
                                    NO-LOCK NO-ERROR.
                         
       IF AVAILABLE as4dict.qusrspc THEN DO:
          IF as4dict.qusrspc.data-length > 0 THEN
            ASSIGN data-val = as4dict.qusrspc.Data-value
                   stat = as4dict.qusrspc.Data-length.
          ELSE
            ASSIGN data-val = ""
                   stat = 0.
       END.        
    END.  

    RETURN.
&ENDIF










