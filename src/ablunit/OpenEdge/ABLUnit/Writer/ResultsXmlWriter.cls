/************************************************
Copyright (c) 2020-2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ResultsXmlWriter
    Purpose     : Writes a test run's output to a jUnit results.xml format
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2020-02-04
    Notes       : * The format of the XML is per https://llg.cubic.org/docs/junit/ and/or
                  https://github.com/junit-team/junit5/blob/master/platform-tests/src/test/resources/jenkins-junit.xsd
                  * USE-WIDGET-POOL in case there are handle leaks
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.ABLUnit.Model.TestCase.
using OpenEdge.ABLUnit.Model.TestClass.
using OpenEdge.ABLUnit.Model.TestEntity.
using OpenEdge.ABLUnit.Model.TestSuite.
using OpenEdge.ABLUnit.Results.TestResultEnum.
using OpenEdge.ABLUnit.Results.TestTestResult.
using OpenEdge.ABLUnit.Writer.IResultsWriter.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.Array.
using OpenEdge.Core.Collections.ICollection.

class OpenEdge.ABLUnit.Writer.ResultsXmlWriter
use-widget-pool
implements IResultsWriter:
    // holder of the first properties element; we clone it for all subsequent tests in this run
    define private variable mPropertiesElem as handle no-undo.
    
    /* Writes the test results to a longchar
       
       @param TestEntity The test to write (root)
       @param longchar The XML output, with a UTF-8 codepage */
    method public longchar WriteToLongchar(input pTestEntity as TestEntity):
        define variable xml as longchar no-undo.
        define variable xmlDoc as handle no-undo.
        
        create widget-pool.
        
        fix-codepage(xml) = 'utf-8':u.
        
        assign xmlDoc = WriteXml(pTestEntity).
        
        xmlDoc:save('longchar':u, xml).
        
        return xml.
        finally:
            delete widget-pool.
        end finally.
    end method.
    
    /* Writes the test results in the xml file
       
       @param character The XML file name.
       @param TestEntity The test to write (root)   */
    method public void WriteToFile(input pXmlFileName as character,
                                   input pTestEntity as TestEntity):
        define variable xmlDoc as handle no-undo.
        
        create widget-pool.
        
        assign xmlDoc = WriteXml(pTestEntity).
        
        xmlDoc:save('file':u, pXmlFileName).
        finally:
            delete widget-pool.
        end finally.
    end method.
    
    /* Writes the testENtity as XML
       
       @param  TestEntity The test to write (root)
       @param  ICollection A collection holding all X-DOC or X-NODEREF handles for cleanup after writing of the doc.
                           An invalid object may be passed in. A valid object will always be passed out.
       @return handle The XML document (X-DOC) */
    @deprecated(since="12.5.0").
    {&_proparse_ prolint-nowarn(varusage)}
    method protected handle WriteXml(input        pTestEntity as TestEntity,
                                     input-output pXmlRefs as ICollection):
        return WriteXml(pTestEntity).
    end method.
    
    /* Writes the TestEntity as XML
       
       @param  TestEntity The test to write (root)
       @return handle The XML document (X-DOC) */
    method protected handle WriteXml(input pTestEntity as TestEntity):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable xmlDoc as handle no-undo.
        define variable rootNode as handle no-undo.
        define variable entities as Array no-undo.
        
        assign xmlDoc   = CreateXmlDoc()
               rootNode = CreateXmlNode()
               entities = pTestEntity:getTestEntities()
               cnt      = pTestEntity:getChildrenSize()
               .
        xmlDoc:create-node(rootNode, 'testsuites':u, 'ELEMENT':u).
        xmlDoc:append-child(rootNode).
        
        rootNode:set-attribute('name':u,     'ABLUnit':u).
        rootNode:set-attribute('tests':u,    string(pTestEntity:Summary:TestCount)).
        rootNode:set-attribute('errors':u,   string(pTestEntity:Summary:errorCount)).
        rootNode:set-attribute('failures':u, string(pTestEntity:Summary:failureCount)).
        
        if pTestEntity:Summary:ignoreCount gt 0 then
        do:
            rootNode:set-attribute('skipped':u, string(pTestEntity:Summary:ignoreCount)).
            rootNode:set-attribute('ignored':u, string(pTestEntity:Summary:ignoreCount)).
        end.
        
        do loop = 1 to cnt:
            AddChildEntities(cast(entities:GetValue(loop), TestEntity), rootNode).
        end.
        
        return xmlDoc.
    end method.
    
    /* Creates a properties element, which has some runtime properties added
       
       @param handle The XML document the <properties> element is added to
       @param ICollection A collection to hold any X-DOC or X-NODEREF handles for cleanup after writing of the doc
       @return handle The <properties> element */
    @deprecated(since="12.5.0").
    {&_proparse_ prolint-nowarn(varusage)}
    method protected handle CreatePropertiesElement(input pDoc as handle,
                                                    input pXmlRefs as ICollection):
        return CreatePropertiesElement(pDoc).
    end method.
    
    /* Creates a properties element, which has some runtime properties added
       
       @param handle The XML document the <properties> element is added to
       @return handle The <properties> element */
    method protected handle CreatePropertiesElement(input pDoc as handle):
        define variable properties as handle no-undo.
        define variable propertyElem as handle no-undo.
        
        Assert:NotNull(pDoc, 'XML document').
        
        assign properties = CreateXmlNode().
        // clone the cached element and return
        if valid-handle(mPropertiesElem) then
        do:
            mPropertiesElem:clone-node(properties, true).
            return properties.
        end.
        // create a new element and cache
        assign propertyElem = CreateXmlNode().
        
        pDoc:create-node(properties, 'properties':u , 'ELEMENT':u).
        
        pDoc:create-node(propertyElem, 'property':u , 'ELEMENT':u).
            propertyElem:set-attribute('name',  'proversion':u).
            propertyElem:set-attribute('value', proversion(1)).
        properties:append-child(propertyElem).
        
        pDoc:create-node(propertyElem, 'property':u , 'ELEMENT':u).
            propertyElem:set-attribute('name',  'process-architecture':u).
            propertyElem:set-attribute('value', string(process-architecture)).
        properties:append-child(propertyElem).
        
        pDoc:create-node(propertyElem, 'property':u , 'ELEMENT':u).
            propertyElem:set-attribute('name',  'opsys':u).
            propertyElem:set-attribute('value', opsys).
        properties:append-child(propertyElem).
        
        pDoc:create-node(propertyElem, 'property':u , 'ELEMENT':u).
            propertyElem:set-attribute('name',  'window-system':u).
            propertyElem:set-attribute('value', session:window-system).
        properties:append-child(propertyElem).
        
        pDoc:create-node(propertyElem, 'property':u , 'ELEMENT':u).
            propertyElem:set-attribute('name',  'cpinternal':u).
            propertyElem:set-attribute('value', session:cpinternal).
        properties:append-child(propertyElem).
        
        pDoc:create-node(propertyElem, 'property':u , 'ELEMENT':u).
            propertyElem:set-attribute('name',  'startup-parameters':u).
            propertyElem:set-attribute('value', session:startup-parameters).
        properties:append-child(propertyElem).
        
        // assign the 'holder' a clone of this properties element
        assign mPropertiesElem = CreateXmlNode().
        properties:clone-node(mPropertiesElem, true).
        
        return properties.
    end method.
    
    /* Creates an X-NODEREF and caches it for later cleanup
       
       @param ICollection A collection to hold any X-DOC or X-NODEREF handles for cleanup after writing of the doc
       @return handle The newly created X-NODEREF handle */
    @deprecated(since="12.5.0").
    {&_proparse_ prolint-nowarn(varusage)}
    method protected handle CreateXmlNode(input pXmlRefs as ICollection):
        return CreateXmlNode().
    end method.
    
    /* Creates an X-NODEREF
       
       @return handle The newly created X-NODEREF handle */
    method protected handle CreateXmlNode():
        define variable xmlNode as handle no-undo.
        
        create x-noderef xmlNode.
        
        return xmlNode.
    end method.
    
    /* Creates an X-DOCUMENT and caches it for later cleanup
       
       @param ICollection A collection to hold any X-DOC or X-NODEREF handles for cleanup after writing of the doc
       @return handle The newly created X-DOCUMENT handle  */
    @deprecated(since="12.5.0").
    {&_proparse_ prolint-nowarn(varusage)}
    method protected handle CreateXmlDoc(input pXmlRefs as ICollection):
        return CreateXmlDoc().
    end method.
    
    /* Creates an X-DOCUMENT
       
       @param ICollection A collection to hold any X-DOC or X-NODEREF handles for cleanup after writing of the doc
       @return handle The newly created X-DOCUMENT handle  */
    method protected handle CreateXmlDoc():
        define variable xmlDoc as handle no-undo.
        
        create x-document xmlDoc.
        
        return xmlDoc.
    end method.
    
    /* Writes the details of a particular test case into the given handle
       
       @param TestEntity The test entity being written
       @param handle The parent XML node
       @param ICollection A collection to hold any X-DOC or X-NODEREF handles for cleanup after writing of the doc */
    @deprecated(since="12.5.0").
    {&_proparse_ prolint-nowarn(varusage)}
    method protected void AddChildEntities(input pEntity as TestEntity,
                                           input pParentNode as handle,
                                           input pXmlRefs as ICollection):
        AddChildEntities(pEntity, pParentNode).
    end method.
    
    /* Writes the details of a particular test case into the given handle
       
       @param TestEntity The test entity being written
       @param handle The parent XML node */
    method protected void AddChildEntities(input pEntity as TestEntity,
                                           input pParentNode as handle):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable entityNode as handle no-undo.
        define variable entities as Array no-undo.
        define variable caseNode as handle no-undo.
        define variable testType as character no-undo.
        define variable tr as TestTestResult extent no-undo.
        define variable xmlDoc as handle no-undo.
        
        assign entities   = pEntity:getTestEntities()
               entityNode = CreateXmlNode()
               xmlDoc     = pParentNode:owner-document
               .
        if type-of(pEntity, TestSuite) then
        do:
            xmlDoc:create-node(entityNode, 'testsuite':u, 'ELEMENT':u).
            
            entityNode:set-attribute('name':u, pEntity:Name).
            entityNode:set-attribute('id':u,   string(pEntity:id)).
            
            // not in spec, but keep for backwards compat
            if pEntity:Summary:ignoreCount gt 0 then
                entityNode:set-attribute('ignored':u, 'true':u).
            
            entityNode:set-attribute('errors':u,    string(pEntity:Summary:errorCount)).
            entityNode:set-attribute('failures':u,  string(pEntity:Summary:failureCount)).
            entityNode:set-attribute('skipped':u,   string(pEntity:Summary:ignoreCount)).
            entityNode:set-attribute('tests':u,     string(pEntity:Summary:TestCount)).
            
            // if this is a class-based TestSuite
            if valid-object(cast(pEntity, TestSuite):classInfo) then
                entityNode:set-attribute('classname':u, cast(pEntity, TestSuite):ClassInfo:getClassName()).
            
            pParentNode:append-child(entityNode).
        end.    // TestSuite
        else
        // Each class or procedure is a 'testsuite'
        if type-of (pEntity, TestCase) then
        do:
            xmlDoc:create-node(entityNode, 'testsuite':u, 'ELEMENT':u).
            
            entityNode:set-attribute('name':u,  pEntity:Name).
            entityNode:set-attribute('id':u,     string(pEntity:id)).
            entityNode:set-attribute('time':u,   string(pEntity:timeTaken)).
            
            // Technically the 'name' attribute should be the type name, but it already does what it does, so
            // we use a 'classname' attribute instead.
            if type-of(pEntity, TestClass) then
                entityNode:set-attribute('classname':u, cast(pEntity, TestClass):ClassInfo:getClassName()).
            
            entityNode:set-attribute('errors':u,    string(pEntity:Summary:errorCount)).
            entityNode:set-attribute('failures':u,  string(pEntity:Summary:failureCount)).
            entityNode:set-attribute('skipped':u,   string(pEntity:Summary:ignoreCount)).
            entityNode:set-attribute('tests':u,     string(pEntity:Summary:TestCount)).
            
            entityNode:append-child(CreatePropertiesElement(xmlDoc)).
            
            // Errors/failures for running the TestClass/TestProcedure and it's lifecycle methods
            if    pEntity:Summary:errorCount   gt 0
               or pEntity:Summary:failureCount gt 0
            then
            do:
                assign caseNode = CreateXmlNode()
                       tr       = pEntity:GetTestResults()
                       cnt      = extent(tr)
                       .
                RESULTBLK:
                do loop = 1 to cnt:
                    // only deal with errors or failures here
                    if     not tr[loop]:TestResult eq TestResultEnum:StatusFailed
                       and not tr[loop]:TestResult eq TestResultEnum:StatusError
                    then
                        next RESULTBLK.
                    
                    // create a 'testcase' node for the constructor failure
                    AddTestcase(caseNode, pEntity, entityNode).
                    
                    // if this is a class, write the class name (to indicate the constructor)
                    if type-of (pEntity, TestClass) then
                    do:
                        caseNode:set-attribute('name':u,      tr[loop]:TestName).
                        caseNode:set-attribute('classname':u, cast(pEntity, TestClass):ClassInfo:getClassName()).
                        caseNode:set-attribute('time':u,      string(pEntity:timeTaken)).
                    end.
                    
                    entityNode:append-child(caseNode).
                end.
            end.
            
            pParentNode:append-child(entityNode).
        end.    // TestCase
        else
        do:
            AddTestcase(entityNode, pEntity, pParentNode).
            
            assign testType = pParentNode:get-attribute('classname':u).
            if testType eq ? then
                assign testType = pParentNode:get-attribute('name':u).
            
            if     not testType eq '':u
               and not testType eq ?
            then
                entityNode:set-attribute('classname':u, testType).
        end.    // TestMethods/other
        
        entityNode:set-attribute('time':u, string(pEntity:timeTaken)).
        
        assign cnt = pEntity:getChildrenSize().
        do loop = 1 to cnt:
            AddChildEntities(cast(entities:GetValue(loop),TestEntity), entityNode).
        end.
    end method.
    
    /* Adds a 'skipped' element with a message attribute
       
       @param handle the X-DOC handle
       @param character A message string. If an unknonw string is send, no message attribute is added.
       @param ICollection A collection to hold any X-DOC or X-NODEREF handles for cleanup after writing of the doc
       @return handle The 'skipped' element */
    @deprecated(since="12.5.0").
    {&_proparse_ prolint-nowarn(varusage)}
    method protected handle CreateSkippedElement(input pDoc as handle,
                                                 input pMessage as character,
                                                 input pXmlRefs as ICollection):
        return CreateSkippedElement(pDoc, pMessage).
    end method.
    
    /* Adds a 'skipped' element with a message attribute
       
       @param handle the X-DOC handle
       @param character A message string. If an unknonw string is send, no message attribute is added.
       @return handle The 'skipped' element */
    method protected handle CreateSkippedElement(input pDoc as handle,
                                                 input pMessage as character):
        define variable elem as handle no-undo.
        
        assign elem = CreateXmlNode().
        pDoc:create-node(elem, 'skipped':u, 'ELEMENT':u).
        
        if not pMessage eq ? then
            elem:set-attribute('message', pMessage).
        
        return elem.
    end method.
    
    /* Creates the trace element with the given name and result in the xml file . Applicable for both error and exception
       nodeName: the name of the node 'error' or 'failure'.
       
       @param handle The XML document
       @param TestTestResult The test result
       @param character The name for this trace node (error/failure)
       @param ICollection A collection to hold any X-DOC or X-NODEREF handles for cleanup after writing of the doc
       @return handle The newly-populated/created trace */
    @deprecated(since="12.5.0").
    {&_proparse_ prolint-nowarn(varusage)}
    method protected handle CreateTraceElement(input pDoc as handle,
                                               input pResult as TestTestResult,
                                               input pNodeName as character,
                                               input pXmlRefs as ICollection):
        return CreateTraceElement(pDoc, pResult, pNodeName).
    end method.
    
    /* Creates the trace element with the given name and result in the xml file . Applicable for both error and exception
       nodeName: the name of the node 'error' or 'failure'.
       
       @param handle The XML document
       @param TestTestResult The test result
       @param character The name for this trace node (error/failure)
       @return handle The newly-populated/created trace */
    method protected handle CreateTraceElement(input pDoc as handle,
                                               input pResult as TestTestResult,
                                               input pNodeName as character    ):
        define variable resultNode as handle no-undo.
        define variable traceElem as handle no-undo.
        
        assign traceElem  = CreateXmlNode()
               resultNode = CreateXmlNode()
               .
        pDoc:create-node(traceElem, pNodeName, 'ELEMENT':u).
        pDoc:create-node(resultNode, '':u, 'TEXT':u).
        
        if length(pResult:Message) gt 0 then
            traceElem:set-attribute('message':u, pResult:Message).
        
        if valid-object(pResult:Error) then
        do:
            traceElem:set-attribute('type':u, pResult:Error:GetClass():TypeName).
            if not pResult:Error:CallStack eq ? then
            do:
                assign resultNode:node-value = pResult:Error:CallStack.
                traceElem:append-child(resultNode).
            end.
        end.
        
        if valid-object(pResult:Stop) then
        do:
            traceElem:set-attribute('type':u, pResult:Stop:GetClass():TypeName).
            if not pResult:Stop:CallStack eq ? then
            do:
                assign resultNode:node-value = pResult:Stop:CallStack.
                traceElem:append-child(resultNode).
            end.
        end.
        
        return traceElem.
    end method.
    
    /* Creates the <testcase> tag element for every test method or test procedure.
       
       @param handle An X-NODEREF
       @param TestEntity The entity for which to write results
       @param handle The parent X-NODEREF
       @param ICollection A collection to hold any X-DOC or X-NODEREF handles for cleanup after writing of the doc */
    @deprecated(since="12.5.0").
    {&_proparse_ prolint-nowarn(varusage)}
    method protected void AddTestcase(input pNode as handle,
                                      input pEntity as TestEntity,
                                      input pParentNode as handle,
                                      input pXmlRefs as ICollection ):
        AddTestcase(pNode, pEntity, pParentNode).
    end method.
    
    /* Creates the <testcase> tag element for every test method or test procedure.
       
       @param handle An X-NODEREF
       @param TestEntity The entity for which to write results
       @param handle The parent X-NODEREF */
    method protected void AddTestcase(input pNode as handle,
                                      input pEntity as TestEntity,
                                      input pParentNode as handle ):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable testResult as TestTestResult extent no-undo.
        define variable maxResult as integer no-undo initial 0.
        define variable xmlDoc as handle no-undo.
        
        assign testResult = pEntity:GetTestResults()
               cnt        = extent(testResult)
               xmlDoc     = pParentNode:owner-document
               .
        xmlDoc:create-node(pNode, 'testcase':u, 'ELEMENT':u).
        pParentNode:append-child(pNode).
        
        pNode:set-attribute('name':u, pEntity:Name).
        
        // process the individual test results
        do loop = 1 to cnt:
            // Report the most severe condition: Error > Failed > NotStarted > Passed > NoTests > Ignored
            // if the status is 'Error' then keep that, since it's more severe than a Failure
            assign maxResult = max(maxResult, integer(testResult[loop]:TestResult)).
            
            case testResult[loop]:TestResult:
                when TestResultEnum:StatusFailed then
                    pNode:append-child(CreateTraceElement(xmlDoc, testResult[loop], 'failure':u)).
                
                when TestResultEnum:StatusError then
                    pNode:append-child(CreateTraceElement(xmlDoc, testResult[loop], 'error':u)).
                
                when TestResultEnum:StatusIgnored then
                do:
                    pNode:append-child(CreateSkippedElement(xmlDoc, testResult[loop]:Message)).
                    pNode:set-attribute('ignored':u, 'true':u).
                end.
            end case.
        end.
        
        // determine the status for this test (worst-case is written as 'status')
        // Attribute 'status' represents the test case status 'Success', 'Error' or 'Failure'
        case maxResult:
            when integer(TestResultEnum:StatusFailed) then
                pNode:set-attribute('status':u, 'Failure':u).
            
            when integer(TestResultEnum:StatusError) then
                pNode:set-attribute('status':u, 'Error':u).
            
            when integer(TestResultEnum:StatusIgnored) then
            do:
                pNode:set-attribute('status':u, 'Success':u).
                pNode:append-child(CreateSkippedElement(xmlDoc, 'Ignored')).
            end.
            
            when integer(TestResultEnum:StatusPassed) then
                pNode:set-attribute('status':u, 'Success':u).
            
            when integer(TestResultEnum:StatusNotStarted) then
            do:
                pNode:set-attribute('status':u, 'NotStarted':u).
                pNode:append-child(CreateSkippedElement(xmlDoc, 'NotStarted')).
            end.
            
            // there were no testresults
            when 0 then
            do:
                pNode:set-attribute('status':u, 'Ignored':u).
                pNode:append-child(CreateSkippedElement(xmlDoc, 'NotStarted')).
            end.
        end case.
    end method.

end class.

