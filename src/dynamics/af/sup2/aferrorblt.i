/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
RUN mip-bl-error (
    "{1}",
    "{2}",
(IF {3} = ? THEN "?" ELSE TRIM(STRING({3})))
&IF "{4}" <> "" &THEN + "|" + (IF {4} = ? THEN "?" ELSE TRIM(STRING({4}))) &ENDIF
&IF "{5}" <> "" &THEN + "|" + (IF {5} = ? THEN "?" ELSE TRIM(STRING({5}))) &ENDIF
&IF "{6}" <> "" &THEN + "|" + (IF {6} = ? THEN "?" ELSE TRIM(STRING({6}))) &ENDIF
&IF "{7}" <> "" &THEN + "|" + (IF {7} = ? THEN "?" ELSE TRIM(STRING({7}))) &ENDIF
&IF "{8}" <> "" &THEN + "|" + (IF {8} = ? THEN "?" ELSE TRIM(STRING({8}))) &ENDIF
&IF "{9}" <> "" &THEN + "|" + (IF {9} = ? THEN "?" ELSE TRIM(STRING({9}))) &ENDIF
&IF "{10}" <> "" &THEN + "|" + (IF {10} = ? THEN "?" ELSE TRIM(STRING({10}))) &ENDIF
&IF "{11}" <> "" &THEN + "|" + (IF {11} = ? THEN "?" ELSE TRIM(STRING({11}))) &ENDIF
).
&IF "{12}" <> "" &THEN 
&MESSAGE "Too many arguments to include file af/sup/aferrortxt.i" 
&ENDIF

