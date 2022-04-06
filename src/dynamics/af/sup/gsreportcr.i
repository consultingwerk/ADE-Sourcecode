/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gsreportcr.i

  Description:  Report extract creation include

  Purpose:      Report extract creation include

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:         681   UserRef:    
                Date:   03/11/1998  Author:     Johan Meyer

  Update Notes: Created from Template afteminclu.i

  (v:010001)    Task:        1175   UserRef:    
                Date:   08/04/1999  Author:     Jenny Bond

  Update Notes: Investigate reports not printing.  Modify so that something is put in the file, even
                if there is no information.

  (v:010002)    Task:        1335   UserRef:    
                Date:   31/05/1999  Author:     Stefan Le Jeune

  Update Notes: Changed gsreportcr.i to only put quotes round character fields.

  (v:010003)    Task:        1465   UserRef:    
                Date:   03/06/1999  Author:     Jenny Bond

  Update Notes: Test printing subreports in crystal

  (v:010004)    Task:        2493   UserRef:    
                Date:   23/08/1999  Author:     Marcia Bouwman

  Update Notes: Allow for more fields in the temp-table.

  (v:010005)    Task:        3842   UserRef:    
                Date:   13/12/1999  Author:     Pieter Meyer

  Update Notes: Crystal Printing via AccessDB.
                Add a extra reporting tool function into the printing include to allow the use of a AccessDB. Try to customise the code to allow the use of the AccessDB. Test and implement the full use of the AccessDB Print if the option is possible.

---------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gsreportcr.i
&scop object-version    010005

/* MIP object identifying preprocessor */
&glob   mip-structured-include  no

            /*************************************************************
             *** DON'T DECLARE ANY VARIABLES IN HERE                   ***
             ***  as this include file is included many times into the ***
             ***  same code section.                                   ***
             *************************************************************/

/* ***************************  Main Block  *************************** */
/* See the bottom of the main block for usage examples */

&if defined(gsrepstream) <> 0
&then

    &if "{&gsformatvalue}" = "":U
    &then
        &scop gsformatvalue yes
        DEFINE VARIABLE lv_rep_format_obj   AS DECIMAL   NO-UNDO.
        DEFINE VARIABLE lv_rep_tool_obj     AS DECIMAL   NO-UNDO.
        DEFINE VARIABLE lv_rep_tool_code    AS CHARACTER NO-UNDO.
        DEFINE VARIABLE lv_header_0         AS LOGICAL   NO-UNDO. 
        DEFINE VARIABLE lv_datafile_0       AS CHARACTER NO-UNDO.
        DEFINE VARIABLE lv_rep_streams      AS INTEGER   NO-UNDO.
        DEFINE VARIABLE lv_rep_fields       AS INTEGER   NO-UNDO EXTENT {&max-crystal-fields}. 
        DEFINE VARIABLE lv_rep_dir          AS CHARACTER NO-UNDO.
        DEFINE VARIABLE lv_table_loop       AS INTEGER   NO-UNDO.
        DEFINE VARIABLE lv_data_loop        AS INTEGER   NO-UNDO.
        DEFINE VARIABLE lv_datasource       AS CHARACTER NO-UNDO.
        DEFINE VARIABLE lv_dataobject       AS CHARACTER NO-UNDO.
        DEFINE VARIABLE lv_datatables       AS CHARACTER NO-UNDO.
        DEFINE VARIABLE lv_num_entries      AS INTEGER   NO-UNDO.
        DEFINE VARIABLE lv_width_list       AS CHARACTER NO-UNDO EXTENT {&max-crystal-fields}.
        DEFINE VARIABLE lv_cr_parameter     AS CHARACTER NO-UNDO.
        DEFINE BUFFER   lb_tt_datasource    FOR tt_datasource.

        DEFINE VARIABLE lv_error_grp        AS CHARACTER        NO-UNDO.
        DEFINE VARIABLE lv_error_num        AS INTEGER          NO-UNDO.
        DEFINE VARIABLE lv_error_include    AS CHARACTER        NO-UNDO.

        ASSIGN lv_rep_streams = {&gsrepstream}.
    &endif

    &if {&gsrepstream} > 0
    &then 
        DEFINE STREAM   ls_stream_1. 
        DEFINE VARIABLE lv_header_1         AS LOGICAL   NO-UNDO. 
        DEFINE VARIABLE lv_datafile_1       AS CHARACTER NO-UNDO. 
    &endif
    &if {&gsrepstream} > 1
    &then 
        DEFINE STREAM   ls_stream_2. 
        DEFINE VARIABLE lv_header_2         AS LOGICAL   NO-UNDO. 
        DEFINE VARIABLE lv_datafile_2       AS CHARACTER NO-UNDO. 
    &endif
    &if {&gsrepstream} > 2
    &then 
        DEFINE STREAM   ls_stream_3. 
        DEFINE VARIABLE lv_header_3         AS LOGICAL   NO-UNDO. 
        DEFINE VARIABLE lv_datafile_3       AS CHARACTER NO-UNDO. 
    &endif
    &if {&gsrepstream} > 3
    &then 
        DEFINE STREAM   ls_stream_4. 
        DEFINE VARIABLE lv_header_4         AS LOGICAL   NO-UNDO. 
        DEFINE VARIABLE lv_datafile_4       AS CHARACTER NO-UNDO. 
    &endif
    &if {&gsrepstream} > 4
    &then
        DEFINE STREAM   ls_stream_5.
        DEFINE VARIABLE lv_header_5         AS LOGICAL   NO-UNDO.
        DEFINE VARIABLE lv_datafile_5       AS CHARACTER NO-UNDO.
    &endif
&endif

