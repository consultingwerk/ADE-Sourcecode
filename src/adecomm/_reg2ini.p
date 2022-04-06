/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  adecomm/_reg2ini.p
    
    Purpose:   Given a Registry Base Key, it cycles through the sections and 
	creates an ini file. You can specify required sections must be 
	present before the ini file is created.
	THIS IS ONLY FOR MS WINDOWS!!!!
                
    Syntax :
    RUN adetran/pm/_reg2ini.p 
		(INPUT p-basekey, /* Registry Base Key */
		INPUT p-subKey,	 	/* Registry SubKey */
                INPUT p-reqSection,		/* Sections required 
						before generating ini */
                INPUT p-inifile,		/* File into which the Registry
						information should be saved */
                OUTPUT p-error).		/* did it fail? */

    Parameters:
    
	p-baseKey 	- Registry Base Key
			   HKEY_CURRENT_USER, HKEY_CURRENT_USER etc.
	p-subKey 	- Registry Sub Key
			Software/PSC/Progress/8.2a2b
	p-reqSection	- sections that must exist w/in base key for 
			ini creation to be executed. Delimeter must be CHR(4)
			"Fonts" + CHR(4) "Colors"
			Sections must be separated by CHR(4)
	p-iniFile	- ini output file
			"d:/work/test.ini"
	p-error		- were we able to generate the ini successfully?
			true or false

    Description:
    
    Notes  : 
    Authors: 
    Date   : 03/12/97
    Updated: 

	
**************************************************************************/

DEFINE INPUT 	PARAMETER p-baseKey 	AS CHARACTER NO-UNDO.
DEFINE INPUT 	PARAMETER p-subKey 	AS CHARACTER NO-UNDO.
DEFINE INPUT 	PARAMETER p-reqSection 	AS CHARACTER NO-UNDO.
DEFINE INPUT 	PARAMETER p-iniFile	AS CHARACTER NO-UNDO.
DEFINE OUTPUT 	PARAMETER p-error	AS LOGICAL INITIAL no NO-UNDO.

DEFINE VARIABLE l-sections 		AS CHARACTER.
DEFINE VARIABLE l-section-Items     AS CHARACTER.
DEFINE VARIABLE l-cnt   		AS INTEGER.
DEFINE VARIABLE l-cnt2 AS INTEGER.
DEFINE VARIABLE l-line AS CHARACTER FORMAT "x(255)".
DEFINE STREAM   l-outStream.

DEFINE VARIABLE l-sectionName AS CHARACTER FORMAT "x(255)" NO-UNDO.
DEFINE VARIABLE l-itemName AS CHARACTER FORMAT "x(255)" NO-UNDO.
DEFINE VARIABLE l-itemValue AS CHARACTER FORMAT "x(255)" NO-UNDO.
DEFINE VARIABLE l-reqSatisfied AS LOGICAL INITIAL yes NO-UNDO.
DEFINE TEMP-TABLE l-reqTable
	FIELD section AS CHARACTER
	FIELD foundIt AS LOGICAL INITIAL no.

DEFINE VARIABLE ThisMessage 	AS CHARACTER 	NO-UNDO.
DEFINE VARIABLE l-dirName 	AS CHARACTER 	NO-UNDO.
DEFINE VARIABLE l-baseName 	AS CHARACTER 	NO-UNDO.
DEFINE VARIABLE ErrorStatus 	AS LOGICAL 	NO-UNDO.
DEFINE VARIABLE Success 	AS LOGICAL 	NO-UNDO.

/* ----------------------------------------------------------------------- */
IF p-baseKey <> "" AND p-baseKey <> ? THEN
DO:
  LOAD p-subKey BASE-KEY p-baseKey NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
     ASSIGN ThisMessage = "Could not LOAD " 
		+ p-baseKey + " " + p-subKey
		+ " Make sure that it is valid Registry Base Key/Sub-key." .
     RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "W":U, "OK":U, ThisMessage).
     ASSIGN p-error = TRUE.
     RETURN.
  END.
END.
ELSE
DO:
  LOAD p-subKey NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
  ASSIGN ThisMessage = "Could not LOAD " + " " + p-subKey
	+ " Make sure that it is valid Registry Sub-key." .
  RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "W":U, "OK":U, ThisMessage).
  ASSIGN p-error = TRUE.
  RETURN.
END.
END.

USE p-subkey NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
  ASSIGN ThisMessage = "Could not USE " 
	 ThisMessage = IF p-baseKey <> "" AND p-baseKey <> ? 
		THEN ThisMessage + p-baseKey 
		ELSE ThisMessage
	 ThisMessage = ThisMessage + " " + p-subKey
		 + " Make sure that it is valid Registry "
	 ThisMessage = IF p-baseKey <> "" AND p-baseKey <> ?
		THEN ThisMessage + "Key/"
		ELSE ThisMessage
	 ThisMessage = ThisMessage + "SubKey."
	.
  RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "W":U, "OK":U, ThisMessage).
  ASSIGN p-error = TRUE.
  RUN ResetEnv.
  RETURN.
END.

GET-KEY-VALUE SECTION ? KEY ? VALUE l-sections.

