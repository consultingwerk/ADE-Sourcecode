/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  ptools.i
  Tools Menu Related Procedures for Editor 
--------------------------------------------------------------------------*/


PROCEDURE RunTool .
/*----------------------------------------------------------------------------
  Purpose     : Runs an ADE Tool.  Tool to run cannot have Run-Time Parameters
                or arguments.
  Syntax      : 
                  RUN RunTool( INPUT  p_Program_Name ) .
                  
  Description : 

  Author      : John Palazzo
  Date Created: 04/02/93
----------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p_Program_Name  AS CHAR .

    DEFINE VAR Can_Run AS LOGICAL .

    DO ON STOP UNDO, LEAVE : /* proc-main */
        RUN CheckTool( INPUT p_Program_Name , INPUT YES /* disp alert-box */ ,
                       OUTPUT Can_Run ) .
        IF ( Can_Run = NO ) THEN RETURN .
        RUN RunProc ( INPUT p_Program_Name , 
                      INPUT TRUE /* Never Pause After Run */ ).
    END . /* proc-main */
    
END PROCEDURE .


PROCEDURE disable_widgets .
  /*--------------------------------------------------------------------------
    Purpose:     Routine called from Tools Menu to disable editor
                 before running ADE Tool.
    
    Run Syntax:  RUN disable_widgets .
    Parameters:  None.

    Description:
    Notes:
  --------------------------------------------------------------------------*/

  RUN DisableEditor
	( INPUT win_Proedit, 
	  INPUT Run_Window, 
	  INPUT Editor_Name + " - Run",
	  INPUT Compile_FileName ) .
    
END.


PROCEDURE enable_widgets.
  /*--------------------------------------------------------------------------
    Purpose:     Routine called from Tools Menu to enable editor
                 after running ADE Tool.
    
    Run Syntax:  RUN disable_widgets .
    Parameters:  None.

    Description:
    Notes:
  --------------------------------------------------------------------------*/

  RUN EnableEditor
	( INPUT win_Proedit, 
	  INPUT Run_Window, 
	  INPUT Editor_Name + " - Run",
	  INPUT Compile_FileName ,
	  INPUT FALSE /* Does not force a no-pause after run */ ).
    
END.
