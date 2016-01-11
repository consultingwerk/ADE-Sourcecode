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
/*parameters*/
/************************ sample input values
ASSIGN
pcSdoName = "customerfullo.w"
pcTableName = "customer"
pcProductModuleCode = "testmodule"
piMaxFlds = 10
pcRelativePath = "sdo"
cObjectNameSuffix = "viewv"
pcDumpName = "customer"
pcDatabaseName = "sports2000".
***********************/
DEFINE INPUT PARAMETER pcDatabaseName                       AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcSdoName                            AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcTableName                          AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcProductModuleCode                  AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcRelativePath                       AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER piMaxFlds                            AS INTEGER              NO-UNDO.
DEFINE INPUT PARAMETER pcDumpName                           AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER cObjectNameSuffix                    AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER piMaxColumnFlds                      AS INTEGER              NO-UNDO.
DEFINE INPUT PARAMETER plSDOFields                          AS LOGICAL              NO-UNDO.
DEFINE INPUT PARAMETER plDeleteInstances                    AS LOGICAL              NO-UNDO.

/*local variables*/
DEFINE VARIABLE maxframewidth                   AS DEC INIT 1024                  NO-UNDO.
DEFINE VARIABLE maxframeheight                  AS DEC INIT 768                   NO-UNDO.
DEFINE VARIABLE maxfldlength                    AS DEC                            NO-UNDO.
DEFINE VARIABLE maxcharlength                   AS INT INIT 30                    NO-UNDO.
DEFINE VARIABLE maxlabellength                  AS DECIMAL                        NO-UNDO.
DEFINE VARIABLE totflds                         AS INTEGER                        NO-UNDO.
DEFINE VARIABLE totcolumns                      AS INTEGER                        NO-UNDO.
DEFINE VARIABLE cformat                         AS CHAR                           NO-UNDO.
DEFINE VARIABLE totfldwidth                     AS DECIMAL EXTENT 30              NO-UNDO.
DEFINE VARIABLE totlabelwidth                   AS DECIMAL EXTENT 30              NO-UNDO.
DEFINE VARIABLE totfldscolumn                   AS INT                            NO-UNDO.
DEFINE VARIABLE framex                          AS HANDLE                         NO-UNDO.
DEFINE VARIABLE thdl                            AS HANDLE                         NO-UNDO.
DEFINE VARIABLE lhdl                            AS HANDLE                         NO-UNDO.
DEFINE VARIABLE cnt                             AS DEC                            NO-UNDO.
DEFINE VARIABLE keyindexcnt                     AS INTEGER                        NO-UNDO.
DEFINE VARIABLE extentcnt                       AS INTEGER                        NO-UNDO.
DEFINE VARIABLE processcnt                      AS INTEGER                        NO-UNDO.
DEFINE VARIABLE currentcolumn                   AS INTEGER                        NO-UNDO.
DEFINE VARIABLE wwin                            AS HANDLE                         NO-UNDO.
DEFINE VARIABLE cc                              AS INT                            NO-UNDO.
DEFINE VARIABLE framewidth                      AS DEC                            NO-UNDO.
DEFINE VARIABLE frameheight                     AS DEC                            NO-UNDO.
DEFINE VARIABLE newframewidth                   AS DEC                            NO-UNDO.
DEFINE VARIABLE newframeheight                  AS DEC                            NO-UNDO.
DEFINE VARIABLE tmpextent                       AS INT                            NO-UNDO.
DEFINE VARIABLE tmplabelchars                   AS INT                            NO-UNDO.
DEFINE VARIABLE tmpfieldchars                   AS INT                            NO-UNDO.
DEFINE VARIABLE iFont                           AS INTEGER                        NO-UNDO.
DEFINE VARIABLE maxfields                       AS CHAR                           NO-UNDO.
DEFINE VARIABLE fieldnames                      AS CHAR                           NO-UNDO.
DEFINE VARIABLE fieldvalues                     AS CHAR                           NO-UNDO.
DEFINE VARIABLE cprocname                       AS CHAR                           NO-UNDO.
DEFINE VARIABLE selectedfields                  AS CHAR                           NO-UNDO.
DEFINE VARIABLE iLoop                           AS INTEGER                        NO-UNDO.
DEFINE VARIABLE cEntry                          AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE cField                          AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE lEnabled                        AS LOGICAL                        NO-UNDO.
DEFINE VARIABLE iPosn1                          AS INTEGER                        NO-UNDO.
DEFINE VARIABLE iPosn2                          AS INTEGER                        NO-UNDO.
DEFINE VARIABLE cLine                           AS CHAR                           NO-UNDO.
DEFINE VARIABLE cObjectName                     AS CHAR                           NO-UNDO.
DEFINE VARIABLE cmes                            AS CHAR                           NO-UNDO.
DEFINE VARIABLE cAttributeNames                 AS CHAR                           NO-UNDO.
DEFINE VARIABLE cAttributeValues                AS CHAR                           NO-UNDO. 
DEFINE VARIABLE cObjectDescription              AS CHAR                           NO-UNDO. 
DEFINE VARIABLE dSmartObject                    AS DECIMAL                        NO-UNDO.
DEFINE VARIABLE cFldSmartObject                 AS DECIMAL                        NO-UNDO.
DEFINE VARIABLE dinstance                       AS DECIMAL                        NO-UNDO.
DEFINE VARIABLE windowtitlefield                AS CHAR                           NO-UNDO.
DEFINE VARIABLE tmpsdoname                      AS CHAR                           NO-UNDO.
DEFINE VARIABLE tmpTableName                    AS CHAR                           NO-UNDO.
DEFINE VARIABLE sdohdl                          AS HANDLE                         NO-UNDO.
DEFINE VARIABLE tmpdatacolumns                  AS CHAR                           NO-UNDO.
DEFINE VARIABLE tmpreadonlyflag                 AS LOGICAL                        NO-UNDO.
DEFINE VARIABLE tmpcolumntable                  AS CHAR                           NO-UNDO.
DEFINE VARIABLE tmpupdatabletables              AS CHAR                           NO-UNDO.
DEFINE VARIABLE fldcnt                          AS INTEGER                        NO-UNDO.
DEFINE VARIABLE fieldlist                       AS CHAR                           NO-UNDO.
DEFINE VARIABLE showpopup                       AS CHAR                           NO-UNDO.
DEFINE VARIABLE hQuery                          AS HANDLE                         NO-UNDO.
DEFINE VARIABLE hField                          AS HANDLE                         NO-UNDO.
DEFINE VARIABLE cDbTable                        AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE cDbField                        AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE cQuery                          AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE rRecid                          AS RECID                          NO-UNDO.
DEFINE VARIABLE cVisualizationType              AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE cPreviousEntry                  AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE cPrimaryTableObjField           AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE cSchemaName                     AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE hDbBuffer                       AS HANDLE                       NO-UNDO.
DEFINE VARIABLE hFileBuffer                     AS HANDLE                       NO-UNDO.
DEFINE VARIABLE hFieldBuffer                    AS HANDLE                       NO-UNDO.
DEFINE VARIABLE cWhere                          AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cDbBufferName                   AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cFileBufferName                 AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cFieldBufferName                AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE hWidget                         AS HANDLE                       NO-UNDO.
DEFINE VARIABLE dFrameHeightChars               AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE dFrameWidthChars                AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE cEnabledFields                  AS CHARACTER                    NO-UNDO.

