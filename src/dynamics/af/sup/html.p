/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* html.p
 * Take Dictionary and convert to HTML Document
 */

DEF VAR v-name  AS CHAR NO-UNDO.
DEF VAR v-title AS CHAR NO-UNDO INITIAL "ICFDB Database".
DEF VAR v-home  AS CHAR NO-UNDO INITIAL "C:/temp".
DEF VAR v-inc   AS INTE NO-UNDO.

OUTPUT TO VALUE( v-home + "/index.htm" ).

PUT UNFORMATTED "<html>" SKIP.
PUT UNFORMATTED "<head>" SKIP.
PUT UNFORMATTED "<title>" + v-title + "</title><p>" SKIP.
PUT UNFORMATTED "</head>" SKIP.
PUT UNFORMATTED "<body bgcolor=""white"">" SKIP.
PUT UNFORMATTED "<hr>" SKIP.
PUT UNFORMATTED "<h1><center><font color=red face=""Verdana"">" + v-title. 
PUT UNFORMATTED "</font></center></h1>" SKIP.
PUT UNFORMATTED "<hr>" SKIP.
PUT UNFORMATTED "<p>" SKIP.
PUT UNFORMATTED "<div align=""center""><center>" SKIP.
PUT UNFORMATTED "<table border=""0"" cellpadding=""5"" cellspacing=""5"">" SKIP.

FOR EACH ICFDB._file WHERE 
         ICFDB._file._file-name < "_" 
   NO-LOCK:

   ASSIGN v-inc = v-inc + 1.

   IF v-inc modulo 5 = 1 THEN 
      PUT UNFORMATTED "<tr>" SKIP.

   /** replace any # (hashes) with special encoding for URL %23 = # **/

   ASSIGN v-name = ICFDB._file._dump-name.
   do while index( v-name, "#" ) > 0:
     substring( v-name, index( v-name, "#" ), 1 ) = "%23".
   END. /* do while index( v-name, "#" ) > 0: */

   PUT UNFORMATTED "<td><font face=""Verdana"">".
   PUT UNFORMATTED "<a href=" + v-name + ".htm>" + ICFDB._file._file-name. 
   PUT UNFORMATTED "</a></font></td>" SKIP.
   IF v-inc modulo 5 = 0 THEN 
      PUT UNFORMATTED "</tr>" SKIP.
END. /* FOR EACH ICFDB._file WHERE */

PUT UNFORMATTED "</table>" SKIP.
PUT UNFORMATTED "</center></div>" SKIP.
PUT UNFORMATTED "</p><br>" SKIP.
PUT UNFORMATTED "<hr><br>" SKIP.
PUT UNFORMATTED "<center><font face=""Verdana"">" SKIP.
PUT UNFORMATTED "<i>Last updated " + string( today, "99/99/9999" ) + " ".
PUT UNFORMATTED string( time, "hh:mm:ss am" ) + "</i><br><p>" SKIP.
PUT UNFORMATTED "<hr><br>" SKIP.
PUT UNFORMATTED "</font></center><br><p>" SKIP.
PUT UNFORMATTED "</body>" SKIP.
PUT UNFORMATTED "</html>" SKIP.

OUTPUT CLOSE.

