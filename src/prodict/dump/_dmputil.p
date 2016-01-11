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

/*----------------------------------------------------------------------------

File: _dmputil.p

Description:
   This is a persistent procedure library used by the incremental dump utility,
   _dmpincr.p.  

Author: Mario Brunetti

Date Created: 10/04/99
     History: 03/28/00 D. McMann Checking inprimary was looking at the
                                 wrong database to determine if field was there
                                 20000327012.
              08/16/00 D. McMann Added _Db-recid to _storageObject find 20000815029

-----------------------------------------------------------------------------*/

/*------------------------ D E C L A R A T I O N S --------------------------*/

{ prodict/dump/dumpvars.i SHARED }

/*--------------- F U N C T I O N S   &  P R O C E D U R E S ----------------*/
FUNCTION fileAreaMatch RETURNS LOGICAL (INPUT db1FileNo AS INT,
                                        INPUT db2FileNo AS INT,
                                        INPUT db1recid  AS RECID,
                                        INPUT db2recid  AS RECID).
   /* Checks to see that the DICTDB2 file area exists in DICTDB */

   FIND DICTDB._StorageObject WHERE
        DICTDB._StorageObject._Db-recid = db1recid AND
        DICTDB._StorageObject._Object-type = 1 AND
        DICTDB._StorageObject._Object-number = db1FileNo NO-ERROR.
   IF AVAILABLE DICTDB._StorageObject THEN
      FIND DICTDB._Area WHERE
         DICTDB._Area._Area-number = DICTDB._StorageObject._Area-number
      NO-ERROR.
				      
   FIND DICTDB2._StorageObject WHERE
        DICTDB2._StorageObject._Db-recid = db2recid AND
        DICTDB2._StorageObject._Object-type = 1 AND
        DICTDB2._StorageObject._Object-number = db2FileNo
   NO-ERROR.
   IF AVAILABLE DICTDB2._StorageObject THEN
      FIND DICTDB2._Area WHERE
           DICTDB2._Area._Area-number = DICTDB2._StorageObject._Area-number
      NO-ERROR.

   IF DICTDB._Area._Area-Name = DICTDB2._Area._Area-Name THEN
      RETURN TRUE.

   RETURN FALSE.

END FUNCTION.

FUNCTION indexAreaMatch RETURNS LOGICAL(INPUT db1IndexNo AS INT,
                                        INPUT db2IndexNo AS INT,
                                        INPUT db1recid   AS RECID,
                                        INPUT db2recid   AS RECID).

   FIND DICTDB._StorageObject WHERE
        DICTDB._StorageObject._Db-recid = db1recid AND
        DICTDB._StorageObject._Object-type = 2 AND
	    DICTDB._Storageobject._Object-number = db1IndexNo NO-ERROR.
   IF AVAILABLE DICTDB._StorageObject THEN
      FIND DICTDB._Area WHERE
	   DICTDB._Area._Area-number = DICTDB._StorageObject._Area-number
      NO-ERROR.
   ELSE
   FIND DICTDB._Area WHERE
        DICTDB._Area._Area-number = db1IndexNo NO-ERROR.

   FIND DICTDB2._StorageObject WHERE
        DICTDB2._StorageObject._db-recid = db2recid AND
        DICTDB2._StorageObject._Object-type = 2 AND
	DICTDB2._Storageobject._Object-number = db2IndexNo NO-ERROR.
   IF AVAILABLE DICTDB2._StorageObject THEN
      FIND DICTDB2._Area WHERE
	   DICTDB2._Area._Area-number = DICTDB2._StorageObject._Area-number
      NO-ERROR.
   ELSE
   FIND DICTDB2._Area WHERE
        DICTDB2._Area._Area-number = db2IndexNo NO-ERROR.

   IF DICTDB._Area._Area-Name = DICTDB2._Area._Area-Name THEN
      RETURN TRUE.
   
   RETURN FALSE.

END FUNCTION.

