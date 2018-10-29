
/*------------------------------------------------------------------------
    File        : SessionStartup.p
    Purpose     : 

    Syntax      :

    Description : SessionStartup Procedure for LogAnalyzer

    Author(s)   : isyed
    Created     : Thu Jan 04 13:02:41 EST 2018
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.
USING OpenEdge.LogAnalyzer.Events.InvokeEvents FROM PROPATH.

/* ***************************  Main Block  *************************** */
DEFINE INPUT  PARAMETER pcArgs AS CHARACTER NO-UNDO.

NEW OpenEdge.LogAnalyzer.Events.InvokeEvents().

        
CATCH e AS Progress.Lang.Error :
        
    MESSAGE e:GetMessage(1). 
    RETURN ERROR e:GetMessage(1).
        
END CATCH.
