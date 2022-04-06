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
  File: gsrepprgft.i

  Description:  Report Footer for Prgrs-formatted Rep

  Purpose:      Report Footer for Prgrs-formatted Rep

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        4887   UserRef:    IL575
                Date:   13/03/2000  Author:     Peter Judge

  Update Notes: Created from Template afteminclu.i

  (v:010001)    Task:        4970   UserRef:    IL759
                Date:   14/03/2000  Author:     Peter Judge

  Update Notes: MOD/ find the name of this procedure for the footer details.

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gsrepprgft.i
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

DEFINE VARIABLE lv_extract_date     AS CHARACTER FORMAT "x(10)"     LABEL "Extract Date"        NO-UNDO.
DEFINE VARIABLE lv_extract_time     AS CHARACTER FORMAT "x(8)"      LABEL "Extract Time"        NO-UNDO.
DEFINE VARIABLE lv_extract_user     AS CHARACTER FORMAT "x(55)"     LABEL "Extracted By"        NO-UNDO.
DEFINE VARIABLE lv_print_user       AS CHARACTER FORMAT "x(55)"     LABEL "Printed By"          NO-UNDO.
DEFINE VARIABLE lv_distribution     AS CHARACTER FORMAT "x(55)"     LABEL "Distribution"        NO-UNDO.
DEFINE VARIABLE lv_rep_filename     AS CHARACTER FORMAT "x(55)"     LABEL "Report filename"     NO-UNDO.
DEFINE VARIABLE lv_data_filename    AS CHARACTER FORMAT "x(55)"     LABEL "Data Filename"       NO-UNDO.
DEFINE VARIABLE lv_print_date       AS CHARACTER FORMAT "x(18)"     LABEL "Print Date and Time" NO-UNDO.
DEFINE VARIABLE lv_file_count       AS INTEGER                                                  NO-UNDO.

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
         HEIGHT             = 10.43
         WIDTH              = 50.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
    &IF "{&frame-width}":U = "132":U &THEN
        &scoped-define position-report-banner    40
    &ELSE
        /* Default */
        &scoped-define position-report-banner    40
    &ENDIF

    ASSIGN lv_title_list    = REPLACE(lv_title_list,'"','')
           lv_value_list    = REPLACE(lv_value_list,'"','')
           lv_extract_date  = ENTRY(LOOKUP("Extract Date",      lv_title_list),lv_value_list)
           lv_extract_time  = ENTRY(LOOKUP("Extract Time",      lv_title_list),lv_value_list)
           lv_extract_user  = ENTRY(LOOKUP("Extract User",      lv_title_list),lv_value_list)
           lv_print_user    = ENTRY(LOOKUP("Print User",        lv_title_list),lv_value_list)
           lv_distribution  = ENTRY(LOOKUP("Distribution List", lv_title_list),lv_value_list)
           lv_extract_seq   = ENTRY(LOOKUP("Report Sequence",   lv_title_list),lv_value_list)
           lv_data_filename = ENTRY(LOOKUP("Data Filename",     lv_title_list),lv_value_list)
           lv_print_date    = STRING(TODAY,"99/99/9999") + "  " + STRING(TIME,"HH:MM")
           lv_rep_filename  = THIS-PROCEDURE:FILE-NAME
           .

    FORM    "Print Date and Time : "       AT 2
            lv_print_date                  AT 25 NO-LABEL
            "Printed By          : "       AT 2
            lv_print_user                  AT 25 NO-LABEL
            "Report Sequence     : "       AT 2
            lv_extract_seq                 AT 25 NO-LABEL
            "Extract Date        : "       AT 2
            lv_extract_date                AT 25 NO-LABEL
            "Extract Time        : "       AT 2
            lv_extract_time                AT 25 NO-LABEL
            "Extracted By        : "       AT 2
            lv_extract_user                AT 25 NO-LABEL
            "Distribution        : "       AT 2
            lv_distribution                AT 25 NO-LABEL
            "Report Filename     : "       AT 2
            lv_rep_filename                AT 25 NO-LABEL
            "Extract Filename    : "       AT 2
            lv_extract_program             AT 25 NO-LABEL
            "Data Filename       : "       AT 2
            lv_data_filename               AT 25 NO-LABEL
            WITH
                FRAME {&report-footer-frame}
                WIDTH {&frame-width}
                SIDE-LABELS
                STREAM-IO
                .

    PUT {&output-stream} "" SKIP.
    PUT {&output-stream} "****   END OF REPORT   ****"           AT {&position-report-banner} SKIP.
    PUT {&output-stream} "" SKIP.
    PUT {&output-stream} "****   START OF REPORT FOOTER    ****" AT {&position-report-banner} SKIP. 
    PUT {&output-stream} "" SKIP.

    DISPLAY {&output-stream}
        lv_print_date
        lv_extract_seq              
        lv_extract_date             
        lv_extract_time             
        lv_extract_user             
        lv_print_user               
        lv_distribution             
        lv_rep_filename             
        lv_extract_program
        ENTRY(1, lv_data_filename, ";":U)   @     lv_data_filename
        WITH FRAME {&report-footer-frame}.

    DO lv_file_count = 2 TO NUM-ENTRIES(lv_data_filename,";":U):
        PUT {&output-stream} UNFORMATTED
            ENTRY(lv_file_count, lv_data_filename, ";":U)       AT 25
            SKIP.
    END.    /* file count */

    PUT {&output-stream} "" SKIP.
    PUT {&output-stream} "****   END OF REPORT FOOTER    ****" AT {&position-report-banner} SKIP.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


