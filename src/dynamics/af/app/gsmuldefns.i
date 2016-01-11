&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include
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
/*---------------------------------------------------------------------------------
  File: gsmuldefns.i

  Description:  Security Allocations definitions

  Purpose:      Preprocessor definitions used in the Security Allocations maintenance
                program

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000011   UserRef:    POSSE
                Date:   28/03/2001  Author:     Phillip Magnay

  Update Notes: Created from Template ryteminclu.i

  (v:010001)    Task:   0           UserRef:    POSSE
                Date:   06/04/2002   Author:    Sunil Belgaonkar
  Update Notes: Added Object Level Security

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Astra 2 object identifying preprocessor */
&glob   AstraInclude    yes

/* Constants corresponding to security type */
&GLOBAL-DEFINE MENU-STRUCTURES   1
&GLOBAL-DEFINE MENU-ITEMS        2
&GLOBAL-DEFINE ACCESS-TOKENS     3
&GLOBAL-DEFINE FIELDS            4
&GLOBAL-DEFINE DATA-RANGES       5
&GLOBAL-DEFINE DATA-RECORDS      6
&GLOBAL-DEFINE LOGIN-COMPANIES   7
&GLOBAL-DEFINE CONTAINER-OBJECTS 8

/* Comma-delimited list of entity mnemonics relating to each security type */
&GLOBAL-DEFINE ENTITY-MNEMONIC-LIST "GSMMS,GSMMI,GSMSS,GSMSS,GSMSS,,GSMLG,RYCSO":U

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow:
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB)
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 12.81
         WIDTH              = 73.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


