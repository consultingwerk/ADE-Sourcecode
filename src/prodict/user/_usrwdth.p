/*********************************************************************
* Copyright (C) 2005,2007,2016 by Progress Software Corporation. All *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _usrwdth.p

History:  
   09/18/02   D. McMann    Created
   09/16/05   K. McIntosh  Prevented deletion of valid report data, also found
                           & fixed problem with usage of BUFFER-VALUE in LENGTH
                           function for INTEGER elements of arrays 20031121-042.
   10/26/07   fernando     Make sure recommended length is not > 31995 - OE00098662
   08/03/16   Rohit K      proper handling of decimal data with negative values

----------------------------------------------------------------------------*/

{ prodict/fhidden.i }

DEFINE INPUT PARAMETER p_DbId  AS RECID      NO-UNDO.
DEFINE INPUT PARAMETER p_Tbl   AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER p_how   AS CHARACTER  NO-UNDO.

DEFINE SHARED STREAM rpt.

DEFINE VARIABLE line         AS CHARACTER              NO-UNDO.
DEFINE VARIABLE scr-count    AS INTEGER                NO-UNDO.
DEFINE VARIABLE lReturnValue AS LOGICAL                NO-UNDO.
DEFINE VARIABLE lDefName    AS CHARACTER FORMAT "x(6)" NO-UNDO.  

DEFINE TEMP-TABLE sc-rpt
    FIELD rpt-id   AS INTEGER
    FIELD rpt-line AS CHARACTER FORMAT "x(60)"
    INDEX rpt rpt-id.

DEFINE TEMP-TABLE ttField
    FIELD tField-Name   LIKE DICTDB._Field._Field-Name 
    FIELD tWidth        LIKE DICTDB._Field._Width
    FIELD tDecimals     LIKE DICTDB._Field._Decimals
    INDEX IdxField-Name IS PRIMARY tField-Name.

DEFINE TEMP-TABLE ttExceed
    FIELD tFile-Name    LIKE DICTDB._File._File-Name 
    FIELD tField-Name   LIKE DICTDB._Field._Field-Name 
    FIELD tFormat       LIKE DICTDB._Field._Format
    FIELD tdtype        LIKE DICTDB._Field._Data-Type
    FIELD tExtent       LIKE DICTDB._Field._Extent
    FIELD tDecimals     LIKE DICTDB._Field._Decimals
    FIELD tDecData      LIKE DICTDB._Field._Decimals  /* Maximum decimals found */ 
    FIELD tWidth        LIKE DICTDB._Field._Width
    FIELD tFmtLen       AS INTEGER                  /* The length of the format */ 
    FIELD tKey          AS LOGICAL
    FIELD tNumberErr    AS INTEGER                   /* Number of format/width errors found for field */ 
    FIELD tNumberDec    AS INTEGER                   /* Number records with a field that exeeded the maximum number of decimal places */ 
    FIELD tLength       AS INTEGER
    FIELD tSize         AS INTEGER
    FIELD tMaxValue     AS CHARACTER                 /* Maximum falue for field exceeding format/width */
    FIELD tMaxDec       AS CHARACTER                 /* Value showing most significant decimal places. */ 
    FIELD tLargeValue   AS CHARACTER                 /* Largest decimal value, for comparision with longest */
    FIELD tDecOnly      AS LOGICAL 
    INDEX IdxFField-Name IS PRIMARY tFile-Name tField-Name.

DEFINE QUERY qFileSchema FOR DICTDB._File CACHE 50. 

FORM
  SKIP(1) 
  SPACE(3) DICTDB._File._File-name LABEL "Working on" FORMAT "x(32)" SPACE
  SKIP(1)
  WITH FRAME working_on SIDE-LABELS VIEW-AS DIALOG-BOX  
  TITLE "Generating Report".

FORM
    rpt-line
    WITH FRAME shorpt STREAM-IO DOWN USE-TEXT NO-LABELS.

FUNCTION LengthDecimal RETURNS INTEGER
  ( INPUT pDec AS DECIMAL )  FORWARD.

/*===========================Mainline code=================================*/

IF p_Tbl = "ALL" THEN
   SESSION:IMMEDIATE-DISPLAY = yes.
   
