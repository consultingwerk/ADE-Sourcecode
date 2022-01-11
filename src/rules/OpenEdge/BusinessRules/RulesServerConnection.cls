/************************************************
Copyright (c)  2013-2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : RulesServerConnection
    Purpose     : OE Rules Server connection
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 09 14:20:45 EDT 2013
    Notes       : * This class is a wrapper around the actual Server Connection,
                    which happens to initially be one or 2 WebService Connections.
                  * Methods that are interface implementations are documented in
                    the interface, unless there are significant exceptions.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.BusinessRules.RulesServerConnectionParameters.

using OpenEdge.Core.ServerConnection.WebServiceConnection.
using OpenEdge.Core.ServerConnection.IConnectionParameters.
using OpenEdge.Core.ServerConnection.WebServiceConnectionParameters.
using OpenEdge.Core.ServerConnection.IServerConnection.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Core.Assert.
using Progress.Lang.SoapFaultError.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.BusinessRules.RulesServerConnection use-widget-pool implements IServerConnection:
    define private variable moDecisionServiceConnection as WebServiceConnection no-undo.
    define private variable moAdminServiceConnection as WebServiceConnection no-undo.
    
    define private variable mhDecisionServicePort as handle no-undo.
    define private variable mhAdminServicePort as handle no-undo.
    
    /** A reference to the server. Returns a reference to the Decision Service's
        Server object. */  
    define public property Server as Object no-undo
        get():
            if valid-object(moDecisionServiceConnection) then
                return moDecisionServiceConnection:Server.
        end get.

    /** Parameters for this connection */
    define public property ConnectionParameters as IConnectionParameters no-undo get. private set.

    /**  Returns the result of the Decision Service server's Connected property */
	define public property Connected as logical no-undo 
        get():
            define variable lConnected as logical no-undo.
            
            if valid-object(moDecisionServiceConnection) then
                lConnected = moDecisionServiceConnection:Connected.
            if lConnected and valid-object(moAdminServiceConnection) then
                lConnected = moAdminServiceConnection:Connected.
            
            return lConnected.
        end get.

	constructor public RulesServerConnection (input poConnectionParameters as RulesServerConnectionParameters):
        Assert:NotNull(poConnectionParameters, 'Connection Parameters').
        this-object:ConnectionParameters = poConnectionParameters.
        
        moDecisionServiceConnection = new WebServiceConnection(cast(poConnectionParameters:DecisionServiceConnectionParameters, WebServiceConnectionParameters)).
        if valid-object(poConnectionParameters:AdminServiceConnectionParameters) then
            moAdminServiceConnection = new WebServiceConnection(cast(poConnectionParameters:AdminServiceConnectionParameters, WebServiceConnectionParameters)).
	end constructor.
	
    method public void CreateServer():
        moDecisionServiceConnection:CreateServer().
        
        if valid-object(moAdminServiceConnection) then
            moAdminServiceConnection:CreateServer().
    end method.

	method public void DestroyServer():
	    moDecisionServiceConnection:DestroyServer().
	    
	    if valid-object(moAdminServiceConnection) then
	       moAdminServiceConnection:DestroyServer().
	end method.

	method public void Connect():
	    define variable hRulesService as handle no-undo.
	    
	    if not moDecisionServiceConnection:Connected then
	    do:
    	    moDecisionServiceConnection:Connect().
    	    
    	    hRulesService = cast(moDecisionServiceConnection:Server, WidgetHandle):Value.
    
            run value(moDecisionServiceConnection:PortName) set mhDecisionServicePort on hRulesService.	
        end.
                
        if valid-object(moAdminServiceConnection) and
           not moAdminServiceConnection:Connected then
        do:
            moAdminServiceConnection:Connect().
            
            hRulesService = cast(moAdminServiceConnection:Server, WidgetHandle):Value.
    
            run value(moAdminServiceConnection:PortName) set mhAdminServicePort on hRulesService.
        end.
	end method.

	method public void Disconnect():
	    moDecisionServiceConnection:Disconnect().
	    
	    if valid-object(moAdminServiceConnection) then
            moAdminServiceConnection:Disconnect().
        
	    delete object mhDecisionServicePort no-error.
	    /* simplere just to delete no-error than check first */
        delete object mhAdminServicePort no-error.
	end method.
	
	/** Invokes a decision service on the Rules Server
	   
	   @param  longchar The message/payload to send
	   @return longchar The results of the service call. */
	method public longchar InvokeDecisionService(input pcRequestDocument as longchar):
        define variable lcResponseDocument as longchar no-undo.
        define variable xmlDoc  as handle no-undo.
        define variable xmlNode as handle no-undo.

        if not this-object:Connected then
            this-object:Connect().
        
        if session:debug-alert then
            copy-lob pcRequestDocument to file session:temp-dir + '/decisionservice-request.xml'.
        
        /* make the call across the wire. */
        run value(moDecisionServiceConnection:Operation) in mhDecisionServicePort (
                    input pcRequestDocument, 
                    output lcResponseDocument).
        
        if session:debug-alert then
            copy-lob lcResponseDocument to file session:temp-dir + '/decisionservice-response.xml'.
        
        return lcResponseDocument.
        catch oSoapError as SoapFaultError:
            define variable oAppError as AppError no-undo.
            
            oAppError = new AppError(oSoapError:GetMessage(1)).
            IF oSoapError:GetMessageNum(1) EQ 11506 THEN DO:
                create x-document xmlDoc.
                create x-noderef xmlNode.
    
                xmlDoc:load('longchar', pcRequestDocument, false).
                xmlDoc:get-document-element(xmlNode).

                oAppError:AddMessage(substitute('Decision Service &1 is not available on the Business Rules server',
                                                 quoter(xmlNode:get-attribute ('decisionServiceName'))), 0).
            END.
            ELSE DO:
                oAppError:AddMessage(oSoapError:SoapFault:soap-fault-code, oSoapError:GetMessageNum(1)).
                oAppError:AddMessage(oSoapError:SoapFault:soap-fault-actor, oSoapError:GetMessageNum(1)).
            END.
            undo, throw oAppError.
        end catch.
        finally:
            delete object xmlDoc no-error.
            delete object xmlNode no-error.
        end finally.
    end method.
    
    /** Returns true if any version of a specified Decision Service is deployed. 
        
        @param character The decision service name.
        @return logical Whether the decision service is deployed of not. */
    method public logical IsDecisionServiceAvailable(input pcServiceName as character):
        return true.
    end method.
     
    /** Returns true if a particular version of a specified Decision Service is deployed. 
        
        @param character The decision service name.
        @param decimal The version to query.
        @return logical Whether the decision service is deployed of not. */
    method public logical IsDecisionServiceAvailable(input pcServiceName as character, 
                                                     input pdVersion as decimal):
        return true.                                                 
    end method.
    
    /** Returns true if any version of a specified Decision Service is deployed
        on a specified effective date. 
        
        @param character The decision service name.
        @param datetime-tz The effective datetime stamp on which a decision service
                           is deployed.
        @return logical Whether the decision service is deployed of not. */    
    method public logical IsDecisionServiceAvailable(input pcServiceName as character, 
                                                     input ptEffectiveOn as datetime-tz):
        
        return true.
    end method.    
    
    method override public character ToString():
        return this-object:ConnectionParameters:GetConnectionString().
	end method.
	
end class.
