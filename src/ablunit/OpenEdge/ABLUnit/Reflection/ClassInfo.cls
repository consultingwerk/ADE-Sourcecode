/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/ 
 /*------------------------------------------------------------------------
    File        : ClassInfo
    Purpose     : Stores the information of the class and annotation preceding the class
    Syntax      : 
    Description : 
    Author(s)   : hgarapat
    Created     : Fri Jul 13 14:51:10 IST 2012
    Notes       : 
  ----------------------------------------------------------------------*/

USING OpenEdge.Core.Collections.Array.

CLASS OpenEdge.ABLUnit.Reflection.ClassInfo: 

	DEFINE PRIVATE VARIABLE className AS CHARACTER NO-UNDO.
	DEFINE PUBLIC PROPERTY annotationsInfo AS Array NO-UNDO GET. SET.
	
	CONSTRUCTOR PUBLIC ClassInfo (INPUT classN AS CHARACTER, INPUT annotationsInfo AS Array):
        	className = classN.
        	THIS-OBJECT:annotationsInfo = annotationsInfo.	
	END CONSTRUCTOR.

	METHOD PUBLIC CHARACTER getClassName(  ):
		RETURN className.
	END METHOD.    


    METHOD PUBLIC Array getAnnotations(  ):
        RETURN annotationsInfo.
    END METHOD.    

END CLASS.