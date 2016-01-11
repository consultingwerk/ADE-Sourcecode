/************************************************
Copyright (c)  2013, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : SessionClientTypeEnum
    Purpose     : Enumeration of ABL client types, as per the SESSION:CLIENT-TYPE 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 18 15:08:28 EST 2010
    Notes       : * Descriptions appear in the ABL documentation.
                  * This class based on the AutoEdge|TheFactory version
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

enum OpenEdge.Core.SessionClientTypeEnum:
    define enum       ABLClient 
                      WebClient 
                      AppServer 
                      WebSpeed  
                      Multi-Session-Agent
                      PacificAS = Multi-Session-Agent 
                      Other.
end enum.
