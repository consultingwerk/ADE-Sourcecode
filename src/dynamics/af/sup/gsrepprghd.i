&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Include _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Include _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
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
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gsrepprghd.i

  Description:  Header Include for Prgrs-formatted Rep

  Purpose:      Header Include for Prgrs-formatted Rep

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        4887   UserRef:    IL575
                Date:   13/03/2000  Author:     Peter Judge

  Update Notes: Created from Template afteminclu.i

  (v:010001)    Task:        5084   UserRef:    
                Date:   14/03/2000  Author:     Peter Judge

  Update Notes: MOD/ Add extra lines to header display

  (v:010002)    Task:        5239   UserRef:    
                Date:   28/03/2000  Author:     Peter Judge

  Update Notes: MOD/ Add position preprocessors for 115-character pages.

  (v:010003)    Task:        5259   UserRef:    
                Date:   06/04/2000  Author:     Peter Judge

  Update Notes: MOD/ Add header positioning for 168 chars

------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gsrepprghd.i
&scop object-version    010003


/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

DEFINE VARIABLE lv_company          AS CHARACTER    FORMAT "x(40)":U    NO-UNDO.
DEFINE VARIABLE lv_title            AS CHARACTER    FORMAT "x(40)":U    NO-UNDO.
DEFINE VARIABLE lv_extract_seq      AS CHARACTER    FORMAT "x(5)":U     NO-UNDO.
DEFINE VARIABLE lv_extract_program  AS CHARACTER    FORMAT "x(55)":U    NO-UNDO.

DEFINE VARIABLE lv_title_list       AS CHARACTER    FORMAT "x(300)":U   NO-UNDO.
DEFINE VARIABLE lv_value_list       AS CHARACTER    FORMAT "x(300)":U   NO-UNDO.
DEFINE VARIABLE lv_datafile_list    AS CHARACTER    FORMAT "x(300)":U   NO-UNDO.

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
         HEIGHT             = 6.81
         WIDTH              = 49.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

INPUT  {&import-stream} FROM VALUE(ip_header_file_name).
    IMPORT {&import-stream} UNFORMATTED lv_title_list.
    IMPORT {&import-stream} UNFORMATTED lv_value_list.

    import-datafiles:
    REPEAT:
        ASSIGN lv_datafile_list = "":U.
        IMPORT {&import-stream} UNFORMATTED lv_datafile_list.
        ASSIGN lv_value_list = lv_value_list + ";":U + lv_datafile_list.
    END.    /* import datafiles */
INPUT  {&import-stream} CLOSE.

ASSIGN lv_title_list      = REPLACE(lv_title_list,'"','')
       lv_value_list      = REPLACE(lv_value_list,'"','')
       lv_company         = ENTRY(LOOKUP("Company Name",lv_title_list),lv_value_list)
       lv_title           = ENTRY(LOOKUP("Report Title",lv_title_list),lv_value_list)
       lv_extract_seq     = ENTRY(LOOKUP("Report Sequence",lv_title_list),lv_value_list)
       lv_extract_program = ENTRY(LOOKUP("Extract Program",lv_title_list),lv_value_list)
       .

&IF "{&streamref}":U = "":U &THEN
    &SCOPED-DEFINE paged-stream-ref
&ELSE
    &SCOPED-DEFINE paged-stream-ref ( {&streamref} )
&ENDIF

&IF "{&frame-width}":U = "168":U &THEN
    &scoped-define position-date            22
    &scoped-define position-time            34
    &scoped-define position-company         75
    &scoped-define position-page-number     167
    &scoped-define position-extract-seq     22
    &scoped-define position-report-title    75
&ELSEIF "{&frame-width}":U = "115":U &THEN
    &scoped-define position-date            22
    &scoped-define position-time            34
    &scoped-define position-company         60
    &scoped-define position-page-number     114
    &scoped-define position-extract-seq     22
    &scoped-define position-report-title    60
&ELSEIF "{&frame-width}":U = "132":U &THEN
    &scoped-define position-date            22
    &scoped-define position-time            34
    &scoped-define position-company         60
    &scoped-define position-page-number     131
    &scoped-define position-extract-seq     22
    &scoped-define position-report-title    60
&ELSE
    /* Default assumed to be 132 chars */
    &scoped-define position-date            22
    &scoped-define position-time            34
    &scoped-define position-company         60
    &scoped-define position-page-number     131
    &scoped-define position-extract-seq     22
    &scoped-define position-report-title    60
&ENDIF

FORM    HEADER
        "Run Date & Time : " 
        TODAY FORMAT "99/99/9999"                               AT {&position-date}
        STRING(TIME,"HH:MM")                                    AT {&position-time}
        lv_company                                              AT {&position-company}
        PAGE-NUMBER {&paged-stream-ref}    FORMAT "Page: zz9"   TO {&position-page-number}
        SKIP(1)
        "Sequence Number : "
        lv_extract_seq                                          AT {&position-extract-seq}
        lv_title                                                AT {&position-report-title}
        SKIP
        &if "{&header-line-1}" <> "":U &then {&header-line-1}        SKIP &endif
        &if "{&header-line-2}" <> "":U &then {&header-line-2}        SKIP &endif
        &if "{&header-line-3}" <> "":U &then {&header-line-3}        SKIP &endif
        &if "{&header-line-4}" <> "":U &then {&header-line-4}        SKIP &endif
        &if "{&header-line-5}" <> "":U &then {&header-line-5}        SKIP &endif
        WITH
            PAGE-TOP
            FRAME {&report-header-frame}
            NO-BOX
            WIDTH {&frame-width}
            STREAM-IO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


