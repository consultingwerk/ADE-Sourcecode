&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Procedure
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 
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

  File: _filetyp.p

  Description:
    Computes the filetype of a disk file. This is some combination of:
       STRUCTURED -- a structured (ANALYZE-SUSPEND file).
       TEXT       -- text file
       UIB        -- a NON-webspeed structured file.
       4GL        -- Progress 4gl file
       E4GL       -- Embedded 4GL file
       E4GL-GEN   -- E4GL Generated (intermediate) file.
       HTML       -- HTML file     
       MAPPED     -- HTML file that is has a .w/.p that is not E4GL-GEN.
       JAVA       -- A .java file
       JavaScript -- A .js file
       R-CODE     -- r-code file
       BINARY     -- a binary file
       READ-ONLY  -- file is not writable
       ?          -- file does not exist
  
    Unsupported files:
       There are a variety of files we do not support They return a type of:
          Unsupported
       The p_list will contain the additional value of:
          Spaces-in-name -- if unsupported because of spaces in the name.

  Input Parameters:
     p_fullpath -- the full path

  Output Parameters:
     p_type -- the main type
     p_list -- the type list

  Author:  Wm.T.Wood
  Created: Jan. 1997

---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_fullpath    AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p_type        AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p_list        AS CHAR NO-UNDO.

DEFINE STREAM instream.
DEFINE VARIABLE ch            AS CHARACTER NO-UNDO.
DEFINE VARIABLE temp_fullpath AS CHARACTER NO-UNDO.
DEFINE VARIABLE temp_type     AS CHARACTER NO-UNDO.
DEFINE VARIABLE temp_list     AS CHARACTER NO-UNDO.

/* Check for unsupported files. */
IF OPSYS eq "UNIX":U THEN DO:
  IF INDEX(p_fullpath, " ":U) > 0 
  THEN ASSIGN p_type = "Unsupported":U
              p_list = p_type + ',Spaces-in-Name':U.
END.
IF p_type eq "unsupported":U THEN RETURN.

/* Assume the type is the extension. Get the extention by breaking the name
   into its prefix (ch) and file name (temp_type).  For example, 
   for p_fullpath = "/users/devp/file.w" we get 
     ch="/uesrs/devp/", temp_type="file.w" and p_type=".w"
 */
RUN adecomm/_osprefx.p (p_fullpath, OUTPUT ch, OUTPUT temp_type).
RUN adecomm/_osfext.p (temp_type, OUTPUT p_type).
IF p_type BEGINS ".":U THEN DO:
  IF LENGTH (p_type, "CHARACTER":U) eq 1 
  THEN p_type = "".
  ELSE p_type = SUBSTRING(p_type, 2, -1, "CHARACTER":U).
END.
  
/* ************************ Main Code Block ************************** */

/* First, does the file really exist, and that we really have the full 
   path. */
FILE-INFO:FILE-NAME = p_fullpath.
IF FILE-INFO:FULL-PATHNAME eq ? THEN p_list = ?.
ELSE DO:
  p_fullpath = FILE-INFO:FULL-PATHNAME.

  /* Create a list starting from scratch. */
  p_list = "".      
  
  /* Look at the extension for some basic elements. */
  CASE p_type:
    WHEN "p":U OR WHEN "w":U THEN DO:
      ASSIGN p_type =  "4GL":U
             p_list = p_list + ",4GL,Text".
      /* Is it a structured file (Workshop Generated) or an E4GL temporary
         file? Note that this will also see if it is a Template, and will
         reset the TYPE for web objects. */
      RUN peek-file.             
    END.

    WHEN "i":U THEN DO:
      ASSIGN p_type =  "4GL include":U
             p_list = p_list + ",4GL,Include,Text".
      /* Is it a structured file (Workshop Generated),
         or an E4GL temporary file? */
      RUN peek-file.             
    END.

    WHEN "r":U THEN DO:
      /* Assume this is Progress r-code. */
      ASSIGN p_type = "r-code"
             p_list = "r-code,Binary":U.
    END.
    
    WHEN "html":U OR WHEN "htm":U THEN DO: 
      ASSIGN p_type = "HTML":U
      p_list =  p_list + ",Text,HTML":U.

      /* Search for .w or .p file and check it's type. This will determine
         if the file is an E4GL file or if it has a companion html-mapping 
         web-object.  */
      ASSIGN ch = SUBSTRING(p_fullpath, 1, R-INDEX(p_fullpath, ".":U), "CHARACTER":U) 
             temp_fullpath = SEARCH(ch + "w":U).
      IF temp_fullpath eq ? THEN temp_fullpath = SEARCH(ch + "p":U).
      IF temp_fullpath ne ? THEN DO:
         RUN webtools/util/_filetyp.p (INPUT  temp_fullpath,
                                       OUTPUT temp_type,
                                       OUTPUT temp_list ).        
         p_list = p_list + 
                 (IF LOOKUP("E4GL-GEN", temp_list) > 0 THEN ",E4GL":U ELSE ",MAPPED":U).
      END.
      ELSE DO:
         /* If there is no .w or .p, look for a .off file. This also will indicate that
            the file is an HTML Mapping file. */
         IF SEARCH(ch + "off":U) ne ? THEN p_list = p_list + ",MAPPED":U.
         ELSE DO:
          /* There is no .w or .p, or .off, but there is a .r.  Probably E4GL. */
           IF SEARCH(ch + "r":U) ne ? THEN p_list = p_list + ",E4GL":U. 
         END.
      END.
    END. /* HTML or HTM */   
  
    
    /* Java/JavaScript source and class files. */
    WHEN "class":U THEN
      ASSIGN p_list =  p_list + ",Binary":U.        
    WHEN "java":U  THEN 
      ASSIGN p_list =  p_list + ",Java,Text":U.             
    WHEN "js":U  THEN 
      ASSIGN p_type = "JavaScript"
             p_list =  p_list + ",JavaScript,Text":U.


    /* Text File Options. */
    WHEN "asp":U OR  /* Active Server Page -- MS IIS Web Servers */
    WHEN "bat":U OR
    WHEN "cgi":U OR
    WHEN "cnf":U OR  /* WebSpeed Configuration files */
    WHEN "dat":U OR 
    WHEN "ini":U OR
    WHEN "log":U OR  /* WebSpeed error/session logs */
    WHEN "off":U OR  /* WebSpeed TAGEXTRACT offset files. */
    WHEN "sh":U  OR 
    WHEN "txt":U  THEN 
      ASSIGN p_list =  p_list + ",Text":U.

    WHEN "exe":U OR WHEN "gif":U OR WHEN "jpg":U OR WHEN "jpeg":U THEN 
      ASSIGN p_list =  p_list + ",Binary":U.
    
  END CASE. /* p_type */

  /* Is the file read-only? */
  FILE-INFO:FILE-NAME = p_fullpath.
  IF INDEX (FILE-INFO:FILE-TYPE, "W":U) eq 0 THEN p_list = p_list + ",Read-Only":U.
  
  /* Remove leading commas. */
  p_list = LEFT-TRIM (p_list, ",":U).