FUNCTION inprimary RETURNS LOGICAL (INPUT p_db1PrimeIndex AS RECID,
                                    INPUT p_db1RecId      AS RECID).
   
    /* Determines whether a field is part of an primary index */

 DEFINE BUFFER _Field-Pri FOR DICTDB2._Field.   
  
   FIND DICTDB2._Index WHERE
      RECID(DICTDB2._Index) = p_db1PrimeIndex NO-ERROR.
   IF AVAIL DICTDB2._Index THEN
   FOR EACH DICTDB2._Index-Field OF DICTDB2._Index:
   
      FIND DICTDB2._Field-Pri WHERE
      RECID(DICTDB2._Field-Pri) = DICTDB2._Index-Field._Field-Recid NO-ERROR.

     IF AVAIL DICTDB2._Field-Pri AND
      RECID(DICTDB2._Field-Pri) = p_db1Recid THEN
         RETURN TRUE.
   END.

   RETURN FALSE.
   
END FUNCTION.

/* We don't delete indexes first because Progress doesn't let you delete
   the last index.  So if we are about to rename an index or add a new
   one, see if an index with this name is in the list to be deleted.
   If so, rename that one so we don't get a name conflict.  It will 
   be deleted later.
*/
PROCEDURE Check_Index_Conflict:

   DEFINE INPUT PARAMETER p_i1Name LIKE index-list.i1-name.
   DEFINE INPUT PARAMETER p_db1-file-name LIKE _File._FIle-name.

   DEFINE VAR tempname AS CHAR INITIAL "temp-" NO-UNDO.
   DEFINE VAR lastCnt  AS INTEGER NO-UNDO.
   
   FIND FIRST index-alt WHERE NOT index-alt.i1-i2 AND /* to be deleted */
                    index-alt.i1-name = p_i1Name NO-ERROR. 
   IF AVAILABLE index-alt THEN DO:
      lastCnt = cnt.
      DO WHILE cnt = lastCnt:
         cnt = RANDOM(10000,99999).
      END.
      tempname = tempname + STRING(cnt).
      PUT STREAM ddl UNFORMATTED
        'RENAME INDEX "' index-alt.i1-name
        '" TO "' tempname
        '" ON "' p_db1-file-name '"' SKIP(1).
      index-alt.i1-name = tempname.
   END.
END.

PROCEDURE tmp-name:
   /* This procedure takes a field name and renames it to a unique
    * name so it can be deleted later. This is done in the instance
    * when a field has changed data-type or extent and is part of a
    * primary index. Since the index will not be deleted until later
    * on in the code. We will rename it and delete it later
    */
   DEFINE INPUT  PARAMETER fname   AS CHAR NO-UNDO.
   DEFINE OUTPUT PARAMETER newname AS CHAR NO-UNDO.

   DEFINE VARIABLE s AS INT NO-UNDO.

   DO s = 1 to 99:
     newname = "Z_" + substring(fname,1,28) + string(s,"99").
     FIND FIRST DICTDB.old-field WHERE DICTDB.old-field._Field-name = newname
          NO-ERROR.
     IF NOT AVAILABLE(DICTDB.old-field) THEN DO:
       FIND FIRST DICTDB2.new-field WHERE 
           DICTDB2.new-field._Field-name = newname
           NO-ERROR.
       IF NOT AVAILABLE(DICTDB2.new-field) THEN DO:
         FIND FIRST missing WHERE missing.name = newname NO-ERROR.
         IF NOT AVAILABLE(missing) THEN LEAVE. /* got it! */
       END.
     END.
   END. 
END PROCEDURE.   

/* Stolen from _dctquot.p - SO!  If you update this for any reason   
 *  (not very likely) consider if that should be updated             
 */
PROCEDURE dctquot:

   DEFINE INPUT  PARAMETER inline  AS CHARACTER            NO-UNDO.
   DEFINE INPUT  PARAMETER quotype AS CHARACTER            NO-UNDO.
   DEFINE OUTPUT PARAMETER outline AS CHARACTER INITIAL "" NO-UNDO.
   DEFINE        VARIABLE  i       AS INTEGER              NO-UNDO.

   IF INDEX(inline,quotype) > 0 THEN
     DO i = 1 TO LENGTH(inline):
       outline = outline + (IF SUBSTRING(inline,i,1) = quotype
                 THEN quotype + quotype ELSE SUBSTRING(inline,i,1)).
     END.
   ELSE
     outline = inline.

   outline = (IF outline = ? THEN "?" ELSE quotype + outline + quotype).

END PROCEDURE.

