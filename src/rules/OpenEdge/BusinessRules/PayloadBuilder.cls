/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : PayloadBuilder
    Purpose     : Helper class to encapsulate building of the XML payload for 
                  a DecisionService Call 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed May 08 10:20:10 EDT 2013
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.BusinessRules.DecisionServiceSelectorEnum.
using OpenEdge.Lang.TimeStamp.
using OpenEdge.Lang.Assert.

class OpenEdge.BusinessRules.PayloadBuilder use-widget-pool:
    
    define variable mhSaxWriter as handle no-undo.
    
    constructor public PayloadBuilder():
        create sax-writer mhSaxWriter.
    end constructor.
    
    destructor PayloadBuilder():
        delete object mhSaxWriter no-error.
    end destructor.
    
    /** Builds the XML payload document payload for passing into a Decision Service.
        
        @param  character (mandatory) The decision service nam,e
        @param  DecisionServiceSelectorEnum (mandatory) The criterion used to select the service
        @param  character (optional) The value used to select the decision service
        @param  handle    (optional) A handle to a ProDataSet containing payload data
        @return longchar  A completed payload XML document  */
    method public longchar BuildPayload(input pcDecisionServiceName as character,
                                        input poDecisionServiceSelector as DecisionServiceSelectorEnum,
                                        input pcSelectorValue as character,
                                        input phAppData as handle):
        define variable iNumBuffers as integer no-undo.
        define variable iBufferLoop as integer no-undo.
        define variable lcPayload as longchar no-undo.
        define variable cAttributeName as character no-undo.
        
        Assert:ArgumentNotNull(pcDecisionServiceName, 'Decision Service Name').
        Assert:ArgumentNotNull(poDecisionServiceSelector, 'Decision Service Selector'). 
        
        mhSaxWriter:reset().
        mhSaxWriter:set-output-destination('longchar', lcPayload).
        mhSaxWriter:encoding = 'utf-8'.
        mhSaxWriter:start-document().
        mhSaxWriter:start-element('execute').
          mhSaxWriter:start-element('CorticonRequest').
            mhSaxWriter:declare-namespace('urn:Corticon').
            mhSaxWriter:declare-namespace('http://www.w3.org/2001/XMLSchema-instance', 'xsi').
            mhSaxWriter:insert-attribute('decisionServiceName', pcDecisionServiceName).
            
        /* Only one selector is used (or none) */
        case poDecisionServiceSelector:
            when DecisionServiceSelectorEnum:Date    then cAttributeName = 'decisionServiceEffectiveTimestamp'.
            when DecisionServiceSelectorEnum:Version then cAttributeName = 'decisionServiceTargetVersion'.
            when DecisionServiceSelectorEnum:Default then cAttributeName = ''.
        end case.
        
        if cAttributeName ne '' then
            mhSaxWriter:insert-attribute(cAttributeName, pcSelectorValue).
        
        mhSaxWriter:start-element('ns1:WorkDocuments').
          mhSaxWriter:declare-namespace('urn:Corticon', 'ns1').
        
        if valid-handle(phAppData) then
        do:
            assign iNumBuffers = phAppData:num-top-buffers.
            do iBufferLoop = 1 to iNumBuffers:
                WriteBufferData(
                    phAppData:get-top-buffer(iBufferLoop),
                    phAppData:top-nav-query(iBufferLoop)).
            end.
        end. /* valid dataset */
        
              mhSaxWriter:end-element('ns1:WorkDocuments').
            mhSaxWriter:end-element('CorticonRequest').
          mhSaxWriter:end-element('execute').
        mhSaxWriter:end-document().
        
        if session:debug-alert then
            copy-lob lcPayload to file session:temp-dir + '/payload.xml'.
        
        return lcPayload.
    end method.
    
    method public void WriteBufferData(input phBuffer as handle,
                                       input phQuery as handle):
        define variable cElementName as character no-undo.
        define variable iFieldLoop as integer no-undo.
        define variable iNumFields as integer no-undo.
        define variable iChildRelationLoop as integer no-undo.
        define variable iNumChildRelations as integer no-undo.
        define variable hRelation as handle no-undo.
        define variable hField as handle no-undo.
        define variable lcValue as longchar no-undo.
        define variable mBlobData as memptr no-undo.
        
        /* Corticon requires us to have the nested entities referred to by the
           association name (which is the relation name in ABL), and not by the
           entity name (buffer name in ABL). This is because in Corticon an
           entity may be a part of multiple associations/relations, and simply
           being nested would not provide sufficient information. */
        if valid-handle(phBuffer:parent-relation) then
            cElementName = phBuffer:parent-relation:name.
        else
            cElementName = phBuffer:xml-node-name.
        
        phQuery:query-open().
        phQuery:get-first().
        
        do while not phQuery:query-off-end:
            mhSaxWriter:start-element(cElementName).
            mhSaxWriter:insert-attribute('id', substitute('&1_id_&2', phBuffer:xml-node-name, string(phBuffer:recid))).
            mhSaxWriter:insert-attribute('tt', phBuffer:name).
            
            /* write fields inline for a (small) perf boost */
            iNumFields = phBuffer:num-fields.
            do iFieldLoop= 1 to iNumFields:
                hField = phBuffer:buffer-field(iFieldLoop).
                
                /* skip the field, if it's marked as such */
                if hField:serialize-hidden then
                    next.
                
                mhSaxWriter:start-element(hField:xml-node-name).
                          
                if hField:buffer-value eq ? then
                    mhSaxWriter:insert-attribute('xsi:nil', 'true').
                else
                do:
                    case hField:data-type:
                        when 'blob' or when 'raw' or when 'rowid' then
                        do on error undo, throw:
                            /* Copy no-error so that we always have a memptr to work with.
                               the copy-lob fails if there's no data, and we rely on
                               the size of the memptr to tell us that.
                               
                               The unknown value check above also fails for BLOB
                               fields, so do that work here. */
                            copy-lob hField:buffer-value to mBlobData no-error.
                            if get-size(mBlobData) gt 0 then
                                mhSaxWriter:write-characters(base64-encode(mBlobData)).
                            else
                                mhSaxWriter:insert-attribute('xsi:nil', 'true').
                            finally:
                                set-size(mBlobData) = 0.
                            end finally.
                        end.
                        when 'clob' then
                        do:
                            lcValue = hField:buffer-value.
                            mhSaxWriter:write-characters(lcValue).
                        end.
                        when 'date' then 
                            /* Corticon Server maintains the date format masks that 
                               are passed into the Decision Service. The payload
                               reader code is expecting YYYY-MM-DD format. */
                            mhSaxWriter:write-characters(substitute('&1-&2-&3',
                                    string(year(hField:buffer-value), '9999'),
                                    string(month(hField:buffer-value), '99'),
                                    string(day(hField:buffer-value), '99'))).
                        when 'datetime' or when 'datetime-tz' then 
                            mhSaxWriter:write-characters(TimeStamp:ToISODateFromABL(datetime-tz(hField:buffer-value))).
                        when 'logical' then
                            mhSaxWriter:write-characters(trim(string(hField:buffer-value, 'true/false'))).
                        when 'decimal' then
                            /* Corticon Server uses American numeric formats */
                            mhSaxWriter:write-characters(
                                replace(string(hField:buffer-value),
                                        session:numeric-decimal-point,
                                        '.')).
                        otherwise
                            mhSaxWriter:write-characters(string(hField:buffer-value)).                        
                    end case.
                end.    /* non-nil value */
                mhSaxWriter:end-element(hField:xml-node-name).
            end.    /* field loop */
            
            /* Only recurse into nested relations; other relations' buffers
               will appear in the top-level buffer list */
            iNumChildRelations = phBuffer:num-child-relations.
            do iChildRelationLoop = 1 to iNumChildRelations:
                hRelation = phBuffer:get-child-relation(iChildRelationLoop).
                if not hRelation:recursive then
                    WriteBufferData(hRelation:child-buffer, hRelation:query).
            end.    /* child relation loop */
            
            mhSaxWriter:end-element(cElementName).

            phQuery:get-next().
        end.    /* query loop */
        
        finally:
            phQuery:query-close().
        end finally.
    end method.
end class.