DEFINE BUFFER rycoi     FOR ryc_object_instance.
DEFINE BUFFER rycso     FOR ryc_smartObject.

{ afglobals.i }

DEFINE TEMP-TABLE ttFieldTable          NO-UNDO
    LIKE _field.

DEFINE TEMP-TABLE tmprecord             NO-UNDO
    FIELD tmpfieldname             AS CHAR
    FIELD tmpfieldlength           AS INTEGER
    FIELD tmplabellength           AS INTEGER
    FIELD tmplabel                 AS CHARACTER
    FIELD tmptotfldwidth           AS INTEGER
    FIELD tmpcolumn                AS DECIMAL
    FIELD tmpRow                   AS DECIMAL
    FIELD tmpformat                AS CHARACTER
    FIELD tmporder                 AS INTEGER
    FIELD tmpfldhdl                AS HANDLE
    FIELD tmplabhdl                AS HANDLE
    FIELD tmpdatatype              AS CHARACTER
    FIELD tmpviewas                AS CHARACTER
    FIELD tmpEnabled               AS LOGICAL
    FIELD tmpInitialValue          AS CHARACTER
    FIELD tmpHelp                  AS CHARACTER
    FIELD tmpColumnLabel           AS CHARACTER
    INDEX KEY IS UNIQUE PRIMARY
        tmporder    ASCENDING
    .
IF cObjectNameSuffix = "":U THEN
    ASSIGN cObjectNameSuffix = "viewv":U.

ASSIGN cObjectName        = pcDumpName + cObjectNameSuffix
       cObjectDescription = SUBSTITUTE("Dynamic Viewer for &1",pcTableName)
       iFont              = ?             /* ? = system default font. */
       windowtitlefield   = " ":U + CAPS( SUBSTRING(pcTableName, 1, 1)) +  SUBSTRING(pcTableName, 2, LENGTH(pcTableName)) + "s ":U       
       maxFrameHeight     = SESSION:HEIGHT-CHARS
       maxFrameWidth      = SESSION:WIDTH-CHARS
       .
CREATE WINDOW wWin
    ASSIGN HIDDEN        = YES
           TITLE         = "<insert SmartWindow title>"
           HEIGHT-CHARS  = maxFrameHeight
           WIDTH-CHARS   = maxFrameWidth
           RESIZE        = NO
           SCROLL-BARS   = NO
           STATUS-AREA   = NO
           BGCOLOR       = ?
           FGCOLOR       = ?
           THREE-D       = YES
           MESSAGE-AREA  = NO
           SENSITIVE     = YES
           RESIZE        = NO
           FONT          = iFont
           HIDDEN        = TRUE
           VISIBLE       = FALSE
           .
