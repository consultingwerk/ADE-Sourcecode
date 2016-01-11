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

/* qdtarcv.p
   Donna L. McMann
   May 13, 1997

   Procedure to receive an entry from the specified data queue.

   Modified: 06/09/98 D. McMann Added find for dictdb._file 98-06-08-023
             06/30/98 D. McMann Added (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                                to _File find.
   
*/

DEFINE INPUT        PARAMETER  que-name  AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER  lib-name  AS CHARACTER NO-UNDO. 
DEFINE INPUT        PARAMETER  ky-data   AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER  ky-length AS INTEGER   NO-UNDO. 
DEFINE INPUT        PARAMETER  ky-order  AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER  wt-time   AS DECIMAL   NO-UNDO.

DEFINE INPUT-OUTPUT PARAMETER send-data AS CHARACTER NO-UNDO.

DEFINE OUTPUT       PARAMETER ent-data  AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER stat      AS INTEGER   NO-UNDO.



&IF "{&OPSYS}" = "OS400" &THEN
    DEFINE NEW SHARED VARIABLE queue         AS CHARACTER          NO-UNDO.
    DEFINE NEW SHARED VARIABLE lib           AS CHARACTER          NO-UNDO.
    DEFINE NEW SHARED VARIABLE wait-time     AS INTEGER            NO-UNDO.
    DEFINE NEW SHARED VARIABLE key-length    AS INTEGER            NO-UNDO.
    DEFINE NEW SHARED VARIABLE key-buffer    AS CHARACTER          NO-UNDO.
    DEFINE NEW SHARED VARIABLE entry-buffer  AS CHARACTER          NO-UNDO.
    DEFINE NEW SHARED VARIABLE entry-length  AS INTEGER            NO-UNDO.
    DEFINE NEW SHARED VARIABLE operation     AS CHARACTER          NO-UNDO.
    DEFINE NEW SHARED VARIABLE key-order     AS CHARACTER          NO-UNDO.
    DEFINE NEW SHARED VARIABLE sender-length AS INTEGER            NO-UNDO.
    DEFINE NEW SHARED VARIABLE sender-buffer AS CHARACTER          NO-UNDO.
    DEFINE NEW SHARED VARIABLE sts           AS INTEGER            NO-UNDO.
    DEFINE NEW SHARED VARIABLE msgarr        AS CHARACTER EXTENT 1 NO-UNDO.
    DEFINE NEW SHARED VARIABLE msgID         AS CHARACTER          NO-UNDO.

    ASSIGN operation     = "R"
           queue         = CAPS(que-name)
           lib           = CAPS(lib-name)
           entry-length  = 0
           entry-buffer  = ""
           key-length    = ky-length
           key-buffer    = ky-data
           key-order     = ky-order
           wait-time     = wt-time
           sender-length = 64.

    OS400 EPI STATUS(sts) MESSAGES(msgarr)
        CALL PGM(usrdtaq)
           PARM(operation      AS CHARACTER(1) USE INPUT)
           PARM(queue          AS CHARACTER(10) USE INPUT)
           PARM(lib            AS CHARACTER(10) USE INPUT)
           PARM(entry-length   AS INTEGER(4) USE INPUT-OUTPUT)
           PARM(entry-buffer   AS CHARACTER(2048) USE INPUT-OUTPUT)
           PARM(key-length     AS INTEGER(4) USE INPUT)
           PARM(key-buffer     AS CHARACTER(256) USE INPUT)
           PARM(key-order      AS CHARACTER(2) USE INPUT)
           PARM(wait-time      AS INTEGER(4) USE INPUT)
           PARM(sender-length  AS INTEGER(4) USE INPUT-OUTPUT)
           PARM(sender-buffer  AS CHARACTER(64) USE OUTPUT)
           PARM(msgID          AS CHARACTER(7) USE OUTPUT).

    IF OS-ERROR > 0 THEN
      ASSIGN ent-data = ""
             stat = -1.
    ELSE 
      ASSIGN ent-data = entry-buffer
             send-data = (IF substring(send-data, 1,1) = "Y" THEN
                          sender-buffer ELSE "")
             stat = entry-length.

    RETURN.
