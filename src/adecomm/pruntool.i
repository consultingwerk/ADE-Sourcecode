/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*****************************************************************************
  File        : pruntool.i
  Purpose     : Internal Procedures for determining if procedures are
                running, etc.

  Syntax      : 
                  { adecomm/pruntool.i }
                  
  Description : 

  Notes:

  Author      : John Palazzo
  Date Created: 04/02/93
*****************************************************************************/


PROCEDURE ProgramIsRunning .
/*----------------------------------------------------------------------------
  Purpose     : Returns TRUE if a specified procedure is actively running
                in the PROGRESS session.  Returns FALSE otherwise.
  Syntax      : 
                  RUN ProgramIsRunning( INPUT  p_Program_Name , 
                                        OUTPUT p_Program_IsRunning ) .
                  
  Description : 
  
  Author      : John Palazzo
  Date Created: 04/02/93
----------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p_Program_Name      AS CHAR .
    DEFINE OUTPUT PARAMETER p_Program_IsRunning AS LOGICAL.

    DEFINE VAR Programs_List AS CHAR .
    DO : /* proc-main */
        
        RUN ProgramsRunning( OUTPUT Programs_List ) .
        p_Program_IsRunning = ( LOOKUP( p_Program_Name , Programs_List ) > 0 ).
    
    END . /* proc-main */
    
END PROCEDURE .


PROCEDURE ProgramsRunning .
/*----------------------------------------------------------------------------
  Purpose     : Returns comma-delimited list of procedure names the current 
                PROGRESS session is actively running.
  Syntax      : 
                  RUN ProgramsRunning ( OUTPUT p_Programs_List ) .
                  
  Description : Loops through PROGRAM-NAME function and builds comma-delimited
                list.  DOES include itself in the list.

  Author      : John Palazzo
  Date Created: 04/02/93
----------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER p_Programs_List AS CHAR .

    DEFINE VAR ProgramN AS INTEGER .

 
    DO : /* proc-main */

        ASSIGN
            ProgramN = 1 
            .
        REPEAT WHILE ( PROGRAM-NAME( ProgramN ) <> ? ) :
            MESSAGE PROGRAM-NAME( ProgramN ) 
                VIEW-AS ALERT-BOX.
            p_Programs_List = p_Programs_List + "," + PROGRAM-NAME( ProgramN ) .
            ProgramN        = ProgramN + 1 .
        END . /* DO WHILE */

    END . /* proc-main */
    
END PROCEDURE .

PROCEDURE RunBy.
/*----------------------------------------------------------------------------
  Purpose     : Returns the name of the calling procedure.

  Syntax      : 
                  RUN RunBy ( INPUT p_Level , OUTPUT p_Program_Name ) .
                  
  Description : p_Level is the level up from the current program that
                you want to know the calling program name.

  Author      : John Palazzo
  Date Created: 09/08/95
----------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Level         AS INTEGER   NO-UNDO .
  DEFINE OUTPUT PARAMETER p_Program_Name  AS CHARACTER NO-UNDO INITIAL ?.

  DEFINE VAR ProgramN AS INTEGER NO-UNDO.
  DEFINE VAR Num_Runs AS INTEGER NO-UNDO.
 
  DO : /* proc-main */
      IF p_Level = 0 THEN RETURN.
       
      /* Start above this internal procedure and it caller. */
      ASSIGN ProgramN = 3 .
      
      IF p_Level = ? THEN
      DO:
        DO WHILE TRUE:
          IF PROGRAM-NAME(ProgramN) <> ? THEN
            ASSIGN ProgramN = ProgramN + 1.
          ELSE
          DO:
            ASSIGN p_Program_Name = PROGRAM-NAME(ProgramN - 1).
            LEAVE.
          END.
        END.
        RETURN.
      END.

      DO WHILE ( PROGRAM-NAME( ProgramN ) <> ? ) :
        IF NUM-ENTRIES(PROGRAM-NAME(ProgramN) , " ":U) = 1 THEN
        DO:
          ASSIGN Num_Runs = Num_Runs + 1.
          IF Num_Runs = p_Level THEN
          DO:
              ASSIGN p_Program_Name = PROGRAM-NAME(ProgramN).
              RETURN.
          END.
        END.
        
        ASSIGN ProgramN = ProgramN + 1.
        IF PROGRAM-NAME(ProgramN) = ? THEN
        DO:
            ASSIGN p_Program_Name = PROGRAM-NAME(ProgramN - 1).
            RETURN.
        END.
      END . /* DO WHILE */

  END . /* proc-main */
  
END PROCEDURE .

/*  DEFINE VAR l_Level         AS INTEGER   NO-UNDO .
 *   DEFINE VAR l_Program_Name  AS CHARACTER NO-UNDO .
 * 
 * run runby ( 1 , OUTPUT l_Program_Name ).
 * message l_Program_Name view-as alert-box title "Run By".
 * */
