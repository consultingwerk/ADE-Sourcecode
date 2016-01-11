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
