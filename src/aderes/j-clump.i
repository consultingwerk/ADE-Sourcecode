/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

