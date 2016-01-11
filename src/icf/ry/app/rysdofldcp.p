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
  File: rysdofldcp.p

  Description:  SDO Field SmartObject Creation Procedure

  Purpose:      SDO Field SmartObject Creation Procedure. This procedure creates
                SmartObject records and assigns attribute values for these smartObjects, based
                on an SDO

  Parameters:   INPUT pcSdoName

  History:
  --------
  (v:010000)    Task:   101000006   UserRef:    
                Date:   08/14/2001  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcSdoName            AS CHARACTER                NO-UNDO.

DEFINE VARIABLE lCanSearch          AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE lDefaultValues      AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE lIsSdo              AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE cLine               AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cFields             AS CHARACTER      EXTENT 20         NO-UNDO.
DEFINE VARIABLE cDelimiter          AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cFieldOrder         AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cDataSourceName     AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cSchemaDetail       AS CHARACTER                        NO-UNDO.

DEFINE BUFFER rycso     FOR ryc_smartObject.

DEFINE TEMP-TABLE ttField       NO-UNDO
    FIELD tFieldName                AS CHARACTER        INITIAL ?
    FIELD tTableName                AS CHARACTER        INITIAL ?
    FIELD tDataBaseName             AS CHARACTER        INITIAL ?
    FIELD tDataSource               AS CHARACTER        INITIAL ?
    FIELD tLabel                    AS CHARACTER        INITIAL ?
    FIELD tFormat                   AS CHARACTER        INITIAL ?
    FIELD tBgColor                  AS INTEGER          INITIAL ?
    FIELD tFgColor                  AS INTEGER          INITIAL ?
    FIELD tFont                     AS INTEGER          INITIAL ?
    FIELD tLabelFgColor             AS INTEGER          INITIAL ?
    FIELD tLabelBgColor             AS INTEGER          INITIAL ?
    FIELD tLabelFont                AS INTEGER          INITIAL ?
    FIELD tHelp                     AS CHARACTER        INITIAL ?
    FIELD tMandatory                AS LOGICAL          INITIAL ?
    FIELD tEnabled                  AS LOGICAL          INITIAL ?
    FIELD tWidth                    AS DECIMAL          INITIAL ?
    FIELD tInheritValidation        AS LOGICAL          INITIAL ?
    FIELD tCalculatedField          AS LOGICAL          INITIAL ?
    FIELD tOrder                    AS INTEGER          INITIAL ?
    FIELD tDataType                 AS CHARACTER        INITIAL ?
    .
DEFINE STREAM sSdo.

/* Just in case the Dynamic Object Maintenance Tool has already been run in the session.
 * That program will need to be shut down and restarted for its trigger to be reset.    */
ON FIND OF ryc_attribute REVERT.

EMPTY TEMP-TABLE ttField.

IF SEARCH(pcSdoName) = ? THEN
    RETURN ERROR {af/sup2/aferrortxt.i 'AF' '1' '?' '?' '"SDO"' "'SDO: ' + pcSdoName"  }.

