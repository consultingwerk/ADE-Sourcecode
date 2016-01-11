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
/*Copyright (c) PROGRESS SOFTWARE CORPORATION 1996 - AllRights Reserved*/

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
