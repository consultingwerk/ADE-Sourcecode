/* Purpose : The procedure will read through all the current SDO's in the repository,
             check if it is a valid SDO in the PROPATH, check if the SDO has a 
             Logic Procedure and edit the Server and Client side programs to ensure
             that any BACKSLASHES '\' are changed to FORWARDSLASHES '/'
             See issue #3511 - Inconsistent use of slashes in Generated SDO's and logic procedure
    Author : Mark Davies (MIP)
      Date : 01/16/2002
                                                                                                 */
                                                                                                 
&GLOBAL-DEFINE FRAME-NAME EDIT-FRAME

/* Set this value to TRUE to indicate that errors were found during fix */
DEFINE VARIABLE lShowErrors AS LOGICAL    NO-UNDO INITIAL FALSE.

DEFINE VARIABLE eEdit AS CHARACTER VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 200 BY 20 NO-UNDO FONT 2.
DEFINE VARIABLE iOffset       AS INTEGER    NO-UNDO.
DEFINE VARIABLE cSDOFileName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLogicProc    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lErrors       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cLogFile      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLogicProcCln AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBackSlash    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cForwardSlash AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lSaveOk       AS LOGICAL    NO-UNDO.

FORM eEdit AT ROW 1 COL 1 NO-LABEL
    WITH FRAME {&FRAME-NAME} 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 200 BY 20.

DEFINE STREAM stErr.

FUNCTION editFixCRLF RETURNS LOGICAL FORWARD.

eEdit:PROGRESS-SOURCE = YES.

/* Read through SDO records in Repository */
FIND FIRST gsc_object_type
     WHERE gsc_object_type.object_type_code = "SDO":U
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE gsc_object_type THEN DO:
  MESSAGE "Could not find object type for SDO"
          VIEW-AS ALERT-BOX.
  RETURN.
END.

