/*************************************************************/
/* Copyright (c) 2010,2025 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : DataAccessError
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Fri Aug 06 13:23:06 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.DataAccess.IDataMapper from propath.
using OpenEdge.DataAdmin.Error.DataError from propath.

class OpenEdge.DataAdmin.DataAccess.DataAccessError inherits DataError:    
	/*------------------------------------------------------------------------------
	Purpose:  																	  
	Notes:   																	  
	------------------------------------------------------------------------------*/
		
	constructor public DataAccessError (msg as char ):
		super (msg).
	end constructor.
    
    constructor public DataAccessError (mapper as IDataMapper,e as Error):
/*        define variable i as integer no-undo.*/
        super (TransformMessage(e:GetMessage(1),e:GetMessageNum(1),mapper),e).  
/*        do i = 2 to e:NumMessages:                                                    */
/*            AddMessage(TransformMessage(e:GetMessage(i),e:GetMessageNum(i),mapper),?).*/
/*        end.                                                                          */
        /* store the mapper if needed for addmessage ?*/
    end constructor.
    
    /* constructor added specifically to handle authenticationsystem already exists 
      (replace "domain type" with "name" in message and pass it as char) */
    constructor public DataAccessError (mapper as IDataMapper,cmsg as char, num as int, e as Error):
        super (TransformMessage(cMsg,num,mapper),e).  
    end constructor.

	constructor public DataAccessError ( e as Error ):
		super (input e).
	end constructor.
	
	constructor public DataAccessError ( cMsg as character, e as Error ):
		super (input cMsg, input e).	
	end constructor.

    method protected character TransformMessage(pMsg as char,pNum as int,pMapper as IDataMapper):
        define variable i   as integer no-undo.
        define variable cWord as character no-undo. 
        define variable cTarget as character no-undo. 
        define variable cTable as character no-undo.
        define variable lendswithperiod as logical no-undo.
        /* note - if we decide to keep number then we need to add them back below as the
          logic to find ending period depends on this removal */
        pMsg = trim(replace(pMsg,"(" + string(pNum) + ")","")).
        if r-index(pMsg,".") = length(pMsg) then
        do:
            lendswithperiod = true.
            pmsg = right-trim(pMsg,".") .
        end.      
        do i = 1 to num-entries(pMsg," "):
           cWord = entry(i,pMsg," ").
           /* remove end period as it is not part of last word */
           if num-entries(cWord,".") = 1 then                 
               cTarget = pMapper:GetTargetTable(cWord).
           if cTarget = "" then
               cTarget = pMapper:GetTargetColumn(cWord).
           /* check qualified word in error message against unqualified mapping */
           if cTarget = "" and num-entries(cWord,".") = 2 then
           do:
               cTable = pMapper:GetTargetTable(entry(1,cWord,".")). 
               if cTable > "" then
               do:
                   cTarget = pMapper:GetTargetColumn(entry(2,cWord,".")).
                   if cTarget > " " then 
                   do:
                       cTarget = cTable + " " + cTarget.
                   end.    
               end.             
           end.
           if cTarget > "" then 
               entry(i,pMsg," ") = cTarget.
                
        end.
       
        return pmsg + if lendswithperiod then "." else "".   
    end method.     
    
end class.
