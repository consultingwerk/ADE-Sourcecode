&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : analyzer.p
    Purpose     : Application code formatting utility.
    Updated     : 03/05/01 pdigre@progress.com
                    Initial version
                  04/27/01 adams@progress.com
                    WebSpeed integration
    Notes       : pe - Progress keyword expand
                  pu - Progress keyword uppercase
                  pl - Progress keyword lowercase
                  hu - HTML     keyword uppercase
                  hl - HTML     keyword lowercase

                  Call-back procedures
                  ------------------------------------------------
                  analyzeElem(cCommand,cData)    
                    1 command and corresponding data section
                  analyzeLine(cCommands,cData)   
                    chr(2) delimited strings of commands and data.

                  Command name - Value
                  ------------------------------------------------
                  CR    - Carriage Return (CR)
                  PB    - Progress New Command Break (PB)
                  PROG  - Progress code section
                  COMM  - Commented code section
                  QUOT  - Quoted string section
                  HTML  - HTML code section
                  SCRP  - Other script language section.

  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* generic object definition section */
DEFINE VARIABLE hParent   AS HANDLE       NO-UNDO.
DEFINE VARIABLE cCallback AS CHARACTER    NO-UNDO.

/*program parser */
DEFINE VARIABLE cIn       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cIn2      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cOut      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cOut2     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c1        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c2        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c3        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c4        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i1        AS INTEGER      NO-UNDO.
DEFINE VARIABLE i2        AS INTEGER      NO-UNDO.
DEFINE VARIABLE i3        AS INTEGER      NO-UNDO.
DEFINE VARIABLE i4        AS INTEGER      NO-UNDO.
DEFINE VARIABLE iBlock    AS INTEGER      NO-UNDO.
DEFINE VARIABLE iLine     AS INTEGER      NO-UNDO.
DEFINE VARIABLE cLine     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cQuote    AS CHARACTER    NO-UNDO. /** Indicates type of Quote starter **/
DEFINE VARIABLE iComment  AS INTEGER      NO-UNDO. /** Indicates commenting level     ***/
DEFINE VARIABLE lHTML     AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lTilde    AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lScript   AS LOGICAL      NO-UNDO.
DEFINE VARIABLE cCommand  AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cLineProg AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cLineComm AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cLineHTML AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cLineQuot AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cLastChar AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cCurrChar AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cElemCmd  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cElemData AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cLineCmd  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cLineData AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cOutputProg AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBeautify   AS CHARACTER  NO-UNDO. /* CAN-DO option list */

DEFINE STREAM sIn.
DEFINE STREAM sProg.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fSplitCmd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSplitCmd Procedure 
FUNCTION fSplitCmd RETURNS LOGICAL
  ( INPUT-OUTPUT cCmd AS CHARACTER,
    INPUT-OUTPUT cData AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-beautify) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beautify Procedure 
PROCEDURE beautify :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pBeautify   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pOutputProg AS CHARACTER  NO-UNDO.

  ASSIGN
    cBeautify   = pBeautify
    cOutputProg = pOutputProg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-beautifyCmd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beautifyCmd Procedure 