END.

RETURN.
&ANALYZE-RESUME
/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE peek-file 
PROCEDURE peek-file :
/*------------------------------------------------------------------------------
  Purpose:  Open the file and see if the first list begins with
            "&ANALYZE-SUSPEND"  or if it begins *E4GL- for E4GL 
            generated files.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE aline     AS CHAR EXTENT 10 NO-UNDO.
  DEFINE VARIABLE bline     AS CHAR EXTENT 10 NO-UNDO.
  DEFINE VARIABLE iPos      AS INTEGER        NO-UNDO.
  DEFINE VARIABLE test-file AS CHAR           NO-UNDO.
  
  INPUT STREAM instream FROM VALUE(p_fullpath).
  Read-Top-of-File:
  REPEAT ON END-KEY UNDO Read-Top-of-File, LEAVE Read-Top-of-File:
    IMPORT STREAM instream aline NO-ERROR.
    IF ERROR-STATUS:ERROR THEN LEAVE Read-Top-of-File.
    IF aline[1] ne "":U THEN DO:
      IF aline[1] eq "&ANALYZE-SUSPEND":U AND
         aline[2] eq "_VERSION-NUMBER":U 
      THEN DO:
        p_list = p_list + ",Structured":U. 
        /* Is this a WebSpeed file? */
        IF aline[3] BEGINS "UIB_":U THEN p_list = p_list + ",UIB":U.
        /* In WebSpeed 2, the line should be:
           &ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 type Template */
        IF aline[3] BEGINS "WDT_v":U THEN DO:
          IF (aline[3] BEGINS "WDT_v1") THEN DO:
            /* V1 File -- guess that is is HTML-Mapping if we can file
               a .off file. */
            iPos = R-INDEX (p_fullpath, ".":U).
            IF iPos > 0 AND 
               SEARCH(SUBSTRING(p_fullpath, 1, iPos, "CHARACTER":U) + "off":U) ne ?
            THEN p_list = p_list + ",Html-Mapping":U.
          END.
          ELSE DO:
            /* Post V1 file -- Look for header information. */
            p_type = aline[4].
            IF aline[5] eq "Template":U THEN p_list = p_list + ",Template":U.
            /* Peek at the second line to see if this .w file maps an HTML
             * File. If so, the second line will be
             *        "/* Maps: <filename> */"
             * Note: <filename may be just HTML in some cases. */  
            IMPORT STREAM instream bline NO-ERROR.
            IF ERROR-STATUS:ERROR THEN LEAVE Read-Top-of-File.   
            IF bline[1] eq "/*":U AND bline[2] eq "Maps:":U 
            THEN p_list = p_list + ",Html-Mapping":U.        
          END. /* IF...WDT_v2... */
        END. /* IF...WDT... */
      END. /* IF...Structured */
      ELSE IF aline[1] BEGINS '/*E4GL-':U THEN DO:
        ASSIGN p_list = ",E4GL-Gen" + p_list
               p_type = "Embedded SpeedScript".
      END.
      /* Stop looking. */
      LEAVE Read-Top-of-File.
    END.
  END.
  INPUT STREAM instream CLOSE.

END PROCEDURE.
&ANALYZE-RESUME
