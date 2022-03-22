/* hmapmain.i - Main Code Block for HTML Mapping Procedures. 
    Bill Wood 5/96 */   

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN dispatch ('destroy':U).

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON STOP    UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  
  /* Load the HTM handles etc. */
  RUN dispatch IN THIS-PROCEDURE ('initialize':U).
 
  /* Process the current web event. */
  RUN dispatch IN THIS-PROCEDURE ('process-web-request':U).
END.

/* Run the local/adm-destroy procedures, if the procedure is ending.    */
IF NOT THIS-PROCEDURE:PERSISTENT THEN RUN dispatch ('destroy':U).   