PROCEDURE beautifyCmd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER cElemCmd  AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER cElemData AS CHARACTER  NO-UNDO.

  /**** Progress beautify *******/
  IF cElemCmd = "Prog" THEN DO:
    ASSIGN i2 = 1.
    DO WHILE i2 < LENGTH(cElemData):
      ASSIGN
        c2 = SUBSTRING(cElemData,i2)
        i3 = LENGTH(c2) + 1.
      ASSIGN  i4 = INDEX(c2," ").
      IF i4 > 0 AND i4 < i3 THEN i3 = i4.
      ASSIGN  i4 = INDEX(c2,".").
      IF i4 > 0 AND i4 < i3 THEN i3 = i4.
      ASSIGN  i4 = INDEX(c2,",").
      IF i4 > 0 AND i4 < i3 THEN i3 = i4.
      ASSIGN  i4 = INDEX(c2,":").
      IF i4 > 0 AND i4 < i3 THEN i3 = i4.
      ASSIGN  i4 = INDEX(c2,"(").
      IF i4 > 0 AND i4 < i3 THEN i3 = i4.
      ASSIGN  i4 = INDEX(c2,")").
      IF i4 > 0 AND i4 < i3 THEN i3 = i4.
      IF i3 > 2 THEN DO:
        ASSIGN cCommand = SUBSTRING(cElemData,i2,i3 - 1).
        IF KEYWORD-ALL(cCommand) > "" THEN DO:
          IF CAN-DO(cBeautify,'pe') THEN cCommand = KEYWORD-ALL(cCommand).
          IF CAN-DO(cBeautify,'pu') THEN cCommand = CAPS(cCommand).
          IF CAN-DO(cBeautify,'pl') THEN cCommand = LC(cCommand).
        END.
        ASSIGN SUBSTRING(cElemData,i2,i3 - 1) = cCommand
               i3 = LENGTH(cCommand).
      END.
      ASSIGN i2 = i2 + i3.
    END.
  END.

  /**** HTML beautify *******/
  IF cElemCmd = "HTML" THEN DO:
    ASSIGN i2 = 1.
    DO WHILE i2 < LENGTH(cElemData):
      ASSIGN
        c2 = SUBSTRING(cElemData,i2)
        i3 = LENGTH(c2) + 1.
    ASSIGN  i4 = INDEX(c2," ").
      IF i4 > 0 AND i4 < i3 THEN i3 = i4.
      ASSIGN  i4 = INDEX(c2,">").
      IF i4 > 0 AND i4 < i3 THEN i3 = i4.
      IF i3 > 2 THEN DO:
        ASSIGN cCommand = SUBSTRING(cElemData,i2,i3 - 1).
        IF cCommand BEGINS "<" THEN DO:
          IF CAN-DO(cBeautify,'hu') THEN cCommand = CAPS(cCommand).
          IF CAN-DO(cBeautify,'hl') THEN cCommand = LC(cCommand).
        END.
        IF NUM-ENTRIES(cCommand,"=") > 1 THEN DO:
          IF CAN-DO(cBeautify,'hu') THEN 
            ENTRY(1,cCommand,"=") = CAPS(ENTRY(1,cCommand,"=")).
          IF CAN-DO(cBeautify,'hl') THEN 
            ENTRY(1,cCommand,"=") = LC(ENTRY(1,cCommand,"=")).
        END.
        ASSIGN SUBSTRING(cElemData,i2,i3 - 1) = cCommand
               i3 = LENGTH(cCommand).
      END.
      ASSIGN i2 = i2 + i3.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-callBack) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE callBack Procedure 
PROCEDURE callBack :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER h1 AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER c1 AS CHARACTER  NO-UNDO.

  ASSIGN hParent   = h1
         cCallBack = c1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Process) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Process Procedure 