CURRENT-WINDOW = wwin.

CREATE FRAME frameX
     ASSIGN VIRTUAL-WIDTH-PIXELS  = SESSION:WIDTH-PIXELS - 1
            VIRTUAL-HEIGHT-PIXELS = SESSION:HEIGHT-PIXELS - 1
            WIDTH-CHARS           = frameX:VIRTUAL-WIDTH-CHARS 
            HEIGHT-CHARS          = frameX:VIRTUAL-HEIGHT-CHARS
            VISIBLE               = FALSE
            FONT                  = iFont
            BOX                   = FALSE
            THREE-D               = TRUE
            SCROLLABLE            = FALSE
            OVERLAY               = TRUE
            HIDDEN                = TRUE
            SIDE-LABELS           = TRUE
            DOWN                  = 1
     . 
ASSIGN tmpsdoname = pcSdoName.

RUN adecomm/_osfmush.p ( INPUT pcRelativePath,  INPUT pcSdoName, OUTPUT pcSdoName ).

ASSIGN fieldlist      = "":U
       cEnabledFields = "":U
       .
IF NOT plSDOFields THEN DO:
/*use entiity mnemonic to get fieldnames if avail*/

  FIND FIRST gsc_entity_mnemonic NO-LOCK 
    WHERE gsc_entity_mnemonic.entity_mnemonic_description = pcTableName
    NO-ERROR.
  IF AVAILABLE gsc_entity_mnemonic THEN
  DO:
      ASSIGN iLoop = 0.
  
      ENTITYLOOP:
      FOR EACH gsc_entity_display_field WHERE
               gsc_entity_display_field.entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic
               NO-LOCK
               BY gsc_entity_display_field.display_field_order
               WHILE iLoop <= piMaxFlds:
  
          ASSIGN iLoop     = iLoop + 1
                 fieldlist = fieldlist + (IF NUM-ENTRIES(fieldList, CHR(3)) EQ 0 THEN "":U ELSE CHR(3))
                           + gsc_entity_display_field.display_field_name
                 .
      END. /* ENTITYLOOP: for each gsc_entity_display_field*/
  END. /* avail gsc_entity_mnemonic*/

    /* Assume that all fields are updateable. */
    ASSIGN cEnabledFields = REPLACE(FieldList, CHR(3), ",":U).
END.

/*else use fields in SDO*/
IF fieldlist = "":U THEN
SDO-BLOCK:
DO ON ERROR UNDO, LEAVE SDO-BLOCK:
    DO ON STOP UNDO, LEAVE SDO-BLOCK:
        IF SEARCH(pcSDOName) = ? AND
           NUM-ENTRIES(pcSDOName, ".":U) < 2 THEN
          pcSDOName = pcSDOName + ".w":U.

        RUN VALUE(pcSdoName) PERSISTENT SET sdohdl.
    END.

    IF NOT VALID-HANDLE(sdoHdl) THEN LEAVE SDO-BLOCK.
    
    RUN initializeObject IN sdohdl.

    /* Get all fields from SDO */
    ASSIGN tmpdatacolumns = DYNAMIC-FUNCTION("getdatacolumns":U IN sdohdl).

    /* find updatable tables */
    ASSIGN tmpupdatabletables = "":U
           cEnabledFields     = "":U
           .
    FLDCNTLOOP:
    DO fldcnt = 1 TO NUM-ENTRIES(tmpdatacolumns):
        IF NOT DYNAMIC-FUNCTION("columnreadonly":U IN sdohdl, ENTRY(fldcnt, tmpdatacolumns)) THEN
        DO:
            ASSIGN tmpcolumntable = DYNAMIC-FUNCTION("columntable":U IN sdohdl, ENTRY(fldcnt, tmpdatacolumns)).

            IF LOOKUP(tmpcolumntable,tmpupdatabletables, CHR(3)) = 0 THEN
                ASSIGN tmpupdatabletables = tmpupdatabletables + (IF NUM-ENTRIES(tmpUpdatableTables, CHR(3)) EQ 0 THEN "":U ELSE CHR(3))
                                          + tmpcolumntable.
            ASSIGN cEnabledFields = cEnabledFields + (IF NUM-ENTRIES(cEnabledFields) EQ 0 THEN "":U ELSE ",":U)
                                  + ENTRY(fldcnt, tmpdatacolumns).
        END. /*not dynamic-function*/

        IF fldcnt = piMaxFlds THEN LEAVE FLDCNTLOOP.
    END. /* fldcntloop */

    /* Include all fields updatable or not if table is updatable */
    FINDFLDLOOP:
    DO fldcnt = 1 TO NUM-ENTRIES(tmpdatacolumns):
        tmpcolumntable = DYNAMIC-FUNCTION("columntable" IN sdohdl, ENTRY(fldcnt, tmpdatacolumns)).

        IF LOOKUP(tmpcolumntable, tmpupdatabletables, CHR(3)) > 0 THEN
            ASSIGN fieldlist = fieldlist + (IF NUM-ENTRIES(fieldList, CHR(3)) EQ 0 THEN "":U ELSE CHR(3))
                             + ENTRY(fldcnt,tmpdatacolumns)
                   .
        IF fldcnt = piMaxFlds THEN LEAVE FINDFLDLOOP.
    END. /* FINDFLDLOOP */

    RUN "destroyobject" IN sdohdl.

    IF VALID-HANDLE(sdohdl) THEN 
        DELETE OBJECT sdohdl.