ASSIGN lCanSearch          = NO
       lIsSdo              = NO
       cDataSourceName     = REPLACE(pcSdoName, "~\":U, "/":U)
       cDataSourceName     = SUBSTRING(cDataSourceName, R-INDEX(cDataSourceName, "/":U) + 1)       
       FILE-INFO:FILE-NAME = pcSdoName
       .

INPUT STREAM sSdo FROM VALUE(FILE-INFO:FULL-PATHNAME).
IMPORT-FILE:
REPEAT:
    IMPORT STREAM sSdo UNFORMATTED cLine.

    IF NOT lIsSdo                                                     AND
       cLine BEGINS "&Scoped-define PROCEDURE-TYPE SmartDataObject":U THEN
        ASSIGN lIsSdo = YES.

    /* Is not an SDO then loop to next line. */
    IF NOT lIsSdo THEN
        NEXT IMPORT-FILE.

    /* Only start looking from here */
    IF cLine BEGINS "&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main":U THEN
        ASSIGN lCanSearch = YES.
    IF lCanSearch                       AND
       cLine BEGINS "&ANALYZE-RESUME":U THEN
        ASSIGN lCanSearch = NO.

    IF NOT lCanSearch THEN
        NEXT IMPORT-FILE.

    /* Field List */
    IF TRIM(cLine) BEGINS "_FldNameList":U  THEN
    DO:
        ASSIGN cFields = ?.

        CREATE ttField.
        /* First Line: Has the field number, and whether this is a calculated field, as well as the name.
         * (1) Calculated field: 
         *     _FldNameList[n]   > "_<CALC>"
         * (2) Standard field:
         *     _FldNameList[n]   > DBNAME.TableName.FieldName
         */

        ASSIGN cDelimiter     = ( IF LOOKUP("=":U, cLine) GT 0 THEN "=":U ELSE ">":U)
               lDefaultValues = ( cDelimiter EQ "=":U)
               cFieldOrder    = SUBSTRING(cLine, INDEX(cLine, "[":U) + 1)
               .
        ASSIGN cFieldOrder = SUBSTRING(cFieldOrder, 1, INDEX(cFieldOrder, "]":U) - 1).

        ASSIGN ttField.tCalculatedField = (ENTRY(2, cLine, cDelimiter) EQ '"<CALC>"':U)
               ttField.tDataSource      = cDataSourceName
               ttField.tOrder           = INTEGER(cFieldOrder)
               NO-ERROR.

        IF NOT ttField.tCalculatedField THEN
        CASE NUM-ENTRIES(ENTRY(2, cLine, cDelimiter), ".":U):
            WHEN 1 THEN /* Field-name */
                ASSIGN ttField.tFieldName = TRIM(ENTRY(1, ENTRY(2, cLine, cDelimiter), ".":U)).
            WHEN 2 THEN /* Table-name.Field-name */
                ASSIGN ttField.tFieldName = TRIM(ENTRY(2, ENTRY(2, cLine, cDelimiter), ".":U))
                       ttField.tTableName = TRIM(ENTRY(1, ENTRY(2, cLine, cDelimiter), ".":U))
                       .
            WHEN 3 THEN /* Db-name.Table-name.Field-name*/
                ASSIGN ttField.tFieldName    = TRIM(ENTRY(3, ENTRY(2, cLine, cDelimiter), ".":U))
                       ttField.tTableName    = TRIM(ENTRY(2, ENTRY(2, cLine, cDelimiter), ".":U))
                       ttField.tDataBaseName = TRIM(ENTRY(1, ENTRY(2, cLine, cDelimiter), ".":U))
                       .
        END CASE.   /* entries in the field name */

        /* Provide backward compatability */
        IF LOOKUP(ttField.tDataBaseName, "ASDB,AFDB,RYDB":U) GT 0 THEN
            ASSIGN ttField.tDataBaseName = "ICFDB":U.

        /* If these are the default values, all of the values are inherited from the 
         * database metaschema, where possible                                       */
        IF NOT lDefaultValues THEN
        DO:
            /* Second line contains the detail of the field. The line format is from adeshar/_gen4gl.p.
             * _NAME _DISP-NAME output-label output-format _DATA-TYPE _BGCOLOR
             * _FGCOLOR _FONT _LABEL-BGCOLOR _LABEL-FGCOLOR 
             * _LABEL-FONT _ENABLED output-help
             * _MANDATORY _WIDTH _INHERIT-VALIDATION
             */
            ASSIGN cFields = ?.
            IMPORT STREAM sSdo
                cFields[1]      cFields[2]      cFields[3]      cFields[4]
                cFields[5]      cFields[6]      cFields[7]      cFields[8]
                cFields[9]      cFields[10]     cFields[11]     cFields[12]
                cFields[13]     cFields[14]     cFields[15]     cFields[16]
                NO-ERROR.

            IF ttField.tCalculatedField THEN
                ASSIGN ttField.tFieldName = cFields[2]. /* _BC._DISP-NAME */

            ASSIGN ttField.tLabel    = cFields[3]
                   ttField.tFormat   = cFields[4]
                   ttField.tDataType = cFields[5]
                   .
            ASSIGN ttField.tBgColor      = INTEGER(cFields[6]) NO-ERROR.
            ASSIGN ttField.tFgColor      = INTEGER(cFields[7]) NO-ERROR.
            ASSIGN ttField.tFont         = INTEGER(cFields[8]) NO-ERROR.
            ASSIGN ttField.tLabelBgColor = INTEGER(cFields[9]) NO-ERROR.
            ASSIGN ttField.tLabelFgColor = INTEGER(cFields[10]) NO-ERROR.
            ASSIGN ttField.tLabelFont    = INTEGER(cFields[11]) NO-ERROR.

            ASSIGN ttField.tEnabled   = (IF cFields[12] NE ? THEN (cFields[12] EQ "YES":U) ELSE ?)
                   ttField.tHelp      = cFields[13]
                   ttField.tMandatory = (IF cFields[14] NE ? THEN (cFields[14] EQ "YES":U) ELSE ?)
                   .
            ASSIGN ttField.tWidth = DECIMAL(cFields[15]) NO-ERROR.

            ASSIGN ttField.tInheritValidation = (IF cFields[16] NE ? THEN (cFields[16] EQ "YES":U) ELSE ?).
        END.    /* not the default values */
    END.    /* Field List */
END.    /* IMPORT-FILE: */

INPUT STREAM sSdo CLOSE.

IF NOT lIsSdo THEN
    RETURN ERROR (pcSdoName + " is not an ADM-generated SDO.").
ELSE
DO:
    /* ?? Make sure the a SmartObject record exists for the SDO */
    FIND FIRST gsc_object_type WHERE
               gsc_object_type.object_type_code = "DataField":U
               NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gsc_object_type THEN
    DO:
        CREATE gsc_object_type.
        ASSIGN gsc_object_type.object_type_code        = "DataField":U
               gsc_object_type.object_type_description = "SmartDataObject Field"
               NO-ERROR.
        IF RETURN-VALUE NE "":U OR ERROR-STATUS:ERROR THEN RETURN ERROR RETURN-VALUE.
    END.    /* n/a object type */

    FIND FIRST rycso WHERE
               rycso.object_filename = cDataSourceName
               NO-LOCK NO-ERROR.
    IF NOT AVAILABLE rycso THEN
        RETURN ERROR {af/sup2/aferrortxt.i 'AF' '5' 'ryc_smartObject' '' '"smartObject record"' "'SDO Name: ' + cDataSourceName" }.

    FOR EACH ttField
             NO-LOCK:
        /* Get default values from metaschema; only for 
         * non-calculated fields.
         * We do this for the following fields:
         *  tLabel
         *  tFormat
         *  tHelp
         *  tMandatory
         *  tDataType   */
        IF ( ttField.tLabel = ? OR ttField.tFormat = ? OR ttField.tHelp = ? OR
             ttField.tMandatory = ? OR ttField.tDataType = ? ) THEN
        DO:
            RUN getSchemaInfo ( INPUT  ttField.tFieldName,
                                INPUT  ttField.tTableName,
                                INPUT  ttField.tDataBaseName,
                                OUTPUT cSchemaDetail    ).
            IF ttField.tLabel EQ ? THEN
                ASSIGN ttField.tLabel = ENTRY(LOOKUP("LABEL":U, cSchemaDetail, CHR(3)) + 1, cSchemaDetail, CHR(3)).
            IF ttField.tFormat EQ ? THEN
                ASSIGN ttField.tFormat = ENTRY(LOOKUP("FORMAT":U, cSchemaDetail, CHR(3)) + 1, cSchemaDetail, CHR(3)).
            IF ttField.tHelp EQ ? THEN
                ASSIGN ttField.tHelp = ENTRY(LOOKUP("HELP":U, cSchemaDetail, CHR(3)) + 1, cSchemaDetail, CHR(3)).
            IF ttField.tDataType EQ ? THEN
                ASSIGN ttField.tDataType = ENTRY(LOOKUP("DATA-TYPE":U, cSchemaDetail, CHR(3)) + 1, cSchemaDetail, CHR(3)).
            IF ttField.tMandatory EQ ? THEN
                ASSIGN ttField.tMandatory = ( ENTRY(LOOKUP("MANDATORY":U, cSchemaDetail, CHR(3)) + 1, cSchemaDetail, CHR(3)) EQ "YES":U).
        END.    /* we need to go to the metaschema */

        /* Create SmartObject record for the SDF */
        FIND FIRST ryc_smartObject WHERE
                   ryc_smartObject.object_filename = ttField.tTableName + ".":U + ttField.tFieldName
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_smartObject THEN
        DO:
            CREATE gsc_object NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

            ASSIGN gsc_object.object_type_obj         = gsc_object_type.object_type_obj
                   gsc_object.product_module_obj      = rycso.product_module_obj
                   gsc_object.object_description      = "SDO - " + cDataSourceName + " Field - " + ttField.tTableName + ".":U + ttField.tFieldName
                   gsc_object.object_filename         = ttField.tTableName + ".":U + ttField.tFieldName
                   gsc_object.object_path             = "":U
                   gsc_object.runnable_from_menu      = NO
                   gsc_object.disabled                = NO
                   gsc_object.run_persistent          = NO
                   gsc_object.run_when                = "ANY":U
                   gsc_object.security_object_obj     = gsc_object.object_obj
                   gsc_object.container_object        = NO
                   gsc_object.physical_object_obj     = 0
                   gsc_object.logical_object          = NO
                   gsc_object.generic_object          = NO
                   gsc_object.required_db_list        = "":U
                   NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR ERROR-STATUS:GET-MESSAGE(1).

            VALIDATE gsc_object NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

            CREATE ryc_smartObject NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

            ASSIGN ryc_smartObject.layout_obj             = 0
                   ryc_smartObject.object_type_obj        = gsc_object_type.object_type_obj
                   ryc_smartObject.object_obj             = gsc_object.object_obj
                   ryc_smartObject.object_filename        = ttField.tTableName + ".":U + ttField.tFieldName
                   ryc_smartObject.product_module_obj     = rycso.product_module_obj
                   ryc_smartObject.static_object          = NO
                   ryc_smartObject.custom_super_procedure = "":U
                   ryc_smartObject.system_owned           = NO
                   ryc_smartObject.shutdown_message_text  = ""
                   ryc_smartObject.sdo_smartobject_obj    = rycso.smartobject_obj
                   ryc_smartObject.template_smartobject   = NO
                   NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR ERROR-STATUS:GET-MESSAGE(1).

            VALIDATE ryc_smartObject NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* n/a smartobject */

        /* Create attributes */
        /* Field Name */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "FieldName":U,
                                    INPUT ttField.tFieldName,
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Table Name */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "TableName":U,
                                    INPUT ttField.tTableName,
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* DB Name */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "DataBaseName":U,
                                    INPUT ttField.tDataBaseName,
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Data Source */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "DataSource":U,
                                    INPUT ttField.tDataSource,
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Label */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "Label":U,
                                    INPUT ttField.tLabel,
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Format */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "Format":U,
                                    INPUT ttField.tFormat,
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Font */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "Font":U,
                                    INPUT STRING(ttField.tFont),
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Help */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "Help":U,
                                    INPUT ttField.tHelp,
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Mandatory */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "Mandatory":U,
                                    INPUT STRING(ttField.tMandatory),
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Enabled */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "Enabled":U,
                                    INPUT STRING(ttField.tEnabled),
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "EnabledField":U,
                                    INPUT STRING(ttField.tEnabled),
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Width */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "WIDTH-CHARS":U,
                                    INPUT STRING(ttField.tWidth),
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Field Order */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "FieldOrder":U,
                                    INPUT STRING(ttField.tOrder),
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Data Type */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "DATA-TYPE":U,
                                    INPUT ttField.tDataType,
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* BG Color */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "BGCOLOR":U,
                                    INPUT STRING(ttField.tBgColor),
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* FG Color */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "FGCOLOR":U,
                                    INPUT STRING(ttField.tFgColor),
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Label Font */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "LabelFont":U,
                                    INPUT STRING(ttField.tLabelFont),
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Label BG Color */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "LabelBgColor":U,
                                    INPUT STRING(ttField.tLabelBgColor),
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Label FG Color */
        RUN CreateAttributeValues ( INPUT gsc_object_type.object_type_obj,
                                    INPUT ryc_smartObject.smartObject_obj,
                                    INPUT "LabelFgColor":U,
                                    INPUT STRING(ttField.tLabelFgColor),
                                    INPUT "WidgetAttributes" ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* each field */
END.    /* this is an sdo */

PROCEDURE getSchemaInfo:
    DEFINE INPUT  PARAMETER pcFieldName         AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcTableName         AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcDatabaseName      AS CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcSchemaDetail      AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE hBuffer         AS HANDLE                           NO-UNDO.
    DEFINE VARIABLE hField          AS HANDLE                           NO-UNDO.
    DEFINE VARIABLE hBufferFile     AS HANDLE                           NO-UNDO.
    DEFINE VARIABLE hBufferField    AS HANDLE                           NO-UNDO.
    DEFINE VARIABLE hTable          AS HANDLE                           NO-UNDO.    
    DEFINE VARIABLE hQuery          AS HANDLE                           NO-UNDO.
    DEFINE VARIABLE cDbList         AS CHARACTER                        NO-UNDO.
    DEFINE VARIABLE iLoop           AS INTEGER                          NO-UNDO.

    IF pcFieldName EQ "":U THEN
        RETURN.

    /* Determine the */
    IF pcTableName EQ "":U THEN
    DO:
        IF pcDatabaseName EQ "":U THEN
        DO iLoop = 1 TO NUM-DBS:
            ASSIGN cDbList = cDbList + (IF NUM-ENTRIES(cDbList) EQ 0 THEN "":U ELSE ",":U) 
                           + LDBNAME(iLoop).
        END.    /* loop through db's */
        ELSE
            ASSIGN cDbList = pcDatabaseName.

        CREATE WIDGET-POOL "SCHEMA-INFO":U.

        DB-LOOP:
        DO iLoop = 1 TO NUM-ENTRIES(cDbList) WHILE pcTableName EQ "":U:
            CREATE QUERY hQuery IN WIDGET-POOL "SCHEMA-INFO":U.
            CREATE BUFFER hBufferFile FOR TABLE ( ENTRY(iLoop, cDbList) + "._File":U ) IN WIDGET-POOL "SCHEMA-INFO":U.
            CREATE BUFFER hBufferField FOR TABLE ( ENTRY(iLoop, cDbList) + "._Field":U ) IN WIDGET-POOL "SCHEMA-INFO":U.

            hQuery:ADD-BUFFER(hBufferField).
            hQuery:ADD-BUFFER(hBufferFile).

            hQuery:QUERY-PREPARE("FOR EACH " + ENTRY(iLoop, cDbList) + "._Field":U + "  WHERE ":U
                                    + ENTRY(iLoop, cDbList) + "._Field._Field-Name = '":U + pcFieldName + "' ":U
                                    + "NO-LOCK, ":U
                                 + "FIRST " + ENTRY(iLoop, cDbList) + "._File":U
                                    + "OF " + ENTRY(iLoop, cDbList) + "._Field":U
                                    + "NO-LOCK ").

            hQuery:QUERY-OPEN().
            hQuery:GET-FIRST(NO-LOCK).

            IF hBufferField:AVAILABLE THEN
                ASSIGN hField      = hBufferField:BUFFER-FIELD("_File-Name":U)
                       pcTableName = hField:BUFFER-VALUE
                       .
            hQuery:QUERY-CLOSE().

            DELETE OBJECT hQuery NO-ERROR.
        END.    /* DB-LOOP: loop through db list */

        DELETE WIDGET-POOL "SCHEMA-INFO":U.

        IF pcTableName EQ ? THEN
            ASSIGN pcTableName = "":U.
    END.    /* table name n/a */

    IF pcTableName NE "":U THEN
    DO:
        CREATE WIDGET-POOL "SCHEMA-INFO".
        CREATE BUFFER hBuffer FOR TABLE ( pcDatabaseName + ".":U + pcTableName ) IN WIDGET-POOL "SCHEMA-INFO":U NO-ERROR.
        
        IF NOT ERROR-STATUS:ERROR THEN
            ASSIGN hField = hBuffer:BUFFER-FIELD(pcFieldName).

        IF VALID-HANDLE(hField) THEN
            ASSIGN pcSchemaDetail = "DATA-TYPE"   + CHR(3) + hField:DATA-TYPE         + CHR(3)
                                  + "FORMAT":U    + CHR(3) + hField:FORMAT            + CHR(3)
                                  + "HELP":U      + CHR(3) + hField:HELP              + CHR(3)
                                  + "LABEL":U     + CHR(3) + hField:LABEL             + CHR(3)
                                  + "MANDATORY":U + CHR(3) + STRING(hField:MANDATORY)
                   .
        DELETE WIDGET-POOL "SCHEMA-INFO":U.
    END.    /* table name is available */

    RETURN.
END PROCEDURE.  /* getschemainfo */

PROCEDURE CreateAttributeValues:
    DEFINE INPUT PARAMETER pdObjectTypeObj          AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pdSmartObjectObj         AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pcAttributeLabel         AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcAttributeValue         AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcAttributeGroupName     AS CHARACTER        NO-UNDO.     

    DEFINE BUFFER ryc_attribute_value       FOR ryc_attribute_value.
    DEFINE BUFFER ryc_attribute             FOR ryc_attribute.
    DEFINE BUFFER ryc_attribute_group       FOR ryc_attribute_group.

    FIND FIRST ryc_attribute WHERE
               ryc_attribute.attribute_label = pcAttributeLabel
               NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ryc_attribute THEN
    DO:
        FIND FIRST ryc_attribute_group WHERE
                   ryc_attribute_group.attribute_group_name = pcAttributeGroupName
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_attribute_group THEN
        DO:
            CREATE ryc_attribute_group NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

            ASSIGN ryc_attribute_group.attribute_group_name      = pcAttributeGroupName
                   ryc_attribute_group.attribute_group_narrative = pcAttributeGroupName
                   NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR ERROR-STATUS:GET-MESSAGE(1).

            VALIDATE ryc_attribute_group NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* n/a attribute group */

        CREATE ryc_attribute NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        ASSIGN ryc_attribute.attribute_group_obj = ryc_attribute_group.attribute_group_obj
               ryc_attribute.attribute_type_TLA  = "CHR":U
               ryc_attribute.attribute_label     = pcAttributeLabel
               ryc_attribute.attribute_narrative = pcAttributeLabel
               ryc_attribute.system_owned        = NO
               NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR ERROR-STATUS:GET-MESSAGE(1).

        VALIDATE ryc_attribute NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Associate the attribute with the object type */
        CREATE ryc_attribute_value NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        ASSIGN ryc_attribute_value.object_type_obj             = pdObjectTypeObj
               ryc_attribute_value.container_smartobject_obj   = 0
               ryc_attribute_value.smartobject_obj             = 0
               ryc_attribute_value.object_instance_obj         = 0
               ryc_attribute_value.inheritted_value            = NO
               ryc_attribute_value.constant_value              = NO
               ryc_attribute_value.attribute_group_obj         = ryc_attribute.attribute_group_obj
               ryc_attribute_value.attribute_type_tla          = ryc_attribute.attribute_type_tla
               ryc_attribute_value.attribute_label             = ryc_attribute.attribute_label
               ryc_attribute_value.attribute_value             = ?      /* default Null value */
               NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR ERROR-STATUS:GET-MESSAGE(1).

        VALIDATE ryc_attribute_value NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* n/a attribute */

    FIND FIRST ryc_attribute_value WHERE
               ryc_attribute_value.primary_smartObject_obj = pdSmartObjectObj                  AND
               ryc_attribute_value.attribute_group_obj     = ryc_attribute.attribute_group_obj AND
               ryc_attribute_value.attribute_type_TLA      = ryc_attribute.attribute_type_TLA  AND
               ryc_attribute_value.attribute_label         = ryc_attribute.attribute_label
               EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
    IF NOT AVAILABLE ryc_attribute_value THEN
    DO:
        CREATE ryc_attribute_value NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        ASSIGN ryc_attribute_value.object_type_obj             = pdObjectTypeObj
               ryc_attribute_value.container_smartobject_obj   = 0
               ryc_attribute_value.smartobject_obj             = pdSmartObjectObj
               ryc_attribute_value.object_instance_obj         = 0
               ryc_attribute_value.inheritted_value            = NO
               ryc_attribute_value.constant_value              = NO
               ryc_attribute_value.attribute_group_obj         = ryc_attribute.attribute_group_obj
               ryc_attribute_value.attribute_type_tla          = ryc_attribute.attribute_type_tla
               ryc_attribute_value.attribute_label             = ryc_attribute.attribute_label
               NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR ERROR-STATUS:GET-MESSAGE(1).

        VALIDATE ryc_attribute_value NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    END.

    ASSIGN ryc_attribute_value.attribute_value = pcAttributeValue NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR ERROR-STATUS:GET-MESSAGE(1).

    VALIDATE ryc_attribute_value NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    RETURN.
END PROCEDURE.  /* CreateAttributeValues */