FIND _Db NO-LOCK WHERE RECID(_Db) = p_DbId.

lReturnValue = SESSION:SET-WAIT-STATE("general"). 

RUN Process-Tables NO-ERROR. 

HIDE FRAME working_on NO-PAUSE.
RUN Display-Report.
HIDE FRAME shorpt NO-PAUSE.
RETURN.

PROCEDURE Display-Report:
/* The purpose of this rountin is to display the information generated when checking
   the data.
*/

  FIND FIRST sc-rpt NO-ERROR.
  IF NOT AVAILABLE sc-rpt THEN DO:
    CREATE sc-rpt.
    ASSIGN rpt-line = "No data was found that exceeds the report's criteria. ".
  END.

  PAGE STREAM rpt.

  FOR EACH sc-rpt:
    DISPLAY STREAM rpt rpt-line WITH FRAME shorpt.
    DOWN STREAM rpt WITH FRAME shorpt.
  END.

END PROCEDURE.

PROCEDURE Process-Tables :
/*------------------------------------------------------------------------------
  Purpose: The purpose of this routine is to create records in a temporary table
            that identify the character and decimal fields that have data that 
            exceed either the format or the width.  The determination of format
            or width is set by a global variable.  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lBufHndl     AS HANDLE NO-UNDO.
DEFINE VARIABLE lQryHndl     AS HANDLE NO-UNDO.
DEFINE VARIABLE iIdx         AS INTEGER NO-UNDO.
DEFINE VARIABLE lFieldHndl   AS HANDLE NO-UNDO. 
DEFINE VARIABLE lLength      AS INTEGER NO-UNDO. 
DEFINE VARIABLE lPrint       AS LOGICAL INITIAL TRUE NO-UNDO. 
DEFINE VARIABLE lDecOnly     AS LOGICAL NO-UNDO. 
DEFINE VARIABLE lSize        AS INTEGER NO-UNDO. 
DEFINE VARIABLE lErrorFld    AS LOGICAL NO-UNDO. 
DEFINE VARIABLE lWidth       AS INTEGER NO-UNDO. 
DEFINE VARIABLE lNumDecimals AS INTEGER NO-UNDO. 
DEFINE VARIABLE TmpDec       AS DECIMAL NO-UNDO. 

/* Clear the temporary table */ 
FOR EACH ttExceed: 
    DELETE ttExceed. 
END.  

ASSIGN scr-count = 1.

IF p_Tbl = "ALL" THEN 
  OPEN QUERY qFileSchema FOR EACH DICTDB._File WHERE DICTDB._File._Tbl-Type = "T" 
                                               AND   DICTDB._File._Owner = "PUB" NO-LOCK.