PROCEDURE Process :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER cInputFile  AS CHARACTER NO-UNDO.

  /***** Initialize *****************/
  INPUT STREAM sIn FROM VALUE(cInputFile).
  ASSIGN
    lHtml    = cInputFile MATCHES "*htm" OR cInputFile MATCHES "*html"
    iComment = 0
    cQuote   = ""
    lScript  = FALSE
    lTilde   = FALSE.

  IF cOutputProg > '' THEN 
    OUTPUT STREAM sProg TO VALUE(cOutputProg).

  /***** Read the input data ********/
  REPEAT:
    ASSIGN
      cIn       = ""
      cLine     = ""
      cLineCmd  = ""
      cLineData = ""
      cLineComm = ""
      cLineQuot = ""
      cLineHTML = ""
      cLineProg = "".

    IMPORT STREAM sIn UNFORMATTED cIn.

    ASSIGN 
      cIn   = REPLACE(cIn,CHR(2)," ") + " "
      iLine = iLine + 1.

    DO i1 = 1 TO LENGTH(cIn):
      ASSIGN 
        cCurrChar = SUBSTRING(cIn,i1,1)
        cElemCmd  = (IF cQuote = ""  THEN "PROG" ELSE "QUOT")
        cElemCmd  = (IF iComment > 0 THEN "COMM" ELSE cElemCmd)
        cElemCmd  = (IF lHTML        THEN "HTML" ELSE cElemCmd).

      CASE cElemCmd:
        WHEN "HTML" THEN DO:
          CASE cCurrChar:
            WHEN "~`" THEN /* Start of BACKTICK > CHANGE */
              ASSIGN lHTML = FALSE.
            WHEN "<"  THEN /* New HTML command > Push last */
              ASSIGN
                cLineData = cLineData + cLineHTML
                cLineHTML = cCurrChar.
            WHEN ">"  THEN /* SCRIPT SPEEDSCRIPT */
              IF cLineHTML MATCHES "*<SCRIPT*" AND cLineHTML MATCHES "*SPEEDSCRIP*" THEN
                ASSIGN
                  lScript   = FALSE
                  lHTML     = FALSE.
              ELSE IF cLineHTML MATCHES "*<SCRIPT*" THEN /* Other script */
                ASSIGN
                  lScript   = TRUE                       
                  cLineData = cLineData + cLineHTML + cCurrChar + CHR(2)
                  cLineHTML = ""
                  cLineCmd  = cLineCmd + "HTML" + CHR(2).
              ELSE ASSIGN
                cLineHTML = cLineHTML + cCurrChar.
            WHEN "/" THEN 
              IF lScript AND cLastChar = "<" THEN /* End of other script */
                ASSIGN
                  lScript   = FALSE
                  cLineData = cLineData + SUBSTRING(cLineHtml,1,LENGTH(cLineHtml) - 1) + CHR(2)
                  cLineHtml = "</":U
                  cLineCmd  = cLineCmd + "SCRP" + CHR(2).
              ELSE ASSIGN
                cLineHTML = cLineHTML + cCurrChar.
            WHEN ":" THEN 
              IF NOT lScript AND cLineHTML MATCHES "*javascript*" THEN 
                ASSIGN
                  lScript   = TRUE
                  cLineData = cLineData + cLineHTML + cCurrChar + CHR(2)
                  cLineHTML = ""
                  cLineCmd  = cLineCmd + "HTML" + CHR(2).
              ELSE 
                ASSIGN
                  cLineHTML = cLineHTML + cCurrChar.
            WHEN "=" THEN 
              IF NOT lScript AND 
                CAN-DO("onClick,onChange,onBlur,onFocus,onSelect",
                  ENTRY(NUM-ENTRIES(cLineHTML," "),cLineHTML," ")) THEN 
                ASSIGN
                  lScript   = TRUE
                  cLineData = cLineData + cLineHTML + cCurrChar + CHR(2)
                  cLineHTML = ""
                  cLineCmd  = cLineCmd + "HTML" + CHR(2).
              ELSE 
                ASSIGN
                  cLineHTML = cLineHTML + cCurrChar.
            OTHERWISE DO:
              IF cLineHTML MATCHES "*!--WSS*" THEN
                lHTML     = FALSE.      /* < ! WSS Speedscript COMMAND */
              ELSE 
                cLineHTML = cLineHTML + cCurrChar.
            END.
          END CASE.
          
          IF lHTML = FALSE THEN 
            ASSIGN
              cLineData = cLineData + cLineHTML + cCurrChar + CHR(2)
              cLineHTML = ""
              cLineCmd  = cLineCmd + (IF lScript THEN "SCRP" ELSE "HTML") + CHR(2).
        END. /* HTML */
        WHEN "COMM" THEN DO:
          IF cLastChar + cCurrChar = "~/~*" THEN 
            iComment = iComment + 1.
          IF cLastChar + cCurrChar = "~*~/" THEN 
            iComment = iComment - 1.

          ASSIGN cLineComm = cLineComm + cCurrChar.
          IF iComment = 0 THEN 
            ASSIGN
              cLineData = cLineData + cLineComm + CHR(2)
              cLineComm = ""
              cLineCmd  = cLineCmd + "COMM" + CHR(2).
        END.
        WHEN "QUOT" THEN DO:
          ASSIGN cLineQuot = cLineQuot + cCurrChar.
          IF cCurrChar = cQuote THEN 
            ASSIGN
              cQuote    = ""
              cLineData = cLineData + cLineQuot + CHR(2)
              cLineQuot = ""
              cLineCmd  = cLineCmd + "QUOT" + CHR(2).
        END.
        WHEN "PROG" THEN DO:
          IF lTilde THEN
            ASSIGN cLineProg = cLineprog + cCurrChar.
          ELSE 
          CASE cCurrChar:
            WHEN "~`" THEN /* End of BACKTICK > CHANGE */
              ASSIGN lHTML = TRUE.
            WHEN "'" OR WHEN '"' THEN /* Start Quoting */
              ASSIGN
                cQuote    = cCurrChar
                cLineData = cLineData + cLineProg + CHR(2)
                cLineProg = ""
                cLineQuot = cCurrChar
                cLineCmd  = cLineCmd + "PROG" + CHR(2).
            WHEN ">" THEN DO:
              IF cLineProg MATCHES "*--" THEN 
                ASSIGN
                  lHTML     = TRUE
                  cLineHtml = SUBSTRING(cLineProg,LENGTH(cLineProg) - 2 + 1)
                  cLineProg = SUBSTRING(cLineProg,1,LENGTH(cLineProg) - 2).
              ELSE 
                IF cLineProg MATCHES "*~/SCRIPT*" THEN 
                  ASSIGN
                    lHTML     = TRUE
                    cLineHtml = SUBSTRING(cLineProg,LENGTH(cLineProg) - 8 + 1)
                    cLineProg = SUBSTRING(cLineProg,1,LENGTH(cLineProg) - 8).
              ELSE   
                cLineProg = cLineprog + cCurrChar.
            END.
            OTHERWISE
              ASSIGN cLineProg = cLineprog + cCurrChar.
          END CASE.

          IF cLastChar + cCurrChar = "~/~*" THEN 
            ASSIGN
              iComment  = 1
              cLineComm = "~/~*"
              cLineData = cLineData + SUBSTRING(cLineProg,1,LENGTH(cLineProg) - 2) + CHR(2)
              cLineProg = ""
              cLineCmd  = cLineCmd + "PROG" + CHR(2).

          IF lHTML = TRUE THEN 
            ASSIGN
              cLineData = cLineData + cLineProg + CHR(2)
              cLineProg = ""
              cLineHTML = cLineHTML + cCurrChar
              cLineCmd  = cLineCmd + "PROG" + CHR(2).
        END.
      END CASE.

      ASSIGN 
        cLastChar = IF lTilde THEN "X" ELSE cCurrChar
        lTilde    = cCurrChar = "~~" AND NOT lTilde.
    END. /* DO */

    CASE cElemCmd:
      WHEN "HTML" THEN cLineData = cLineData + cLineHTML + cCurrChar.
      WHEN "COMM" THEN cLineData = cLineData + cLineComm + cCurrChar.
      WHEN "QUOT" THEN cLineData = cLineData + cLineQuot + cCurrChar.
      WHEN "PROG" THEN cLineData = cLineData + cLineProg + cCurrChar.
    END CASE.

    ASSIGN cLineCmd  = cLineCmd + IF lScript AND cElemCmd = "HTML" THEN "SCRP" ELSE cElemCmd.

    RUN processElements (cLineCmd,cLineData).
  END.
  IF cOutputProg > '' THEN 
    OUTPUT STREAM sProg CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processElements) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processElements Procedure 
