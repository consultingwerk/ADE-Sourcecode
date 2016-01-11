/* fix020010seqref.p
   This program fixes the formats on existing sequences that the framework
   uses to make use of the &S site number mask so that we can avoid sequence
   clashes. */
   PUBLISH "DCU_WriteLog":U ("Changing sequence formats...").
   
   RUN replaceFormat (9451.24, "ICFREL_&9":U, "ICFREL&S_&9":U).
   RUN replaceFormat (2259873.0, "ICF_&9":U, "ICF&S_&9":U).
   RUN replaceFormat (2262945.0, "ASRDF_&9":U, "ASRDF&S_&9":U).
   RUN replaceFormat (2262946.0, "ASRFM_&9":U, "ASRFM&S_&9":U).

PROCEDURE replaceFormat:
  DEFINE INPUT  PARAMETER oObj       AS DECIMAL DECIMALS 9   NO-UNDO.
  DEFINE INPUT  PARAMETER cOldFormat AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER cNewFormat AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bgsc_sequence FOR gsc_sequence.
 
  DISABLE TRIGGERS FOR LOAD OF bgsc_sequence.

  DO TRANSACTION:
    FIND bgsc_sequence
      WHERE bgsc_sequence.sequence_obj = oObj
      NO-ERROR.
    IF AVAILABLE(bgsc_sequence) AND
       bgsc_sequence.sequence_format = cOldFormat THEN
    DO:
      ASSIGN
        bgsc_sequence.sequence_format = cNewFormat
      .
      PUBLISH "DCU_WriteLog":U ("  Sequence: " + bgsc_sequence.sequence_short_desc
                                + " Old Format: " + cOldFormat
                                + " New Format: " + cNewFormat).

      
    END.
  END.
END.

