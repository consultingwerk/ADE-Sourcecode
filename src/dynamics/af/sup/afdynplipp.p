&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
  File: afdynplipp.p

  Description:  Dynamic data build plip

  Purpose:      Contains internal procedures to allow the building of dynamic queries and
                return data in a temp-table.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        5484   UserRef:    
                Date:   17/07/2000  Author:     Johan Meyer

  Update Notes: Created from Template aftemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afdynplipp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{af/sup2/afglobals.i}

&SCOPED-DEFINE MAX-BRW-FIELD 40   /* Max. supported fields in a single browse */
&SCOPED-DEFINE MAX-RECORDS 9999999999
&SCOPED-DEFINE MIN-BRW-WIDTH 320 /* The max width of a field in a browser*/

DEFINE VARIABLE lv_last_query_cnt   AS INTEGER      NO-UNDO.
DEFINE VARIABLE lv_last_query_list  AS CHARACTER    NO-UNDO.

DEFINE TEMP-TABLE tt_datatable NO-UNDO
    FIELD tt_tag AS CHARACTER 
    FIELD tt_data AS CHARACTER EXTENT {&MAX-BRW-FIELD} FORMAT "X(20)" 
    INDEX tt_main tt_tag.

DEFINE TEMP-TABLE tt_filetable NO-UNDO
    FIELD tt_db     AS CHARACTER format "X(20)"
    FIELD tt_type   AS CHARACTER format "X(20)"
    FIELD tt_tag    AS CHARACTER format "X(20)"
    FIELD tt_data   AS CHARACTER EXTENT 4 FORMAT "X(15)" 
    INDEX tt_main tt_db tt_type tt_tag .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 9.81
         WIDTH              = 43.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm/method/attribut.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mipDynamicQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mipDynamicQuery Procedure 
PROCEDURE mipDynamicQuery :
/*------------------------------------------------------------------------------
  Purpose:     mipDynamicQuery
  Parameters:  <none>
  Notes:       Builds a Dynamic Query and puts the data into a temp-table
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER ip_query_list   AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER ip_field_list   AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER ip_sort_by      AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER ip_output_rows  AS INTEGER      NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER ip_last_rowid AS ROWID    NO-UNDO.

    DEFINE VARIABLE lv_table_list           AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE lv_datab_list           AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE lv_cnt_tables           AS INTEGER      NO-UNDO.
    DEFINE VARIABLE lv_int_table            AS INTEGER      NO-UNDO.
    DEFINE VARIABLE lv_int_field            AS INTEGER      NO-UNDO.
    DEFINE VARIABLE lv_int_row              AS INTEGER      NO-UNDO.

    DEFINE VARIABLE lv_widget_pool          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE lv_value_buffer         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE lv_value_table          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE lv_value_db_table       AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE lv_value_field          AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE lh_query                AS HANDLE       NO-UNDO.
    DEFINE VARIABLE lh_buffer_table         AS HANDLE       NO-UNDO EXTENT 10.
    DEFINE VARIABLE lh_field                AS HANDLE       NO-UNDO.
    DEFINE VARIABLE lv_query_time           AS INTEGER      NO-UNDO.

    EMPTY TEMP-TABLE tt_datatable.

    IF ip_query_list <> lv_last_query_list
    THEN DO:
        ASSIGN
            lv_last_query_list = ip_query_list
            ip_last_rowid      = ?.
    END.    

    DO lv_int_table = 1 to NUM-ENTRIES(ip_query_list," "):
        IF CAN-DO("EACH,FIRST,LAST",ENTRY(lv_int_table,ip_query_list," "))
        THEN
            ASSIGN
                lv_value_table = REPLACE(ENTRY(lv_int_table + 1,ip_query_list," "),",":U,"":U)
                lv_table_list = lv_table_list + "|":U WHEN lv_table_list <> "":U
                lv_datab_list = lv_datab_list + "|":U WHEN lv_datab_list <> "":U
                lv_datab_list = lv_datab_list + lv_value_table
                lv_table_list = lv_table_list + IF NUM-ENTRIES(lv_value_table,".") > 1 THEN ENTRY(2,lv_value_table,".") ELSE lv_value_table.
    END.    

    ASSIGN
        lv_widget_pool = "local_widgets":U
        lv_cnt_tables  = NUM-ENTRIES(lv_table_list,"|":U).

/* Create the Widget pool and the Query */
    CREATE WIDGET-POOL lv_widget_pool.
    CREATE QUERY  lh_query IN WIDGET-POOL lv_widget_pool.