ELSE
  OPEN QUERY qFileSchema FOR EACH DICTDB._File WHERE DICTDB._File._Tbl-Type = "T" 
                                               AND   DICTDB._File._Owner = "PUB" 
                                               AND   DICTDB._File._File-name = p_Tbl NO-LOCK.

  File-loop: 
  REPEAT:
    GET NEXT qFileSchema.
    IF NOT AVAILABLE DICTDB._File THEN 
        LEAVE File-loop.

    DISPLAY DICTDB._File._File-name WITH FRAME working_on.

    RUN LocateFields.

    CREATE BUFFER lBufHndl FOR TABLE DICTDB._File._File-Name.
    CREATE QUERY  lQryHndl.
    lQryHndl:SET-BUFFERS(lBufHndl).
    lQryHndl:QUERY-PREPARE("FOR EACH " + DICTDB._File._File-Name).
    lQryHndl:QUERY-OPEN.

    Data-Loop: 
    REPEAT:   
      /* Process all of the data records for the selected table. */ 

      lQryHndl:GET-NEXT.      /* get the next data record from current DICTDB._File._File-Name */ 
      IF lQryHndl:QUERY-OFF-END THEN DO:
        /* All data records have been processed */
        /* Print information if fields were found that exceeded format/width */ 
        RUN DisplayFieldInfo (INPUT DICTDB._File._File-Name).
        LEAVE Data-Loop.
      END.
    
      ttField-loop: 
      FOR EACH ttField:
        /* For each field in the temporary table that is character or decimal */ 
        ASSIGN  lFieldHndl  = lBufHndl:buffer-field(ttField.tField-Name) 
                iIdx        = 1         /* Set extent index. */  
                lErrorFld    = FALSE.   /* Initialize value that no errors have been found. */ 

        Extent-loop: 
        REPEAT:
          IF lFieldHndl:EXTENT > 0 THEN DO:
            IF CAN-DO("XLOB,CLOB,BLOB,CHARACTER,RAW",lFieldHndl:DATA-TYPE) THEN
              lLength = LENGTH(lFieldHndl:BUFFER-VALUE(iIdx), 
                               "CHARACTER") NO-ERROR. 
            ELSE IF lFieldHndl:DATA-TYPE = "decimal" THEN /* Type is decimal */
              lLength = LengthDecimal(DECIMAL(lFieldHndl:BUFFER-VALUE(iIdx))).
            ELSE 
              lLength = LENGTH(STRING(lFieldHndl:BUFFER-VALUE(iIdx)),
                               "CHARACTER") NO-ERROR.
          END.
          ELSE DO:
            IF CAN-DO("XLOB,CLOB,BLOB,CHARACTER,RAW",lFieldHndl:DATA-TYPE) THEN
              lLength = LENGTH(lFieldHndl:BUFFER-VALUE, 
                               "CHARACTER") NO-ERROR. 
            ELSE IF lFieldHndl:DATA-TYPE = "decimal" THEN /* Type is decimal */
              lLength = LengthDecimal(DECIMAL(lFieldHndl:BUFFER-VALUE)).
            ELSE lLength = LENGTH(STRING(lFieldHndl:BUFFER-VALUE),
                                  "CHARACTER") NO-ERROR.
          END.
          /* If the data exceeds the size of the format then process the data ... */
          /*    The buffer-field object handle value WIDTH-CHARS is derived from the field format */ 
          
          ASSIGN  lPrint   = FALSE
                  lDecOnly = FALSE. 

          IF p_how = "W" AND lLength > ttField.tWidth THEN DO: 
            IF lFieldHndl:EXTENT > 0 THEN  
              ASSIGN lWidth = ((ttField.tWidth / 2) / lFieldHndl:EXTENT) - 1.                 
            ELSE 
              ASSIGN lWidth = INTEGER(ttField.tWidth).   
                       
              /* Width was selected so only put message in the report if the width is exceeded. */ 
            IF lLength > lWidth THEN      
              ASSIGN  lPrint      = TRUE
                      lSize       = lWidth. 
            ELSE 
               /* Width is not exceeded, only format */ 
              NEXT ttField-loop. 
          END.
          ELSE IF lLength > (lFieldHndl:WIDTH-CHARS) THEN            
            ASSIGN  lPrint      = TRUE
                    lSize       = lFieldHndl:WIDTH-CHARS. 

                    
          IF lFieldHndl:DATA-TYPE = "decimal" THEN DO: 
            /* Get the number of significant decimal places for this decimal value. */ 
            IF lFieldHndl:EXTENT > 0 THEN  
              lNumDecimals = 
                LENGTH(STRING(ABSOLUTE(DECIMAL(lFieldHndl:BUFFER-VALUE(iIdx)) - 
                              TRUNCATE(DECIMAL(lFieldHndl:BUFFER-VALUE(iIdx)),
                                       0)))) NO-ERROR.
            ELSE
              lNumDecimals = 
                LENGTH(STRING(ABSOLUTE(DECIMAL(lFieldHndl:BUFFER-VALUE) - 
                              TRUNCATE(DECIMAL(lFieldHndl:BUFFER-VALUE),
                                       0)))) NO-ERROR.

            /* Subtract 1 to remove the counting of the decimal place. */ 
            lNumDecimals = lNumDecimals - 1. 

              /* If the number of decimal places is greater than the schema definition ...  */ 
            IF lNumDecimals > ttField.tDecimals THEN  
              ASSIGN  lDecOnly    = NOT lPrint  
                      lPrint      = TRUE. 
                                     
          END.

          IF lPrint THEN DO: 
              /* Keep track of the informaiton to be printed and possibly updated. */ 
            FIND ttExceed WHERE ttExceed.tFile  = lFieldHndl:TABLE
                            AND   ttExceed.tField = lFieldHndl:NAME NO-ERROR.
            IF NOT AVAILABLE ttExceed THEN DO: 
              CREATE ttExceed. 
              ASSIGN  ttExceed.tFile          = lFieldHndl:TABLE
                      ttExceed.tField         = lFieldHndl:NAME
                      ttExceed.tWidth         = ttField.tWidth
                      ttExceed.tFormat        = lFieldHndl:FORMAT 
                      ttExceed.tFmtLen        = lFieldHndl:WIDTH-CHARS 
                      ttExceed.tSize          = lSize
                      ttExceed.tKey           = lFieldHndl:KEY
                      ttExceed.tdtype         = lFieldHndl:DATA-TYPE
                      ttExceed.tDecimals      = ttField.tDecimals                               
                      ttExceed.tDecData       = 0                                
                      ttExceed.tExtent        = lFieldHndl:EXTENT     
                      ttExceed.tNumberErr     = 0
                      ttExceed.tNumberDec     = 0 
                      ttExceed.tDecOnly       = lDecOnly.
            END. 

              /* the tDecOnly field is used to control the reporting and printing.
                 If tDecOnly is true then the format/width has not been exceeded.  */                                                                                                
            IF NOT lDecOnly THEN  
              ASSIGN  ttExceed.tNumberErr = ttExceed.tNumberErr + 1
                        ttExceed.tDecOnly   = NO.

            IF lNumDecimals > ttField.tDecimals THEN DO:
              ASSIGN ttExceed.tNumberDec = ttExceed.tNumberDec + 1. 
              IF lNumDecimals > ttExceed.tDecData THEN  
                  ASSIGN ttExceed.tDecData   = lNumDecimals.                  
            END. 

              /* Keep track of the longest field over the definition size */ 
            IF lLength > ttExceed.tLength THEN 
              ASSIGN ttExceed.tLength   = lLength. 
               
          END. /* IF lPrint */ 

          IF lFieldHndl:EXTENT > 0 THEN DO:
            ASSIGN iIdx = iIdx + 1. 
            IF iIdx > lFieldHndl:EXTENT THEN 
              LEAVE Extent-loop. 
          END.
          ELSE   /* Process only once for non-extent field */ 
            LEAVE Extent-loop.        
        END.  /* Extent-loop */ 
      END. /* ttField-loop */ 
    END. /* Data-Loop */
    
    DELETE OBJECT lQryHndl.
    DELETE OBJECT lBufHndl.
  END. /* File-loop */ 