END. /* SDO-BLOCK: else */

IF fieldlist = "":U THEN
  RETURN ERROR "Could not find fields in the entity mnemonic table or the SDO for table: " + pcTableName.

/* If the logical object name and the schema name differ, then we assume that we are working with 
 * a DataServer. If the schema and logical names are the same, we are dealing with a native 
 * Progress DB.                                                                                   */
ASSIGN cSchemaName = SDBNAME(pcDataBaseName).

IF cSchemaName EQ pcDataBaseName THEN
    ASSIGN cDbBufferName    = pcDataBaseName + "._Db":U
           cFileBufferName  = pcDataBaseName + "._File":U
           cFieldBufferName = pcDataBaseName + "._Field":U
           cWhere           = "FOR EACH ":U + cDbBufferName + " NO-LOCK, ":U
                            + " EACH " + cFileBufferName + " WHERE ":U
                            +   cFileBufferName + "._Db-recid  = RECID(_Db) AND ":U
                            +   cFileBufferName + "._File-name = '":U + pcTableName + "' AND ":U
                            +   cFileBufferName + "._Owner     = 'PUB':U ":U
                            + " NO-LOCK, ":U
                            + " EACH ":U + cFieldBufferName + " WHERE ":U
                            +   cFieldBufferName + "._File-recid = RECID(_File) ":U
                            + " NO-LOCK ":U.
ELSE
    ASSIGN cDbBufferName    = cSchemaName + "._Db":U
           cFileBufferName  = cSchemaName + "._File":U
           cFieldBufferName = cSchemaName + "._Field":U
           cWhere           = " FOR EACH ":U + cDbBufferName + " WHERE ":U
                            +   cDbBufferName + "._Db-Name = '" + pcDataBaseName + "' ":U
                            + " NO-LOCK, ":U
                            + " EACH " + cFileBufferName + " WHERE ":U
                            +   cFileBufferName + "._Db-recid  = RECID(_Db) AND ":U
                            +   cFileBufferName + "._File-name = '":U + pcTableName + "' AND ":U
                            +   cFileBufferName + "._Owner     = '_Foreign':U ":U
                            + " NO-LOCK, ":U
                            + " EACH ":U + cFieldBufferName + " WHERE ":U
                            +  cFieldBufferName + "._File-recid = RECID(_File) ":U
                            + " NO-LOCK ":U.

CREATE BUFFER hDbBuffer     FOR TABLE cDbBufferName     NO-ERROR.   {afcheckerr.i}
CREATE BUFFER hFileBuffer   FOR TABLE cFileBufferName   NO-ERROR.   {afcheckerr.i}
CREATE BUFFER hFieldBuffer  FOR TABLE cFieldBufferName  NO-ERROR.   {afcheckerr.i}
CREATE BUFFER hField        FOR TABLE "ttFieldTable":U  NO-ERROR.   {afcheckerr.i}

CREATE QUERY hQuery NO-ERROR.
    {afcheckerr.i}

hQuery:SET-BUFFERS(hDbBuffer, hFileBuffer, hFieldBuffer) NO-ERROR.
    {afcheckerr.i}

hQuery:QUERY-PREPARE(cWhere) NO-ERROR.
    {afcheckerr.i}

hQuery:QUERY-OPEN() NO-ERROR.
    {afcheckerr.i}

hQuery:GET-FIRST(NO-LOCK) NO-ERROR.
    {afcheckerr.i}

DO WHILE hFieldBuffer:AVAILABLE:
    hField:BUFFER-CREATE().
    hField:BUFFER-COPY(hFieldBuffer).
    hField:BUFFER-RELEASE().

    hQuery:GET-NEXT(NO-LOCK).
END.

hQuery:QUERY-CLOSE().

DELETE OBJECT hQuery.
ASSIGN hQuery = ?.

DELETE OBJECT hFieldBuffer NO-ERROR.
ASSIGN hFieldBuffer = ?.

DELETE OBJECT hFileBuffer NO-ERROR.
ASSIGN hFileBuffer = ?.

DELETE OBJECT hDbBuffer NO-ERROR.
ASSIGN hDbBuffer = ?.

/*end of build field list*/