/* Create the buffers for the tables */
    DO lv_int_table = 1 TO lv_cnt_tables:

        ASSIGN 
            lv_value_table  = ENTRY(lv_int_table,lv_table_list,"|":U) WHEN NUM-ENTRIES(lv_table_list,"|":U) > 1
            lv_value_table  = lv_table_list WHEN NUM-ENTRIES(lv_table_list,"|":U) <= 1
            lv_value_buffer = "bb_" + REPLACE(lv_value_table,".","_")
            lv_value_db_table = ENTRY(lv_int_table,lv_datab_list,"|":U) WHEN NUM-ENTRIES(lv_datab_list,"|":U) > 1
            lv_value_db_table = lv_datab_list WHEN NUM-ENTRIES(lv_datab_list,"|":U) <= 1
            lv_value_db_table = SUBSTRING(lv_value_db_table,INDEX(lv_value_db_table,"_":U) + 1) WHEN lv_value_db_table BEGINS "lb":U.

        CREATE BUFFER lh_buffer_table[lv_int_table]
               FOR TABLE      lv_value_db_table
               BUFFER-NAME    lv_value_buffer
               IN WIDGET-POOL lv_widget_pool.

        IF NOT lh_query:ADD-BUFFER(lh_buffer_table[lv_int_table])
        THEN DO:
            DELETE WIDGET-POOL lv_widget_pool.
            RETURN "Error setting buffers for dynamic query".
        END.

        /*Parse the query list - A table name can be followed by a " ", ".", ","or ")" - as in recid(_file), */
        ASSIGN
            ip_query_list = ip_query_list + " ":U
            ip_query_list = REPLACE(ip_query_list, lv_value_table + " ":U, lv_value_buffer + " ":U)
            ip_sort_by    = REPLACE(ip_sort_by, lv_value_table + " ":U, lv_value_buffer + " ":U)
            ip_query_list = REPLACE(ip_query_list, lv_value_table + ".":U, lv_value_buffer + ".":U)
            ip_sort_by    = REPLACE(ip_sort_by, lv_value_table + ".":U, lv_value_buffer + ".":U)
            ip_query_list = REPLACE(ip_query_list, lv_value_table + ",":U, lv_value_buffer + ",":U)
            ip_sort_by    = REPLACE(ip_sort_by, lv_value_table + ",":U, lv_value_buffer + ",":U)
            ip_query_list = REPLACE(ip_query_list, lv_value_table + ")":U, lv_value_buffer + ")":U)
            ip_sort_by    = REPLACE(ip_sort_by, lv_value_table + ")":U, lv_value_buffer + ")":U)
            ip_query_list = REPLACE(ip_query_list, "bb_bb_":U, "bb_":U)
            ip_sort_by    = REPLACE(ip_sort_by, "bb_bb_":U, "bb_":U).

    END.

