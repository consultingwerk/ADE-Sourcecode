/*********************************************************************
* Copyright (C) 2005,2011 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
Procedure:    adetran/pm/loadstr.i
Author:       R. Ryan
Created:      2/95
Updated:      pulled from adetran/pm/_loadstr.w
               so it could be included in _loadstr.w and _extract.w
Purpose:      load a xrf file into XL_STRING_INFO and XL_INSTANCE tables
Notes:        This is a complex procedure that reads the string-xref file, then
              does the following:

               It then looks at the combination of string and string attributes
                   and decides if this is:

                     a. a new string (if so, it builds a XL_STRING_INFO records and
                        a corresponding XL_INSTANCE record)
                     b. an existing string but a new instance (if so, it builds a
                        new XL_INSTANCE record).
                     c. an existing string and an update to an existing instance.

Procedures:   Key procedures include:

                 IncludeThis      as a record is being read, it looks at the
                                  XL_SelectedFilter table, and prepares to loads those
                                  records which match.  But first, it looks at...
                 ExcludeThis      as a record is being read, and it has already passed
                                  the 'IncludeThis' test, the XL_CustomFilters table
                                  is read.  If a match is made, that record is rejected,
                                  otherwise it is loaded.
                IsAlpha           determines if the string contains any 'alpha' characters. 'Alpha' currently being defined as English A-Z, a-z. To be expanded in the future to use codepage ISALPHA.
*/
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExcludeThis Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadStr Dialog-Frame
PROCEDURE LoadStr:
DO:

  DEFINE INPUT PARAMETER pXREFFileName AS CHARACTER.
  DEFINE INPUT PARAMETER pUseFilters   AS LOGICAL.
  DEFINE INPUT PARAMETER pDeleteXREF   AS LOGICAL.

  DEFINE VARIABLE CANCEL-FLAG   AS LOGICAL                       NO-UNDO.
  DEFINE VARIABLE cntr          AS INTEGER                       NO-UNDO.
  DEFINE VARIABLE err-num       AS INTEGER                       NO-UNDO.
  DEFINE VARIABLE Justify       AS integer      INITIAL 0        NO-UNDO.
  DEFINE VARIABLE NumProcs      AS INTEGER                       NO-UNDO.
  DEFINE VARIABLE PctTaken      AS decimal format ">>9.9%":u     NO-UNDO.
  DEFINE VARIABLE real-err      AS LOGICAL                       NO-UNDO.
  DEFINE VARIABLE subst-line    AS CHARACTER                     NO-UNDO.
  DEFINE VARIABLE ThisFile      AS CHARACTER                     NO-UNDO.
  DEFINE VARIABLE ThisProc      AS CHARACTER                     NO-UNDO.

  DEFINE VARIABLE ThisMessage   AS CHARACTER                     NO-UNDO.
  DEFINE VARIABLE ErrorStatus   AS LOGICAL                       NO-UNDO.
  DEFINE VARIABLE msg-win       AS WIDGET-HANDLE                 NO-UNDO.
  DEFINE VARIABLE TimeDateStamp AS DECIMAL                       NO-UNDO.

  DEFINE VARIABLE baseName      AS CHARACTER                     NO-UNDO.
  DEFINE VARIABLE DirName       AS CHARACTER                     NO-UNDO.
  DEFINE VARIABLE lSkipProc     AS LOGICAL     INITIAL FALSE     NO-UNDO.
  DEFINE VARIABLE cProcessedProc        AS CHARACTER             NO-UNDO.
  DEFINE VARIABLE lCleanedProcessedProc AS LOGICAL               NO-UNDO.

  if pXREFFileName = "" then do:
     return no-apply.
  end.

  FILE-INFO:FILENAME = pXREFFileName.
  IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
    ThisMessage = pXREFFileName + "^does not exist or cannot be located.".
    run adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w":U, "ok":U, ThisMessage).
    RETURN.
  END.

  IF pUseFilters THEN
  DO:
     {adetran/pm/ckfilter.i}
  END.

  /*
  ** All the checks are done, ready to load
  */
  if not frame {&frame-name}:hidden then frame {&frame-name}:hidden = true.

  TimeDateStamp = integer(today) + (time / 100000).

  /* Modified to maintain Sequence/Instance IDs
   *  xlatedb.XL_Project.DisplayType
   *       DisplayType CHR(4) Sequence_Num CHR(4) Instance_Number
   * We are NOT using project.ProjectRevision because it is part of an
   * index and may already contain a directory which may cause an issue
   * with being part of an index.
   */

   FIND FIRST xlatedb.XL_Project NO-LOCK NO-ERROR.
   IF NUM-ENTRIES(xlatedb.XL_Project.DisplayType,CHR(4)) > 1 THEN
   DO:
      ASSIGN
         NextString   = INTEGER(ENTRY(2, xlatedb.XL_Project.DisplayType, CHR(4)))
         NextInstance = INTEGER(ENTRY(3, xlatedb.XL_Project.DisplayType, CHR(4)))
         NextString   = IF NextString = ? THEN 1 ELSE NextString
         NextInstance = IF NextINstance = ? THEN 1 ELSE NextInstance.
   END.
   ELSE
   DO:
       find last xlatedb.XL_String_Info use-index Sequence_Num no-lock no-error.
       find last xlatedb.XL_Instance use-index Instance_Num no-lock no-error.
       ASSIGN
          NextInstance = if available xlatedb.XL_Instance then
                              xlatedb.XL_Instance.Instance_Num + 1
                          else 1
          NextString   = if available xlatedb.XL_String_Info then
                              xlatedb.XL_String_Info.Sequence_Num + 1
                          else 1.
   END.

  /* Open the file to see how big it is  */
  FILE-INFO:FILE-NAME = pXREFFileName.
  input STREAM XREFStream from value(FILE-INFO:FULL-PATHNAME).
  seek STREAM XREFStream to end.
  assign FileSize = seek(XREFStream)
         Result   = yes.

  /* Back the file pointer to the beginning of the file  */
  seek STREAM XREFStream to 0.
  if not Result or Result = ? then do:
    input STREAM XREFStream close.
    return.
  end.

  ASSIGN TotalStrings    = 0
         IncludedStrings = 0
         cancel-flag     = FALSE.

  IF VALID-HANDLE(_hMeter) THEN
    RUN Realize in _hMeter ("Loading...").

