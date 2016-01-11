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
  /* Additional fields beyond the data fields which are a standard part of the RowObject Temp-Table definition. */
  /* Included into data.i and into all browsers and other objects which use the Temp-Table definition.          */
   FIELD RowNum       AS INTEGER
   FIELD RowIdent     AS CHARACTER
   FIELD RowMod       AS CHARACTER INIT "":U
   FIELD RowIdentIdx  AS CHARACTER
   FIELD RowUserProp  AS CHARACTER
   INDEX RowNum       IS PRIMARY   RowNum      /* Not UNIQUE because copied for pre-mod */
   INDEX RowMod                    RowMod
   INDEX RowIdentIdx               RowIdentIdx
   /* RowIdentIdx */
   /* The RowIdentIdx field and index is added to fix the Rocket's index length limitation of 188 chars.        */
   /* Further in the code the RowIdentIdx field is deliberately trimmed to guaranteedly not exceed this limit.  */ 
   /* The trimmed field is used for indexed search to keep the satisfactory performance                         */
   /* RowUserProp */
   /* The RowUserProp field is added to allow user properties to be passed back and forth.                      */
   /* The values in this field must be CHR(3) and CHR(4) delimited                                              */