RETURN. 
END PROCEDURE.

PROCEDURE LocateFields :
/*------------------------------------------------------------------------------
  Purpose: Create temporary table records with meta schema information on the 
            width and the decimal values.  Only these fields are needed since the
            buffer-field object handle provides access to all of the other meta
            schema information that is needed.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Clear the temporary table */ 
    FOR EACH ttField: 
        DELETE ttField. 
    END.  

    field-loop: 
    FOR EACH DICTDB._Field WHERE DICTDB._Field._File-recid = RECID(DICTDB._File)
                    AND   (DICTDB._Field._Data-Type  = "character"
                           OR DICTDB._Field._Data-Type  = "decimal"
                           OR DICTDB._Field._Data-type = "raw"
                           OR DICTDB._Field._Extent > 0) NO-LOCK:     

        CREATE ttField.
        CASE DICTDB._Field._Data-Type:
            WHEN "character" OR WHEN "raw" THEN DO: 
                ASSIGN  tField-Name   =    DICTDB._Field._Field-Name
                        tWidth        =    DICTDB._Field._Width.
            END.
            WHEN "decimal" THEN DO: 
                ASSIGN  tField-Name   =    DICTDB._Field._Field-Name
                        tWidth        =    DICTDB._Field._Width
                        tDecimals     =    DICTDB._Field._Decimals.
            END.
            OTHERWISE 
                ASSIGN tField-name    =    DICTDB._Field._Field-name
                       tWidth         =    DICTDB._Field._Width.
        END CASE.        
    END. 
    RETURN. 
END PROCEDURE.