&ELSE

    DEFINE VARIABLE dta-length AS RECID NO-UNDO.
    
    FIND FIRST DICTDB._File WHERE DICTDB._File._File-name = "qdtaq-entry" 
                              AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                              NO-LOCK NO-ERROR.

    IF NOT AVAILABLE DICTDB._File THEN DO:
      ASSIGN stat = -2.
      RETURN.
    END.  


    ASSIGN que-name = CAPS(que-name)
           lib-name = CAPS(lib-name).

    CASE ky-order:
    
        WHEN "EQ" THEN
          FIND FIRST as4dict.qdtaq-entry WHERE as4dict.qdtaq-entry.queue-name = que-name
                                 AND as4dict.qdtaq-entry.library-name = lib-name
                                 AND as4dict.qdtaq-entry.wait-time = wt-time
                                 AND as4dict.qdtaq-entry.key-length = ky-length
                                 AND as4dict.qdtaq-entry.Key-data = ky-data
                                 AND as4dict.qdtaq-entry.Sender-Data-length = 64
                                 NO-LOCK NO-ERROR.
         WHEN "GE" THEN
           FIND FIRST as4dict.qdtaq-entry WHERE as4dict.qdtaq-entry.queue-name = que-name
                                 AND as4dict.qdtaq-entry.library-name = lib-name
                                 AND as4dict.qdtaq-entry.wait-time = wt-time
                                 AND as4dict.qdtaq-entry.key-length = ky-length
                                 AND as4dict.qdtaq-entry.Key-data >= ky-data
                                 AND as4dict.qdtaq-entry.Sender-Data-length = 64
                                 NO-LOCK NO-ERROR.
                                 
         WHEN "LE" THEN
           FIND FIRST as4dict.qdtaq-entry WHERE as4dict.qdtaq-entry.queue-name = que-name
                                 AND as4dict.qdtaq-entry.library-name = lib-name
                                 AND as4dict.qdtaq-entry.wait-time = wt-time
                                 AND as4dict.qdtaq-entry.key-length = ky-length
                                 AND as4dict.qdtaq-entry.Key-data <= ky-data
                                 AND as4dict.qdtaq-entry.Sender-Data-length = 64
                                 NO-LOCK NO-ERROR.
                                 
         WHEN "NE" THEN
           FIND FIRST as4dict.qdtaq-entry WHERE as4dict.qdtaq-entry.queue-name = que-name
                                 AND as4dict.qdtaq-entry.library-name = lib-name
                                 AND as4dict.qdtaq-entry.wait-time = wt-time
                                 AND as4dict.qdtaq-entry.key-length = ky-length
                                 AND as4dict.qdtaq-entry.Key-data <> ky-data
                                 AND as4dict.qdtaq-entry.Sender-Data-length = 64
                                 NO-LOCK NO-ERROR.
         WHEN "GT" THEN
           FIND FIRST as4dict.qdtaq-entry WHERE as4dict.qdtaq-entry.queue-name = que-name
                                 AND as4dict.qdtaq-entry.library-name = lib-name
                                 AND as4dict.qdtaq-entry.wait-time = wt-time
                                 AND as4dict.qdtaq-entry.key-length = ky-length
                                 AND as4dict.qdtaq-entry.Key-data > ky-data
                                 AND as4dict.qdtaq-entry.Sender-Data-length = 64
                                 NO-LOCK NO-ERROR.
                                 
         WHEN "LT" THEN
           FIND FIRST as4dict.qdtaq-entry WHERE as4dict.qdtaq-entry.queue-name = que-name
                                 AND as4dict.qdtaq-entry.library-name = lib-name
                                 AND as4dict.qdtaq-entry.wait-time = wt-time
                                 AND as4dict.qdtaq-entry.key-length = ky-length
                                 AND as4dict.qdtaq-entry.Key-data < ky-data
                                 AND as4dict.qdtaq-entry.Sender-Data-length = 64
                                 NO-LOCK NO-ERROR.
                                 
        OTHERWISE                             
            FIND FIRST as4dict.qdtaq-entry WHERE as4dict.qdtaq-entry.queue-name = que-name
                                 AND as4dict.qdtaq-entry.library-name = lib-name
                                 AND as4dict.qdtaq-entry.wait-time = wt-time
                                 AND as4dict.qdtaq-entry.Sender-Data-length = 64
                                 NO-LOCK NO-ERROR.                         
    END CASE.     
               
    IF AVAILABLE as4dict.qdtaq-entry THEN DO:
        IF as4dict.qdtaq-entry.entry-length > 0 THEN
            ASSIGN ent-data = as4dict.qdtaq-entry.entry-data
                   send-data = (IF substring(send-data,1,1) = "Y" THEN
                                substring(as4dict.qdtaq-entry.Sender-Data,9,56) ELSE "")
                   stat = as4dict.qdtaq-entry.entry-length.
        ELSE
            ASSIGN ent-data = ""
                   send-data = ""
                   stat = 0.
    END.        

    RETURN.
&ENDIF


