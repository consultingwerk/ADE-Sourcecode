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