FOR EACH ICFDB._file WHERE 
         ICFDB._file._file-name < "_" 
   NO-LOCK:

   OUTPUT TO VALUE( v-home + "/" + ICFDB._file._dump-name + ".htm" ).

   PUT UNFORMATTED "<html>" SKIP.
   PUT UNFORMATTED "<head>" SKIP.
   PUT UNFORMATTED "<title>" + v-title + " -- " + ICFDB._file._file-name.
   PUT UNFORMATTED "</title><p>" SKIP.
   PUT UNFORMATTED "</head>" SKIP.
   PUT UNFORMATTED "<body bgcolor=""white"">" SKIP.
   PUT UNFORMATTED "<hr>" SKIP.
   PUT UNFORMATTED "<h1><center><font color=""red"" face=""Verdana"">".
   PUT UNFORMATTED v-title + "</font></center></h1>" SKIP.
   PUT UNFORMATTED "<hr>" SKIP.
   PUT UNFORMATTED "<h2><center><font color=""blue"" face=""Verdana"">".
   PUT UNFORMATTED ICFDB._file._file-name + "</font></h2>" SKIP.
   PUT UNFORMATTED "<p><h3>" + ICFDB._file._desc + "</h3></p></center>" SKIP.
   PUT UNFORMATTED "<h4><center><font face=""Verdana"">".
   PUT UNFORMATTED "<a href=" + ICFDB._file._dump-name + ".htm#index>Indexing</a>".
   PUT UNFORMATTED "</font></center></h4>" SKIP.
   PUT UNFORMATTED "<hr>" SKIP.
   PUT UNFORMATTED "<div align=""center""><center>" SKIP.
   PUT UNFORMATTED "<table border=""1"" cellpadding=""4"" cellspacing=""1""".
   PUT UNFORMATTED "bgcolor=""#C0C0C0"">" SKIP.
   PUT UNFORMATTED "<tr>" SKIP.
   PUT UNFORMATTED "<td align=left><font color=""blue"" face=""Verdana"">".
   PUT UNFORMATTED "Field Name</font></th>" SKIP.
   PUT UNFORMATTED "<td align=left><font color=""blue"" face=""Verdana"">".
   PUT UNFORMATTED "Datatype</font></th>" SKIP.
   PUT UNFORMATTED "<td align=right><font color=""blue"" face=""Verdana"">".
   PUT UNFORMATTED "Format</font></th>" SKIP.
   PUT UNFORMATTED "<td align=left><font color=""blue"" face=""Verdana"">".
   PUT UNFORMATTED "Extent</font></th>" SKIP.
   PUT UNFORMATTED "<td align=left><font color=""blue"" face=""Verdana"">".
   PUT UNFORMATTED "Default</font></th>" SKIP.
   PUT UNFORMATTED "<td align=left><font color=""blue"" face=""Verdana"">".
   PUT UNFORMATTED "Description</font></th>" SKIP.
   PUT UNFORMATTED "</tr>" SKIP.

   FOR EACH ICFDB._field  WHERE 
            ICFDB._field._file-recid = RECID(_file) 
      NO-LOCK BY _order :

      PUT UNFORMATTED "<tr>" SKIP.
      PUT UNFORMATTED "<td><font face=""Verdana"">" + ICFDB._field._field-name. 
      PUT UNFORMATTED "</font></td>" SKIP.
      PUT UNFORMATTED "<td><font face=""Verdana"">" + ICFDB._field._data-type. 
      PUT UNFORMATTED "</font></td>" SKIP.
      PUT UNFORMATTED "<td align=right><font face=""Verdana"">". 
      PUT UNFORMATTED ICFDB._field._format + "</font></td>" SKIP.
      IF ICFDB._field._extent > 0 THEN 
      DO:
         PUT UNFORMATTED "<td align=right><font face=""Verdana"">".
	 PUT UNFORMATTED ICFDB._field._extent "</font></td>" SKIP. 
      END.
      ELSE
      DO:
	 PUT UNFORMATTED "<td align=right><font face=""Verdana"">1</font></td>".
	 PUT UNFORMATTED SKIP.
      END.
      IF TRIM(_field._initial) = "" OR
         ICFDB._field._initial       = ?  THEN
	 PUT UNFORMATTED "<td>&nbsp\;</td>" SKIP.
      ELSE
	 PUT UNFORMATTED "<td><font face=""Verdana"">" + ICFDB._field._initial + "</font></td>" SKIP.
      IF TRIM(_field._desc) = "" THEN
	 PUT UNFORMATTED "<td>&nbsp\;</td>" SKIP.
      ELSE
	 PUT UNFORMATTED "<td><font face=""Verdana"">" + ICFDB._field._desc  + "</font></td>" SKIP.
      PUT UNFORMATTED "</tr>" SKIP.
   END. /* FOR EACH ICFDB._field  WHERE */

   PUT UNFORMATTED "</table>" SKIP.
   PUT UNFORMATTED "</p>" SKIP.
   PUT UNFORMATTED "<hr>" SKIP.
   PUT UNFORMATTED "<p><center><font color=blue face=""Verdana""><h3>" SKIP.
   PUT UNFORMATTED "<a name=""index"">Indexing</a></h3></font></center>" SKIP.

   FOR EACH ICFDB._index WHERE 
            ICFDB._index._file-recid = RECID(_file) 
      NO-LOCK:
      PUT UNFORMATTED "<br><font color=red face=""Verdana""><b>". 
      PUT UNFORMATTED ICFDB._index._index-name + "</b></font>" SKIP.
      IF ICFDB._file._prime-index = RECID(_index) THEN 
         PUT UNFORMATTED "<font color=blue face=""Verdana""><i> - Primary </i></font>" SKIP.
      IF ICFDB._index._unique THEN 
         PUT UNFORMATTED "<font color=blue face=""Verdana""><i> - Unique </i></font>" SKIP.

      FOR EACH ICFDB._index-field WHERE 
               ICFDB._index-field._index-recid = RECID(_index) 
         NO-LOCK:
	 FIND ICFDB._field WHERE 
            RECID(_field) = ICFDB._index-field._field-recid 
            NO-LOCK.
         IF AVAIL ICFDB._field THEN
	    PUT UNFORMATTED "<br><font face=""Verdana"">" + ICFDB._field._field-name + "</font>" SKIP.
      END. /* FOR EACH ICFDB._index-field WHERE */
      PUT UNFORMATTED "<p>" SKIP.
   END. /* FOR EACH ICFDB._index WHERE */

   PUT UNFORMATTED "</p><br>" SKIP.
   PUT UNFORMATTED "<hr><br><font face=""Verdana"">" SKIP.
   PUT UNFORMATTED "<i>Last updated " + string( today, "99/99/9999" ) + " ".
   PUT UNFORMATTED string( time, "hh:mm:ss am" ) + "</i>" SKIP.
   PUT UNFORMATTED "<p><br>" SKIP.
   PUT UNFORMATTED "<a href=""index.htm"">Return to Listing Of Database ".
   PUT UNFORMATTED "Tables</a><br><p>" SKIP.
   PUT UNFORMATTED "<hr><br>" SKIP.
   PUT UNFORMATTED "</font><p><br><br>" SKIP.
   PUT UNFORMATTED "</body>" SKIP.
   PUT UNFORMATTED "</html>" SKIP.
   OUTPUT CLOSE.
END. /* FOR EACH ICFDB._file WHERE */

RETURN.

