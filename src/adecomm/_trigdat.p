/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _trigdat.p

Description:
   Produce a report on all the schema triggers that indicate where the 
   specified procedure is found (full path) and what the CRC status is.

Input Parameters:
   p_DbId    - Id of the _Db record for this database.

Author: Laura Stern

Date Created: 11/18/92 

Modified on 06/14/94 by Gerry Seidl. Added NO-LOCKs to file accesses.
            07/10/98 by D. McMann    Added DBVERSION and _Owner check.
----------------------------------------------------------------------------*/


DEFINE INPUT PARAMETER p_DbId AS RECID NO-UNDO.

DEFINE SHARED STREAM rpt.

Define var crc_val as integer NO-UNDO.
Define var name	   as char    NO-UNDO.
Define var event   as char    NO-UNDO.
Define var proc    as char    NO-UNDO.
Define var crc     as char    NO-UNDO.
Define var any_t   as logical NO-UNDO.  /* any table triggers listed */.
Define var any_f   as logical NO-UNDO.  /* any field triggers listed  */
Define var flags   as char    NO-UNDO.

FORM
   name  FORMAT "x(18)"  COLUMN-LABEL "Table/Field Name"
   event FORMAT "x(6)"   COLUMN-LABEL "Event"
   crc   FORMAT "x(5)"   COLUMN-LABEL "Check!CRC"
   flags FORMAT "x(5)"   COLUMN-LABEL "Flags"
   proc  FORMAT "x(38)"  COLUMN-LABEL "Procedure"
   WITH FRAME shotrig USE-TEXT STREAM-IO DOWN.

FIND _Db WHERE RECID(_Db) = p_DbId NO-LOCK.

/* Go through all tables */
for each _File NO-LOCK where _File._Db-recid = p_DbId:
   IF INTEGER(DBVERSION("DICTDB")) > 8 AND 
     (_File._Owner <> "PUB" AND _File._Owner <> "_FOREIGN")
       THEN NEXT.
   any_t = no.
   for each _File-trig of _File NO-LOCK: 
      assign
      	 name = (if NOT any_t then _File._File-name else "")
      	 any_t = yes
      	 event = ( if _File-trig._Event begins "REPLICATION"
      	             then "RP-" + substring(_File-trig._Event,13,-1,"character")
      	             else _File-trig._Event
      	         )
      	 proc = SEARCH(_File-trig._Proc-Name)
      	 rcode-info:filename = proc
      	 crc_val = rcode-info:crc-value
      	 crc = (if _File-trig._Trig-CRC = ? then "no" else "yes")
      	 flags = (if _File-trig._Override then "*" else "") + 
      	       	 (if crc = "yes" AND crc_val = ? then "nr" else "") +
      	       	 (if crc = "yes" AND crc_val <> ? AND
      	       	     crc_val <> _File-trig._Trig-CRC
      	       	     then "m" else "")
      	 .

      /* In case procedure is in a library, just display name even though
      	 we couldn't find the file.
      */
      if proc = ? then proc = _File-trig._Proc-Name.

      display STREAM rpt
      	 name event crc flags proc with frame shotrig.
      down STREAM rpt with frame shotrig.
   end.

   /* Field info will be interspersed throughout the report, each
      under the table it belongs to.
   */
   for each _Field of _File NO-LOCK:

      any_f = no.
      for each _Field-trig of _Field NO-LOCK:
      	 /* If the table name hasn't been listed yet, display it so user
      	    knows what tables these fields belong to. 
      	 */
      	 if NOT any_t then
      	 do:
      	    display STREAM rpt
      	       _File._File-name @ name with frame shotrig.
      	    down STREAM rpt with frame shotrig.
      	    any_t = yes.
      	 end.
      	 
	 assign
      	    /* field name will be indented slightly from file name */
      	    name = (if NOT any_f then "  " + _Field._Field-Name else "")
      	    any_f = yes
	    event = _Field-trig._Event
	    proc = SEARCH(_Field-trig._Proc-Name)
	    rcode-info:filename = proc
	    crc_val = rcode-info:crc-value
	    crc = (if _Field-trig._Trig-CRC = ? then "no" else "yes")
      	    flags = (if _Field-trig._Override then "*" else "") + 
      	       	    (if crc = "yes" AND crc_val = ? then "nr" else "") +
      	       	    (if crc = "yes" AND crc_val <> ? AND
      	       	     	crc_val <> _Field-trig._Trig-CRC
      	       	     	then "m" else "")
      	 .
   
      /* In case procedure is in a library, just display name even though
      	 we couldn't find the file.
      */
      if proc = ? then proc = _Field-trig._Proc-Name.

	 display STREAM rpt
	    name event crc flags proc with frame shotrig.
	 down STREAM rpt with frame shotrig.
      end.
   end.

   /* Put an extra line between tables */   
   down STREAM rpt with frame shotrig.
end.