PROCEDURE DisplayFieldInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pFile AS CHARACTER NO-UNDO.

DEFINE VARIABLE numrec AS INTEGER NO-UNDO.
DEFINE VARIABLE size   AS INTEGER NO-UNDO.

FIND FIRST ttExceed WHERE ttExceed.tFile = pFile NO-ERROR.

IF AVAILABLE ttExceed THEN DO:
    /* At least one field exists that should be modified in the selected table. */ 
    FIND FIRST sc-rpt NO-ERROR.
    IF AVAILABLE sc-rpt THEN DO:
      CREATE sc-rpt.
      ASSIGN rpt-id = scr-count
             rpt-line = "  "
             scr-count = scr-count + 1.
    END.

    CREATE sc-rpt.
    ASSIGN rpt-id = scr-count
           rpt-line = ttExceed.tFile-Name  + " Table"
           scr-count = scr-count + 1.

    numrec = scr-count.
END.

_crt-rpt:
FOR EACH ttExceed WHERE ttExceed.tFile = pFile: 
    IF ttExceed.tExtent > 0 AND (((ttExceed.tLength + 1) * ttExceed.tExtent) < ttExceed.tWidth) THEN
       NEXT _crt-rpt.
    
    /* Do not add to report for format/width if this is a decimal only issue. */ 
    IF ttExceed.tDecOnly = NO THEN DO:             
        CREATE sc-rpt.
        ASSIGN rpt-id = scr-count
               rpt-line = "  " + ttExceed.tField-Name
               scr-count = scr-count + 1.
        CREATE sc-rpt.
        ASSIGN rpt-id = scr-count
               rpt-line =  "      Number of records exceeding format: " + (IF ttExceed.tExtent > 0 THEN STRING(INTEGER(tNumberErr / ttExceed.tExtent))
                                                                           ELSE STRING(tNumberErr))
               scr-count = scr-count + 1.
        CREATE sc-rpt.
        ASSIGN rpt-id = scr-count
               rpt-line =  "      Data type: " + ttExceed.tdtype +  "   Used in an index: " + STRING(ttExceed.tKey)
               scr-count = scr-count + 1.
        CREATE sc-rpt.
        ASSIGN rpt-id = scr-count
               rpt-line =  "      Format Length: " + STRING(ttExceed.tFmtLen) + "       Format: " + ttExceed.tFormat
               scr-count = scr-count + 1.
        CREATE sc-rpt.
        ASSIGN rpt-id = scr-count
               rpt-line =  "      Width: " + STRING(ttExceed.tWidth )
               scr-count = scr-count + 1.
        IF ttExceed.tExtent = 0 THEN DO:
          CREATE sc-rpt.
          ASSIGN rpt-id = scr-count
                 rpt-line =  "      Longest Data Length: " + STRING(ttExceed.tLength)
                 scr-count = scr-count + 1.
        END.
        ELSE DO:
          CREATE sc-rpt.
          ASSIGN rpt-id = scr-count
                 rpt-line =  "      Longest Individual Element: " + STRING(ttExceed.tLength)
                 scr-count = scr-count + 1.
        END.
       
      
       /* SQL client cannot access fields having widths greater than 31995 */
       ASSIGN size = ((ttExceed.tLength + 1) * ttExceed.tExtent).
       IF size > 31995 THEN
          ASSIGN size = 31995.
       
        CASE ttExceed.tdtype:
            WHEN "character" OR WHEN "raw" THEN DO:
                IF ttExceed.tExtent > 0 THEN DO:
                    CREATE sc-rpt.
                    ASSIGN rpt-id = scr-count
                           rpt-line = "      Extent: " + STRING(ttExceed.tExtent)
                           scr-count = scr-count + 1.
                    CREATE sc-rpt.
                    ASSIGN rpt-id = scr-count
                           rpt-line = "      Recommended Field Width: " + STRING(size)
                           scr-count = scr-count + 1.                    
                END.                                         
            END.
            WHEN "decimal" THEN DO: 
                IF ttExceed.tExtent > 0 THEN DO:
                    CREATE sc-rpt.
                    ASSIGN rpt-id = scr-count
                           rpt-line = "      Extent: " + STRING(ttExceed.tExtent)
                           scr-count = scr-count + 1.
                    CREATE sc-rpt.
                    ASSIGN rpt-id = scr-count
                           rpt-line = "      Recommended Field Width: " + STRING(size)
                           scr-count = scr-count + 1.                    
                END.                
            END.
            OTHERWISE DO:
              IF ttExceed.tExtent > 0 THEN DO:
                CREATE sc-rpt.
                ASSIGN rpt-id = scr-count
                       rpt-line = "      Extent: " + STRING(ttExceed.tExtent)
                       scr-count = scr-count + 1.
                CREATE sc-rpt.
                ASSIGN rpt-id = scr-count
                       rpt-line = "      Recommended Field Width: " + STRING(size)
                       scr-count = scr-count + 1.                    
              END.  
            END.

        END CASE.  
    END. /* IF ttExceed.tDecOnly = NO */ 

    /* Does the number of decimals need to be modified? */
    IF ttExceed.tDecimals < ttExceed.tDecData THEN DO: 
        CREATE sc-rpt.
        ASSIGN rpt-id = scr-count
               rpt-line = "    " + ttExceed.tField-Name + " field does not have enough decimal places for the data."
               scr-count = scr-count + 1.
        CREATE sc-rpt.
        ASSIGN rpt-id = scr-count
               rpt-line = "        Number of records exceeding format: " + STRING(tNumberDec)
               scr-count = scr-count + 1.
        CREATE sc-rpt.
        ASSIGN rpt-id = scr-count
               rpt-line = "        Decimals: " + STRING(ttExceed.tDecimals) + "   Part of index: " + STRING(ttExceed.tKey)
               scr-count = scr-count + 1.
        CREATE sc-rpt.
        ASSIGN rpt-id = scr-count
               rpt-line = "        Maximum Decimals: " + STRING(ttExceed.tDecData)  + "   Data type: " + ttExceed.tdtype
               scr-count = scr-count + 1.

        IF ttExceed.tExtent > 0 THEN DO:
            CREATE sc-rpt.
            ASSIGN rpt-id = scr-count
                   rpt-line = "      Extent: " + STRING(ttExceed.tExtent)
                   scr-count = scr-count + 1.
        END.
    END.