PROCEDURE processElements :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAM cLineCmd  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAM cLineData AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cRest AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i2    AS INTEGER    NO-UNDO.

  /* Inserting Progress breaks */
  ASSIGN i2 = NUM-ENTRIES(cLineCmd,CHR(2)).

  DO i1 = i2 TO 1 BY -1:
    ASSIGN 
      cElemCmd  = ENTRY(i1,cLineCmd, CHR(2))
      cElemData = ENTRY(i1,cLineData,CHR(2)).
    IF cElemCmd = 'prog' THEN 
      fSplitCmd(INPUT-OUTPUT cElemCmd,INPUT-OUTPUT cElemData).

    ASSIGN 
      ENTRY(i1,cLineCmd, CHR(2)) = cElemCmd
      ENTRY(i1,cLineData,CHR(2)) = cElemData.
  END.

  /* Processing options per element */
  DO i1 = 1 TO NUM-ENTRIES(cLineCmd,CHR(2)):
    ASSIGN 
      cElemCmd  = ENTRY(i1,cLineCmd, CHR(2))
      cElemData = ENTRY(i1,cLineData,CHR(2)).

    IF cBeautify > '' THEN 
      RUN beautifyCmd(INPUT-OUTPUT cElemCmd,INPUT-OUTPUT cElemData).

    ASSIGN ENTRY(i1,cLineData,CHR(2)) = cElemData.

    IF ENTRY(1,cCallback) > '' THEN 
      RUN VALUE(ENTRY(1,cCallback)) IN hParent (cElemCmd,cElemData).

    IF cElemCmd <> "PB" THEN 
      cLine = cLine + cElemData.
  END.

  /* Processing options per line */
  IF cOutputProg > '' THEN 
    PUT STREAM sProg UNFORMATTED cLine SKIP.

  IF ENTRY(1,cCallback) > '' THEN 
    RUN VALUE(ENTRY(1,cCallback)) IN hParent ('CR','CR').

  
  IF ENTRY(2,cCallback + ',') > '' THEN 
    RUN VALUE(ENTRY(2,cCallback)) IN hParent (cLineCmd + CHR(2) + 'CR',cLineData + CHR(2) + 'CR').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fSplitCmd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSplitCmd Procedure 