EMPTY TEMP-TABLE tmprecord.
ASSIGN cnt            = 0
       totflds        = 0
       maxlabellength = 0
       maxfldlength   = 0
       keyindexcnt    = 0
       totcolumns     = 0
       totfldwidth    = 0
       totfldscolumn  = 0
       currentcolumn  = 1
       totfldwidth    = 0
       totlabelwidth  = 0
       tmpfieldchars  = 0
       tmplabelchars  = 0
       totflds        = NUM-ENTRIES(fieldlist, CHR(3))
       .
IF piMaxColumnFlds LE 0 THEN
    ASSIGN piMaxColumnFlds = 16.

IF totflds <= piMaxColumnFlds THEN
    ASSIGN totcolumns = 1.
ELSE
DO:
    ASSIGN totcolumns = TRUNCATE( totflds / piMaxColumnFlds, 0 ).

    IF totflds MOD piMaxColumnFlds > 0 THEN
        ASSIGN totcolumns = totcolumns + 1.
END.    /* more fields than max fields per column */

ASSIGN totfldscolumn = totflds / totcolumns
       totflds       = 0
       .
FLDLOOP:
DO fldcnt = 1 TO NUM-ENTRIES(fieldlist, CHR(3)):
    FIND ttFieldTable WHERE
         ttFieldTable._field-name = ENTRY(fldcnt, fieldList, CHR(3))
         NO-LOCK NO-ERROR.

    IF NOT AVAILABLE ttFieldTable THEN NEXT FLDLOOP.

    IF ttFieldTable._data-type = "RAW" THEN NEXT FLDLOOP.

    IF ttFieldTable._extent = 0 THEN
        ASSIGN tmpextent = 1.
    ELSE
        ASSIGN tmpextent = ttFieldTable._extent.

    EXTENTLOOP:
    DO extentcnt = 1 TO tmpextent:
        ASSIGN keyindexcnt = keyindexcnt + 1.

        CREATE tmprecord.

        /* Enabled? */
        ASSIGN tmpRecord.tmpEnabled = (LOOKUP(ENTRY(fldcnt, fieldList, CHR(3)), cEnabledFields) NE 0).

        IF tmpextent GT 1 THEN
            ASSIGN tmprecord.tmpfieldname = ttFieldTable._field-name + "[":U + STRING(extentcnt) + "]":U.
        ELSE
            ASSIGN tmprecord.tmpfieldname = ttFieldTable._field-name.

        ASSIGN tmprecord.tmpviewas = ttFieldTable._view-as
               tmprecord.tmporder  = keyindexcnt
               .
        IF tmpextent GT 1 THEN
            ASSIGN tmprecord.tmplabel = IF ttFieldTable._label = "?" OR ttFieldTable._label = ? 
                                        THEN tmprecord.tmpfieldname + "[":U + STRING(extentcnt) + "]:":U
                                        ELSE ttFieldTable._label + "[":U + STRING(extentcnt) + "]:":U.
        ELSE
        IF ttFieldTable._label = "?" OR ttFieldTable._label = ? THEN
            ASSIGN tmprecord.tmplabel = tmprecord.tmpfieldname + ":":U.
        ELSE
            ASSIGN tmprecord.tmplabel = ttFieldTable._label + ":":U.

        ASSIGN tmprecord.tmpformat       = ttFieldTable._format
               tmprecord.tmpdatatype     = ttFieldTable._data-type
               cformat                   = ttFieldTable._format
               tmpRecord.tmpInitialValue = (IF ttFieldTable._Initial EQ ? THEN "?":U ELSE ttFieldTable._Initial)
               tmpRecord.tmpHelp         = (IF ttFieldTable._Help EQ ? THEN "?":U ELSE ttFieldTable._Help)
               tmpRecord.tmpColumnLabel  = (IF ttFieldTable._Col-label EQ ? THEN "?":U ELSE ttFieldTable._Col-label)
               .
        IF ttFieldTable._View-As EQ "TOGGLE-BOX":U THEN
            ASSIGN tmpRecord.tmpLabel = TRIM(tmpRecord.tmpLabel, ":":U).

        IF INDEX(ttFieldTable._format, "(":U)  > 0 THEN        
        DO:        
            ASSIGN cformat       = REPLACE(cformat, "(":U, "":U)
                   cformat       = REPLACE(cformat, ")":U, "":U)
                   cformat       = REPLACE(cformat, "X", "")  /****other format types ?***/
                   tmpfieldchars = INTEGER(cformat)
                   NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
                ASSIGN tmpfieldchars = LENGTH(cformat).
        END.    /* ( in format. */
        ELSE
            ASSIGN tmpfieldchars = LENGTH(cformat).

        IF tmpfieldchars GT maxcharlength THEN
        DO:
            ASSIGN tmpfieldchars = maxcharlength.

            IF tmprecord.tmpdatatype BEGINS "CHAR" THEN
                tmprecord.tmpformat = "X(":U + STRING(maxcharlength) + ")":U.
        END. /*tmprecord.tmpfieldlength > 50*/

        ASSIGN tmplabelchars = LENGTH (tmprecord.tmplabel).  /*allow for colon and space and padding*/

        CREATE TEXT lhdl
            ASSIGN FRAME        = frameX
                   DATA-TYPE    = "CHARACTER":U
                   FORMAT       = "x(":U + STRING(tmplabelchars)  + ")":U
                   WIDTH-PIXELS = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(tmprecord.tmplabel, iFont)
                   FONT         = iFont
                   SCREEN-VALUE = tmprecord.tmplabel
                   .
        ASSIGN tmprecord.tmplabhdl      = lhdl
               tmprecord.tmplabellength = lHdl:WIDTH-PIXELS
               .
        CREATE FILL-IN thdl
            ASSIGN FRAME             = frameX
                   FONT              = iFont
                   DATA-TYPE         = tmpdatatype
                   FORMAT            = tmpformat
                   SIDE-LABEL-HANDLE = lhdl
                   .
        ASSIGN tmprecord.tmpRow         = cnt
               cnt                      = cnt + thdl:HEIGHT-PIXELS
               tmprecord.tmpfldhdl      = thdl
               tmprecord.tmpfieldlength = thdl:WIDTH-PIXELS
               .
        IF tmprecord.tmpfieldlength GT maxfldlength THEN
            ASSIGN maxfldlength = tmprecord.tmpfieldlength + 8.

        IF tmprecord.tmplabellength GT maxlabellength THEN
            ASSIGN maxlabellength = tmprecord.tmplabellength + 8.

        IF keyindexcnt MOD totfldscolumn = 0 THEN        
            ASSIGN totfldwidth[currentcolumn]   = maxfldlength
                   totlabelwidth[currentcolumn] = maxlabellength
                   maxfldlength                 = 0
                   maxlabellength               = 0
                   currentcolumn                = currentcolumn + 1
                   cnt                          = 0
                   .
    END.    /* EXTENTLOOP: */