/* Prepare and Open the Query */
    IF NOT lh_query:QUERY-PREPARE(ip_query_list + " ":U + ip_sort_by + " INDEXED-REPOSITION")
    THEN DO:
        DELETE WIDGET-POOL lv_widget_pool.
        RETURN "Error preparing dynamic query".
    END.
    IF NOT lh_query:QUERY-OPEN
    THEN DO:
        DELETE WIDGET-POOL lv_widget_pool.
        RETURN "Error opening dynamic query".
    END.

    /* Retrieve the Field Attributes */
    IF ip_last_rowid = ? THEN DO lv_int_field = 1 TO MIN(NUM-ENTRIES(ip_field_list,"|":U),{&MAX-BRW-FIELD}):

        IF NUM-ENTRIES(ENTRY(lv_int_field,ip_field_list,"|":U),".":U) <> 2
        THEN
            RETURN "Fields must be specified in the form TABLE.FIELD|TABLE.FIELD".

        ASSIGN
            lv_value_table = ENTRY(1,ENTRY(lv_int_field,ip_field_list,"|":U),".":U)
            lv_value_field = ENTRY(2,ENTRY(lv_int_field,ip_field_list,"|":U),".":U)
            lv_int_table   = LOOKUP(lv_value_table,lv_table_list,"|":U)
            lh_field       = lh_buffer_table[lv_int_table]:BUFFER-FIELD(lv_value_field).

        FIND FIRST tt_datatable
            WHERE tt_datatable.tt_tag = "FNAME":U
            NO-ERROR.
        IF NOT AVAILABLE tt_datatable
        THEN DO:
            CREATE tt_datatable.
            ASSIGN tt_datatable.tt_tag = "FNAME":U.
        END.
        ASSIGN tt_datatable.tt_data[lv_int_field] = lh_field:NAME.

        FIND FIRST tt_datatable
            WHERE tt_datatable.tt_tag = "FDTYPE":U
            NO-ERROR.
        IF NOT AVAILABLE tt_datatable
        THEN DO:
            CREATE tt_datatable.
            ASSIGN tt_datatable.tt_tag = "FDTYPE":U.
        END.
        ASSIGN tt_datatable.tt_data[lv_int_field] = lh_field:DATA-TYPE.

        FIND FIRST tt_datatable
            WHERE tt_datatable.tt_tag = "FFORMAT":U
            NO-ERROR.
        IF NOT AVAILABLE tt_datatable
        THEN DO:
            CREATE tt_datatable.
            ASSIGN tt_datatable.tt_tag = "FFORMAT":U.
        END.
        ASSIGN tt_datatable.tt_data[lv_int_field] = lh_field:FORMAT.

        FIND FIRST tt_datatable
            WHERE tt_datatable.tt_tag = "FWCHARS":U
            NO-ERROR.
        IF NOT AVAILABLE tt_datatable
        THEN DO:
            CREATE tt_datatable.
            ASSIGN tt_datatable.tt_tag = "FWCHARS":U.
        END.
        ASSIGN tt_datatable.tt_data[lv_int_field] = STRING(MAX(LENGTH(lh_field:LABEL),lh_field:WIDTH-CHARS)).

        FIND FIRST tt_datatable
            WHERE tt_datatable.tt_tag = "FLABEL":U
            NO-ERROR.
        IF NOT AVAILABLE tt_datatable
        THEN DO:
            CREATE tt_datatable.
            ASSIGN tt_datatable.tt_tag = "FLABEL":U.
        END.
        ASSIGN tt_datatable.tt_data[lv_int_field] = lh_field:COLUMN-LABEL.
        IF     tt_datatable.tt_data[lv_int_field] = "":U
        THEN
        ASSIGN tt_datatable.tt_data[lv_int_field] = lh_field:LABEL.
        IF     tt_datatable.tt_data[lv_int_field] = "":U
        THEN
        ASSIGN tt_datatable.tt_data[lv_int_field] = lh_field:NAME
               tt_datatable.tt_data[lv_int_field] = REPLACE(tt_datatable.tt_data[lv_int_field], "_":U , " ":U).
        ASSIGN tt_datatable.tt_data[lv_int_field] = REPLACE(tt_datatable.tt_data[lv_int_field], "!":U , " ":U).
    END.

