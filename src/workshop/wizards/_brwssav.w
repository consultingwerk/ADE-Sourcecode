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
/*------------------------------------------------------------------
   _brwssav.w 

   Parse brwstmpl.dat with user selected options 

   Author: Michael Cavedon

------------------------------------------------------------------*/

  {webutil/wstyle.i}      /* Standard style definitions. */
  {workshop/errors.i}     /* Workshop Error Handling */
  {workshop/sharvars.i}   /* Workshop Shared Variables - Suppress DB Name */
  {webtools/help.i}
  {src/web/method/wrap-cgi.i}

  /* Output the MIME header. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).  

  {&OUT} '<body ' + get-body-phrase('wz_parse') + '>~n'.

  DEF VAR next-line AS CHAR NO-UNDO.
  DEF VAR SaveAsFile AS CHAR NO-UNDO.
  DEF VAR ReportTitle AS CHAR NO-UNDO.
  DEF VAR SearchLabel AS CHAR NO-UNDO.
  DEF VAR SearchString AS CHAR NO-UNDO.
  DEF VAR LinkField AS CHAR NO-UNDO.
  DEF VAR LinkedWebObject AS CHAR NO-UNDO.
  DEF VAR LinkTable AS CHAR NO-UNDO.
  DEF VAR l-Errors AS LOGICAL NO-UNDO.
  DEF VAR TargetFrame AS CHAR NO-UNDO.
  DEF VAR StatusLine AS CHAR NO-UNDO.
  DEF VAR DefineQuery AS CHAR NO-UNDO.
  DEF VAR OpenQuery AS CHAR NO-UNDO.
  DEF VAR GetQueryTables AS CHAR NO-UNDO.
  DEF VAR QueryTables AS CHAR EXTENT 50 NO-UNDO.
  DEF VAR QueryTableName AS CHAR NO-UNDO.
  DEF VAR ExternalTable AS CHAR NO-UNDO.
  DEF VAR GetDisplayFields AS CHAR NO-UNDO.
  DEF VAR DisplayFields AS CHAR EXTENT 50 NO-UNDO.
  DEF VAR SortField AS CHAR NO-UNDO.
  DEF VAR PrimarySortOrder AS CHAR NO-UNDO.
  DEF VAR SortByField AS CHAR NO-UNDO.
  DEF VAR SecondarySortFields AS CHAR NO-UNDO.
  DEF VAR SearchForm AS CHAR NO-UNDO.
  DEF VAR SearchValue AS CHAR NO-UNDO.
  DEF VAR NavPanel AS CHAR NO-UNDO.
  DEF VAR ColumnHeadings AS CHAR.
  DEF VAR Result-rows AS CHAR NO-UNDO.
  DEF VAR Border-size AS CHAR NO-UNDO.
  DEF VAR PageColor AS CHAR NO-UNDO.
  DEF VAR PageImage AS CHAR NO-UNDO.
  DEF VAR PageCustomColor AS CHAR NO-UNDO.
  DEF VAR TableColor AS CHAR NO-UNDO.
  DEF VAR TableImage AS CHAR NO-UNDO.
  DEF VAR LastHeading AS INTEGER.
  DEF VAR NumFields AS INTEGER NO-UNDO.
  DEF VAR NumTables AS INTEGER NO-UNDO.
  DEF VAR i-count AS INTEGER NO-UNDO.
  DEF VAR DefineBuffers AS CHAR NO-UNDO.
  DEF VAR p_fld_label AS CHAR NO-UNDO.
  DEF VAR p_fld_label_sa AS CHAR NO-UNDO.
  DEF VAR p_fld_format AS CHAR NO-UNDO.
  DEF VAR p_fld_format_sa AS CHAR NO-UNDO.
  DEF VAR p_fld_type AS CHAR NO-UNDO.
  DEF VAR p_fld_help AS CHAR NO-UNDO.
  DEF VAR p_fld_help_sa AS CHAR	NO-UNDO.
  DEF VAR p_fld_extent AS INTEGER NO-UNDO.
  DEF VAR p_fld_initial AS CHAR NO-UNDO.

  ASSIGN
    SaveAsFile        = TRIM(get-field("SaveAsFile":U)) 
    ReportTitle       = get-field("ReportTitle":U)
    LinkField         = get-field("LinkField":U)
    LinkedWebObject   = get-field("LinkedWebObject":U)
    TargetFrame       = get-field("TargetFrame":U)
    StatusLine        = get-field("StatusLine":U)
    DefineQuery       = get-field("DefineQuery":U)
    OpenQuery         = get-field("OpenQuery":U)
    GetQueryTables    = get-field("QueryTables":U)
    ExternalTable     = get-field("ExternalTable":U)
    GetDisplayFields  = get-field("DisplayFields":U)
    SortField         = get-field("SortFields":U)
    PrimarySortOrder  = get-field("PrimarySortOrder":U)
    SearchForm        = get-field("SearchForm":U)
    NavPanel          = get-field("NavPanel":U)
    ColumnHeadings    = get-field("ColumnHeadings":U)
    PageColor         = get-field("PageColor":U)
    PageImage         = get-field("PageImage":U)
    TableColor        = get-field("TableColor":U)
    TableImage        = get-field("TableImage":U)
    Result-rows       = get-field("Result-Rows":U)
    Border-size       = get-field("Border-Size":U)
    DefineBuffers     = get-field("DefineBuffers":U).

  FILE-INFO:FILE-NAME = SaveAsFile.
  IF get-field("OverWriteFile":U) eq "":U AND SEARCH(FILE-INFO:FULL-PATHNAME) ne ? THEN DO:
    l-errors = yes.
    {&OUT} '<UL>' format-filename (FILE-INFO:FULL-PATHNAME, "The file &1 already exists.", "":U) '</UL>~n':U.
    {&OUT} '<UL>Enter a new name, or ask to overwrite the existing file.</UL>~n':U.
  END.
  ELSE DO:
    /* Validate the file name as if this is a E4GL/HTML/TEXT file. The validation routine uses the
       workshop error handle. */
    RUN workshop/_valfnam.p (saveAsFile, "HTML,E4GL,TEXT":U, "VALIDATE":U, OUTPUT l-Errors).
    IF l-Errors THEN DO:
      {&OUT} format-filename (SaveAsFile, "Error saving to file &1:", "":U) '<UL>~n'.
      RUN output-errors IN _err-hdl ("VALIDATE":U, ?).
      {&OUT} '</UL>~n':U.
    END.
  END.
  
  /* Start Saving, if no errors.  Add close button if errors. */
  IF l-Errors THEN DO:
    {&OUT} '<form><INPUT TYPE="button" VALUE="Close" NAME="CloseWindow" onclick="window.close()"></form>~n'. 
  END.
  ELSE DO:
    /* Save the file. */ 
    {&OUT} format-filename (SaveAsFile, "Saving &1...", "":U).

    IF INDEX(SortField," ":U) ne 0 THEN
      ASSIGN
        SecondarySortFields = SUBSTRING(SortField,INDEX(SortField," ":U) + 1,LENGTH(SortField))
        SortField = SUBSTRING(SortField,1,INDEX(SortField," ":U) - 1).

    IF SortField eq "":U THEN
      ASSIGN
        SearchLabel = "":U
        SearchString = "":U.
    ELSE DO:
      RUN webutil/_fldinfo.p (INPUT SortField, 
                              OUTPUT p_fld_label,
                              OUTPUT p_fld_label_sa,
                              OUTPUT p_fld_format,
                              OUTPUT p_fld_format_sa,
                              OUTPUT p_fld_type,
                              OUTPUT p_fld_help,
                              OUTPUT p_fld_help_sa,
                              OUTPUT p_fld_extent,
                              OUTPUT p_fld_initial).
      CASE p_fld_type:
        WHEN "Character" THEN
          SearchValue = "search-value":U.
        WHEN "Integer" THEN
          SearchValue = "INTEGER(search-value)":U.
        WHEN "Decimal" THEN
          SearchValue = "DECIMAL(search-value)":U.
        WHEN "Date" THEN
          SearchValue = "DATE(search-value)":U.
        WHEN "Logical" THEN DO:
          SearchValue = '(IF search-value = "':U + ENTRY(1,p_fld_format,"/":U) + '"'.
          IF ENTRY(1,p_fld_format,"/":U) ne "Yes" THEN
            SearchValue = SearchValue + ' OR search-value = "Yes"':U.
          IF ENTRY(1,p_fld_format,"/":U) ne "TRUE" THEN
            SearchValue = SearchValue + ' OR search-value = "TRUE"':U.
          SearchValue = SearchValue + ' THEN TRUE ELSE FALSE)':U.
        END.
      END CASE.
      IF p_fld_extent > 0 THEN 
        ASSIGN
          OpenQuery = REPLACE(OpenQuery,SortField,SortField + "[1]":U)
          SortField = SortField + "[1]":U.
      IF _suppress_dbname AND NUM-ENTRIES(SortField,".":U) = 3 THEN
        SortField = SUBSTRING(SortField,INDEX(SortField,".":U) + 1,LENGTH(SortField)).
      SearchLabel = "html-encode(SearchField:LABEL IN FRAME SearchFrame + ':':U)":U.
      IF PrimarySortOrder = "Descending":U THEN
        SearchString = "AND ":U + SortField + " > ":U + SearchValue.
      ELSE
        SearchString = "AND ":U + SortField + " < ":U + SearchValue.
      
      SecondarySortFields:
      DO WHILE SecondarySortFields ne "":
        IF INDEX(SecondarySortFields," ":U) ne 0 THEN 
          SortByField = SUBSTRING(SecondarySortFields,1,INDEX(SecondarySortFields," ":U) - 1).
        ELSE
          SortByField = SecondarySortFields.
        RUN webutil/_fldinfo.p (INPUT SortByField, 
                                OUTPUT p_fld_label,
                                OUTPUT p_fld_label_sa,
                                OUTPUT p_fld_format,
                                OUTPUT p_fld_format_sa,
                                OUTPUT p_fld_type,
                                OUTPUT p_fld_help,
                                OUTPUT p_fld_help_sa,
                                OUTPUT p_fld_extent,
                                OUTPUT p_fld_initial).
        IF p_fld_extent > 0 THEN 
          OpenQuery = REPLACE(OpenQuery,SortByField,SortByField + "[1]":U).
        IF INDEX(SecondarySortFields," ":U) ne 0 THEN 
          SecondarySortFields = SUBSTRING(SecondarySortFields,INDEX(SecondarySortFields," ":U) + 1,LENGTH(SecondarySortFields)).
        ELSE
          LEAVE SecondarySortFields.
      END.

    END.

    StripDisplayFields:
    DO NumFields = 1 TO 50:
      IF GetDisplayFields ne "":U THEN DO:
        IF INDEX(GetDisplayFields," ":U) ne 0 THEN DO:
          DisplayFields[NumFields] = SUBSTRING(GetDisplayFields,1,INDEX(GetDisplayFields," ":U) - 1).
          RUN webutil/_fldinfo.p (INPUT DisplayFields[NumFields], 
                                  OUTPUT p_fld_label,
                                  OUTPUT p_fld_label_sa,
                                  OUTPUT p_fld_format,
                                  OUTPUT p_fld_format_sa,
                                  OUTPUT p_fld_type,
                                  OUTPUT p_fld_help,
                                  OUTPUT p_fld_help_sa,
                                  OUTPUT p_fld_extent,
                                  OUTPUT p_fld_initial).
          IF p_fld_extent > 0 THEN 
            DisplayFields[NumFields] = DisplayFields[NumFields] + "[1]":U.
          IF _suppress_dbname AND NUM-ENTRIES(DisplayFields[NumFields],".":U) = 3 THEN
            DisplayFields[NumFields] = SUBSTRING(DisplayFields[NumFields],INDEX(DisplayFields[NumFields],".":U) + 1,LENGTH(DisplayFields[NumFields])).
          GetDisplayFields = SUBSTRING(GetDisplayFields,INDEX(GetDisplayFields," ":U) + 1,LENGTH(GetDisplayFields)).
        END.
        ELSE DO:
          DisplayFields[NumFields] = GetDisplayFields.
          RUN webutil/_fldinfo.p (INPUT DisplayFields[NumFields], 
                                  OUTPUT p_fld_label,
                                  OUTPUT p_fld_label_sa,
                                  OUTPUT p_fld_format,
                                  OUTPUT p_fld_format_sa,
                                  OUTPUT p_fld_type,
                                  OUTPUT p_fld_help,
                                  OUTPUT p_fld_help_sa,
                                  OUTPUT p_fld_extent,
                                  OUTPUT p_fld_initial).
          IF p_fld_extent > 0 THEN 
            DisplayFields[NumFields] = DisplayFields[NumFields] + "[1]":U.
          IF _suppress_dbname AND NUM-ENTRIES(DisplayFields[NumFields],".":U) = 3 THEN
            DisplayFields[NumFields] = SUBSTRING(DisplayFields[NumFields],INDEX(DisplayFields[NumFields],".":U) + 1,LENGTH(DisplayFields[NumFields])).
          LEAVE StripDisplayFields.
        END.
      END.
      ELSE DO:
        NumFields = NumFields - 1.
        LEAVE StripDisplayFields.
      END.
    END.
  
    StripQueryTables:
    DO NumTables = 1 TO 50:
      IF GetQueryTables ne "":U THEN DO:
        IF INDEX(GetQueryTables," ":U) ne 0 THEN DO:
          QueryTables[NumTables] = SUBSTRING(GetQueryTables,1,INDEX(GetQueryTables," ":U) - 1).
          IF _suppress_dbname AND NUM-ENTRIES(QueryTables[NumTables],".":U) = 2 THEN DO:
            ASSIGN
              QueryTableName = QueryTables[NumTables]
              QueryTables[NumTables] = SUBSTRING(QueryTables[NumTables],INDEX(QueryTables[NumTables],".":U) + 1,LENGTH(QueryTables[NumTables])).
            DefineQuery = REPLACE(DefineQuery,QueryTableName,QueryTables[NumTables]).
            OpenQuery = REPLACE(OpenQuery,QueryTableName,QueryTables[NumTables]).
            DefineBuffers = REPLACE(DefineBuffers,QueryTableName,QueryTables[NumTables]).
          END.
          GetQueryTables = SUBSTRING(GetQueryTables,INDEX(GetQueryTables," ":U) + 1,LENGTH(GetQueryTables)).
        END.
        ELSE DO:
          QueryTables[NumTables] = GetQueryTables.
          IF _suppress_dbname AND NUM-ENTRIES(QueryTables[NumTables],".":U) = 2 THEN DO:
            ASSIGN
              QueryTableName = QueryTables[NumTables]
              QueryTables[NumTables] = SUBSTRING(QueryTables[NumTables],INDEX(QueryTables[NumTables],".":U) + 1,LENGTH(QueryTables[NumTables])).
            DefineQuery = REPLACE(DefineQuery,QueryTableName,QueryTables[NumTables]).
            OpenQuery = REPLACE(OpenQuery,QueryTableName,QueryTables[NumTables]).
            DefineBuffers = REPLACE(DefineBuffers,QueryTableName,QueryTables[NumTables]).
          END.
          LEAVE StripQueryTables.
        END.
      END.
      ELSE DO:
        NumTables = NumTables - 1.
        LEAVE StripQueryTables.
      END.
    END.
  
    IF LinkField ne "None":U THEN DO:
      IF NUM-ENTRIES(LinkField,".":U) = 3 THEN DO:
        IF _suppress_dbname THEN
          ASSIGN
            LinkField = SUBSTRING(LinkField,INDEX(LinkField,".":U) + 1,LENGTH(LinkField))
            LinkTable = ENTRY(1,LinkField,".":U).
        ELSE
          LinkTable = ENTRY(1,LinkField,".":U) + ".":U + ENTRY(2,LinkField,".":U).
      END.
      ELSE
        LinkTable = ENTRY(1,LinkField,".":U).
    END.

    IF ExternalTable ne "":U AND _suppress_dbname AND NUM-ENTRIES(ExternalTable,".":U) = 2 THEN
      ExternalTable = SUBSTRING(ExternalTable,INDEX(ExternalTable,".":U) + 1,LENGTH(ExternalTable)).

    IF Result-Rows = "All":U THEN
      Result-Rows = "100000".

    DEF STREAM tempStream.
    DEF STREAM outStream.

    /* Create the input and output streams. */
    INPUT STREAM tempStream FROM VALUE(SEARCH("workshop/wizards/brwstmpl.dat")) NO-ECHO.

    OUTPUT STREAM outStream TO VALUE(SaveAsFile) NO-ECHO.
    
    Read-Block:
    REPEAT ON ENDKEY UNDO Read-Block, LEAVE Read-Block:
      /* Read the next line from the template. Replace key lines with generated
         code and output the rest. */
      IMPORT STREAM tempStream UNFORMATTED next-line.

      next-line = REPLACE(next-line, "##ReportTitle##":U, ReportTitle).    
      next-line = REPLACE(next-line, "##SearchLabel##":U, SearchLabel).
      next-line = REPLACE(next-line, "##SearchString##":U, SearchString).
      next-line = REPLACE(next-line, "##Query-Table##":U, QueryTables[1]).    
      next-line = REPLACE(next-line, "##SortField##":U, SortField).    
      next-line = REPLACE(next-line, "##Result-Rows##":U, Result-rows).
      next-line = REPLACE(next-line, "##Border-Size##":U, Border-size).

      PUT STREAM outStream UNFORMATTED next-line + "~n":U.

      IF next-line = '</head>':U THEN DO:
        IF PageImage ne "":U THEN 
          PUT STREAM OutStream UNFORMATTED
            '~n<body background="' + PageImage + '">~n':U.
        ELSE DO:
          IF PageColor = "Default":U OR PageColor = "":U THEN
            PUT STREAM OutStream UNFORMATTED
              '~n<body>~n':U.
          ELSE 
            PUT STREAM OutStream UNFORMATTED 
              '~n<body bgcolor="' + PageColor + '">~n':U.
        END.
      END.

      IF next-line MATCHES '*DEF VAR NavRowid*':U THEN DO:
        IF NumTables > 1 THEN DO:
          DO i-count = 2 to NumTables:
            PUT STREAM outStream UNFORMATTED
              '  DEF VAR NavRowid':U + STRING(i-count) + '      AS CHAR NO-UNDO.~n':U.
          END.
        END.
      END.

      IF next-line MATCHES '*DEF VAR DelimiterField*':U THEN DO:
        IF SearchForm = "Yes":U THEN 
          PUT STREAM outStream UNFORMATTED
            '  DEF VAR SearchForm     AS LOGICAL INITIAL TRUE NO-UNDO.~n':U.
        ELSE
          PUT STREAM outStream UNFORMATTED
            '  DEF VAR SearchForm     AS LOGICAL INITIAL FALSE NO-UNDO.~n':U.
        IF NavPanel = "Yes":U THEN 
          PUT STREAM outStream UNFORMATTED
            '  DEF VAR NavPanel       AS LOGICAL INITIAL TRUE NO-UNDO.~n':U.
        ELSE
          PUT STREAM outStream UNFORMATTED
            '  DEF VAR NavPanel AS LOGICAL INITIAL FALSE NO-UNDO.~n':U.
        IF DefineBuffers ne "":U THEN
          PUT STREAM outStream UNFORMATTED
            '~n':U
            DefineBuffers
            '~n':U.
        PUT STREAM outStream UNFORMATTED 
          '~n':U
          '  /* Form Buffer for column labels and display data formats */~n':U
          '  FORM~n':U.
        DO i-count = 1 TO NumFields:
          PUT STREAM outStream UNFORMATTED
            '    ':U + DisplayFields[i-count] + '~n':U.
        END.
        PUT STREAM outStream UNFORMATTED
          '    WITH FRAME ReportFrame.~n':U.
      END.

      IF next-line MATCHES '*get-field("NavRowid":U)*':U THEN DO:
        IF NumTables > 1 THEN DO:
          DO i-count = 2 to NumTables:
            PUT STREAM outStream UNFORMATTED
              '    NavRowid':U + STRING(i-count) + '   = get-field("NavRowid':U + STRING(i-count) + '":U)~n':U.
          END.
        END.
      END.

      IF next-line MATCHES '*Display "Search" Form*':U THEN DO: 
        IF SortField ne "":U THEN 
          PUT STREAM outStream UNFORMATTED
            '  /* Create form buffer for correct Search Field label */~n':U
            '  DEF VAR SearchField LIKE ':U + SortField ' NO-UNDO.~n':U
            '  DISPLAY SearchField WITH FRAME SearchFrame.~n':U.
      END.

      IF next-line MATCHES '*External Table Reference*':U THEN DO:
        IF ExternalTable ne "":U THEN
          PUT STREAM outStream UNFORMATTED 
            '~n/* Find the record for the table defined as external */~n':U
            'FIND ':U + ExternalTable + ' WHERE ROWID(':U + ExternalTable + ') = TO-ROWID(LinkRowid) NO-LOCK NO-ERROR.~n':U
            'IF NOT AVAILABLE ':U + ExternalTable + ' THEN DO:~n':U
            '  ~{&OUT~} ~'<p>No link table found.  Finding first record for standalone testing.<p>~~n~':U.~n':U
            '  FIND FIRST ':U + ExternalTable + ' NO-LOCK NO-ERROR.~n':U
            '  LinkRowid = STRING(ROWID(':U + ExternalTable + ')).~n':U
            'END.~n':U.
      END.

      IF next-line MATCHES '*Define the Query*':U THEN 
        PUT STREAM outStream UNFORMATTED DefineQuery + '~n':U.
  
      IF next-line MATCHES '*Open the Query*':U THEN
        PUT STREAM outStream UNFORMATTED OpenQuery + '~n':U.
 
      IF next-line MATCHES '*WHEN "Prev" THEN DO*':U OR 
         next-line MATCHES '*WHEN "Next" THEN DO*':U THEN DO:
        PUT STREAM outStream UNFORMATTED
          '          REPOSITION Browse-Qry TO ROWID TO-ROWID(NavRowid) NO-ERROR.~n':U
          '          IF NOT ERROR-STATUS:ERROR THEN DO:~n':U.
        IF NumTables > 1 THEN DO:
          PUT STREAM outStream UNFORMATTED 
            '            GET NEXT Browse-Qry NO-LOCK.~n':U
            '            DO WHILE AVAILABLE ':U + QueryTables[1] + '~n':U
            '              AND (':U. 
          DO i-count = 2 TO NumTables:
            IF i-count > 2 THEN
              PUT STREAM outStream UNFORMATTED ' OR ':U.
            PUT STREAM outStream UNFORMATTED 
              'ROWID(':U + QueryTables[i-count] + ') ne TO-ROWID(NavRowid':U + STRING(i-count) + ')':U. 
          END.
          PUT STREAM outStream UNFORMATTED 
            '):~n':U
            '              GET NEXT Browse-Qry NO-LOCK.~n':U
            '            END.~n':U.
          IF next-line MATCHES '*WHEN "Prev" THEN DO*' THEN
            PUT STREAM outStream UNFORMATTED 
              '            REPOSITION Browse-Qry BACKWARDS 2 NO-ERROR.~n':U.
        END.
        ELSE 
          IF next-line MATCHES '*WHEN "Prev" THEN DO*' THEN
            PUT STREAM outStream UNFORMATTED
              '            GET PREV Browse-QRY NO-LOCK.~n':U.
          ELSE
            PUT STREAM outStream UNFORMATTED
              '            GET NEXT Browse-Qry NO-LOCK.~n':U.
      END.

      IF next-line MATCHES '*Display Table Definition*':U THEN DO:
        IF TableImage ne "":U THEN 
          PUT STREAM outStream UNFORMATTED
            '<table background="' + TableImage + '" border="' + border-size + '">~n':U.
        ELSE DO:
          IF TableColor = "Default":U OR TableColor = "":U THEN
            PUT STREAM outStream UNFORMATTED
              '<table border="' + border-size + '">~n':U.
          ELSE
            PUT STREAM outStream UNFORMATTED 
              '<table bgcolor="' + TableColor + '" border="' + border-size + '">~n':U.
        END.
      END.
  
      IF next-line MATCHES '*Display Column Headings*':U THEN DO:
        IF ColumnHeadings eq "Yes":U THEN DO:
          DO i-count = 1 TO NumFields:
            PUT STREAM outStream UNFORMATTED
              '<th>`html-encode(':U + DisplayFields[i-count] + ':LABEL IN FRAME ReportFrame)`</th>~n':U.
          END.
        END.
      END.

      IF next-line MATCHES '*Create form buffer for correct data display format*':U THEN DO:
        PUT STREAM outStream UNFORMATTED '        DISPLAY~n':U.
        DO i-count = 1 TO NumFields:
          PUT STREAM outStream UNFORMATTED '          ':U + DisplayFields[i-count] + '~n':U.
        END.
        PUT STREAM outStream UNFORMATTED '          WITH FRAME ReportFrame.~n':U.
      END.

      IF next-line MATCHES '*If more than one table defined in Query, add ROWID here*':U THEN DO:
        IF NumTables > 1 THEN DO:
          DO i-count = 2 TO NumTables:
            PUT STREAM outStream UNFORMATTED 
              '         TmpUrl = TmpUrl + url-field("NavRowid':U + STRING(i-count) + '":U,STRING(ROWID(':U + QueryTables[i-count] + ')),DelimiterField).~n':U
              '         IF INDEX(TmpUrl,"?") > 0~n':U
              '           THEN DelimiterField = ?.~n':U
              '           ELSE DelimiterField = "?".~n':U.
          END.
        END.
      END.

      IF next-line MATCHES '*Output the requested Display Fields*':U THEN DO:
        PUT STREAM outStream UNFORMATTED 
          '</script>~n':U
          '        <tr>~n':U.
        PutDisplayFields:
        DO i-count = 1 TO NumFields:
          IF DisplayFields[i-count] = LinkField THEN
            PUT STREAM outStream UNFORMATTED
              '          <td><a href="`url-encode(~'':U +  LinkedWebObject + '~',~'Default~') + url-field(~'LinkRowid~',STRING(ROWID(':U + LinkTable + ')),~'?~')`"~n':U
              '          target="':U + TargetFrame + '"~n':U
              '          onMouseover="window.status=~'':U + StatusLine + '~';return true"~n':U
              '          onMouseout="window.status=~'~';return true">`html-encode(':U + DisplayFields[i-count] + ':SCREEN-VALUE IN FRAME ReportFrame)`</a></td>~n':U.
          ELSE
            PUT STREAM outStream UNFORMATTED
              '          <td>`html-encode(':U + DisplayFields[i-count] + ':SCREEN-VALUE IN FRAME ReportFrame)`</td>~n':U.
        END.
        PUT STREAM outStream UNFORMATTED 
          '        </tr>~n':U
          '<script language="SpeedScript">~n':U.
      END. 
  
    END.
 
    INPUT STREAM tempStream CLOSE.
    OUTPUT STREAM outStream CLOSE.
  
    FILE-INFO:FILE-NAME = SaveAsFile.
    {&OUT} '<UL>File saved (<I>' FILE-INFO:FULL-PATHNAME '</I>).</UL>'.
    RUN webtools/util/_fileact.p (SaveAsFile, FILE-INFO:FULL-PATHNAME, "Compile":U, "No-Head,No-w-save-message":U).
  
    {&OUT} '<form><INPUT TYPE="button" VALUE="Close" NAME="CloseWindow"~n'
           'onclick="window.close()"></form>~n'.
    
  END.
  