DO TRANSACTION:
  TRANS-LOOP:
  REPEAT:
    INNER:
    REPEAT cntr = 1 TO 300 ON END-KEY UNDO inner, LEAVE TRANS-LOOP:

      InputLine = "".
      process events.
      if StopProcessing then do:
        cancel-flag = TRUE.
        run HideMe in _hMeter.
        UNDO INNER, LEAVE TRANS-LOOP.
      end.

      import STREAM XREFStream InputLine no-error.

      /* HEADER LINE */
      if InputLine[1] = "String":u and InputLine[2] = "Xref":u then do:
        if InputLine[4] <> "{&XREF-VER}":u then do:
          ThisMessage = "_prowin.exe version mismatch.  Expected XREF version {&XREF-VER}; found " +
                           InputLine[4] + ".":u.
          run adecomm/_s-alert.p (input-output ErrorStatus, "e":u,"ok":u, ThisMessage).
          IF VALID-HANDLE(_hMeter) THEN
            RUN HideMe in _hMeter.
          frame {&frame-name}:hidden = false.
          return no-apply.
        end.

        /* For subsets, we want to clean up only procedures that were processed
         */
        IF NOT lCleanedProcessedProc THEN
        DO:
              /* Cleanup
               * Remove all instances in the last procedure that were not found in this load
               */
              FOR EACH xlatedb.XL_Instance WHERE
                       xlatedb.XL_Instance.Proc_Name     = cProcessedProc and
                       xlatedb.XL_Instance.Last_Change   NE TimeDateStamp EXCLUSIVE-LOCK:
                DELETE xlatedb.XL_Instance.
              END.  /* For each xlatedb.XL_INstance */
              ASSIGN lCleanedProcessedProc = TRUE.
        END.

        ASSIGN lSkipProc = FALSE
               ThisProc  = InputLine[5].

        IF lSubset THEN
        DO:
           RUN adecomm/_osprefx.p (ThisProc, OUTPUT DirName, OUTPUT baseName).
           /* Remove the trailing slash */
           DirName = RIGHT-TRIM(DirName, "\").
           IF DirName = "":U THEN
             ASSIGN DirName = ".":U.  /* This is the way subset stores current dir */

           FIND FIRST ThisSubsetList WHERE ThisSubsetList.Project   = ProjectDB
                                       AND ThisSubsetList.Directory = DirName
                                       AND ThisSubsetList.FileName  = BaseName
           NO-LOCK NO-ERROR.
           IF NOT AVAILABLE ThisSubsetList THEN
           DO:
                FIND FIRST ThisSubsetList WHERE ThisSubsetList.Project   = ProjectDB
                                            AND ThisSubsetList.Directory = DirName
                                            AND ThisSubsetList.FileName  = cAllFiles
                  NO-LOCK NO-ERROR.
                IF NOT AVAILABLE ThisSubsetList THEN
                  ASSIGN lSkipProc = TRUE.
                ELSE
                  ASSIGN cProcessedProc        = ThisProc
                         lCleanedProcessedProc = FALSE.
           END.
           ELSE
             ASSIGN cProcessedProc        = ThisProc
                    lCleanedProcessedProc = FALSE.
        END.
        ELSE
          ASSIGN cProcessedProc        = ThisProc
                 lCleanedProcessedProc = FALSE.

        IF VALID-HANDLE(_hMeter) THEN
          RUN SetBar in _hMeter (FileSize, seek(XREFStream), ThisProc).
      end.  /* If the Header line */

      /* DATA */
      else if InputLine[3] <> "":U AND InputLine[3] <> "?":U then do:

        /* If we are dealing with subsets, skip this procedure if it is not part of the subset */
        IF lSkipProc THEN NEXT INNER.

        Justify = if InputLine[5] = "LEFT":u then 1
                  else if InputLine[5] = "RIGHT":u then 2
                  else if InputLine[5] = "CENTER":u then 3
                  else if InputLine[5] = "TRIM":u then 4
                  else 1.

        IF FileSize < 30000 THEN IF VALID-HANDLE(_hMeter) THEN
          RUN SetBar in _hMeter (FileSize, seek(XREFStream), ThisProc).
        TotalStrings = TotalStrings + 1.

        /*
        ** Filter the data here
        */
        IF pUseFilters THEN run IncludeThis (output FoundIt).
        ELSE FoundIt = yes.

        if FoundIt then do:
          /*
          ** if we are here, then the include filters matched, so add it.
          ** But not so fast: see if there are exclusion filters first.
          */
          IF pUseFilters THEN run ExcludeThis (output FoundIt).
          ELSE Foundit = no.

          if NOT FoundIt then do:  /* Add it: check to see if the record exists  */
            ASSIGN IncludedStrings = IncludedStrings + 1
                   /* 20050624-034 - right-trim only spaces*/
                   subst-line      = SUBSTRING(RIGHT-TRIM(InputLine[3], " "),1,63,"COLUMN":U).

            FIND FIRST xlatedb.XL_String_Info WHERE
                 xlatedb.XL_String_Info.KeyOfString BEGINS subst-line AND
                 xlatedb.XL_String_info.Original_String = InputLine[3]
               USE-INDEX String_Key NO-ERROR.

            if AVAILABLE xlatedb.XL_String_Info THEN DO: /* Ok, we already have this string,
                                                            so check the Instances           */
              find first xlatedb.XL_Instance WHERE
                xlatedb.XL_Instance.Sequence_Num  = xlatedb.XL_String_Info.Sequence_Num AND
                xlatedb.XL_Instance.Proc_Name     = ThisProc and
                xlatedb.XL_Instance.MaxLength     = Integer(InputLine[4]) and
                xlatedb.XL_Instance.Justification = Justify
                EXCLUSIVE-LOCK no-error.

              IF AVAILABLE xlatedb.XL_Instance THEN
                ASSIGN xlatedb.XL_Instance.Num_Occurs  =
                          IF xlatedb.XL_Instance.Last_Change = TimeDateStamp
                             THEN xlatedb.XL_Instance.Num_Occurs + 1 ELSE 1
                       xlatedb.XL_Instance.Last_Change = TimeDateStamp
                       xlatedb.XL_Instance.Line_Num    = IF xlatedb.XL_Instance.Num_Occurs = 1 THEN
                                                         INTEGER(InputLine[1]) ELSE
                                                         ?
                       xlatedb.XL_Instance.Statement   =
                          IF InputLine[6] = xlatedb.XL_Instance.Statement THEN
                                                         InputLine[6] ELSE
                                                         "?":U
                       xlatedb.XL_Instance.Item        =
                          IF InputLine[7] = xlatedb.XL_Instance.Item THEN
                                                         InputLine[7] ELSE
                                                         "?":U.
              ELSE DO:
                create xlatedb.XL_Instance.
                assign xlatedb.XL_Instance.Instance_Num  = NextInstance
                       xlatedb.XL_Instance.Sequence_Num  = xlatedb.XL_String_Info.Sequence_Num
                       xlatedb.XL_Instance.Proc_Name     = ThisProc
                       xlatedb.XL_Instance.MaxLength     = Integer(InputLine[4])
                       xlatedb.XL_Instance.Justification = Justify
                       xlatedb.XL_Instance.Line_Num      = integer(InputLine[1])
                       xlatedb.XL_Instance.ObjectName    = if InputLine[2] = "?":u then ""
                                                           else InputLine[2]
                       xlatedb.XL_Instance.Statement     = InputLine[6]
                       xlatedb.XL_Instance.Item          = InputLine[7]
                       NextInstance                      = NextInstance + 1
                       xlatedb.XL_Instance.Last_Change   = TimeDateStamp
                       xlatedb.XL_Instance.Num_Occurs    = 1.
              end. /* else do */
            end. /* if available xl_string_info */

            else do: /* This is a NEW string, so add it  */
              create xlatedb.XL_String_Info.
              create xlatedb.XL_Instance.
              assign xlatedb.XL_String_Info.Sequence_Num    = NextString
                     xlatedb.XL_String_Info.KeyOfString     = subst-line
                     xlatedb.XL_String_Info.Original_String = InputLine[3]
                     xlatedb.XL_String_Info.Last_Change     = TimeDateStamp
                     xlatedb.XL_Instance.Instance_Num       = NextInstance
                     xlatedb.XL_Instance.Sequence_Num       = xlatedb.XL_String_Info.Sequence_Num
                     xlatedb.XL_Instance.Proc_Name          = ThisProc
                     xlatedb.XL_Instance.Last_Change        = TimeDateStamp
                     xlatedb.XL_Instance.Line_Num           = integer(InputLine[1])
                     xlatedb.XL_Instance.Num_Occurs         = 1
                     xlatedb.XL_Instance.MaxLength          = Integer(InputLine[4])
                     xlatedb.XL_Instance.Justification      = Justify
                     xlatedb.XL_Instance.ObjectName         = if InputLine[2] = "?" then ""
                                                              else InputLine[2]
                     xlatedb.XL_Instance.Statement          = InputLine[6]
                     xlatedb.XL_Instance.Item               = InputLine[7]
                     NextInstance                           = NextInstance + 1
                     NextString                             = NextString + 1.
            end. /* else do */
          end. /* if NOT Foundit */
        end. /* if FoundIt */
      end. /* string <> "" */
    end. /* repeat loop */

  END. /* Repeat */

  /* Note that this is done even if the load was cancelled since
   * the cancellation does not undo all the load, it only stops the
   * load
   */
      /* Save the NextString/NextInstance */
      ASSIGN
       xlatedb.XL_Project.DisplayType =
          IF NUM-ENTRIES(xlatedb.XL_Project.DisplayType,CHR(4)) > 1 THEN
             ENTRY(1,xlatedb.XL_Project.DisplayType,CHR(4))
             + CHR(4) + TRIM(STRING(NextString))
             + CHR(4) + TRIM(STRING(NextInstance))
       ELSE
          xlatedb.XL_Project.DisplayType
             + CHR(4) + TRIM(STRING(NextString))
             + CHR(4) + TRIM(STRING(NextInstance)).
  END. /* DO Trans */
  input STREAM XREFStream close.
  run HideMe in _hMeter.

  run adecomm/_setcurs.p ("wait":u).
  IF NextString > 150 THEN DO:
    CREATE WINDOW msg-win
       ASSIGN WIDTH        = 35
              HEIGHT       = 4
              TITLE        = "Please Wait...":U
              MESSAGE-AREA = NO
              STATUS-AREA  = NO
              ROW          = _MainWindow:ROW + 8
              COLUMN       = _MainWindow:COLUMN + 29
              BGCOLOR      = _MainWindow:BGCOLOR
              FGCOLOR      = _MainWindow:FGCOLOR
              SCROLL-BARS  = NO
              THREE-D      = YES
              VISIBLE      = YES.
    DEFINE FRAME cs
           SKIP (1)
           "Calculating statistics." AT 9 SKIP (1)
         WITH NO-BOX SIZE 35 BY 4 ROW 1 COLUMN 1.
    VIEW FRAME cs IN WINDOW msg-win.
  END.  /* Put up message if statistice takes a while */

  IF cancel-flag = false THEN DO:
    /* Remove all instances in the last procedure that were not found in this load */
    FOR EACH xlatedb.XL_Instance WHERE
             xlatedb.XL_Instance.Proc_Name     = ThisProc and
             xlatedb.XL_Instance.Last_Change   NE TimeDateStamp EXCLUSIVE-LOCK:
      DELETE xlatedb.XL_Instance.
    END.  /* For each xlatedb.XL_INstance */

/* **** This is unnecessary; The delete trigger on the XL_Instance table does this...
    /* Remove all strings that no-longer have instances */
    FOR EACH xlatedb.XL_String_Info WHERE
        NOT CAN-FIND(FIRST xlatedb.XL_Instance
            WHERE xlatedb.XL_Instance.Sequence_Num = xlatedb.XL_String_Info.Sequence_Num)
        EXCLUSIVE-LOCK:
      DELETE xlatedb.XL_String_Info.
    END.  /* For each xlatedb.XL_String_INfo without an instance */
 **** */
  END.  /* If not canceled */

  IF CurrentMode = 2 THEN RUN OpenQuery IN _hTrans.
  IF VALID-HANDLE(msg-win) THEN DELETE WIDGET msg-win.

  run adecomm/_setcurs.p ("").

  /*
  ** should we delete the XREF file?
  */
  if pDeleteXREF then os-delete value(pXREFFileName).

  assign
    PctTaken    = ((TotalStrings - IncludedStrings) / TotalStrings) * 100
    PctTaken    = 100 - PctTaken
    ThisMessage = string(TotalStrings) + " phrases were extracted." + "^":u +
                  string(IncludedStrings) + " phrases were loaded (" +
                  trim(string(PctTaken,">>9.9%":u)) + ")." +
                  "^^The XREF file: " + XREFFileName + " has " +
                  (IF pDeleteXREF THEN "" else "not") + " been deleted.".

  if ThisMessage = ? then do:
    ThisMessage = "No phrases were loaded.".
    run adecomm/_s-alert.p (input-output ErrorStatus, "w":u,"ok":u, ThisMessage).
  end.

  else
    run adecomm/_s-alert.p (input-output ErrorStatus, "i":u,"ok":u, ThisMessage).
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExcludeThis Dialog-Frame
PROCEDURE ExcludeThis :
DEFINE OUTPUT PARAMETER pFoundIt AS LOGICAL NO-UNDO.

/* Since we are introducing special exclusion filters which include wildcard,
 * we need to check the recType...
 */
  pFoundIt = CAN-FIND(FIRST xlatedb.XL_CustomFilter where
          xlatedb.XL_CustomFilter.recType = "KEYWORDS"
          AND xlatedb.XL_CustomFilter.Filter  = InputLine[3]).
  IF NOT pFoundIt THEN DO:  /* VZA */
    IF lCase THEN DO:
      ASSIGN cLine = InputLine[3].
      FOR EACH xlatedb.XL_CustomFilter WHERE
            xlatedb.XL_CustomFilter.recType = "USER" AND
            xlatedb.XL_CustomFilter.Filter  = InputLine[3] NO-LOCK:
         ASSIGN cFilt = xlatedb.XL_CustomFilter.Filter
                pFoundIt = cFilt = cLine.
         IF pFoundIt THEN LEAVE.
      END.
    END.
    ELSE
      pFoundIt = CAN-FIND(FIRST xlatedb.XL_CustomFilter where
             xlatedb.XL_CustomFilter.recType = "USER"
            AND xlatedb.XL_CustomFilter.Filter  = InputLine[3]).
  END.
  IF NOT pFoundIt Then
  DO:
    /* Check special filters wildcard, single char */
     FOR EACH xlatedb.XL_CustomFilter WHERE xlatedb.XL_CustomFilter.recType = "SPECIAL" NO-LOCK:
         pFoundIt = CAN-DO(xlatedb.XL_CustomFilter.Filter,InputLine[3]).
         IF pFoundIt THEN LEAVE.
     END.
  END.
  /* Check no alpha filter */
  IF NOT pFoundIt AND CAN-FIND(FIRST xlatedb.XL_CustomFilter where
          xlatedb.XL_CustomFilter.recType = "NOALPHA") THEN
  DO:
      run IsAlpha(output pFoundIt).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IncludeThis Dialog-Frame
PROCEDURE IncludeThis :
DEFINE OUTPUT PARAMETER pFoundIt AS LOGICAL NO-UNDO.

  /* Case -1: any tooltip on any statement except def-button*/
  if InputLine[7] = "TOOLTIP":U then
    pFoundIt = CAN-FIND(xlatedb.XL_SelectedFilter where
                        xlatedb.XL_SelectedFilter.Item  = InputLine[7]).

  /* Case 0: any tooltip on def-button  and def-browse
   * This case MUST be before case 1 else we include a tooltip
   * that should not be there!
   */
  else if InputLine[8] = "TOOLTIP":U then
    pFoundIt = CAN-FIND(xlatedb.XL_SelectedFilter where
                        xlatedb.XL_SelectedFilter.Item  = InputLine[8]).

  /* Case 1: display statements with free text  */
  else if InputLine[6] = "DISPLAY":u and InputLine[7] = "" or
      InputLine[6] = "FORM":u and InputLine[7] = "EXPR":u then
    pFoundIt = CAN-FIND(xlatedb.XL_SelectedFilter where
                        xlatedb.XL_SelectedFilter.Statement  = "FORM":u and
                        xlatedb.XL_SelectedFilter.Item       = "").

  /* Case 2: any format on any statement depending upon the format type  */
  else if InputLine[7] = "FORMAT":u then
    pFoundIt = CAN-FIND(xlatedb.XL_SelectedFilter where
                        xlatedb.XL_SelectedFilter.Statement  = InputLine[7] and
                        xlatedb.XL_SelectedFilter.Item       = InputLine[8]).

  /* Case 3: filenames on image or button objects  */
  else if InputLine[8] = "IMAGE-FILE":u then
    pFoundIt = CAN-FIND(xlatedb.XL_SelectedFilter where
                        xlatedb.XL_SelectedFilter.Statement  = InputLine[6] and
                        xlatedb.XL_SelectedFilter.Item       = InputLine[8]).

  /* Case 4: [bug] put and put unformatted aren't treated the same and should be  */
  else if InputLine[6] = "PUT":u then
    pFoundIt = CAN-FIND(xlatedb.XL_SelectedFilter where
                        xlatedb.XL_SelectedFilter.Statement  = InputLine[6]).

  /* Case 5: include radio-buttons and selection-list items.  */
  else if can-do("RAD-BUTTON,COMBO-BOX-ITEM,SEL-LIST-ITEM":u,InputLine[7]) then
    pFoundIt = CAN-FIND(xlatedb.XL_SelectedFilter where
                        xlatedb.XL_SelectedFilter.Statement = ? and
                        xlatedb.XL_SelectedFilter.Item      = InputLine[7]).

  /* Case 6: any help on any statement */
  else if InputLine[7] = "HELP":U then
    pFoundIt = CAN-FIND(xlatedb.XL_SelectedFilter where
                        xlatedb.XL_SelectedFilter.Item  = InputLine[7]).

  /* Case 7: any tooltip on any statement except def-button*/
  else if InputLine[7] = "TOOLTIP":U then
    pFoundIt = CAN-FIND(xlatedb.XL_SelectedFilter where
                        xlatedb.XL_SelectedFilter.Item  = InputLine[7]).

  /* Case 8: any tooltip on def-button */
  else if InputLine[8] = "TOOLTIP":U then
    pFoundIt = CAN-FIND(xlatedb.XL_SelectedFilter where
                        xlatedb.XL_SelectedFilter.Item  = InputLine[7]).
  
  /* 'Create' can have qualifiers, but don't let those prevent us from loading 
   * the strings that are part of create statement. (taj iz 3808)
   */
  ELSE IF InputLine[6] = "Create":U THEN
    pFoundIt = CAN-FIND(xlatedb.XL_SelectedFilter where
                        xlatedb.XL_SelectedFilter.Statement  = InputLine[6]).

  else pFoundIt = CAN-FIND(FIRST xlatedb.XL_SelectedFilter where
                           xlatedb.XL_SelectedFilter.Statement  = InputLine[6] and
                           xlatedb.XL_SelectedFilter.Item       = InputLine[7]).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IsALpha Dialog-Frame
PROCEDURE IsALpha :
DEFINE OUTPUT PARAMETER pFoundIt AS LOGICAL NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO. /* ASC of character */
DEFINE VARIABLE j AS INTEGER NO-UNDO. /* length of string */

     /* Check what code page we should be looking at
      * (xlatedb.XL_Project.CodePage x(12) or SESSION:CPINTERNAL?
      * look at the appropriate ISALPHA attribute table.
      * For double-byte languages, use tables IS-LEADBYTE and IS-TRAILBYTE
      * which specify valid lead/trail bytes for each character */
     /* For now only deal with English A-Z, a-z */

     pFoundIt = TRUE.
     /* Check each character - if you find any alphas, set pFoundIt = FALSE */
     Do j = 1 to LENGTH(InputLine[3]):
        i = ASC(SUBSTRING(InputLine[3],j,1,"FIXED":u)).
        If (i >= ASC("A":u) and i <= ASC("Z":u)) or (i >= ASC("a":u) and i <= ASC("z":u)) Then
do:
          pFoundIt = FALSE.
          leave.
end.
     End.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