FUNCTION fSplitCmd RETURNS LOGICAL
  ( INPUT-OUTPUT cCmd AS CHARACTER,
    INPUT-OUTPUT cData AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE l1  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cBR AS CHARACTER  NO-UNDO.

  ASSIGN 
    l1  = FALSE
    cBR = CHR(2) + 'PB' + CHR(2).

  IF INDEX(cData,'. ') > 0 THEN 
    ASSIGN
      cCmd  = cCmd + cBR + 'PROG'
      cData = SUBSTRING(cData,1,INDEX(cData,'. '),"character":U) + cBR + 
              SUBSTRING(cData,INDEX(cData,'. ') + 1,-1,"character":U)
      l1    = TRUE.

  IF INDEX(cData,': ') > 0 THEN 
    ASSIGN
      cCmd  = cCmd + cBR + 'PROG'
      cData = SUBSTRING(cData,1,INDEX(cData,': '),"character":U) + cBR + 
              SUBSTRING(cData,INDEX(cData,': ') + 1,-1,"character":U)
      l1    = TRUE.

  IF INDEX(cData,' then ') > 0 THEN 
    ASSIGN
      cCmd  = cCmd + cBR + 'PROG'
      cData = SUBSTRING(cData,1,INDEX(cData,' then '),"character":U) + cBR + 
              SUBSTRING(cData,INDEX(cData,' then ') + 1,-1,"character":U)
      l1    = TRUE.

  RETURN l1.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

