/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: objects.i

Description:
    This include file defines the TEMP-TABLE related to PROCEDURE and HTML FIELD 
    objects.  
    
Input Parameters:
   <None>

Output Parameters:
   <None>

Author: Wm. T. Wood

Date Created: Dec. 13, 1996 [Friday the 13th]

----------------------------------------------------------------------------*/
/* Max User defined lists */
&Glob MaxUserLists 6

/* _P - Procedure Record
           Contains fields related to a the .w (procedure) file              */
DEFINE {1} SHARED TEMP-TABLE _P
     FIELD _filename           AS CHAR     /* File Name. */
     FIELD _fullpath           AS CHAR     CASE-SENSITIVE           INITIAL ?
     FIELD _fileext            AS CHAR     /* Initial File Extention */

     /* Internal attributes */
     FIELD _compile            AS LOGICAL  LABEL "Compile on Save"
     FIELD _compile-into       AS CHAR     LABEL "Compile into"     INITIAL ?
     FIELD _desc               AS CHAR     LABEL "Description"
     FIELD _file-saved         AS LOGICAL  LABEL "File Saved"       INITIAL TRUE
     FIELD _lists              AS CHAR     LABEL "Lists"
                               INITIAL "List-1,List-2,List-3,List-4,List-5,List-6"
     FIELD _modified           AS LOGICAL  LABEL "Modified"         INITIAL FALSE 
     FIELD _html-file          AS CHAR     LABEL "HTML File " 
     FIELD _open               AS LOGICAL  LABEL "Open"             INITIAL FALSE   
     FIELD _template           AS LOGICAL  LABEL "Template"         INITIAL FALSE
     FIELD _type               AS CHAR     LABEL "Procedure-Type" /* eg. "Web Object" */
     FIELD _type-list          AS CHAR     LABEL "CAN-DO list"    /* eg. "Structured,text,w" */
     
 INDEX _fullpath IS PRIMARY UNIQUE _fullpath
 .