END. /*for each ttFieldTable._field*/

IF keyindexcnt MOD totfldscolumn <> 0 THEN
    ASSIGN totfldwidth[currentcolumn]   = maxfldlength
           totlabelwidth[currentcolumn] = maxlabellength
           .
/*calc num columns*/   
/*reset frame dimensions*/
ASSIGN processcnt     = 0
       currentcolumn  = 1
       cc             = 2
       newframewidth  = 0
       framewidth     = 0
       newframeheight = 0
       frameheight    = 0
       .
DSPLOOP:
FOR EACH tmprecord NO-LOCK
         BY tmpRecord.tmpOrder:
    /* The fields must fit inside the frame. */
    IF frameX:WIDTH-PIXELS LT (cc + totlabelwidth[currentcolumn] + totfldwidth[currentcolumn]) THEN
        LEAVE DSPLOOP.

    ASSIGN processcnt                    = processcnt + 1
           tmprecord.tmplabhdl:Y         = tmpRow
           tmprecord.tmplabhdl:X         = (cc + totlabelwidth[currentcolumn]) - tmprecord.tmplabellength
           tmprecord.tmplabhdl:SENSITIVE = TRUE
           tmprecord.tmplabhdl:VISIBLE   = TRUE
           cnt                           = cnt + 1
           tmprecord.tmpfldhdl:Y         = tmpRow
           tmprecord.tmpfldhdl:X         = cc + totlabelwidth[currentcolumn]
           tmprecord.tmpfldhdl:SENSITIVE = TRUE
           tmprecord.tmpfldhdl:VISIBLE   = TRUE
           .
    IF processcnt MOD totfldscolumn = 0 THEN    
        ASSIGN processcnt    = 0
               cc            = cc + totlabelwidth[currentcolumn] + totfldwidth[currentcolumn]
               currentcolumn = currentcolumn + 1
               .

    ASSIGN framewidth = tmprecord.tmpfldhdl:X + tmprecord.tmpfldhdl:WIDTH-PIXELS + 4.

    IF framewidth GT newframewidth THEN
        ASSIGN newframewidth = framewidth.

    ASSIGN frameheight = tmprecord.tmpfldhdl:Y + tmprecord.tmpfldhdl:HEIGHT-PIXELS + 4.
    IF frameheight GT newframeheight THEN
        ASSIGN newframeheight = frameheight.
END. /*DSPLOOP*/

IF processcnt MOD totfldscolumn NE 0 THEN
    ASSIGN cc = cc + totlabelwidth[currentcolumn] + totfldwidth[currentcolumn].

/** Calculate the minimum size of the objects contained withing the frame.
 *  We calculate this in this way to conform to the dynamic viewer's
 *  calculations.
 *  ----------------------------------------------------------------------- **/
ASSIGN hWidget          = frameX:FIRST-CHILD
       hWidget          = hWidget:FIRST-CHILD
       dFrameWidthChars = 10                    /* The frame should be at least 10 chars wide. */
       .