lErrors = FALSE.
cLogFile = REPLACE(SESSION:TEMP-DIR,"~\":U,"/":U) + "sdoslasherr.txt".
OUTPUT STREAM stErr TO VALUE(cLogFile).
REPO_LOOP:
FOR EACH gsc_object 
    WHERE gsc_object.object_type_obj = gsc_object_type.object_type_obj,
    FIRST gsc_product_module 
    WHERE gsc_product_module.product_module_obj = gsc_object.product_module_obj
    AND   NOT gsc_product_module.product_module_code BEGINS "ry":U
    AND   NOT gsc_product_module.product_module_code BEGINS "af":U
    AND   NOT gsc_product_module.product_module_code BEGINS "db":U
    AND   NOT gsc_product_module.product_module_code BEGINS "dcu":U
    AND   NOT gsc_product_module.product_module_code BEGINS "icf":U
    AND   NOT gsc_product_module.product_module_code BEGINS "rtb":U
    AND   NOT gsc_product_module.product_module_code BEGINS "rv":U
    AND   NOT gsc_product_module.product_module_code BEGINS "scmrtb":U
    NO-LOCK:
  /* Clear Editor */
  eEdit:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U.
  
  cSDOFileName = REPLACE(TRIM(gsc_object.object_path),"~\":U,"/":U) + "/":U + TRIM(gsc_object.object_filename) + (IF TRIM(gsc_object.object_extension) <> "":U THEN ".":U + TRIM(gsc_object.object_extension) ELSE "":U).
  IF SEARCH(cSDOFileName) = ? THEN DO:
    PUT STREAM stErr UNFORMATTED "The following SDO could not be found in your PROPATH : " + cSDOFileName SKIP.
    lErrors = TRUE.
    NEXT REPO_LOOP.
  END.
  ASSIGN cBackSlash   = REPLACE(gsc_object.object_path,"/":U,"~\":U) + "~\":U
         cForwardSlash = REPLACE(gsc_object.object_path,"~/":U,"/":U) + "/":U.

  RUN extractLogicProcedure (INPUT  SEARCH(cSDOFileName),
                             OUTPUT cLogicProc).

  IF cLogicProc = "":U THEN DO:
    PUT STREAM stErr UNFORMATTED "The following SDO does not have a logical procedure : " + cSDOFileName SKIP.
    lErrors = TRUE.
    NEXT REPO_LOOP.
  END.
  
  IF SEARCH(cLogicProc) = ? THEN DO:
    PUT STREAM stErr UNFORMATTED "The following Logical Procedure could not be found in your PROPATH : " + cLogicProc SKIP.
    lErrors = TRUE.
    NEXT REPO_LOOP.
  END.
  
  /* First fix the logic procedure */
  DO WITH FRAME {&FRAME-NAME}:
      eEdit:SCREEN-VALUE = "":U.
      eEdit:READ-FILE(SEARCH(cLogicProc)).
      editFixCRLF().
      eEdit:REPLACE(cBackSlash,cForwardSlash,24).
      lSaveOk = TRUE.
      lSaveOk = eEdit:SAVE-FILE(SEARCH(cLogicProc)) NO-ERROR.
      IF lSaveOk = FALSE THEN
        PUT STREAM stErr UNFORMATTED "The following file could not be changed - file might be read-only : " + cLogicProc SKIP.
        lErrors = TRUE.
  END.
  /* Now fix the logic procedure's client side procedure */
  cLogicProcCln = REPLACE(cLogicProc,".p":U,"_cl.p":U).
  IF SEARCH(cLogicProcCln) = ? THEN
    NEXT REPO_LOOP.
  DO WITH FRAME {&FRAME-NAME}:
      eEdit:SCREEN-VALUE = "":U.
      eEdit:READ-FILE(SEARCH(cLogicProcCln)).
      editFixCRLF().
      eEdit:REPLACE(cBackSlash,cForwardSlash,24).
      lSaveOk = TRUE.
      lSaveOk = eEdit:SAVE-FILE(SEARCH(cLogicProcCln)) NO-ERROR.
      IF lSaveOk = FALSE THEN
        PUT STREAM stErr UNFORMATTED "The following file could not be changed - file might be read-only : " + cLogicProcCln SKIP.
        lErrors = TRUE.

  END.
END.
OUTPUT STREAM stErr CLOSE.

IF lErrors = TRUE AND 
   lShowErrors = TRUE THEN
  MESSAGE "Errors were logged in " cLogFile
          VIEW-AS ALERT-BOX.


PROCEDURE extractLogicProcedure:
/*------------------------------------------------------------------------------
  Purpose:     Extracts the Logical Procedure name from the SDO defenition section
  Notes:        
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSDOFileName AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcLogicProc   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iStart     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEnd       AS INTEGER    NO-UNDO.
  

  DO WITH FRAME {&FRAME-NAME}:
      eEdit:READ-FILE(pcSDOFileName).
      editFixCRLF().
      
      eEdit:CURSOR-OFFSET = 1.
      eEdit:SEARCH("&glob DATA-LOGIC-PROCEDURE":U,37).
      iStart = eEdit:SELECTION-START.
      eEdit:SEARCH(".p",37).
      iEnd = eEdit:SELECTION-END.
      pcLogicProc = "":U.
      IF iStart > 1 THEN DO:
          eEdit:SET-SELECTION ( iStart , iEnd ).
          pcLogicProc = eEdit:SELECTION-TEXT.
          pcLogicProc = TRIM(REPLACE(pcLogicProc,"&glob DATA-LOGIC-PROCEDURE":U,"":U)).
      END.
      IF pcLogicProc = ? OR
         TRIM(pcLogicProc) = "":U THEN
        pcLogicProc = "":U.
  END.
END PROCEDURE. 

FUNCTION editFixCRLF RETURNS LOGICAL:
/*------------------------------------------------------------------------------
  Purpose:  Changes all single CHR(10) to CR/LF so that template files saved on a unix 
            file system will not cause errors when read on a windows system
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VARIABLE lResult AS LOGICAL    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    eEdit:CURSOR-OFFSET = 1.
    IF eEdit:SEARCH(CHR(10),17) AND NOT eEdit:SEARCH(CHR(10) + CHR(13),17) THEN
      lResult = eEdit:REPLACE(CHR(10),CHR(10) + CHR(13),8).
    eEdit:CURSOR-OFFSET = 1.
  END.

  RETURN lResult.

END FUNCTION.
