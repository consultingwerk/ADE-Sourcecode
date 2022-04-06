/* hmapmain.i - Main Code Block for HTML Mapping Procedures. 
   Wn.T.Wood 5/96
   D.M.Adams 3/98 Modifed for Skywalker ADM2
*/
/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
  RUN destroy NO-ERROR.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON STOP    UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* Create temp-table record for unmapped fields. */
  &IF INDEX("{&DISPLAYED-TABLES}":U,"ab_unmap":U) ne 0 &THEN
  CREATE ab_unmap.
  &ENDIF
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"adm-create-objects") THEN
  DO:
     RUN adm-create-objects.
  END.
  ELSE DO:  
   /* If adm-create-objects is not here we start the SDO as pre 3.1 */
    ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, THIS-PROCEDURE:ADM-DATA, CHR(1)))
           ghProp = ghProp:BUFFER-FIELD('DataSourceFile':U).    
    IF ghProp:BUFFER-VALUE NE "" THEN 
      DYNAMIC-FUNCTION('startDataObject':U, ghProp:BUFFER-VALUE).
  END.
  /* Load the HTM handles etc. */
  RUN initializeObject.
  
  /* Process the current web event. */
  RUN process-web-request.
END.

/* Run ADM2 destroy procedure if the procedure is ending. */
IF NOT THIS-PROCEDURE:PERSISTENT THEN 
  RUN destroyObject NO-ERROR.

/* hmapmain.i - end of file */