DO WHILE VALID-HANDLE(hWidget):
    IF CAN-QUERY(hWidget, "ROW":U) AND CAN-QUERY(hWidget, "HEIGHT-CHARS":U) THEN
        ASSIGN dFrameHeightChars = MAX(dFrameHeightChars, hWidget:ROW + hWidget:HEIGHT-CHARS).

    IF CAN-QUERY(hWidget, "COLUMN":U) AND CAN-QUERY(hWidget, "WIDTH-CHARS":U) THEN
        ASSIGN dFrameWidthChars  = MAX(dFrameWidthChars,  hWidget:COL + hWidget:WIDTH-CHARS).

    ASSIGN hWidget = hWidget:NEXT-SIBLING.
END.    /* while valid handle. */

ASSIGN frameX:WIDTH-CHARS  = dFrameWidthChars
       frameX:HEIGHT-CHARS = dFrameHeightChars
       framex:SCROLLABLE   = FALSE
       wWin:WIDTH-PIXELS   = frameX:WIDTH-PIXELS  + 3
       wWin:HEIGHT-PIXELS  = frameX:HEIGHT-PIXELS + 3
       cAttributeNames     = "":U
       cAttributeValues    = "":U
       .
{ afrun2.i 
    &PLIP  = 'ry/app/ryreposobp.p'
    &IProc = 'storeobject'
    &PList = "( INPUT 'dynview':U,~
                INPUT  pcProductModuleCode,~
                INPUT  cObjectName,~
                INPUT  cObjectDescription,~
                INPUT  cAttributeNames,~
                INPUT  cAttributeValues,~
                OUTPUT dSmartObject )"
}
{ afcheckerr.i }