/* Check to make sure that the required sections are available */
IF p-reqSection <> "":U THEN
DO:
   DO l-cnt = 1 TO NUM-ENTRIES(p-reqSection,CHR(4)):
	IF ENTRY(l-cnt,p-reqSection,CHR(4)) <> "" THEN
	DO:
	   CREATE l-reqTable.
	   ASSIGN l-reqTable.section = TRIM(ENTRY(l-cnt,p-reqSection,CHR(4))).
	END.
   END.

   DO l-cnt = 1 TO NUM-ENTRIES(l-sections):
       ASSIGN l-sectionName = TRIM(ENTRY(l-cnt, l-sections)).
       FIND FIRST l-reqTable WHERE l-reqTable.section = l-sectionName NO-ERROR.
       IF AVAILABLE l-reqTable THEN ASSIGN l-reqTable.foundIt = yes.
   END.
   FIND FIRST l-reqTable WHERE NOT l-reqTable.foundIt NO-ERROR.
   IF AVAILABLE l-reqTable THEN DO:
	p-reqSection = REPLACE (p-reqSection,CHR(4),",":U).
	ThisMessage = "Base key does not contain all required sections [" 
	+ p-reqSection + "]. Environment file not generated.".
      RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "W":U, "OK":U, ThisMessage).
      ASSIGN p-error = TRUE.
      RUN ResetEnv.
      RETURN.
   END.
END. /* requirements satisfied? */

/* Check the ini file */
RUN CheckFile(INPUT p-iniFile, OUTPUT Success).
IF NOT Success THEN DO:
   ASSIGN p-error = TRUE.
   RUN ResetEnv.
   RETURN.
END.
RUN adecomm/_osprefx.p (INPUT p-iniFile, OUTPUT l-dirName, OUTPUT l-basename).
RUN CheckDirectory(INPUT l-dirName, OUTPUT Success).
IF NOT Success THEN DO:
  ASSIGN p-error = TRUE.
  RUN ResetEnv.
  RETURN.
END.
 
OUTPUT STREAM l-outStream TO VALUE(p-inifile) NO-ECHO.

/* Header */
ASSIGN l-line =   ";" + FILL("*",70) + CHR(10)
   + "; " + p-inifile + " generated for TRANMAN II on ":U + STRING(today)
   +	   " at ":U + STRING(time, "hh:mm":U) + CHR(10)
   + "; " + " from Registry "
       l-line = IF p-baseKey <> "" AND p-baseKey <> ? 
		THEN l-line + "Base Key:" + p-baseKey
		ELSE l-line
       l-line = l-line + " SubKey:" + p-subKey + CHR(10)
   + ";" + FILL("*",70) + CHR(10) + CHR(10).
PUT STREAM l-outStream UNFORMATTED l-line.

DO l-cnt = 1 TO NUM-ENTRIES(l-sections):
    ASSIGN l-sectionName = TRIM(ENTRY(l-cnt, l-sections))
           l-line = "[" + l-sectionName + "]" + CHR(10).

    PUT STREAM l-outStream UNFORMATTED l-line.  
    GET-KEY-VALUE SECTION l-sectionName KEY ? VALUE l-section-items.
    DO l-cnt2 = 1 to NUM-ENTRIES(l-section-items):
       ASSIGN l-itemName = TRIM(ENTRY(l-cnt2, l-section-items)).
       GET-KEY-VALUE SECTION l-sectionName KEY l-itemName VALUE l-itemValue.
       ASSIGN l-line = l-itemName + "=" + l-itemValue + CHR(10).
       PUT STREAM l-outStream UNFORMATTED l-line.
    END.
    ASSIGN l-line = CHR(10).
    PUT STREAM l-outStream UNFORMATTED l-line.
END.
OUTPUT STREAM l-outStream CLOSE.
RUN resetEnv.

/* **********************  Internal Procedures  *********************** */

PROCEDURE CheckDirectory :
DEFINE input  parameter FName    as char    no-undo.
DEFINE output parameter pSuccess as logical no-undo init false.
DEFINE var errcode as integer no-undo.
DEFINE var DirName    AS CHARACTER NO-UNDO.
DEFINE var BaseName   AS CHARACTER NO-UNDO.

  RUN adecomm/_osprefx.p (input FName, output DirName, output BaseName).  

  ASSIGN FILE-INFO:FILE-NAME = DirName
        pSuccess = True.
  IF FILE-INFO:FULL-PATHNAME = ? THEN
  DO:
    ASSIGN ThisMessage = "Directory " + "'" + DirName + "'" + " does not exist." + CHR(10) + "Do you want to create it?"
	ErrorStatus = no.
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "q":U, "yes-no":U, ThisMessage).
    IF ErrorStatus THEN
    DO:
        RUN adecomm/_oscpath.p (INPUT DirName, OUTPUT errcode).
        ASSIGN psuccess = IF errcode NE 0 THEN FALSE ELSE TRUE.
    END.
    ELSE pSuccess = FALSE.
  end. /* unknown path/file */   
END PROCEDURE.

PROCEDURE CheckFile:
DEFINE input  parameter FName    as char    no-undo.
DEFINE output parameter pSuccess as logical no-undo init false.
DEFINE var errcode as integer no-undo.

  ASSIGN FILE-INFO:FILE-NAME = FName
        pSuccess = True.
  IF FILE-INFO:FULL-PATHNAME <> ? THEN
  DO:
    ASSIGN ThisMessage = "File " + "'" + FName + "'" + " exists." + CHR(10) + "Do you want to overwrite it?"
	ErrorStatus = no.
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "q":U, "yes-no":U, ThisMessage).
    IF ErrorStatus THEN pSuccess = TRUE.
    ELSE pSuccess = FALSE.
  end. /* unknown path/file */   
END PROCEDURE.

PROCEDURE ResetEnv:
  USE "" NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
     ASSIGN ThisMessage = "Could not USE '""' " .
     RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "W":U, "OK":U, ThisMessage).
     ASSIGN p-error = TRUE.
  END.
  UNLOAD p-subKey NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
     ASSIGN ThisMessage = "Could not UNLOAD " + p-subKey
		+ " Make sure that it is valid Registry Base Key/Sub-key." .
     RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "W":U, "OK":U, ThisMessage).
     ASSIGN p-error = TRUE.
  END.
END.
