/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-draw.i - show db file and where clauses */

(IF qbf-file[1] = "" THEN "" ELSE qbf-db[1] + "." + qbf-file[1]
  + (IF qbf-asked[1] BEGINS " " THEN qbf-asked[1] ELSE ""))
  @ qbf-file[1]
(IF qbf-file[2] = "" THEN "" ELSE qbf-db[2] + "." + qbf-file[2]
  + (IF qbf-asked[2] BEGINS " " THEN qbf-asked[2] ELSE ""))
  @ qbf-file[2]
(IF qbf-file[3] = "" THEN "" ELSE qbf-db[3] + "." + qbf-file[3]
  + (IF qbf-asked[3] BEGINS " " THEN qbf-asked[3] ELSE ""))
  @ qbf-file[3]
(IF qbf-file[4] = "" THEN "" ELSE qbf-db[4] + "." + qbf-file[4]
  + (IF qbf-asked[4] BEGINS " " THEN qbf-asked[4] ELSE ""))
  @ qbf-file[4]
(IF qbf-file[5] = "" THEN "" ELSE qbf-db[5] + "." + qbf-file[5]
  + (IF qbf-asked[5] BEGINS " " THEN qbf-asked[5] ELSE ""))
  @ qbf-file[5]