IF dSmartObject > 0 THEN
DO:
    /* Delete exsiting object instances, if required. */
    IF plDeleteInstances THEN
    FOR EACH rycoi WHERE
             rycoi.container_smartobject_obj = dSmartObject
             NO-LOCK,
        EACH rycso WHERE
             rycso.smartObject_obj = rycoi.smartObject_obj
             NO-LOCK:                
        { launch.i
            &PLIP     = 'ry/app/ryreposobp.p'
            &IProc    = 'DeleteObjectInstance'
            &PList    = "(INPUT cObjectName, INPUT rycso.object_filename, OUTPUT cMes)"
            &AutoKill = NO
        }
        IF cMes NE "":U THEN
        DO:
            RUN SetReturnValue IN gshSessionManager (INPUT cMes).
            { afcheckerr.i }
        END.    /* mes */
    END.    /* each rycoi */

    ASSIGN cAttributeNames = "MinHeight,MinWidth,WindowTitleField,DataSource,DynamicObject":U.    

    /*taj: adding .71 to pad the initial height and width of the dynviewer
     * so that it won't overlap bottom objects like toolbars. IZ 2152     */
    ASSIGN cAttributeValues = STRING(framex:HEIGHT-CHARS) + CHR(3)
                            + STRING(framex:WIDTH-CHARS)  + CHR(3)
                            + TRIM(windowTitleField)      + CHR(3)
                            + TRIM(tmpSdoName)            + CHR(3)
                            + STRING(YES)
           .
    { afrun2.i 
        &PLIP  = 'ry/app/ryreposobp.p'
        &IProc = 'storeAttributeValues'
        &PList = "( INPUT 0,~
                    INPUT dSmartObject,~
                    INPUT 0,~
                    INPUT 0,~
                    INPUT cAttributeNames,~
                    INPUT cAttributeValues)"
    }
    { afcheckerr.i }

    /* Store this table's primary _obj field. This is used to determine whether the 
     * field should appear on the DynView.                                          */
    ASSIGN cPrimaryTableObjField = DYNAMIC-FUNCTION("getObjField":U IN gshGenManager,
                                                    INPUT pcDumpName                 ).

    ADD-FIELD-LOOP:
    FOR EACH tmprecord NO-LOCK:
        ASSIGN tmpTableName = pcTableName + ".":U + tmprecord.tmpfieldname.

        /* Don't create DataField instances for the table's primary _obj field.
         * Other _obj (or _obj type) fields are left on the viewer because they
         * may be used for lookups.                                            */
        IF tmpTableName EQ (pcTableName + ".":U + cPrimaryTableObjField) THEN
            NEXT ADD-FIELD-LOOP.

        /* Create the DataField as an instance on the DynView. This assumes that the 
         * DataField Master SmartObject already exists.                              */
        { afrun2.i
            &PLIP  = 'ry/app/ryreposobp.p'
            &IProc = 'storeObjectInstance'
            &PList = "( INPUT  dSmartObject,~
                        INPUT  tmpTableName,~
                        INPUT  '':U,~
                        OUTPUT cFldSmartObject,~
                        OUTPUT dinstance )"
        }
        { afcheckerr.i }

        ASSIGN cAttributeNames = "FieldName,TableName,DatabaseName,DataSource,Format,Font,Mandatory,":U
                               + "Row,Column,Width-Chars,Height-Chars,Data-Type,Enabled,LabelFont,":U
                               + "ShowPopup,NoLabel,DisplayField,FieldOrder,Visible,VisualizationType,":U
                               + "Label,InitialValue,Help,ColumnLabel":U
                               .
        IF tmprecord.tmpfldhdl:DATA-TYPE EQ "DATE":U    OR
           tmprecord.tmpfldhdl:DATA-TYPE EQ "DECIMAL":U THEN
            ASSIGN showpopup = "YES":U.
        ELSE
            ASSIGN showpopup = "NO":U. 

        /* Set the visualisation type. The default is a FILL-IN */
        ASSIGN cVisualizationType = "FILL-IN":U.

        ASSIGN cAttributeValues = TRIM(tmprecord.tmpfieldname)                              + CHR(3)        /* FieldName */
                                + "RowObject"                                               + CHR(3)        /* TableName */
                                + TRIM(pcDatabaseName)                                      + CHR(3)        /* DB Name */
                                + TRIM(tmpsdoname)                                          + CHR(3)        /* DataSource */
                                + TRIM(tmprecord.tmpformat)                                 + CHR(3)        /* Format */
                                + (IF frameX:FONT EQ ? THEN "?":U ELSE STRING(frameX:FONT)) + CHR(3)        /* Font */
                                + "NO"                                                      + CHR(3)        /* Mandatory */
                                + STRING(tmprecord.tmpfldhdl:ROW)                           + CHR(3)        /* Row */
                                + STRING(tmprecord.tmpfldhdl:COLUMN)                        + CHR(3)        /* Column */
                                + STRING(tmprecord.tmpfldhdl:WIDTH-CHARS)                   + CHR(3)        /* Width-Chars */
                                + STRING(tmprecord.tmpfldhdl:HEIGHT-CHARS)                  + CHR(3)        /* Height-Chars */
                                + STRING(tmprecord.tmpfldhdl:DATA-TYPE)                     + CHR(3)        /* Data-Type */
                                + STRING(tmpRecord.tmpEnabled)                              + CHR(3)        /* Enabled */
                                + (IF iFont EQ ? THEN "?":U ELSE STRING(iFont))             + CHR(3)        /* Label Font */
                                + TRIM(showpopup)                                           + CHR(3)        /* ShowPopup */
                                + "NO"                                                      + CHR(3)        /* NoLabel */
                                + "YES"                                                     + CHR(3)        /* DisplayField */
                                + STRING(tmprecord.tmporder)                                + CHR(3)        /* FieldOrder */
                                + "YES"                                                     + CHR(3)        /* Visible */
                                + TRIM(cVisualizationType)                                  + CHR(3)        /* Visualization Type */
                                + TRIM(SUBSTRING(tmprecord.tmpfldhdl:LABEL, 1, LENGTH(tmprecord.tmpfldhdl:LABEL) - 1)) + CHR(3) /* Label */
                                + TRIM(tmpRecord.tmpInitialValue)                           + CHR(3)        /* InitialValue */
                                + TRIM(tmpRecord.tmpHelp)                                   + CHR(3)        /* Help */
                                + TRIM(tmpRecord.tmpColumnLabel)                                            /* ColumnLabel */
               .
        { afrun2.i 
            &PLIP  = 'ry/app/ryreposobp.p'
            &IProc = 'storeAttributeValues'
            &PList = "( INPUT 0,~
                        INPUT cFldSmartObject,~
                        INPUT dSmartObject,~
                        INPUT dinstance,~
                        INPUT cAttributeNames,~
                        INPUT cAttributeValues)"
        }
        { afcheckerr.i }
    END. /* ADD-FIELD-LOOP: for each temprecord*/
END. /*dSmartObject <> 0*/

    /******use for viewing the viewer to test if it is created correctly****
    framex:VISIBLE = TRUE.
    wwin:VISIBLE = TRUE.
    WAIT-FOR GO OF framex.
    ************/

/*cleanup*/
FOR EACH tmprecord NO-LOCK:
    IF VALID-HANDLE(tmprecord.tmpfldhdl) THEN
    DO:
        ASSIGN tmprecord.tmpfldhdl:VISIBLE = FALSE.
        DELETE WIDGET tmprecord.tmpfldhdl.
        ASSIGN tmprecord.tmpfldhdl = ?.
    END. /*valid-handle(tmprecord.tmpfldhdl)*/

    IF VALID-HANDLE(tmprecord.tmplabhdl) THEN
    DO:
        ASSIGN tmprecord.tmplabhdl:VISIBLE = FALSE.
        DELETE WIDGET tmprecord.tmplabhdl.
        ASSIGN tmprecord.tmplabhdl = ?.
    END. /*valid-handle(tmprecord.tmpfldhdl)*/
END. /*for eachtmprecord*/

DELETE WIDGET frameX.
ASSIGN frameX = ?.

RETURN.
/* -- EOF -- */