/* Reposition the query if limited rows */

    IF ip_last_rowid <> ?
    THEN DO:
        IF NOT lh_query:REPOSITION-TO-ROWID(ip_last_rowid)
        THEN DO:
            DELETE WIDGET-POOL lv_widget_pool.
            RETURN "Error re-positioning dynamic query".
        END.
        /*The first get-next gets the repositioned record into the record buffer ...*/
        IF NOT lh_query:GET-NEXT THEN LEAVE.
        /*... and this one gets the next record*/
        IF NOT lh_query:GET-NEXT THEN LEAVE.
    END.
    ELSE DO:
        IF NOT lh_query:GET-FIRST
        THEN DO:
            DELETE WIDGET-POOL lv_widget_pool.
            RETURN "Error re-positioning dynamic query".
        END.
        ASSIGN
            lv_last_query_cnt  = 0.
    END.

    /* Retrieve the Field Values */
    DO lv_int_row = 1 TO (IF ip_output_rows = ? THEN {&MAX-RECORDS} ELSE ip_output_rows):

        CREATE tt_datatable.
        DO lv_int_field = 1 TO MIN(NUM-ENTRIES(ip_field_list,"|":U),{&MAX-BRW-FIELD}):
            ASSIGN
                lv_value_table = ENTRY(1,ENTRY(lv_int_field,ip_field_list,"|":U),".":U)
                lv_value_field = ENTRY(2,ENTRY(lv_int_field,ip_field_list,"|":U),".":U)
                lv_int_table   = LOOKUP(lv_value_table,lv_table_list,"|":U)
                lh_field       = lh_buffer_table[lv_int_table]:BUFFER-FIELD(lv_value_field)
                tt_datatable.tt_data[lv_int_field] = IF lh_field:extent = 0 
                                                     THEN TRIM(lh_field:STRING-VALUE)
                                                     ELSE "[":U + STRING(lh_field:EXTENT) + "] EXTENT":U.
        END.
        ASSIGN
            lv_last_query_cnt   = lv_last_query_cnt + 1
            tt_datatable.tt_tag = "FVALUE":U + STRING(lv_last_query_cnt,"{&MAX-RECORDS}":U)
            ip_last_rowid = lh_buffer_table[1]:ROWID.

        IF NOT lh_query:GET-NEXT THEN LEAVE.
    END.

/* Release the Buffers for the tables */
    DO lv_int_table = 1 TO lv_cnt_tables:

        lh_buffer_table[lv_int_table]:BUFFER-RELEASE.
    END.

/* Close the Query */
    lh_query:QUERY-CLOSE.

/* Delete the Widget pool */
    DELETE WIDGET-POOL lv_widget_pool.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mipFollowLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mipFollowLinks Procedure 