&if defined(gsrepoutput) <> 0
&then
    &if "{&gsrepoutput}" = "open"
    &then
        FIND gsc_global_default NO-LOCK
            WHERE gsc_global_default.default_type = "RPD":U     /* RePort Data directory */
            NO-ERROR.
        ASSIGN lv_rep_dir = (IF AVAILABLE gsc_global_default THEN REPLACE( REPLACE(gsc_global_default.default_value, "~\":U,"/":U) + "/":U, "//":U, "/":U ) ELSE "":U ).
        &if "{1}" = "1"
        &then
            FIND gsm_report_definition NO-LOCK
                WHERE gsm_report_definition.report_procedure_name = ip_instance_attribute
                 NO-ERROR.
            IF NOT AVAILABLE gsm_report_definition
            THEN DO:
                /* Add Error message handling code in here */
                ASSIGN lv_error_grp     = "AF":U
                       lv_error_num     = 5
                       lv_error_include = "report definition" + "|":U + "Could not find report definition for procedure: " + ip_instance_attribute.
                       .
                &if "{&mip-plip-procedure}":U = "yes":U &then
                    RUN mip-bl-error (lv_error_grp, lv_error_num, lv_error_include).
                    RETURN ERROR "ADM-ERROR":U.
                &elseif "{&WRITE_TRIGGER}":U = "yes":U &then
                    RUN error-message (lv_error_grp,lv_error_num,lv_error_include).
                    /* Already returns an error */
                &else
                    RUN mip-errormess IN gh_local_app_plip (lv_error_grp, lv_error_num, lv_error_include).
                    RETURN ERROR "ADM-ERROR":U.
                &endif
            END.
            ELSE DO:
                RUN get-parameter IN gh_parameter_controller ("RFM":U, STRING(ip_user_obj) + ",":U + ip_instance_attribute, OUTPUT lv_cr_parameter ) NO-ERROR.
                ASSIGN lv_rep_format_obj = DECIMAL(lv_cr_parameter).
                IF lv_rep_format_obj > 0
                THEN
                  FIND FIRST gsm_report_format NO-LOCK
                       WHERE gsm_report_format.report_definition_obj = gsm_report_definition.report_definition_obj
                       AND   gsm_report_format.report_format_obj     = lv_rep_format_obj
                       NO-ERROR.
                ELSE
                  FIND FIRST gsm_report_format NO-LOCK
                       WHERE gsm_report_format.report_format_obj = -1
                       NO-ERROR.
                IF NOT AVAILABLE gsm_report_format
                THEN
                  FIND FIRST gsm_report_format NO-LOCK
                       WHERE gsm_report_format.report_definition_obj = gsm_report_definition.report_definition_obj
                       AND   gsm_report_format.is_this_the_default   = YES
                       NO-ERROR.
                IF NOT AVAILABLE gsm_report_format
                THEN
                  FIND FIRST gsm_report_format NO-LOCK
                       WHERE gsm_report_format.report_definition_obj = gsm_report_definition.report_definition_obj
                       NO-ERROR.
                IF NOT AVAILABLE gsm_report_format
                THEN DO:
                    /* Add Error message handling code in here */
                    ASSIGN lv_error_grp     = "AF":U
                           lv_error_num     = 5
                           lv_error_include = "report format" + "|":U + "Could not find a report format for procedure: " + gsm_report_definition.report_procedure_name.
                           .
                    &if "{&mip-plip-procedure}":U = "yes":U &then
                        RUN mip-bl-error (lv_error_grp, lv_error_num, lv_error_include).
                        RETURN ERROR "ADM-ERROR":U.
                    &elseif "{&WRITE_TRIGGER}":U = "yes":U &then
                        RUN error-message (lv_error_grp,lv_error_num,lv_error_include).
                        /* Already returns an error */
                    &else
                        RUN mip-errormess IN gh_local_app_plip (lv_error_grp, lv_error_num, lv_error_include).
                        RETURN ERROR "ADM-ERROR":U.
                    &endif
                END.
                ELSE DO:
                    ASSIGN lv_cr_parameter = STRING(gsm_report_format.report_format_obj).
                    RUN set-parameter IN gh_parameter_controller ( INPUT "permanent":U, INPUT "RFM":U, INPUT STRING(ip_user_obj) + ",":U + ip_instance_attribute, INPUT lv_cr_parameter ) NO-ERROR.
                    RUN get-parameter IN gh_parameter_controller ( INPUT "RTL":U, STRING(ip_user_obj) + ",":U + ip_instance_attribute, OUTPUT lv_cr_parameter ) NO-ERROR.
                    ASSIGN lv_rep_tool_obj = DECIMAL(lv_cr_parameter).
                    IF lv_rep_tool_obj  > 0
                    AND lv_rep_tool_obj = gsm_report_format.reporting_tool_obj
                    THEN
                        FIND FIRST gsm_reporting_tool NO-LOCK
                           WHERE gsm_reporting_tool.reporting_tool_obj = lv_rep_tool_obj
                           NO-ERROR.
                    IF NOT AVAILABLE gsm_reporting_tool
                    THEN
                      FIND FIRST gsm_reporting_tool NO-LOCK
                           WHERE gsm_reporting_tool.reporting_tool_obj = gsm_report_format.reporting_tool_obj
                           NO-ERROR.
                    IF NOT AVAILABLE gsm_reporting_tool
                    THEN DO:
                        /* Add Error message handling code in here */
                        ASSIGN
                            lv_rep_tool_code = "":U
                            lv_error_grp     = "AF":U
                            lv_error_num     = 5
                            lv_error_include = "reporting tool" + "|":U + "Could not find a reporting tool for the format: " + gsm_report_format.report_format_description.
                            .
                        &if "{&mip-plip-procedure}":U = "yes":U &then
                            RUN mip-bl-error (lv_error_grp, lv_error_num, lv_error_include).
                            RETURN ERROR "ADM-ERROR":U.
                        &elseif "{&WRITE_TRIGGER}":U = "yes":U &then
                            RUN error-message (lv_error_grp,lv_error_num,lv_error_include).
                            /* Already returns an error */
                        &else
                            RUN mip-errormess IN gh_local_app_plip (lv_error_grp, lv_error_num, lv_error_include).
                            RETURN ERROR "ADM-ERROR":U.
                        &endif
                    END.
                    ELSE DO:
                        ASSIGN
                            lv_rep_tool_code = gsm_reporting_tool.reporting_tool_code
                            lv_cr_parameter  = STRING(gsm_reporting_tool.reporting_tool_obj).
                        RUN set-parameter IN gh_parameter_controller ( INPUT "permanent":U, INPUT "RTL":U, INPUT STRING(ip_user_obj) + ",":U + ip_instance_attribute, INPUT lv_cr_parameter ) NO-ERROR.
                    END.
                END.
            END.
        &endif

        CASE lv_rep_tool_code:
            WHEN "TEXT-PRO":U OR
            WHEN "ODBC-CRY":U OR
            WHEN "TEXT-MSDB":U
                THEN DO:
                    DO WHILE lv_datafile_{1} = "":U OR SEARCH(lv_datafile_{1}) <> ?:
                        ASSIGN
                            lv_datafile_{1} = "{2}-":U
                                              + STRING( YEAR(  TODAY ), "9999")
                                              + STRING( MONTH( TODAY ), "99"  )
                                              + STRING( DAY(   TODAY ), "99"  )
                                              + REPLACE(STRING(TIME,"hh:mm:ss":U),":":U,"":U)
                                              + ".rpd":U.
                    END.
                    OUTPUT STREAM ls_stream_{1} TO VALUE( lv_rep_dir + lv_datafile_{1} ) {3}.
                END.
            WHEN "MSDB-CRY":U
                THEN DO:
                    &if "{1}" = "1":U
                    &then
                        FOR EACH tt_datasource: DELETE tt_datasource. END.
                        ASSIGN lv_datasource = "{2}-":U
                                          + STRING( YEAR(  TODAY ), "9999")
                                          + STRING( MONTH( TODAY ), "99"  )
                                          + STRING( DAY(   TODAY ), "99"  ) 
                                          + REPLACE(STRING(TIME,"hh:mm:ss":U),":":U,"":U).
                        ASSIGN lv_datafile_0 ="HEADER":U.
                    &endif
                    DO WHILE lv_datafile_{1} = "":U:
                        ASSIGN
                            lv_datafile_{1} = "{2}":U
                            lv_datatables   = lv_datatables + lv_datafile_{1} + ",":U
                            .
                    END.
                END.
            OTHERWISE
                DO:
                    ASSIGN lv_error_grp     = "AF":U
                           lv_error_num     = 5
                           lv_error_include = "reporting tool code" + "|":U + "Reporting Tool Code = " + lv_rep_tool_code
                           .
                        &if "{&mip-plip-procedure}":U = "yes":U &then
                            RUN mip-bl-error (lv_error_grp, lv_error_num, lv_error_include).
                            RETURN ERROR "ADM-ERROR":U.
                        &elseif "{&WRITE_TRIGGER}":U = "yes":U &then
                            RUN error-message (lv_error_grp,lv_error_num,lv_error_include).
                            /* Already returns an error */
                        &else
                            RUN mip-errormess IN gh_local_app_plip (lv_error_grp, lv_error_num, lv_error_include).
                            RETURN ERROR "ADM-ERROR":U.
                        &endif
                END.    /* don't know the report tool */
        END CASE.

    &elseif "{&gsrepoutput}" = "close"
    &then    
        IF lv_rep_tool_code = "TEXT-PRO":U
        OR lv_rep_tool_code = "ODBC-CRY":U
        OR lv_rep_tool_code = "TEXT-MSDB":U
        THEN DO:
            OUTPUT STREAM ls_stream_{1} CLOSE.
        END.
        ELSE
        IF lv_rep_tool_code = "MSDB-CRY":U
        THEN DO:
            &if "{1}" = "1"
            &then

                /* F0 = Window - File Title */
                CREATE tt_datasource.
                ASSIGN
                    tt_datasource.tt_tag      = STRING(lv_rep_streams + 1,"99") + "F0":U
                    tt_datasource.tt_value[1] = STRING(lv_datafile_0)
                    NO-ERROR.

                /* F1 = Field names */
                CREATE tt_datasource.
                ASSIGN 
                    tt_datasource.tt_tag = STRING(lv_rep_streams + 1,"99") + "F1":U
                    tt_datasource.tt_value[1]  = "Company_Name"
                    tt_datasource.tt_value[2]  = "Report_Title"
                    tt_datasource.tt_value[3]  = "Extract_Date"
                    tt_datasource.tt_value[4]  = "Extract_Time"
                    tt_datasource.tt_value[5]  = "Extract_User"
                    tt_datasource.tt_value[6]  = "Print_User"
                    tt_datasource.tt_value[7]  = "Report_Sequence"
                    tt_datasource.tt_value[8]  = "Distribution-List"
                    tt_datasource.tt_value[9]  = "Filter_Information"
                    tt_datasource.tt_value[10] = "Report_Filename"
                    tt_datasource.tt_value[11] = "Extract_Program"
                    tt_datasource.tt_value[12] = "Data_Filename"
                    .

                /* F2 = Field Labels */
                CREATE tt_datasource.
                ASSIGN
                    tt_datasource.tt_tag = STRING(lv_rep_streams + 1,"99") + "F2":U
                    tt_datasource.tt_value[1]  = "Company Name"
                    tt_datasource.tt_value[2]  = "Report Title"
                    tt_datasource.tt_value[3]  = "Extract Date"
                    tt_datasource.tt_value[4]  = "Extract Time"
                    tt_datasource.tt_value[5]  = "Extract User"
                    tt_datasource.tt_value[6]  = "Print User"
                    tt_datasource.tt_value[7]  = "Report Sequence"
                    tt_datasource.tt_value[8]  = "Distribution List"
                    tt_datasource.tt_value[9]  = "Filter Information"
                    tt_datasource.tt_value[10] = "Report Filename"
                    tt_datasource.tt_value[11] = "Extract Program"
                    tt_datasource.tt_value[12] = "Data Filename"
                    .

                /* F3 = Field Column Widths */ /* width is re-done after the last field has been done */
                CREATE tt_datasource.
                ASSIGN 
                    tt_datasource.tt_tag = STRING(lv_rep_streams + 1,"99") + "F3":U
                    tt_datasource.tt_value[1]  = STRING(LENGTH("Company Name"))
                    tt_datasource.tt_value[2]  = STRING(LENGTH("Report Title"))
                    tt_datasource.tt_value[3]  = STRING(LENGTH("Extract Date"))
                    tt_datasource.tt_value[4]  = STRING(LENGTH("Extract Time"))
                    tt_datasource.tt_value[5]  = STRING(LENGTH("Extract User"))
                    tt_datasource.tt_value[6]  = STRING(LENGTH("Print User"))
                    tt_datasource.tt_value[7]  = STRING(LENGTH("Report Sequence"))
                    tt_datasource.tt_value[8]  = STRING(LENGTH("Distribution List"))
                    tt_datasource.tt_value[9]  = STRING(LENGTH("Filter Information"))
                    tt_datasource.tt_value[10] = STRING(LENGTH("Report Filename"))
                    tt_datasource.tt_value[11] = STRING(LENGTH("Extract Program"))
                    tt_datasource.tt_value[12] = STRING(LENGTH("Data Filename"))
                    .

                /* F4 = Data Types */
                CREATE tt_datasource.
                ASSIGN 
                    tt_datasource.tt_tag = STRING(lv_rep_streams + 1,"99") + "F4":U.
                DO lv_num_entries = 1 TO 12:
                  ASSIGN
                    tt_datasource.tt_value[lv_num_entries] = "10":U. /* why hardcode value as 10 */
                END.
    /* Do the header in the report design */
                FIND FIRST lb_tt_datasource NO-LOCK
                    WHERE SUBSTRING(lb_tt_datasource.tt_tag,1,3) = STRING(lv_rep_streams + 1,"99") + "D" /* D = data */
                    NO-ERROR.
                IF NOT AVAILABLE lb_tt_datasource
                THEN DO:
                    DEFINE VARIABLE lv_crhdr_co_obj         AS CHARACTER    NO-UNDO.
                    DEFINE VARIABLE lv_crhdr_co_name        AS CHARACTER    NO-UNDO.
                    DEFINE VARIABLE lv_crhdr_datafile       AS CHARACTER    NO-UNDO.
                    DEFINE VARIABLE lv_crhdr_printuser      AS CHARACTER    NO-UNDO.
                    DEFINE VARIABLE lv_crhdr_rptseq         AS INTEGER      NO-UNDO.
                    DEFINE VARIABLE lv_crhdr_distlist       AS CHARACTER    NO-UNDO.
                    DEFINE VARIABLE lv_crhdr_filtinfo       AS CHARACTER    NO-UNDO.
                    DEFINE VARIABLE lv_crhdr_filtfrom       AS CHARACTER    NO-UNDO.
                    DEFINE VARIABLE lv_crhdr_filtto         AS CHARACTER    NO-UNDO.
                    DEFINE VARIABLE lv_crhdr_loop           AS INTEGER      NO-UNDO.

                    FIND gsm_user NO-LOCK
                        WHERE gsm_user.user_obj = ip_user_obj
                        NO-ERROR.
                    IF AVAILABLE gsm_user
                    THEN ASSIGN lv_crhdr_printuser = gsm_user.user_full_name.
                    ELSE ASSIGN lv_crhdr_printuser = "?":U.

                    RUN get-parameter IN gh_parameter_controller ( INPUT "RCO":U,  INPUT  STRING(ip_user_obj) + ",":U + ip_instance_attribute, OUTPUT lv_crhdr_co_obj ) NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN ASSIGN lv_crhdr_co_obj = "?":U.
                    RUN get-parameter IN gh_parameter_controller ( INPUT  "RDL":U, INPUT  STRING(ip_user_obj) + ",":U + ip_instance_attribute, OUTPUT lv_crhdr_distlist ) NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN ASSIGN lv_crhdr_distlist = "?":U.
                    RUN get-parameter IN gh_parameter_controller ( INPUT  "RFF":U, INPUT  STRING(ip_user_obj) + ",":U + ip_instance_attribute, OUTPUT lv_crhdr_filtfrom ) NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN ASSIGN lv_crhdr_filtfrom = "?":U.
                    RUN get-parameter IN gh_parameter_controller ( INPUT  "RFT":U, INPUT  STRING(ip_user_obj) + ",":U + ip_instance_attribute, OUTPUT lv_crhdr_filtto ) NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN ASSIGN lv_crhdr_filtto = "?":U.

                    FIND gsm_organisation NO-LOCK
                        WHERE gsm_organisation.organisation_obj = DECIMAL(lv_crhdr_co_obj)
                        NO-ERROR.
                    IF  AVAILABLE gsm_organisation
                    THEN ASSIGN lv_crhdr_co_name = gsm_organisation.organisation_name.
                    ELSE DO:
                        FIND gsm_organisation NO-LOCK
                            WHERE gsm_organisation.organisation_obj = lv_current_organisation_obj.
                        ASSIGN 
                            lv_crhdr_co_name = IF AVAILABLE gsm_organisation THEN gsm_organisation.organisation_name ELSE "?".
                    END.

                    ASSIGN
                        lv_crhdr_datafile = REPLACE(lv_datatables, ",", CHR(10)).
                    ASSIGN
                        lv_crhdr_rptseq    = gsm_report_definition.next_extract_sequence
                        lv_crhdr_filtinfo = "":U.

                    DO lv_crhdr_loop = 1 TO NUM-ENTRIES( gsm_report_definition.filter_label_list ):
                        ASSIGN
                            lv_crhdr_filtinfo = lv_crhdr_filtinfo   
                                                  + ENTRY( lv_crhdr_loop, gsm_report_definition.filter_label_list ) + CHR(9)  /* Tab */
                                                  + ENTRY( lv_crhdr_loop, lv_crhdr_filtfrom )                   + CHR(9)  /* Tab */
                                                  + ENTRY( lv_crhdr_loop, lv_crhdr_filtto )                     + CHR(10) /* Linefeed */
                            NO-ERROR.
                    END.

                    CREATE tt_datasource.
                    ASSIGN
                        tt_datasource.tt_tag       = STRING(lv_rep_streams + 1,"99") + "D":U
                        tt_datasource.tt_value[1]  = lv_crhdr_co_name                                /* Company Name */
                        tt_datasource.tt_value[2]  = gsm_report_definition.report_description       /* Report Title */
                        tt_datasource.tt_value[3]  = STRING(TODAY, lv_date_format)                  /* Extract Date */
                        tt_datasource.tt_value[4]  = STRING(TIME,"HH:MM:SS":U)                      /* Extract Time */
                        tt_datasource.tt_value[5]  = lv_crhdr_printuser                                  /* Extract User */
                        tt_datasource.tt_value[6]  = lv_crhdr_printuser                                  /* Print User */
                        tt_datasource.tt_value[7]  = STRING(lv_crhdr_rptseq)                     /* Report Sequence */
                        tt_datasource.tt_value[8]  = lv_crhdr_distlist                           /* Distribution List */
                        tt_datasource.tt_value[9]  = lv_crhdr_filtinfo                          /* Filter Information */
                        tt_datasource.tt_value[10] = '"'                                            /* Report Filename */
                        tt_datasource.tt_value[11] = gsm_report_definition.report_procedure_name    /* Extract Program */
                        tt_datasource.tt_value[12] = lv_crhdr_datafile                                   /* Data Filename */
                        .
                    ASSIGN
                         lv_rep_fields[lv_rep_streams + 1] = 12. /* Number of fields in header */

                END.

            &endif

            &if "{1}" > "0":U
            &then
                IF lv_rep_streams = {1}
                THEN DO:
                    ASSIGN lv_datatables = lv_datatables + lv_datafile_0. /* Add header section to the datafile list */

/*                    DO lv_table_loop = 3 TO (lv_rep_streams + 1):
 *                         FOR EACH tt_datasource EXCLUSIVE-LOCK
 *                             WHERE SUBSTRING(tt_datasource.tt_tag,1,4) = STRING(lv_table_loop,"99") + "F3" /* F3 = width */
 *                             :
 *                             FOR EACH lb_tt_datasource NO-LOCK
 *                                 WHERE SUBSTRING(lb_tt_datasource.tt_tag,1,3) = STRING(lv_table_loop,"99") + "D" /* D = data */
 *                                 :
 *                                 DO lv_crhdr_loop = 1 TO (lv_rep_fields[lv_table_loop]):
 *                                     IF LENGTH(lb_tt_datasource.tt_value[lv_crhdr_loop]) > INTEGER(tt_datasource.tt_value[lv_crhdr_loop])
 *                                     THEN tt_datasource.tt_value[lv_crhdr_loop] = STRING(LENGTH(lb_tt_datasource.tt_value[lv_crhdr_loop])).
 *                                 END.
 *                             END.
 *                         END.
 *                     END.*/
                    { af/sup/afrun.i
                        &PPlip = "af/sup/afmdbplipp.p"
                        &PName = "mip-create-msdbcry"
                        &PList = "( INPUT lv_rep_dir    ,
                                    INPUT lv_datasource ,
                                    INPUT lv_datatables ,
                                    INPUT YES           ,
                                    TABLE tt_datasource
                                    )"
                    }
                    IF RETURN-VALUE <> "":U AND RETURN-VALUE <> ?
                    THEN DO:
                        IF VALID-HANDLE( lh_plip ) AND LOOKUP( "mip-kill":U, lh_plip:INTERNAL-ENTRIES ) <> 0
                        THEN RUN mip-kill IN lh_plip.
                        RETURN RETURN-VALUE.
                    END.
                END.
            &endif
        END.
    &endif
&endif

&if defined(gsrepcolumn) <> 0
&then
    IF lv_rep_tool_code = "TEXT-PRO":U
    OR lv_rep_tool_code = "ODBC-CRY":U
    OR lv_rep_tool_code = "TEXT-MSDB":U
    THEN DO:
        EXPORT STREAM ls_stream_{1} DELIMITER ","
            &if {&gsrepcolumn} >  0 &then STRING("{2}")   &endif
            &if {&gsrepcolumn} >  1 &then STRING("{3}")   &endif
            &if {&gsrepcolumn} >  2 &then STRING("{4}")   &endif
            &if {&gsrepcolumn} >  3 &then STRING("{5}")   &endif
            &if {&gsrepcolumn} >  4 &then STRING("{6}")   &endif
            &if {&gsrepcolumn} >  5 &then STRING("{7}")   &endif
            &if {&gsrepcolumn} >  6 &then STRING("{8}")   &endif
            &if {&gsrepcolumn} >  7 &then STRING("{9}")   &endif
            &if {&gsrepcolumn} >  8 &then STRING("{10}")  &endif
            &if {&gsrepcolumn} >  9 &then STRING("{11}")  &endif
            &if {&gsrepcolumn} > 10 &then STRING("{12}")  &endif
            &if {&gsrepcolumn} > 11 &then STRING("{13}")  &endif
            &if {&gsrepcolumn} > 12 &then STRING("{14}")  &endif
            &if {&gsrepcolumn} > 13 &then STRING("{15}")  &endif
            &if {&gsrepcolumn} > 14 &then STRING("{16}")  &endif
            &if {&gsrepcolumn} > 15 &then STRING("{17}")  &endif
            &if {&gsrepcolumn} > 16 &then STRING("{18}")  &endif
            &if {&gsrepcolumn} > 17 &then STRING("{19}")  &endif
            &if {&gsrepcolumn} > 18 &then STRING("{20}")  &endif
            &if {&gsrepcolumn} > 19 &then STRING("{21}")  &endif
            &if {&gsrepcolumn} > 20 &then STRING("{22}")  &endif
            &if {&gsrepcolumn} > 21 &then STRING("{23}")  &endif
            &if {&gsrepcolumn} > 22 &then STRING("{24}")  &endif
            &if {&gsrepcolumn} > 23 &then STRING("{25}")  &endif
            &if {&gsrepcolumn} > 24 &then STRING("{26}")  &endif
            &if {&gsrepcolumn} > 25 &then STRING("{27}")  &endif
            &if {&gsrepcolumn} > 26 &then STRING("{28}")  &endif
            &if {&gsrepcolumn} > 27 &then STRING("{29}")  &endif
            &if {&gsrepcolumn} > 28 &then STRING("{30}")  &endif
            &if {&gsrepcolumn} > 29 &then STRING("{31}")  &endif
            &if {&gsrepcolumn} > 30 &then STRING("{32}")  &endif
            &if {&gsrepcolumn} > 31 &then STRING("{33}")  &endif
            &if {&gsrepcolumn} > 32 &then STRING("{34}")  &endif
            &if {&gsrepcolumn} > 33 &then STRING("{35}")  &endif
            &if {&gsrepcolumn} > 34 &then STRING("{36}")  &endif
            &if {&gsrepcolumn} > 35 &then STRING("{37}")  &endif
            &if {&gsrepcolumn} > 36 &then STRING("{38}")  &endif
            &if {&gsrepcolumn} > 37 &then STRING("{39}")  &endif
            &if {&gsrepcolumn} > 38 &then STRING("{40}")  &endif
            &if {&gsrepcolumn} > 39 &then STRING("{41}")  &endif
            &if {&gsrepcolumn} > 40 &then STRING("{42}")  &endif
            &if {&gsrepcolumn} > 41 &then STRING("{43}")  &endif
            &if {&gsrepcolumn} > 42 &then STRING("{44}")  &endif
            &if {&gsrepcolumn} > 43 &then STRING("{45}")  &endif
            &if {&gsrepcolumn} > 44 &then STRING("{46}")  &endif
            &if {&gsrepcolumn} > 45 &then STRING("{47}")  &endif
            &if {&gsrepcolumn} > 46 &then STRING("{48}")  &endif
            &if {&gsrepcolumn} > 47 &then STRING("{49}")  &endif
            &if {&gsrepcolumn} > 48 &then STRING("{50}")  &endif
            &if {&gsrepcolumn} > 49 &then STRING("{51}")  &endif
            &if {&gsrepcolumn} > 50 &then STRING("{52}")  &endif
            &if {&gsrepcolumn} > 51 &then STRING("{53}")  &endif
            &if {&gsrepcolumn} > 52 &then STRING("{54}")  &endif
            &if {&gsrepcolumn} > 53 &then STRING("{55}")  &endif
            &if {&gsrepcolumn} > 54 &then STRING("{56}")  &endif
            &if {&gsrepcolumn} > 55 &then STRING("{57}")  &endif
            &if {&gsrepcolumn} > 56 &then STRING("{58}")  &endif
            &if {&gsrepcolumn} > 57 &then STRING("{59}")  &endif
            &if {&gsrepcolumn} > 58 &then STRING("{60}")  &endif
            &if {&gsrepcolumn} > 59 &then STRING("{61}")  &endif
            &if {&gsrepcolumn} > 60 &then STRING("{62}")  &endif
            &if {&gsrepcolumn} > 61 &then STRING("{63}")  &endif
            &if {&gsrepcolumn} > 62 &then STRING("{64}")  &endif
            &if {&gsrepcolumn} > 63 &then STRING("{65}")  &endif
            .
    END.
    ELSE
    IF lv_rep_tool_code = "MSDB-CRY":U
    THEN DO:

        /* F0 = Window - File Title */
        CREATE tt_datasource.
        ASSIGN
            tt_datasource.tt_tag      = STRING({1},"99") + "F0":U
            tt_datasource.tt_value[1] = STRING(lv_datafile_{1})
            NO-ERROR.

         /* F1 = Field names */
         CREATE tt_datasource.
         ASSIGN
            tt_datasource.tt_tag = STRING({1},"99") + "F1":U
            &if {&gsrepcolumn} > 0  &then tt_datasource.tt_value[1]  = REPLACE(REPLACE(STRING("{2}" ),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 1  &then tt_datasource.tt_value[2]  = REPLACE(REPLACE(STRING("{3}" ),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 2  &then tt_datasource.tt_value[3]  = REPLACE(REPLACE(STRING("{4}" ),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 3  &then tt_datasource.tt_value[4]  = REPLACE(REPLACE(STRING("{5}" ),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 4  &then tt_datasource.tt_value[5]  = REPLACE(REPLACE(STRING("{6}" ),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 5  &then tt_datasource.tt_value[6]  = REPLACE(REPLACE(STRING("{7}" ),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 6  &then tt_datasource.tt_value[7]  = REPLACE(REPLACE(STRING("{8}" ),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 7  &then tt_datasource.tt_value[8]  = REPLACE(REPLACE(STRING("{9}" ),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 8  &then tt_datasource.tt_value[9]  = REPLACE(REPLACE(STRING("{10}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 9  &then tt_datasource.tt_value[10] = REPLACE(REPLACE(STRING("{11}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 10 &then tt_datasource.tt_value[11] = REPLACE(REPLACE(STRING("{12}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 11 &then tt_datasource.tt_value[12] = REPLACE(REPLACE(STRING("{13}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 12 &then tt_datasource.tt_value[13] = REPLACE(REPLACE(STRING("{14}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 13 &then tt_datasource.tt_value[14] = REPLACE(REPLACE(STRING("{15}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 14 &then tt_datasource.tt_value[15] = REPLACE(REPLACE(STRING("{16}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 15 &then tt_datasource.tt_value[16] = REPLACE(REPLACE(STRING("{17}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 16 &then tt_datasource.tt_value[17] = REPLACE(REPLACE(STRING("{18}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 17 &then tt_datasource.tt_value[18] = REPLACE(REPLACE(STRING("{19}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 18 &then tt_datasource.tt_value[19] = REPLACE(REPLACE(STRING("{20}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 19 &then tt_datasource.tt_value[20] = REPLACE(REPLACE(STRING("{21}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 20 &then tt_datasource.tt_value[21] = REPLACE(REPLACE(STRING("{22}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 21 &then tt_datasource.tt_value[22] = REPLACE(REPLACE(STRING("{23}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 22 &then tt_datasource.tt_value[23] = REPLACE(REPLACE(STRING("{24}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 23 &then tt_datasource.tt_value[24] = REPLACE(REPLACE(STRING("{25}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 24 &then tt_datasource.tt_value[25] = REPLACE(REPLACE(STRING("{26}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 25 &then tt_datasource.tt_value[26] = REPLACE(REPLACE(STRING("{27}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 26 &then tt_datasource.tt_value[27] = REPLACE(REPLACE(STRING("{28}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 27 &then tt_datasource.tt_value[28] = REPLACE(REPLACE(STRING("{29}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 28 &then tt_datasource.tt_value[29] = REPLACE(REPLACE(STRING("{30}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 29 &then tt_datasource.tt_value[30] = REPLACE(REPLACE(STRING("{31}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 30 &then tt_datasource.tt_value[31] = REPLACE(REPLACE(STRING("{32}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 31 &then tt_datasource.tt_value[32] = REPLACE(REPLACE(STRING("{33}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 32 &then tt_datasource.tt_value[33] = REPLACE(REPLACE(STRING("{34}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 33 &then tt_datasource.tt_value[34] = REPLACE(REPLACE(STRING("{35}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 34 &then tt_datasource.tt_value[35] = REPLACE(REPLACE(STRING("{36}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 35 &then tt_datasource.tt_value[36] = REPLACE(REPLACE(STRING("{37}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 36 &then tt_datasource.tt_value[37] = REPLACE(REPLACE(STRING("{38}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 37 &then tt_datasource.tt_value[38] = REPLACE(REPLACE(STRING("{39}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 38 &then tt_datasource.tt_value[39] = REPLACE(REPLACE(STRING("{40}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 39 &then tt_datasource.tt_value[40] = REPLACE(REPLACE(STRING("{41}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 40 &then tt_datasource.tt_value[41] = REPLACE(REPLACE(STRING("{42}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 41 &then tt_datasource.tt_value[42] = REPLACE(REPLACE(STRING("{43}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 42 &then tt_datasource.tt_value[43] = REPLACE(REPLACE(STRING("{44}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 43 &then tt_datasource.tt_value[44] = REPLACE(REPLACE(STRING("{45}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 44 &then tt_datasource.tt_value[45] = REPLACE(REPLACE(STRING("{46}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 45 &then tt_datasource.tt_value[46] = REPLACE(REPLACE(STRING("{47}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 46 &then tt_datasource.tt_value[47] = REPLACE(REPLACE(STRING("{48}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 47 &then tt_datasource.tt_value[48] = REPLACE(REPLACE(STRING("{49}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 48 &then tt_datasource.tt_value[49] = REPLACE(REPLACE(STRING("{50}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 49 &then tt_datasource.tt_value[50] = REPLACE(REPLACE(STRING("{51}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 50 &then tt_datasource.tt_value[51] = REPLACE(REPLACE(STRING("{52}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 51 &then tt_datasource.tt_value[52] = REPLACE(REPLACE(STRING("{53}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 52 &then tt_datasource.tt_value[53] = REPLACE(REPLACE(STRING("{54}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 53 &then tt_datasource.tt_value[54] = REPLACE(REPLACE(STRING("{55}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 54 &then tt_datasource.tt_value[55] = REPLACE(REPLACE(STRING("{56}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 55 &then tt_datasource.tt_value[56] = REPLACE(REPLACE(STRING("{57}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 56 &then tt_datasource.tt_value[57] = REPLACE(REPLACE(STRING("{58}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 57 &then tt_datasource.tt_value[58] = REPLACE(REPLACE(STRING("{59}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 58 &then tt_datasource.tt_value[59] = REPLACE(REPLACE(STRING("{60}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 59 &then tt_datasource.tt_value[60] = REPLACE(REPLACE(STRING("{61}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 60 &then tt_datasource.tt_value[61] = REPLACE(REPLACE(STRING("{62}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 61 &then tt_datasource.tt_value[62] = REPLACE(REPLACE(STRING("{63}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 62 &then tt_datasource.tt_value[63] = REPLACE(REPLACE(STRING("{64}"),".":U,"_":U )," ":U,"_":U) &endif
            &if {&gsrepcolumn} > 63 &then tt_datasource.tt_value[64] = REPLACE(REPLACE(STRING("{65}"),".":U,"_":U )," ":U,"_":U) &endif
            .

        /* F2 = Field Labels */
        CREATE tt_datasource.
        ASSIGN
            tt_datasource.tt_tag = STRING({1},"99") + "F2":U
        &if {&gsrepcolumn} > 0  &then tt_datasource.tt_value[1]   = STRING("{2}")  &endif
        &if {&gsrepcolumn} > 1  &then tt_datasource.tt_value[2]   = STRING("{3}")  &endif
        &if {&gsrepcolumn} > 2  &then tt_datasource.tt_value[3]   = STRING("{4}")  &endif
        &if {&gsrepcolumn} > 3  &then tt_datasource.tt_value[4]   = STRING("{5}")  &endif
        &if {&gsrepcolumn} > 4  &then tt_datasource.tt_value[5]   = STRING("{6}")  &endif
        &if {&gsrepcolumn} > 5  &then tt_datasource.tt_value[6]   = STRING("{7}")  &endif
        &if {&gsrepcolumn} > 6  &then tt_datasource.tt_value[7]   = STRING("{8}")  &endif
        &if {&gsrepcolumn} > 7  &then tt_datasource.tt_value[8]   = STRING("{9}")  &endif
        &if {&gsrepcolumn} > 8  &then tt_datasource.tt_value[9]   = STRING("{10}") &endif
        &if {&gsrepcolumn} > 9  &then tt_datasource.tt_value[10]  = STRING("{11}") &endif
        &if {&gsrepcolumn} > 10 &then tt_datasource.tt_value[11]  = STRING("{12}") &endif
        &if {&gsrepcolumn} > 11 &then tt_datasource.tt_value[12]  = STRING("{13}") &endif
        &if {&gsrepcolumn} > 12 &then tt_datasource.tt_value[13]  = STRING("{14}") &endif
        &if {&gsrepcolumn} > 13 &then tt_datasource.tt_value[14]  = STRING("{15}") &endif
        &if {&gsrepcolumn} > 14 &then tt_datasource.tt_value[15]  = STRING("{16}") &endif
        &if {&gsrepcolumn} > 15 &then tt_datasource.tt_value[16]  = STRING("{17}") &endif
        &if {&gsrepcolumn} > 16 &then tt_datasource.tt_value[17]  = STRING("{18}") &endif
        &if {&gsrepcolumn} > 17 &then tt_datasource.tt_value[18]  = STRING("{19}") &endif
        &if {&gsrepcolumn} > 18 &then tt_datasource.tt_value[19]  = STRING("{20}") &endif
        &if {&gsrepcolumn} > 19 &then tt_datasource.tt_value[20]  = STRING("{21}") &endif
        &if {&gsrepcolumn} > 20 &then tt_datasource.tt_value[21]  = STRING("{22}") &endif
        &if {&gsrepcolumn} > 21 &then tt_datasource.tt_value[22]  = STRING("{23}") &endif
        &if {&gsrepcolumn} > 22 &then tt_datasource.tt_value[23]  = STRING("{24}") &endif
        &if {&gsrepcolumn} > 23 &then tt_datasource.tt_value[24]  = STRING("{25}") &endif
        &if {&gsrepcolumn} > 24 &then tt_datasource.tt_value[25]  = STRING("{26}") &endif
        &if {&gsrepcolumn} > 25 &then tt_datasource.tt_value[26]  = STRING("{27}") &endif
        &if {&gsrepcolumn} > 26 &then tt_datasource.tt_value[27]  = STRING("{28}") &endif
        &if {&gsrepcolumn} > 27 &then tt_datasource.tt_value[28]  = STRING("{29}") &endif
        &if {&gsrepcolumn} > 28 &then tt_datasource.tt_value[29]  = STRING("{30}") &endif
        &if {&gsrepcolumn} > 29 &then tt_datasource.tt_value[30]  = STRING("{31}") &endif
        &if {&gsrepcolumn} > 30 &then tt_datasource.tt_value[31]  = STRING("{32}") &endif
        &if {&gsrepcolumn} > 31 &then tt_datasource.tt_value[32]  = STRING("{33}") &endif
        &if {&gsrepcolumn} > 32 &then tt_datasource.tt_value[33]  = STRING("{34}") &endif
        &if {&gsrepcolumn} > 33 &then tt_datasource.tt_value[34]  = STRING("{35}") &endif
        &if {&gsrepcolumn} > 34 &then tt_datasource.tt_value[35]  = STRING("{36}") &endif
        &if {&gsrepcolumn} > 35 &then tt_datasource.tt_value[36]  = STRING("{37}") &endif
        &if {&gsrepcolumn} > 36 &then tt_datasource.tt_value[37]  = STRING("{38}") &endif
        &if {&gsrepcolumn} > 37 &then tt_datasource.tt_value[38]  = STRING("{39}") &endif
        &if {&gsrepcolumn} > 38 &then tt_datasource.tt_value[39]  = STRING("{40}") &endif
        &if {&gsrepcolumn} > 39 &then tt_datasource.tt_value[40]  = STRING("{41}") &endif
        &if {&gsrepcolumn} > 40 &then tt_datasource.tt_value[41]  = STRING("{42}") &endif
        &if {&gsrepcolumn} > 41 &then tt_datasource.tt_value[42]  = STRING("{43}") &endif
        &if {&gsrepcolumn} > 42 &then tt_datasource.tt_value[43]  = STRING("{44}") &endif
        &if {&gsrepcolumn} > 43 &then tt_datasource.tt_value[44]  = STRING("{45}") &endif
        &if {&gsrepcolumn} > 44 &then tt_datasource.tt_value[45]  = STRING("{46}") &endif
        &if {&gsrepcolumn} > 45 &then tt_datasource.tt_value[46]  = STRING("{47}") &endif
        &if {&gsrepcolumn} > 46 &then tt_datasource.tt_value[47]  = STRING("{48}") &endif
        &if {&gsrepcolumn} > 47 &then tt_datasource.tt_value[48]  = STRING("{49}") &endif
        &if {&gsrepcolumn} > 48 &then tt_datasource.tt_value[49]  = STRING("{50}") &endif
        &if {&gsrepcolumn} > 49 &then tt_datasource.tt_value[50]  = STRING("{51}") &endif
        &if {&gsrepcolumn} > 50 &then tt_datasource.tt_value[51]  = STRING("{52}") &endif
        &if {&gsrepcolumn} > 51 &then tt_datasource.tt_value[52]  = STRING("{53}") &endif
        &if {&gsrepcolumn} > 52 &then tt_datasource.tt_value[53]  = STRING("{54}") &endif
        &if {&gsrepcolumn} > 53 &then tt_datasource.tt_value[54]  = STRING("{55}") &endif
        &if {&gsrepcolumn} > 54 &then tt_datasource.tt_value[55]  = STRING("{56}") &endif
        &if {&gsrepcolumn} > 55 &then tt_datasource.tt_value[56]  = STRING("{57}") &endif
        &if {&gsrepcolumn} > 56 &then tt_datasource.tt_value[57]  = STRING("{58}") &endif
        &if {&gsrepcolumn} > 57 &then tt_datasource.tt_value[58]  = STRING("{59}") &endif
        &if {&gsrepcolumn} > 58 &then tt_datasource.tt_value[59]  = STRING("{60}") &endif
        &if {&gsrepcolumn} > 59 &then tt_datasource.tt_value[60]  = STRING("{61}") &endif
        &if {&gsrepcolumn} > 60 &then tt_datasource.tt_value[61]  = STRING("{62}") &endif
        &if {&gsrepcolumn} > 61 &then tt_datasource.tt_value[62]  = STRING("{63}") &endif
        &if {&gsrepcolumn} > 62 &then tt_datasource.tt_value[63]  = STRING("{64}") &endif
        &if {&gsrepcolumn} > 63 &then tt_datasource.tt_value[64]  = STRING("{65}") &endif
        .

        /* F3 = Field Column Widths */ /* width is re-done after the last field has been done */
        CREATE tt_datasource.
        ASSIGN 
            tt_datasource.tt_tag = STRING({1},"99") + "F3":U.
        DO lv_num_entries = 1 TO {&gsrepcolumn}:
          ASSIGN
            tt_datasource.tt_value[lv_num_entries] = lv_width_list[lv_num_entries].
        END.

        /* F4 = Data Types */
        CREATE tt_datasource.
        ASSIGN 
            tt_datasource.tt_tag = STRING({1},"99") + "F4":U.
        DO lv_num_entries = 1 TO {&gsrepcolumn}:
          ASSIGN
            tt_datasource.tt_value[lv_num_entries] = "10":U. /* why hardcode value as 10 */
        END.

    END.

&endif

&if defined(gsrepdatawidth) <> 0 &then

    IF lv_rep_tool_code = "TEXT-PRO":U
    OR lv_rep_tool_code = "ODBC-CRY":U
    OR lv_rep_tool_code = "TEXT-MSDB":U
    THEN DO:
    END.
    ELSE
    IF lv_rep_tool_code = "MSDB-CRY":U
    THEN DO:

        FIND tt_datasource EXCLUSIVE-LOCK
            WHERE tt_datasource.tt_tag = STRING({1},"99") + "F3":U
            NO-ERROR.
        IF NOT AVAILABLE tt_datasource
        THEN DO:
            CREATE tt_datasource.
            ASSIGN 
                tt_datasource.tt_tag = STRING({1},"99") + "F3":U.
        END.

        &if {&gsrepdatawidth} > 0   &then ASSIGN tt_datasource.tt_value[1]   = STRING("{2}")   . &endif
        &if {&gsrepdatawidth} > 1   &then ASSIGN tt_datasource.tt_value[2]   = STRING("{3}")   . &endif
        &if {&gsrepdatawidth} > 2   &then ASSIGN tt_datasource.tt_value[3]   = STRING("{4}")   . &endif
        &if {&gsrepdatawidth} > 3   &then ASSIGN tt_datasource.tt_value[4]   = STRING("{5}")   . &endif
        &if {&gsrepdatawidth} > 4   &then ASSIGN tt_datasource.tt_value[5]   = STRING("{6}")   . &endif
        &if {&gsrepdatawidth} > 5   &then ASSIGN tt_datasource.tt_value[6]   = STRING("{7}")   . &endif
        &if {&gsrepdatawidth} > 6   &then ASSIGN tt_datasource.tt_value[7]   = STRING("{8}")   . &endif
        &if {&gsrepdatawidth} > 7   &then ASSIGN tt_datasource.tt_value[8]   = STRING("{9}")   . &endif 
        &if {&gsrepdatawidth} > 8   &then ASSIGN tt_datasource.tt_value[9]   = STRING("{10}")  . &endif
        &if {&gsrepdatawidth} > 9   &then ASSIGN tt_datasource.tt_value[10]  = STRING("{11}")  . &endif
        &if {&gsrepdatawidth} > 10  &then ASSIGN tt_datasource.tt_value[11]  = STRING("{12}")  . &endif
        &if {&gsrepdatawidth} > 11  &then ASSIGN tt_datasource.tt_value[12]  = STRING("{13}")  . &endif
        &if {&gsrepdatawidth} > 12  &then ASSIGN tt_datasource.tt_value[13]  = STRING("{14}")  . &endif
        &if {&gsrepdatawidth} > 13  &then ASSIGN tt_datasource.tt_value[14]  = STRING("{15}")  . &endif
        &if {&gsrepdatawidth} > 14  &then ASSIGN tt_datasource.tt_value[15]  = STRING("{16}")  . &endif
        &if {&gsrepdatawidth} > 15  &then ASSIGN tt_datasource.tt_value[16]  = STRING("{17}")  . &endif
        &if {&gsrepdatawidth} > 16  &then ASSIGN tt_datasource.tt_value[17]  = STRING("{18}")  . &endif
        &if {&gsrepdatawidth} > 17  &then ASSIGN tt_datasource.tt_value[18]  = STRING("{19}")  . &endif
        &if {&gsrepdatawidth} > 18  &then ASSIGN tt_datasource.tt_value[19]  = STRING("{20}")  . &endif
        &if {&gsrepdatawidth} > 19  &then ASSIGN tt_datasource.tt_value[20]  = STRING("{21}")  . &endif
        &if {&gsrepdatawidth} > 20  &then ASSIGN tt_datasource.tt_value[21]  = STRING("{22}")  . &endif
        &if {&gsrepdatawidth} > 21  &then ASSIGN tt_datasource.tt_value[22]  = STRING("{23}")  . &endif
        &if {&gsrepdatawidth} > 22  &then ASSIGN tt_datasource.tt_value[23]  = STRING("{24}")  . &endif
        &if {&gsrepdatawidth} > 23  &then ASSIGN tt_datasource.tt_value[24]  = STRING("{25}")  . &endif
        &if {&gsrepdatawidth} > 24  &then ASSIGN tt_datasource.tt_value[25]  = STRING("{26}")  . &endif
        &if {&gsrepdatawidth} > 25  &then ASSIGN tt_datasource.tt_value[26]  = STRING("{27}")  . &endif
        &if {&gsrepdatawidth} > 26  &then ASSIGN tt_datasource.tt_value[27]  = STRING("{28}")  . &endif
        &if {&gsrepdatawidth} > 27  &then ASSIGN tt_datasource.tt_value[28]  = STRING("{29}")  . &endif
        &if {&gsrepdatawidth} > 28  &then ASSIGN tt_datasource.tt_value[29]  = STRING("{30}")  . &endif
        &if {&gsrepdatawidth} > 29  &then ASSIGN tt_datasource.tt_value[30]  = STRING("{31}")  . &endif
        &if {&gsrepdatawidth} > 30  &then ASSIGN tt_datasource.tt_value[31]  = STRING("{32}")  . &endif
        &if {&gsrepdatawidth} > 31  &then ASSIGN tt_datasource.tt_value[32]  = STRING("{33}")  . &endif
        &if {&gsrepdatawidth} > 32  &then ASSIGN tt_datasource.tt_value[33]  = STRING("{34}")  . &endif
        &if {&gsrepdatawidth} > 33  &then ASSIGN tt_datasource.tt_value[34]  = STRING("{35}")  . &endif
        &if {&gsrepdatawidth} > 34  &then ASSIGN tt_datasource.tt_value[35]  = STRING("{36}")  . &endif
        &if {&gsrepdatawidth} > 35  &then ASSIGN tt_datasource.tt_value[36]  = STRING("{37}")  . &endif
        &if {&gsrepdatawidth} > 36  &then ASSIGN tt_datasource.tt_value[37]  = STRING("{38}")  . &endif
        &if {&gsrepdatawidth} > 37  &then ASSIGN tt_datasource.tt_value[38]  = STRING("{39}")  . &endif
        &if {&gsrepdatawidth} > 38  &then ASSIGN tt_datasource.tt_value[39]  = STRING("{40}")  . &endif
        &if {&gsrepdatawidth} > 39  &then ASSIGN tt_datasource.tt_value[40]  = STRING("{41}")  . &endif
        &if {&gsrepdatawidth} > 40  &then ASSIGN tt_datasource.tt_value[41]  = STRING("{42}")  . &endif
        &if {&gsrepdatawidth} > 41  &then ASSIGN tt_datasource.tt_value[42]  = STRING("{43}")  . &endif
        &if {&gsrepdatawidth} > 42  &then ASSIGN tt_datasource.tt_value[43]  = STRING("{44}")  . &endif
        &if {&gsrepdatawidth} > 43  &then ASSIGN tt_datasource.tt_value[44]  = STRING("{45}")  . &endif
        &if {&gsrepdatawidth} > 44  &then ASSIGN tt_datasource.tt_value[45]  = STRING("{46}")  . &endif
        &if {&gsrepdatawidth} > 45  &then ASSIGN tt_datasource.tt_value[46]  = STRING("{47}")  . &endif
        &if {&gsrepdatawidth} > 46  &then ASSIGN tt_datasource.tt_value[47]  = STRING("{48}")  . &endif
        &if {&gsrepdatawidth} > 47  &then ASSIGN tt_datasource.tt_value[48]  = STRING("{49}")  . &endif
        &if {&gsrepdatawidth} > 48  &then ASSIGN tt_datasource.tt_value[49]  = STRING("{50}")  . &endif
        &if {&gsrepdatawidth} > 49  &then ASSIGN tt_datasource.tt_value[50]  = STRING("{51}")  . &endif
        &if {&gsrepdatawidth} > 50  &then ASSIGN tt_datasource.tt_value[51]  = STRING("{52}")  . &endif
        &if {&gsrepdatawidth} > 51  &then ASSIGN tt_datasource.tt_value[52]  = STRING("{53}")  . &endif
        &if {&gsrepdatawidth} > 52  &then ASSIGN tt_datasource.tt_value[53]  = STRING("{54}")  . &endif
        &if {&gsrepdatawidth} > 53  &then ASSIGN tt_datasource.tt_value[54]  = STRING("{55}")  . &endif
        &if {&gsrepdatawidth} > 54  &then ASSIGN tt_datasource.tt_value[55]  = STRING("{56}")  . &endif
        &if {&gsrepdatawidth} > 55  &then ASSIGN tt_datasource.tt_value[56]  = STRING("{57}")  . &endif
        &if {&gsrepdatawidth} > 56  &then ASSIGN tt_datasource.tt_value[57]  = STRING("{58}")  . &endif
        &if {&gsrepdatawidth} > 57  &then ASSIGN tt_datasource.tt_value[58]  = STRING("{59}")  . &endif 
        &if {&gsrepdatawidth} > 58  &then ASSIGN tt_datasource.tt_value[59]  = STRING("{60}")  . &endif
        &if {&gsrepdatawidth} > 59  &then ASSIGN tt_datasource.tt_value[60]  = STRING("{61}")  . &endif
        &if {&gsrepdatawidth} > 60  &then ASSIGN tt_datasource.tt_value[61]  = STRING("{62}")  . &endif
        &if {&gsrepdatawidth} > 61  &then ASSIGN tt_datasource.tt_value[62]  = STRING("{63}")  . &endif
        &if {&gsrepdatawidth} > 62  &then ASSIGN tt_datasource.tt_value[63]  = STRING("{64}")  . &endif
        &if {&gsrepdatawidth} > 63  &then ASSIGN tt_datasource.tt_value[64]  = STRING("{65}")  . &endif

    END.

&endif

&if defined(gsrepdatatype) <> 0 &then

    IF lv_rep_tool_code = "TEXT-PRO":U
    OR lv_rep_tool_code = "ODBC-CRY":U
    OR lv_rep_tool_code = "TEXT-MSDB":U
    THEN DO:
    END.
    ELSE
    IF lv_rep_tool_code = "MSDB-CRY":U
    THEN DO:

        FIND tt_datasource EXCLUSIVE-LOCK
            WHERE tt_datasource.tt_tag = STRING({1},"99") + "F4":U
            NO-ERROR.
        IF NOT AVAILABLE tt_datasource
        THEN DO:
            CREATE tt_datasource.
            ASSIGN 
                tt_datasource.tt_tag = STRING({1},"99") + "F4":U.
        END.

        &if {&gsrepdatatype} > 0  &then ASSIGN tt_datasource.tt_value[1]   = STRING("{2}")   . &endif
        &if {&gsrepdatatype} > 1  &then ASSIGN tt_datasource.tt_value[2]   = STRING("{3}")   . &endif
        &if {&gsrepdatatype} > 2  &then ASSIGN tt_datasource.tt_value[3]   = STRING("{4}")   . &endif
        &if {&gsrepdatatype} > 3  &then ASSIGN tt_datasource.tt_value[4]   = STRING("{5}")   . &endif
        &if {&gsrepdatatype} > 4  &then ASSIGN tt_datasource.tt_value[5]   = STRING("{6}")   . &endif
        &if {&gsrepdatatype} > 5  &then ASSIGN tt_datasource.tt_value[6]   = STRING("{7}")   . &endif
        &if {&gsrepdatatype} > 6  &then ASSIGN tt_datasource.tt_value[7]   = STRING("{8}")   . &endif
        &if {&gsrepdatatype} > 7  &then ASSIGN tt_datasource.tt_value[8]   = STRING("{9}")   . &endif 
        &if {&gsrepdatatype} > 8  &then ASSIGN tt_datasource.tt_value[9]   = STRING("{10}")  . &endif
        &if {&gsrepdatatype} > 9  &then ASSIGN tt_datasource.tt_value[10]  = STRING("{11}")  . &endif
        &if {&gsrepdatatype} > 10 &then ASSIGN tt_datasource.tt_value[11]  = STRING("{12}")  . &endif
        &if {&gsrepdatatype} > 11 &then ASSIGN tt_datasource.tt_value[12]  = STRING("{13}")  . &endif
        &if {&gsrepdatatype} > 12 &then ASSIGN tt_datasource.tt_value[13]  = STRING("{14}")  . &endif
        &if {&gsrepdatatype} > 13 &then ASSIGN tt_datasource.tt_value[14]  = STRING("{15}")  . &endif
        &if {&gsrepdatatype} > 14 &then ASSIGN tt_datasource.tt_value[15]  = STRING("{16}")  . &endif
        &if {&gsrepdatatype} > 15 &then ASSIGN tt_datasource.tt_value[16]  = STRING("{17}")  . &endif
        &if {&gsrepdatatype} > 16 &then ASSIGN tt_datasource.tt_value[17]  = STRING("{18}")  . &endif
        &if {&gsrepdatatype} > 17 &then ASSIGN tt_datasource.tt_value[18]  = STRING("{19}")  . &endif
        &if {&gsrepdatatype} > 18 &then ASSIGN tt_datasource.tt_value[19]  = STRING("{20}")  . &endif
        &if {&gsrepdatatype} > 19 &then ASSIGN tt_datasource.tt_value[20]  = STRING("{21}")  . &endif
        &if {&gsrepdatatype} > 20 &then ASSIGN tt_datasource.tt_value[21]  = STRING("{22}")  . &endif
        &if {&gsrepdatatype} > 21 &then ASSIGN tt_datasource.tt_value[22]  = STRING("{23}")  . &endif
        &if {&gsrepdatatype} > 22 &then ASSIGN tt_datasource.tt_value[23]  = STRING("{24}")  . &endif
        &if {&gsrepdatatype} > 23 &then ASSIGN tt_datasource.tt_value[24]  = STRING("{25}")  . &endif
        &if {&gsrepdatatype} > 24 &then ASSIGN tt_datasource.tt_value[25]  = STRING("{26}")  . &endif
        &if {&gsrepdatatype} > 25 &then ASSIGN tt_datasource.tt_value[26]  = STRING("{27}")  . &endif
        &if {&gsrepdatatype} > 26 &then ASSIGN tt_datasource.tt_value[27]  = STRING("{28}")  . &endif
        &if {&gsrepdatatype} > 27 &then ASSIGN tt_datasource.tt_value[28]  = STRING("{29}")  . &endif
        &if {&gsrepdatatype} > 28 &then ASSIGN tt_datasource.tt_value[29]  = STRING("{30}")  . &endif
        &if {&gsrepdatatype} > 29 &then ASSIGN tt_datasource.tt_value[30]  = STRING("{31}")  . &endif
        &if {&gsrepdatatype} > 30 &then ASSIGN tt_datasource.tt_value[31]  = STRING("{32}")  . &endif
        &if {&gsrepdatatype} > 31 &then ASSIGN tt_datasource.tt_value[32]  = STRING("{33}")  . &endif
        &if {&gsrepdatatype} > 32 &then ASSIGN tt_datasource.tt_value[33]  = STRING("{34}")  . &endif
        &if {&gsrepdatatype} > 33 &then ASSIGN tt_datasource.tt_value[34]  = STRING("{35}")  . &endif
        &if {&gsrepdatatype} > 34 &then ASSIGN tt_datasource.tt_value[35]  = STRING("{36}")  . &endif
        &if {&gsrepdatatype} > 35 &then ASSIGN tt_datasource.tt_value[36]  = STRING("{37}")  . &endif
        &if {&gsrepdatatype} > 36 &then ASSIGN tt_datasource.tt_value[37]  = STRING("{38}")  . &endif
        &if {&gsrepdatatype} > 37 &then ASSIGN tt_datasource.tt_value[38]  = STRING("{39}")  . &endif
        &if {&gsrepdatatype} > 38 &then ASSIGN tt_datasource.tt_value[39]  = STRING("{40}")  . &endif
        &if {&gsrepdatatype} > 39 &then ASSIGN tt_datasource.tt_value[40]  = STRING("{41}")  . &endif
        &if {&gsrepdatatype} > 40 &then ASSIGN tt_datasource.tt_value[41]  = STRING("{42}")  . &endif
        &if {&gsrepdatatype} > 41 &then ASSIGN tt_datasource.tt_value[42]  = STRING("{43}")  . &endif
        &if {&gsrepdatatype} > 42 &then ASSIGN tt_datasource.tt_value[43]  = STRING("{44}")  . &endif
        &if {&gsrepdatatype} > 43 &then ASSIGN tt_datasource.tt_value[44]  = STRING("{45}")  . &endif
        &if {&gsrepdatatype} > 44 &then ASSIGN tt_datasource.tt_value[45]  = STRING("{46}")  .  &endif
        &if {&gsrepdatatype} > 45 &then ASSIGN tt_datasource.tt_value[46]  = STRING("{47}")  . &endif
        &if {&gsrepdatatype} > 46 &then ASSIGN tt_datasource.tt_value[47]  = STRING("{48}")  . &endif
        &if {&gsrepdatatype} > 47 &then ASSIGN tt_datasource.tt_value[48]  = STRING("{49}")  . &endif
        &if {&gsrepdatatype} > 48 &then ASSIGN tt_datasource.tt_value[49]  = STRING("{50}")  . &endif
        &if {&gsrepdatatype} > 49 &then ASSIGN tt_datasource.tt_value[50]  = STRING("{51}")  . &endif
        &if {&gsrepdatatype} > 50 &then ASSIGN tt_datasource.tt_value[51]  = STRING("{52}")  . &endif
        &if {&gsrepdatatype} > 51 &then ASSIGN tt_datasource.tt_value[52]  = STRING("{53}")  . &endif
        &if {&gsrepdatatype} > 52 &then ASSIGN tt_datasource.tt_value[53]  = STRING("{54}")  . &endif
        &if {&gsrepdatatype} > 53 &then ASSIGN tt_datasource.tt_value[54]  = STRING("{55}")  . &endif
        &if {&gsrepdatatype} > 54 &then ASSIGN tt_datasource.tt_value[55]  = STRING("{56}")  . &endif
        &if {&gsrepdatatype} > 55 &then ASSIGN tt_datasource.tt_value[56]  = STRING("{57}")  . &endif
        &if {&gsrepdatatype} > 56 &then ASSIGN tt_datasource.tt_value[57]  = STRING("{58}")  . &endif
        &if {&gsrepdatatype} > 57 &then ASSIGN tt_datasource.tt_value[58]  = STRING("{59}")  . &endif 
        &if {&gsrepdatatype} > 58 &then ASSIGN tt_datasource.tt_value[59]  = STRING("{60}")  . &endif
        &if {&gsrepdatatype} > 59 &then ASSIGN tt_datasource.tt_value[60]  = STRING("{61}")  . &endif
        &if {&gsrepdatatype} > 60 &then ASSIGN tt_datasource.tt_value[61]  = STRING("{62}")  . &endif
        &if {&gsrepdatatype} > 61 &then ASSIGN tt_datasource.tt_value[62]  = STRING("{63}")  . &endif
        &if {&gsrepdatatype} > 62 &then ASSIGN tt_datasource.tt_value[63]  = STRING("{64}")  . &endif
        &if {&gsrepdatatype} > 63 &then ASSIGN tt_datasource.tt_value[64]  = STRING("{65}")  . &endif

    END.

&endif

&if defined(gsrepformat) <> 0 &then
    IF lv_rep_tool_code = "TEXT-PRO":U
    OR lv_rep_tool_code = "ODBC-CRY":U
    OR lv_rep_tool_code = "TEXT-MSDB":U
    THEN DO:

        EXPORT STREAM ls_stream_{1} DELIMITER ","
            &if {&gsrepformat} >  0 &then {2}   &endif
            &if {&gsrepformat} >  1 &then {3}   &endif
            &if {&gsrepformat} >  2 &then {4}   &endif
            &if {&gsrepformat} >  3 &then {5}   &endif
            &if {&gsrepformat} >  4 &then {6}   &endif
            &if {&gsrepformat} >  5 &then {7}   &endif
            &if {&gsrepformat} >  6 &then {8}   &endif
            &if {&gsrepformat} >  7 &then {9}   &endif
            &if {&gsrepformat} >  8 &then {10}  &endif
            &if {&gsrepformat} >  9 &then {11}  &endif
            &if {&gsrepformat} > 10 &then {12}  &endif
            &if {&gsrepformat} > 11 &then {13}  &endif
            &if {&gsrepformat} > 12 &then {14}  &endif
            &if {&gsrepformat} > 13 &then {15}  &endif
            &if {&gsrepformat} > 14 &then {16}  &endif
            &if {&gsrepformat} > 15 &then {17}  &endif
            &if {&gsrepformat} > 16 &then {18}  &endif
            &if {&gsrepformat} > 17 &then {19}  &endif
            &if {&gsrepformat} > 18 &then {20}  &endif
            &if {&gsrepformat} > 19 &then {21}  &endif
            &if {&gsrepformat} > 20 &then {22}  &endif
            &if {&gsrepformat} > 21 &then {23}  &endif
            &if {&gsrepformat} > 22 &then {24}  &endif
            &if {&gsrepformat} > 23 &then {25}  &endif
            &if {&gsrepformat} > 24 &then {26}  &endif
            &if {&gsrepformat} > 25 &then {27}  &endif
            &if {&gsrepformat} > 26 &then {28}  &endif
            &if {&gsrepformat} > 27 &then {29}  &endif
            &if {&gsrepformat} > 28 &then {30}  &endif
            &if {&gsrepformat} > 29 &then {31}  &endif
            &if {&gsrepformat} > 30 &then {32}  &endif
            &if {&gsrepformat} > 31 &then {33}  &endif
            &if {&gsrepformat} > 32 &then {34}  &endif
            &if {&gsrepformat} > 33 &then {35}  &endif
            &if {&gsrepformat} > 34 &then {36}  &endif
            &if {&gsrepformat} > 35 &then {37}  &endif
            &if {&gsrepformat} > 36 &then {38}  &endif
            &if {&gsrepformat} > 37 &then {39}  &endif
            &if {&gsrepformat} > 38 &then {40}  &endif
            &if {&gsrepformat} > 39 &then {41}  &endif
            &if {&gsrepformat} > 40 &then {42}  &endif
            &if {&gsrepformat} > 41 &then {43}  &endif
            &if {&gsrepformat} > 42 &then {44}  &endif
            &if {&gsrepformat} > 43 &then {45}  &endif
            &if {&gsrepformat} > 44 &then {46}  &endif
            &if {&gsrepformat} > 45 &then {47}  &endif
            &if {&gsrepformat} > 46 &then {48}  &endif
            &if {&gsrepformat} > 47 &then {49}  &endif
            &if {&gsrepformat} > 48 &then {50}  &endif
            &if {&gsrepformat} > 49 &then {51}  &endif
            &if {&gsrepformat} > 50 &then {52}  &endif
            &if {&gsrepformat} > 51 &then {53}  &endif
            &if {&gsrepformat} > 52 &then {54}  &endif
            &if {&gsrepformat} > 53 &then {55}  &endif
            &if {&gsrepformat} > 54 &then {56}  &endif
            &if {&gsrepformat} > 55 &then {57}  &endif
            &if {&gsrepformat} > 56 &then {58}  &endif
            &if {&gsrepformat} > 57 &then {59}  &endif
            &if {&gsrepformat} > 58 &then {60}  &endif
            &if {&gsrepformat} > 59 &then {61}  &endif
            &if {&gsrepformat} > 60 &then {62}  &endif
            &if {&gsrepformat} > 61 &then {63}  &endif
            &if {&gsrepformat} > 62 &then {64}  &endif
            &if {&gsrepformat} > 63 &then {65}  &endif
            .

    END.
    ELSE
    IF lv_rep_tool_code = "MSDB-CRY":U
    THEN DO:

        ASSIGN
            lv_rep_fields[{1}] = INTEGER({&gsrepformat}).

        /* D = DataValues */
        CREATE tt_datasource.
        ASSIGN
            tt_datasource.tt_tag = STRING({1},"99") + "D":U
        &if {&gsrepformat} > 0  &then tt_datasource.tt_value[1]   = STRING({2})  &endif
        &if {&gsrepformat} > 1  &then tt_datasource.tt_value[2]   = STRING({3})  &endif
        &if {&gsrepformat} > 2  &then tt_datasource.tt_value[3]   = STRING({4})  &endif
        &if {&gsrepformat} > 3  &then tt_datasource.tt_value[4]   = STRING({5})  &endif
        &if {&gsrepformat} > 4  &then tt_datasource.tt_value[5]   = STRING({6})  &endif
        &if {&gsrepformat} > 5  &then tt_datasource.tt_value[6]   = STRING({7})  &endif
        &if {&gsrepformat} > 6  &then tt_datasource.tt_value[7]   = STRING({8})  &endif
        &if {&gsrepformat} > 7  &then tt_datasource.tt_value[8]   = STRING({9})  &endif
        &if {&gsrepformat} > 8  &then tt_datasource.tt_value[9]   = STRING({10}) &endif
        &if {&gsrepformat} > 9  &then tt_datasource.tt_value[10]  = STRING({11}) &endif
        &if {&gsrepformat} > 10 &then tt_datasource.tt_value[11]  = STRING({12}) &endif
        &if {&gsrepformat} > 11 &then tt_datasource.tt_value[12]  = STRING({13}) &endif
        &if {&gsrepformat} > 12 &then tt_datasource.tt_value[13]  = STRING({14}) &endif
        &if {&gsrepformat} > 13 &then tt_datasource.tt_value[14]  = STRING({15}) &endif
        &if {&gsrepformat} > 14 &then tt_datasource.tt_value[15]  = STRING({16}) &endif
        &if {&gsrepformat} > 15 &then tt_datasource.tt_value[16]  = STRING({17}) &endif
        &if {&gsrepformat} > 16 &then tt_datasource.tt_value[17]  = STRING({18}) &endif
        &if {&gsrepformat} > 17 &then tt_datasource.tt_value[18]  = STRING({19}) &endif
        &if {&gsrepformat} > 18 &then tt_datasource.tt_value[19]  = STRING({20}) &endif
        &if {&gsrepformat} > 19 &then tt_datasource.tt_value[20]  = STRING({21}) &endif
        &if {&gsrepformat} > 20 &then tt_datasource.tt_value[21]  = STRING({22}) &endif
        &if {&gsrepformat} > 21 &then tt_datasource.tt_value[22]  = STRING({23}) &endif
        &if {&gsrepformat} > 22 &then tt_datasource.tt_value[23]  = STRING({24}) &endif
        &if {&gsrepformat} > 23 &then tt_datasource.tt_value[24]  = STRING({25}) &endif
        &if {&gsrepformat} > 24 &then tt_datasource.tt_value[25]  = STRING({26}) &endif
        &if {&gsrepformat} > 25 &then tt_datasource.tt_value[26]  = STRING({27}) &endif
        &if {&gsrepformat} > 26 &then tt_datasource.tt_value[27]  = STRING({28}) &endif
        &if {&gsrepformat} > 27 &then tt_datasource.tt_value[28]  = STRING({29}) &endif
        &if {&gsrepformat} > 28 &then tt_datasource.tt_value[29]  = STRING({30}) &endif
        &if {&gsrepformat} > 29 &then tt_datasource.tt_value[30]  = STRING({31}) &endif
        &if {&gsrepformat} > 30 &then tt_datasource.tt_value[31]  = STRING({32}) &endif
        &if {&gsrepformat} > 31 &then tt_datasource.tt_value[32]  = STRING({33}) &endif
        &if {&gsrepformat} > 32 &then tt_datasource.tt_value[33]  = STRING({34}) &endif
        &if {&gsrepformat} > 33 &then tt_datasource.tt_value[34]  = STRING({35}) &endif
        &if {&gsrepformat} > 34 &then tt_datasource.tt_value[35]  = STRING({36}) &endif
        &if {&gsrepformat} > 35 &then tt_datasource.tt_value[36]  = STRING({37}) &endif
        &if {&gsrepformat} > 36 &then tt_datasource.tt_value[37]  = STRING({38}) &endif
        &if {&gsrepformat} > 37 &then tt_datasource.tt_value[38]  = STRING({39}) &endif
        &if {&gsrepformat} > 38 &then tt_datasource.tt_value[39]  = STRING({40}) &endif
        &if {&gsrepformat} > 39 &then tt_datasource.tt_value[40]  = STRING({41}) &endif
        &if {&gsrepformat} > 40 &then tt_datasource.tt_value[41]  = STRING({42}) &endif
        &if {&gsrepformat} > 41 &then tt_datasource.tt_value[42]  = STRING({43}) &endif
        &if {&gsrepformat} > 42 &then tt_datasource.tt_value[43]  = STRING({44}) &endif
        &if {&gsrepformat} > 43 &then tt_datasource.tt_value[44]  = STRING({45}) &endif
        &if {&gsrepformat} > 44 &then tt_datasource.tt_value[45]  = STRING({46}) &endif
        &if {&gsrepformat} > 45 &then tt_datasource.tt_value[46]  = STRING({47}) &endif
        &if {&gsrepformat} > 46 &then tt_datasource.tt_value[47]  = STRING({48}) &endif
        &if {&gsrepformat} > 47 &then tt_datasource.tt_value[48]  = STRING({49}) &endif
        &if {&gsrepformat} > 48 &then tt_datasource.tt_value[49]  = STRING({50}) &endif
        &if {&gsrepformat} > 49 &then tt_datasource.tt_value[50]  = STRING({51}) &endif
        &if {&gsrepformat} > 50 &then tt_datasource.tt_value[51]  = STRING({52}) &endif
        &if {&gsrepformat} > 51 &then tt_datasource.tt_value[52]  = STRING({53}) &endif
        &if {&gsrepformat} > 52 &then tt_datasource.tt_value[53]  = STRING({54}) &endif
        &if {&gsrepformat} > 53 &then tt_datasource.tt_value[54]  = STRING({55}) &endif
        &if {&gsrepformat} > 54 &then tt_datasource.tt_value[55]  = STRING({56}) &endif
        &if {&gsrepformat} > 55 &then tt_datasource.tt_value[56]  = STRING({57}) &endif
        &if {&gsrepformat} > 56 &then tt_datasource.tt_value[57]  = STRING({58}) &endif
        &if {&gsrepformat} > 57 &then tt_datasource.tt_value[58]  = STRING({59}) &endif 
        &if {&gsrepformat} > 58 &then tt_datasource.tt_value[59]  = STRING({60}) &endif
        &if {&gsrepformat} > 59 &then tt_datasource.tt_value[60]  = STRING({61}) &endif
        &if {&gsrepformat} > 60 &then tt_datasource.tt_value[61]  = STRING({62}) &endif
        &if {&gsrepformat} > 61 &then tt_datasource.tt_value[62]  = STRING({63}) &endif
        &if {&gsrepformat} > 62 &then tt_datasource.tt_value[63]  = STRING({64}) &endif
        &if {&gsrepformat} > 63 &then tt_datasource.tt_value[64]  = STRING({65}) &endif
        .

    END.

&endif

&if defined(gsrepindex) <> 0 &then

    IF lv_rep_tool_code = "TEXT-PRO":U
    OR lv_rep_tool_code = "ODBC-CRY":U
    OR lv_rep_tool_code = "TEXT-MSDB":U
    THEN DO:
    END.
    ELSE
    IF lv_rep_tool_code = "MSDB-CRY":U
    THEN DO:

        FIND tt_datasource EXCLUSIVE-LOCK
            WHERE tt_datasource.tt_tag = STRING({&gsrepindex},"99") + "I0":U
            NO-ERROR.
        IF NOT AVAILABLE tt_datasource
        THEN DO:
            CREATE tt_datasource.
            ASSIGN 
                tt_datasource.tt_tag = STRING({&gsrepindex},"99") + "I0":U.
        END.

        ASSIGN
            tt_datasource.tt_value[1] = lv_datafile_{1}
            tt_datasource.tt_value[2] = lv_datafile_{2}
            .

    END.

&endif

&if defined(gsidxfields)   <> 0
&then

    IF lv_rep_tool_code = "TEXT-PRO":U
    OR lv_rep_tool_code = "ODBC-CRY":U
    OR lv_rep_tool_code = "TEXT-MSDB":U
    THEN DO:
    END.
    ELSE
    IF lv_rep_tool_code = "MSDB-CRY":U
    THEN DO:

        FIND tt_datasource EXCLUSIVE-LOCK
            WHERE tt_datasource.tt_tag = STRING({&gsidxfields},"99") + "I1":U + STRING({1},"99")
            NO-ERROR.
        IF NOT AVAILABLE tt_datasource
        THEN DO:
            CREATE tt_datasource.
            ASSIGN 
                tt_datasource.tt_tag = STRING({&gsidxfields},"99") + "I1":U + STRING({1},"99").
        END.

        &if "{1}":U <> "":U
        &then
                &if {2} > 0  &then ASSIGN tt_datasource.tt_value[1]  = REPLACE(REPLACE(STRING("{3}" ),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 1  &then ASSIGN tt_datasource.tt_value[2]  = REPLACE(REPLACE(STRING("{4}" ),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 2  &then ASSIGN tt_datasource.tt_value[3]  = REPLACE(REPLACE(STRING("{5}" ),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 3  &then ASSIGN tt_datasource.tt_value[4]  = REPLACE(REPLACE(STRING("{6}" ),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 4  &then ASSIGN tt_datasource.tt_value[5]  = REPLACE(REPLACE(STRING("{7}" ),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 5  &then ASSIGN tt_datasource.tt_value[6]  = REPLACE(REPLACE(STRING("{8}" ),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 6  &then ASSIGN tt_datasource.tt_value[7]  = REPLACE(REPLACE(STRING("{9}" ),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 7  &then ASSIGN tt_datasource.tt_value[8]  = REPLACE(REPLACE(STRING("{10}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 8  &then ASSIGN tt_datasource.tt_value[9]  = REPLACE(REPLACE(STRING("{11}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 9  &then ASSIGN tt_datasource.tt_value[10] = REPLACE(REPLACE(STRING("{12}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 10 &then ASSIGN tt_datasource.tt_value[11] = REPLACE(REPLACE(STRING("{13}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 11 &then ASSIGN tt_datasource.tt_value[12] = REPLACE(REPLACE(STRING("{14}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 12 &then ASSIGN tt_datasource.tt_value[13] = REPLACE(REPLACE(STRING("{15}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 13 &then ASSIGN tt_datasource.tt_value[14] = REPLACE(REPLACE(STRING("{16}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 14 &then ASSIGN tt_datasource.tt_value[15] = REPLACE(REPLACE(STRING("{17}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 15 &then ASSIGN tt_datasource.tt_value[16] = REPLACE(REPLACE(STRING("{18}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 16 &then ASSIGN tt_datasource.tt_value[17] = REPLACE(REPLACE(STRING("{19}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 17 &then ASSIGN tt_datasource.tt_value[18] = REPLACE(REPLACE(STRING("{20}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 18 &then ASSIGN tt_datasource.tt_value[19] = REPLACE(REPLACE(STRING("{21}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 19 &then ASSIGN tt_datasource.tt_value[20] = REPLACE(REPLACE(STRING("{22}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 20 &then ASSIGN tt_datasource.tt_value[21] = REPLACE(REPLACE(STRING("{23}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 21 &then ASSIGN tt_datasource.tt_value[22] = REPLACE(REPLACE(STRING("{24}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 22 &then ASSIGN tt_datasource.tt_value[23] = REPLACE(REPLACE(STRING("{25}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 23 &then ASSIGN tt_datasource.tt_value[24] = REPLACE(REPLACE(STRING("{26}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 24 &then ASSIGN tt_datasource.tt_value[25] = REPLACE(REPLACE(STRING("{27}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 25 &then ASSIGN tt_datasource.tt_value[26] = REPLACE(REPLACE(STRING("{28}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 26 &then ASSIGN tt_datasource.tt_value[27] = REPLACE(REPLACE(STRING("{29}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 27 &then ASSIGN tt_datasource.tt_value[28] = REPLACE(REPLACE(STRING("{30}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 28 &then ASSIGN tt_datasource.tt_value[29] = REPLACE(REPLACE(STRING("{31}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 29 &then ASSIGN tt_datasource.tt_value[30] = REPLACE(REPLACE(STRING("{32}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 30 &then ASSIGN tt_datasource.tt_value[31] = REPLACE(REPLACE(STRING("{33}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 31 &then ASSIGN tt_datasource.tt_value[32] = REPLACE(REPLACE(STRING("{34}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 32 &then ASSIGN tt_datasource.tt_value[33] = REPLACE(REPLACE(STRING("{35}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 33 &then ASSIGN tt_datasource.tt_value[34] = REPLACE(REPLACE(STRING("{36}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 34 &then ASSIGN tt_datasource.tt_value[35] = REPLACE(REPLACE(STRING("{37}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 35 &then ASSIGN tt_datasource.tt_value[36] = REPLACE(REPLACE(STRING("{38}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 36 &then ASSIGN tt_datasource.tt_value[37] = REPLACE(REPLACE(STRING("{39}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 37 &then ASSIGN tt_datasource.tt_value[38] = REPLACE(REPLACE(STRING("{40}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 38 &then ASSIGN tt_datasource.tt_value[39] = REPLACE(REPLACE(STRING("{41}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 39 &then ASSIGN tt_datasource.tt_value[40] = REPLACE(REPLACE(STRING("{42}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 40 &then ASSIGN tt_datasource.tt_value[41] = REPLACE(REPLACE(STRING("{43}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 41 &then ASSIGN tt_datasource.tt_value[42] = REPLACE(REPLACE(STRING("{44}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 42 &then ASSIGN tt_datasource.tt_value[43] = REPLACE(REPLACE(STRING("{45}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 43 &then ASSIGN tt_datasource.tt_value[44] = REPLACE(REPLACE(STRING("{46}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 44 &then ASSIGN tt_datasource.tt_value[45] = REPLACE(REPLACE(STRING("{47}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 45 &then ASSIGN tt_datasource.tt_value[46] = REPLACE(REPLACE(STRING("{48}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 46 &then ASSIGN tt_datasource.tt_value[47] = REPLACE(REPLACE(STRING("{49}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 47 &then ASSIGN tt_datasource.tt_value[48] = REPLACE(REPLACE(STRING("{50}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 48 &then ASSIGN tt_datasource.tt_value[49] = REPLACE(REPLACE(STRING("{51}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 49 &then ASSIGN tt_datasource.tt_value[50] = REPLACE(REPLACE(STRING("{52}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 50 &then ASSIGN tt_datasource.tt_value[51] = REPLACE(REPLACE(STRING("{53}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 51 &then ASSIGN tt_datasource.tt_value[52] = REPLACE(REPLACE(STRING("{54}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 52 &then ASSIGN tt_datasource.tt_value[53] = REPLACE(REPLACE(STRING("{55}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 53 &then ASSIGN tt_datasource.tt_value[54] = REPLACE(REPLACE(STRING("{56}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 54 &then ASSIGN tt_datasource.tt_value[55] = REPLACE(REPLACE(STRING("{57}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 55 &then ASSIGN tt_datasource.tt_value[56] = REPLACE(REPLACE(STRING("{58}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 56 &then ASSIGN tt_datasource.tt_value[57] = REPLACE(REPLACE(STRING("{59}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 57 &then ASSIGN tt_datasource.tt_value[58] = REPLACE(REPLACE(STRING("{60}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 58 &then ASSIGN tt_datasource.tt_value[59] = REPLACE(REPLACE(STRING("{61}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 59 &then ASSIGN tt_datasource.tt_value[60] = REPLACE(REPLACE(STRING("{62}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 60 &then ASSIGN tt_datasource.tt_value[61] = REPLACE(REPLACE(STRING("{63}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 61 &then ASSIGN tt_datasource.tt_value[62] = REPLACE(REPLACE(STRING("{64}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 62 &then ASSIGN tt_datasource.tt_value[63] = REPLACE(REPLACE(STRING("{65}"),".":U,"_":U ) ," ":U,"_":U). &endif
                &if {2} > 63 &then ASSIGN tt_datasource.tt_value[64] = REPLACE(REPLACE(STRING("{66}"),".":U,"_":U ) ," ":U,"_":U). &endif
        &endif

    END.

&endif

&if defined(gsidxdatatype) <> 0
&then

    IF lv_rep_tool_code = "TEXT-PRO":U
    OR lv_rep_tool_code = "ODBC-CRY":U
    OR lv_rep_tool_code = "TEXT-MSDB":U
    THEN DO:
    END.
    ELSE
    IF lv_rep_tool_code = "MSDB-CRY":U
    THEN DO:

        FIND tt_datasource EXCLUSIVE-LOCK
            WHERE tt_datasource.tt_tag = STRING({&gsidxdatatype},"99") + "I2":U + STRING({1},"99")
            NO-ERROR.
        IF NOT AVAILABLE tt_datasource
        THEN DO:
            CREATE tt_datasource.
            ASSIGN 
                tt_datasource.tt_tag = STRING({&gsidxdatatype},"99") + "I2":U + STRING({1},"99").
        END.

        &if "{1}":U <> "":U
        &then
            &IF {2} >  0 &THEN ASSIGN tt_datasource.tt_value[1]   = STRING("{3}")   . &ENDIF
            &IF {2} >  1 &THEN ASSIGN tt_datasource.tt_value[2]   = STRING("{4}")   . &ENDIF
            &IF {2} >  2 &THEN ASSIGN tt_datasource.tt_value[3]   = STRING("{5}")   . &ENDIF
            &IF {2} >  3 &THEN ASSIGN tt_datasource.tt_value[4]   = STRING("{6}")   . &ENDIF
            &IF {2} >  4 &THEN ASSIGN tt_datasource.tt_value[5]   = STRING("{7}")   . &ENDIF
            &IF {2} >  5 &THEN ASSIGN tt_datasource.tt_value[6]   = STRING("{8}")   . &ENDIF
            &IF {2} >  6 &THEN ASSIGN tt_datasource.tt_value[7]   = STRING("{9}")   . &ENDIF
            &IF {2} >  7 &THEN ASSIGN tt_datasource.tt_value[8]   = STRING("{10}")  . &ENDIF
            &IF {2} >  8 &THEN ASSIGN tt_datasource.tt_value[9]   = STRING("{11}")  . &ENDIF
            &IF {2} >  9 &THEN ASSIGN tt_datasource.tt_value[10]  = STRING("{12}")  . &ENDIF
            &IF {2} > 10 &THEN ASSIGN tt_datasource.tt_value[11]  = STRING("{13}")  . &ENDIF
            &IF {2} > 11 &THEN ASSIGN tt_datasource.tt_value[12]  = STRING("{14}")  . &ENDIF
            &IF {2} > 12 &THEN ASSIGN tt_datasource.tt_value[13]  = STRING("{15}")  . &ENDIF
            &IF {2} > 13 &THEN ASSIGN tt_datasource.tt_value[14]  = STRING("{16}")  . &ENDIF
            &IF {2} > 14 &THEN ASSIGN tt_datasource.tt_value[15]  = STRING("{17}")  . &ENDIF
            &IF {2} > 15 &THEN ASSIGN tt_datasource.tt_value[16]  = STRING("{18}")  . &ENDIF
            &IF {2} > 16 &THEN ASSIGN tt_datasource.tt_value[17]  = STRING("{19}")  . &ENDIF
            &IF {2} > 17 &THEN ASSIGN tt_datasource.tt_value[18]  = STRING("{20}")  . &ENDIF
            &IF {2} > 18 &THEN ASSIGN tt_datasource.tt_value[19]  = STRING("{21}")  . &ENDIF
            &IF {2} > 19 &THEN ASSIGN tt_datasource.tt_value[20]  = STRING("{22}")  . &ENDIF
            &IF {2} > 20 &THEN ASSIGN tt_datasource.tt_value[21]  = STRING("{23}")  . &ENDIF
            &IF {2} > 21 &THEN ASSIGN tt_datasource.tt_value[22]  = STRING("{24}")  . &ENDIF
            &IF {2} > 22 &THEN ASSIGN tt_datasource.tt_value[23]  = STRING("{25}")  . &ENDIF
            &IF {2} > 23 &THEN ASSIGN tt_datasource.tt_value[24]  = STRING("{26}")  . &ENDIF
            &IF {2} > 24 &THEN ASSIGN tt_datasource.tt_value[25]  = STRING("{27}")  . &ENDIF
            &IF {2} > 25 &THEN ASSIGN tt_datasource.tt_value[26]  = STRING("{28}")  . &ENDIF
            &IF {2} > 26 &THEN ASSIGN tt_datasource.tt_value[27]  = STRING("{29}")  . &ENDIF
            &IF {2} > 27 &THEN ASSIGN tt_datasource.tt_value[28]  = STRING("{30}")  . &ENDIF
            &IF {2} > 28 &THEN ASSIGN tt_datasource.tt_value[29]  = STRING("{31}")  . &ENDIF
            &IF {2} > 29 &THEN ASSIGN tt_datasource.tt_value[30]  = STRING("{32}")  . &ENDIF
            &IF {2} > 30 &THEN ASSIGN tt_datasource.tt_value[31]  = STRING("{33}")  . &ENDIF
            &IF {2} > 31 &THEN ASSIGN tt_datasource.tt_value[32]  = STRING("{34}")  . &ENDIF
            &IF {2} > 32 &THEN ASSIGN tt_datasource.tt_value[33]  = STRING("{35}")  . &ENDIF
            &IF {2} > 33 &THEN ASSIGN tt_datasource.tt_value[34]  = STRING("{36}")  . &ENDIF
            &IF {2} > 34 &THEN ASSIGN tt_datasource.tt_value[35]  = STRING("{37}")  . &ENDIF
            &IF {2} > 35 &THEN ASSIGN tt_datasource.tt_value[36]  = STRING("{38}")  . &ENDIF
            &IF {2} > 36 &THEN ASSIGN tt_datasource.tt_value[37]  = STRING("{39}")  . &ENDIF
            &IF {2} > 37 &THEN ASSIGN tt_datasource.tt_value[38]  = STRING("{40}")  . &ENDIF
            &IF {2} > 38 &THEN ASSIGN tt_datasource.tt_value[39]  = STRING("{41}")  . &ENDIF
            &IF {2} > 39 &THEN ASSIGN tt_datasource.tt_value[40]  = STRING("{42}")  . &ENDIF
            &IF {2} > 40 &THEN ASSIGN tt_datasource.tt_value[41]  = STRING("{43}")  . &ENDIF
            &IF {2} > 41 &THEN ASSIGN tt_datasource.tt_value[42]  = STRING("{44}")  . &ENDIF
            &IF {2} > 42 &THEN ASSIGN tt_datasource.tt_value[43]  = STRING("{45}")  . &ENDIF
            &IF {2} > 43 &THEN ASSIGN tt_datasource.tt_value[44]  = STRING("{46}")  . &ENDIF
            &IF {2} > 44 &THEN ASSIGN tt_datasource.tt_value[45]  = STRING("{47}")  . &ENDIF
            &IF {2} > 45 &THEN ASSIGN tt_datasource.tt_value[46]  = STRING("{48}")  . &ENDIF
            &IF {2} > 46 &THEN ASSIGN tt_datasource.tt_value[47]  = STRING("{49}")  . &ENDIF
            &IF {2} > 47 &THEN ASSIGN tt_datasource.tt_value[48]  = STRING("{50}")  . &ENDIF
            &IF {2} > 48 &THEN ASSIGN tt_datasource.tt_value[49]  = STRING("{51}")  . &ENDIF
            &IF {2} > 49 &THEN ASSIGN tt_datasource.tt_value[50]  = STRING("{52}")  . &ENDIF
            &IF {2} > 50 &THEN ASSIGN tt_datasource.tt_value[51]  = STRING("{53}")  . &ENDIF
            &IF {2} > 51 &THEN ASSIGN tt_datasource.tt_value[52]  = STRING("{54}")  . &ENDIF
            &IF {2} > 52 &THEN ASSIGN tt_datasource.tt_value[53]  = STRING("{55}")  . &ENDIF
            &IF {2} > 53 &THEN ASSIGN tt_datasource.tt_value[54]  = STRING("{56}")  . &ENDIF
            &IF {2} > 54 &THEN ASSIGN tt_datasource.tt_value[55]  = STRING("{57}")  . &ENDIF
            &IF {2} > 55 &THEN ASSIGN tt_datasource.tt_value[56]  = STRING("{58}")  . &ENDIF
            &IF {2} > 56 &THEN ASSIGN tt_datasource.tt_value[57]  = STRING("{59}")  . &ENDIF
            &IF {2} > 57 &THEN ASSIGN tt_datasource.tt_value[58]  = STRING("{60}")  . &ENDIF
            &IF {2} > 58 &THEN ASSIGN tt_datasource.tt_value[59]  = STRING("{61}")  . &ENDIF
            &IF {2} > 59 &THEN ASSIGN tt_datasource.tt_value[60]  = STRING("{62}")  . &ENDIF
            &IF {2} > 60 &THEN ASSIGN tt_datasource.tt_value[61]  = STRING("{63}")  . &ENDIF
            &IF {2} > 61 &THEN ASSIGN tt_datasource.tt_value[62]  = STRING("{64}")  . &ENDIF
            &IF {2} > 62 &THEN ASSIGN tt_datasource.tt_value[63]  = STRING("{65}")  . &ENDIF
            &IF {2} > 63 &THEN ASSIGN tt_datasource.tt_value[64]  = STRING("{66}")  . &ENDIF
        &endif

    END.

&endif

&if defined(gscommments) <> 0 &then

/*
        IF gsm_reporting_tool.reporting_tool_code = "TEXT-PRO":U
        IF gsm_reporting_tool.reporting_tool_code = "ODBC-CRY":U
        IF gsm_reporting_tool.reporting_tool_code = "MSDB-CRY":U
        IF gsm_reporting_tool.reporting_tool_code = "TEXT-MSDB":U
*/

/*---------------------------------------------------------------------------------

    TO DEFINE UP TO 5 STREAMS ...
    &scop gsrepstream 2     - # of streams to open
    {gs/inc/gsreportcr.i}
    &undefine gsrepstream

    TO OPEN A STREAM FOR OUTPUT ...
    &scop gsrepoutput OPEN  
    {gs/inc/gsreportcr.i
      1                     - stream instance
      outputfile            - output report filename tttttrrrrr.tla
    }
    &undefine gsrepoutput

    TO CLOSE A STREAM FOR OUTPUT ...
    &scop gsrepoutput CLOSE
    {gs/inc/gsreportcr.i
      1                     - stream instance
    }
    &undefine gsrepoutput

    &scop gsrepformat 2     - # of fields to export
    {gs/inc/gsreportcr.i
      1                     - stream instance
      field-1               - fields / variables (no strings / functions)
      field-2
      ...                   - UP TO A TOTAL OF 50 FIELDS
    }
    &undefine gsrepformat

DATA-TYPE
FORMAT
---------------------------------------------------------------------------------*/

&endif
