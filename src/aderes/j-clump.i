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
/* j-clump.i - shared definitions for field acquisition program */

DEFINE {1} SHARED TEMP-TABLE qbf-clump NO-UNDO
  FIELD qbf-csho AS LOGICAL              /* sublist expanded? */
  FIELD qbf-cfil AS INTEGER              /* table id (in relationship table) */
  FIELD qbf-csiz AS INTEGER              /* used entrys for following */
  FIELD qbf-calc AS CHARACTER            /* calc field type */
  FIELD qbf-cnam AS CHARACTER EXTENT 512 /* field name */
  FIELD qbf-clbl AS CHARACTER EXTENT 512 /* field label */
  FIELD qbf-cext AS INTEGER   EXTENT 512 /* extent */
  FIELD qbf-ccnt AS INTEGER   EXTENT 512 /* for extent processing */
  FIELD qbf-cone AS INTEGER              /* scrap #1 */
  FIELD qbf-ctwo AS INTEGER              /* scrap #2 */
  INDEX qbf-clump-index IS PRIMARY UNIQUE qbf-cfil.

/* j-clump.i - end of file */