END.  /* FOR EACH ttExceed */ 
IF numrec = scr-count THEN DO:
  FIND sc-rpt WHERE rpt-id = numrec - 1 NO-ERROR.
  IF AVAILABLE sc-rpt THEN
    DELETE sc-rpt.
END.

RETURN. 
END PROCEDURE.

FUNCTION LengthDecimal RETURNS INTEGER
  ( INPUT pDec AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose: This function calculates the size needed to accommodate a decimal value.
            The calculated size includes the number of digits (scale), the number of decimal 
            places (precision), the decimal point, the sign, and the comma separator. 
             
    Notes: The decimal calculations include the sign, decimal point, and commas in the size
           calculations.  This errors on the side of allocating a little bit of extra space. 
           This size calculation is the similar to the way the width field was initially 
           calculated.    
           
           The default width when the scale is < 15 is 15 + decimal places.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lTruncate   AS DECIMAL NO-UNDO.
    DEFINE VARIABLE lComma      AS DECIMAL NO-UNDO.
    DEFINE VARIABLE lRemainder  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE lLenDec     AS DECIMAL NO-UNDO.
    DEFINE VARIABLE lSign       AS DECIMAL NO-UNDO.
    
    /* Determine number of commas */ 
    ASSIGN  lTruncate     = TRUNCATE(pDec,0) /* Set the scale */
            lRemainder  = lTruncate 
            lSign       = IF lTruncate < 0 THEN 1 ELSE 0 
            lComma      = 0. 

    DO WHILE (lRemainder > 0) AND (lRemainder > 1000):
        ASSIGN  lComma = lComma + 1  
                lRemainder = lRemainder / 1000. 
    END.

    /* length of scale + precision, includes count of decimal place + commas + sign */  
    RETURN INTEGER((LENGTH(STRING(lTruncate)) + LENGTH(STRING(pDec - lTruncate)) + lComma) + lSign).   /* Function return value. */

END FUNCTION.

