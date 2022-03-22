/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
  /* Additional fields beyond the data fields which are a standard part of the RowObject Temp-Table definition. */
  /* Included into data.i and into all browsers and other objects which use the Temp-Table definition.          */
   FIELD RowNum        AS INTEGER
   FIELD RowIdent      AS CHARACTER
   FIELD RowMod        AS CHARACTER INIT "":U
   FIELD RowIdentIdx   AS CHARACTER
   FIELD RowUserProp   AS CHARACTER
   FIELD ChangedFields AS CHARACTER
   INDEX RowNum        IS PRIMARY   RowNum      /* Not UNIQUE because copied for pre-mod */
   INDEX RowMod                     RowMod
   INDEX RowIdentIdx                RowIdentIdx
   /* RowIdentIdx */
   /* The RowIdentIdx field and index is added to fix the Rocket's index length limitation of 188 chars.        */
   /* Further in the code the RowIdentIdx field is deliberately trimmed to guaranteedly not exceed this limit.  */
   /* The trimmed field is used for indexed search to keep the satisfactory performance                         */
   /* RowUserProp */
   /* The RowUserProp field is added to allow user properties to be passed back and forth.                      */
   /* The values in this field must be CHR(3) and CHR(4) delimited                                              */