PROCEDURE mipFollowLinks :
/*------------------------------------------------------------------------------
  Purpose:     mipFollowLinks
  Parameters:  <none>
  Notes:       Follows the joins to a table and assigns the fields to display
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER ip_method AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER ip_query_list AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER ip_field_list AS CHARACTER NO-UNDO.

DEFINE VARIABLE lv_value_table  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_lookup_list  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_found        AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lv_cnt          AS INTEGER      NO-UNDO.

DEFINE BUFFER lb_file   FOR tt_filetable.
DEFINE BUFFER lb_field  FOR tt_filetable.
DEFINE BUFFER lb_file2  FOR tt_filetable.
DEFINE BUFFER lb_field2 FOR tt_filetable.

    EMPTY TEMP-TABLE tt_filetable.

    ASSIGN
        lv_value_table    = ENTRY(LOOKUP("EACH",ip_query_list," ") + 1,ip_query_list," ")
        lv_value_table    = IF NUM-ENTRIES(lv_value_table,".") > 1 THEN ENTRY(2,lv_value_table,".") ELSE lv_value_table.

    /*Build temp-table for each _file record in all connected database*/
    /* tt_type="_file", tt_tag=_file-name */
    /* tt_data[1]=_file-name, tt_data[2]=RECID(_file), tt_data[3]=ldbname */
    DO lv_cnt = 1 to NUM-DBS:
        RUN mipGetLinkData IN THIS-PROCEDURE("FOR EACH|" + LDBNAME(lv_cnt) + "|_file| WHERE _file._tbl-type = 'T' |_file-name":U).
    END.    

    /*Find the temp-table record for the first table in the query*/
    /*tt_type = _file, tt_tag = file-name*/
    FIND FIRST lb_file NO-LOCK
        WHERE lb_file.tt_type = "_file":U
        AND   lb_file.tt_tag  = lv_value_table NO-ERROR.
    IF AVAILABLE lb_file
    THEN DO:

        /*Build temp-table for each _field record of the first table in the query in all connected database*/
        /* tt_type = "_field", tt_tag = _file-recid, tt_data[1]=_file-recid */
        /* tt_data[2]=_order, tt_data[3]=_field-name, tt_data[4]=RECID(_file), tt_data[5]=ldbname */

        DO lv_cnt = 1 to NUM-DBS:
            RUN mipGetLinkData IN THIS-PROCEDURE("FOR EACH|" + LDBNAME(lv_cnt) + "|_field|WHERE _file-recid =" + lb_file.tt_data[2] + "|_file-recid,_order,_field-name":U).
        END.    

        /*Fix temp-table to sort by _order properly*/
        FOR EACH lb_field
            WHERE lb_field.tt_type = "_field":U:
            ASSIGN
                lb_field.tt_data[2] = STRING(INTEGER(lb_field.tt_data[2]),"99999").
        END.

        /*for each temp-table _field record of the first table in the query*/
        /*lb_field.tt_tag = _file-recid  lb_file.tt_data[2] = recid(_file)*/
        FOR EACH lb_field NO-LOCK
            WHERE lb_field.tt_db   = lb_file.tt_db
            AND   lb_field.tt_type = "_field":U
            AND   lb_field.tt_tag  = lb_file.tt_data[2]
            BY lb_field.tt_db 
            BY lb_field.tt_type 
            BY lb_field.tt_data[2]:

            /*  If the _field-name does not end in _obj then build the field list of all fields on the first table */
            IF (INDEX(lb_field.tt_data[3],"_obj") = 0 AND ip_method = "FOLLOW":U) OR ip_method = "NORMAL":U
            THEN IF INDEX(ip_field_list,lb_file.tt_tag + ".":U + lb_field.tt_data[3]) = 0 
                THEN
                    ASSIGN
                        ip_field_list = ip_field_list + "|":U + lb_file.tt_tag + ".":U + lb_field.tt_data[3].

            /*  If the _field-name does end in _obj */
            IF INDEX(lb_field.tt_data[3],"_obj") <> 0 AND CAN-DO("FOLLOW*":U,ip_method)
            THEN OBJ-BLOCK: DO:
                /*If it is this file's obj, then just add it to field list*/

                IF SUBSTRING(lb_file.tt_tag,INDEX(lb_file.tt_tag,"_") + 1) = REPLACE(lb_field.tt_data[3],"_obj":U,"":U)
                THEN DO:
                    ASSIGN
                        ip_field_list = ip_field_list + "|":U + lb_file.tt_tag + ".":U + lb_field.tt_data[3].
                    LEAVE OBJ-BLOCK.
                END.

                /*Find temp-table _file record that matches the field-name */
                FIND FIRST lb_file2 NO-LOCK
                    WHERE SUBSTRING(lb_file2.tt_tag,INDEX(lb_file2.tt_tag,"_") + 1) = REPLACE(lb_field.tt_data[3],"_obj":U,"":U)
                    NO-ERROR.

                ASSIGN
                    lv_lookup_list = "company_|current".
                /*Find temp-table that matches the lookup-list entries as prefixes if not found yet*/
                IF NOT AVAILABLE lb_file2
                THEN DO lv_cnt = 1 TO NUM-ENTRIES(lv_lookup_list,"|":U):
                    IF INDEX(lb_field.tt_data[3],ENTRY(lv_cnt,lv_lookup_list,"|":U)) <> 0
                    THEN
                        FIND FIRST lb_file2 NO-LOCK
                            WHERE SUBSTRING(lb_file2.tt_tag,INDEX(lb_file2.tt_tag,"_") + 1) = REPLACE(REPLACE(lb_field.tt_data[3],"_obj":U,"":U),ENTRY(lv_cnt,lv_lookup_list,"|":U),"":U)
                            NO-ERROR.
                END.

                IF AVAILABLE lb_file2 AND lb_file2.tt_tag <> lb_file.tt_tag
                THEN DO:
                    ASSIGN
                        lv_found       = NO
                        lv_lookup_list = "*reference,*code,*short*|*tla*,*desc*,*name*".

                    DO lv_cnt = 1 to NUM-DBS:
                        RUN mipGetLinkData IN THIS-PROCEDURE("FOR EACH|" + LDBNAME(lv_cnt) + "|_field|WHERE _file-recid =" + lb_file2.tt_data[2] + "|_file-recid,_order,_field-name":U).
                    END.    

                    DO lv_cnt = 1 to NUM-ENTRIES(lv_lookup_list,"|":U):
                        IF NOT lv_found THEN FOR EACH lb_field2 NO-LOCK
                            WHERE lb_field2.tt_db   = lb_file2.tt_db
                            AND   lb_field2.tt_type = "_field":U
                            AND   lb_field2.tt_tag  = lb_file2.tt_data[2]
                            BY lb_field2.tt_db
                            BY lb_field2.tt_type 
                            BY lb_field2.tt_data[2]:
                            IF NOT lv_found AND CAN-DO(ENTRY(lv_cnt,lv_lookup_list,"|":U),lb_field2.tt_data[3]) 
                            THEN DO:
                                /*Add the related table find to the query_list. Note the related _file-name is used */
                                /*to derive the _field-name in the where clause because of the field names may not be the same in */
                                ASSIGN
                                    ip_query_list = ip_query_list + ", FIRST ":U + lb_file2.tt_tag + " OUTER-JOIN ":U
                                    ip_query_list = ip_query_list + " WHERE ":U + lb_file2.tt_tag + ".":U + SUBSTRING(lb_file2.tt_tag,INDEX(lb_file.tt_tag,"_":U) + 1) + "_obj" + " = ":U + lb_file.tt_tag + ".":U + lb_field.tt_data[3] 
                                    ip_field_list = ip_field_list + "|":U + lb_file2.tt_tag + ".":U + lb_field2.tt_data[3]
                                    lv_found      = YES.
                                LEAVE OBJ-BLOCK.
                            END.    
                        END.
                    END.
                END.
            END.
        END.    
    END.    

    IF SUBSTRING(ip_field_list,1,1) = "|":U
    THEN
        ip_field_list = SUBSTRING(ip_field_list,2).

    EMPTY TEMP-TABLE tt_filetable.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mipFormatBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mipFormatBrowse Procedure 
PROCEDURE mipFormatBrowse :
/*------------------------------------------------------------------------------
  Purpose:     mipFormatBrowse
  Parameters:  <none>
  Notes:       Applies the database formatting to the browse specified
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER lh_browse AS HANDLE  NO-UNDO.

    DEFINE VARIABLE lh_column AS HANDLE  NO-UNDO.
    DEFINE VARIABLE lv_loop   AS INTEGER NO-UNDO.

    ASSIGN
         lh_column = lh_browse:FIRST-COLUMN
         NO-ERROR.

    DO lv_loop = 1 TO {&MAX-BRW-FIELD}:

        FIND tt_datatable NO-LOCK
            WHERE tt_datatable.tt_tag = "FWCHARS":U NO-ERROR.

        IF AVAILABLE tt_datatable 
        THEN 
            lh_column:WIDTH-CHARS = MIN(MAX(INTEGER(tt_datatable.tt_data[lv_loop]),lh_column:WIDTH-CHARS),{&MIN-BRW-WIDTH}).

        FIND tt_datatable NO-LOCK
            WHERE tt_datatable.tt_tag = "FLABEL":U NO-ERROR.
        IF AVAILABLE tt_datatable 
        THEN 
            lh_column:LABEL = tt_datatable.tt_data[lv_loop].

        ASSIGN
            lh_column = lh_column:NEXT-COLUMN NO-ERROR.

        IF NOT VALID-HANDLE(lh_column) THEN LEAVE.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mipGetDataTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mipGetDataTable Procedure 
PROCEDURE mipGetDataTable :
/*------------------------------------------------------------------------------
  Purpose:     mipGetDataTable
  Parameters:  <none>
  Notes:       Returns the temp-table to the calling procedure
               This allows the manipulation of the temp table in this plip 
               without passing the temp-table in and out repeatedly. The 
               temp-table only exists here, and is passed out using this procedure 
               only once all formatting etc is done.
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER TABLE FOR tt_datatable.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mipGetLinkData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mipGetLinkData Procedure 
PROCEDURE mipGetLinkData :
/*------------------------------------------------------------------------------
  Purpose:     Populates the tt_filetable table with data from the _file and _field
               tables.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER ip_query AS CHARACTER.

    DEFINE VARIABLE lh_query                AS HANDLE       NO-UNDO.
    DEFINE VARIABLE lh_field                AS HANDLE       NO-UNDO.
    DEFINE VARIABLE lh_buffer_table         AS HANDLE       NO-UNDO.
    DEFINE VARIABLE lv_field_cnt            AS INTEGER      NO-UNDO.
    DEFINE VARIABLE lv_widget_pool          AS CHARACTER    NO-UNDO.

    ASSIGN
        lv_widget_pool = ENTRY(3,ip_query,"|":U).

    CREATE WIDGET-POOL lv_widget_pool.
    CREATE QUERY  lh_query IN WIDGET-POOL lv_widget_pool.
    CREATE BUFFER lh_buffer_table
           FOR TABLE      ENTRY(2,ip_query,"|":U) + ".":U + ENTRY(3,ip_query,"|":U)
           BUFFER-NAME    ENTRY(3,ip_query,"|":U)
           IN WIDGET-POOL lv_widget_pool.

    lh_query:ADD-BUFFER(lh_buffer_table).
    lh_query:QUERY-PREPARE(ENTRY(1,ip_query,"|":U) + " ":U + ENTRY(2,ip_query,"|":U) + ".":U + ENTRY(3,ip_query,"|":U) + " ":U + ENTRY(4,ip_query,"|":U)).
    lh_query:QUERY-OPEN.

    REPEAT:
        IF NOT lh_query:GET-NEXT THEN LEAVE.
        CREATE
            tt_filetable.

        DO lv_field_cnt = 1 TO NUM-ENTRIES(ENTRY(5,ip_query,"|":U),",":U):
            ASSIGN
                lh_field = lh_buffer_table:BUFFER-FIELD(ENTRY(lv_field_cnt,ENTRY(5,ip_query,"|":U),",":U))
                tt_filetable.tt_tag  = TRIM(lh_field:STRING-VALUE) WHEN lv_field_cnt = 1
                tt_filetable.tt_data[lv_field_cnt] = TRIM(lh_field:STRING-VALUE).

        END.

        ASSIGN    
            tt_filetable.tt_db   = lh_buffer_table:DBNAME
            tt_filetable.tt_type = lh_buffer_table:TABLE
            tt_filetable.tt_data[lv_field_cnt] = TRIM(STRING(lh_buffer_table:RECID)).

    END.

    lh_query:QUERY-CLOSE.
    DELETE WIDGET-POOL lv_widget_pool.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mipGetLinkTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mipGetLinkTable Procedure 
PROCEDURE mipGetLinkTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER ip_query AS CHARACTER.

    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt_filetable.

    RUN mipGetLinkData IN THIS-PROCEDURE(ip_query).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Dynamic Data PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipsetu.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

