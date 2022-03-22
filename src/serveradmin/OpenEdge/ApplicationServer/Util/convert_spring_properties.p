/******************************************************************************
  Copyright (c) 2016-2017, 2021 by Progress Software Corporation. All rights reserved.
*******************************************************************************/
/*------------------------------------------------------------------------
    File        : OpenEdge/ApplicationServer/Util/convert_spring_properties.p 
    Purpose     : Reads a PASOE oeablSecurity-*.xml or web.xml file and produces 
                  oeablSecurity .csv and .properties files 
    Author(s)   : pjudge 
    Created     : 2016-12-14
    Notes       : Input parameters, comma delimited. Pass along via -param 
                         (mandatory) XML-CFG=<path/to/oeablSecurity-*.xml   May be ; delimited.
                         (optional)  OUT-DIR=<path/to/write/new/files>      May be ; delimited.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.StringConstant.
using OpenEdge.Core.XML.SaxReader.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.LogMessage.
using OpenEdge.Logging.LoggerBuilder.
using Progress.IO.FileInputStream.

/* ***************************  Definitions  ************************** */
define variable authMgr as character no-undo.
define variable parentName  as character no-undo.
define variable beanId as character no-undo.
define variable httpTransport as character no-undo.
define variable entryCnt as integer no-undo.
define variable currentElement as character no-undo.
define variable currentElementCtx as character no-undo.
define variable elementValue as longchar no-undo.
define variable paramFile as character no-undo.
define variable paramLoop as integer no-undo.
define variable paramMax as integer no-undo.
define variable paramEntry as character no-undo.
define variable delim as character no-undo.
define variable inDir as character no-undo.
define variable paramDir as character no-undo.
define variable logger as ILogWriter no-undo.

define stream strUrls.
define stream strProps.

/* ***************************  Main Block  *************************** */
assign logger = LoggerBuilder:GetLogger('OpenEdge.ApplicationServer.Util.convert_spring_properties':u).

logger:Info('Spring property conversion started').
logger:Debug(new LogMessage(logger:Name, 'Conversion parameters: &1', session:parameter) ).

/* extract params */
assign paramMax = num-entries(session:parameter).
do paramLoop = 1 to paramMax:
    assign paramEntry = trim(entry(paramLoop, session:parameter)).
    case entry(1, paramEntry, '=':u):
        when 'OUT-DIR':u then
            assign paramDir = entry(2, paramEntry, '=':u).
        
        when 'XML-CFG':u then
            assign paramFile = entry(2, paramEntry, '=':u).
    end case.
end.

assign paramMax = num-entries(paramFile, ';':u).
do paramLoop = 1 to paramMax:
    run LoadFromConfig(entry(paramLoop, paramFile, ';':u), 
                       (if num-entries(paramDir, ';':u) ge paramLoop then entry(paramLoop, paramDir, ';':u) else ?) ).
end.

return.

catch err as Progress.Lang.Error:
    logger:Error('Error converting Spring properties', err).
end catch.
finally:
    logger:Info('Spring property conversion completed').
end finally.

/* ***************************  Procedures  *************************** */
procedure LoadFromConfig:
    define input  parameter pcConfigRoot as character no-undo.
    define input  parameter pcOutDir     as character no-undo.
    
    define variable interceptFile as character no-undo.
    define variable propertiesFile as character no-undo.
    define variable slashPos as integer no-undo.
    define variable iLoop as integer no-undo.
    define variable iMax as integer no-undo.
    define variable inputFileName as character no-undo.
    
    assign file-info:file-name = pcConfigRoot.
    if file-info:full-pathname eq ? then
        return.
    
    assign inputFileName = file-info:full-pathname.
    
    if pcOutDir eq '':u or pcOutDir eq ? then
        assign pcOutDir = replace(inputFileName, StringConstant:BACKSLASH, '/':u) 
               slashPos = r-index(pcOutDir, '/':u)
               pcOutDir = substring(pcOutDir, 1, slashPos)
               .
    else
    do:
        assign pcOutDir = replace(pcOutDir, StringConstant:BACKSLASH, '/':u)
               iMax = num-entries(pcOutDir, '/':u)
               delim    = '':u
               paramEntry = '':u.
        do iLoop = 1 to iMax:
            assign paramEntry = paramEntry + delim
                              + entry(iLoop, pcOutDir, '/':u)
                   delim      = '/':u.
            os-create-dir value(paramEntry).
        end.
    end.
    
    assign interceptFile  = right-trim(pcOutDir, '/':u) + '/oeablSecurity.csv':u
           propertiesFile = right-trim(pcOutDir, '/':u) + '/oeablSecurity.properties':u
           .
    logger:Info(new LogMessage(logger:Name, 'Reading properties from: &1', file-info:full-pathname) ).
    logger:Info(new LogMessage(logger:Name, 'Properties written to: &1',   propertiesFile) ).
    logger:Info(new LogMessage(logger:Name, 'Intercepts written to: &1',   interceptFile) ).
    
    // make backup if the oeablSecurity.[csv|properties] already exists. Only make a single backup
    if     search(interceptFile) ne ?
       and search(interceptFile + '.keep':u) eq ? then
    do:
        logger:Debug(new LogMessage(logger:Name, 'Backup of original oeablSecurity.csv written to: &1.keep',  interceptFile) ).
        os-copy value(interceptFile) value(interceptFile + '.keep':u).
    end.
    
    if     search(propertiesFile) ne ? 
       and search(propertiesFile + '.keep':u) eq ? then
    do:
        logger:Debug(new LogMessage(logger:Name, 'Backup of original oeablSecurity.properties written to: &1.keep',  interceptFile) ).
        os-copy value(propertiesFile) value(propertiesFile + '.keep':u).
    end.
    
    // new files 
    output stream strUrls  to value(interceptFile). 
    output stream strProps to value(propertiesFile).
    
    put stream strProps unformatted
            // manual skip
            '## Properties imported from ':u inputFileName
            skip
            '## Imported at ':u iso-date(now)
            skip
            '##':u 
            skip.
    
    put stream strUrls unformatted
            // manual skip
            '## Intercept URLs imported from ':u inputFileName
            skip
            '## Imported at ':u iso-date(now) 
            skip
            '##':u 
            skip.
    
    // INPUT FILE NAME AND DIRECTORY 
    assign inDir    = replace(inputFileName, StringConstant:BACKSLASH, '/':u)
           slashPos = r-index(inDir, '/':u)
           inDir    = substring(inDir, 1, slashPos)
           .
    run ParseXMLConfig(new FileInputStream(inputFileName)).
    
    catch loadErr as Progress.Lang.Error :
        logger:Error(new LogMessage(logger:Name, 'Error converting Spring properties from &1', inputFileName), loadErr).
    end catch.
    finally:
        output stream strUrls close. 
        output stream strProps close.
    end finally.
end procedure.

// Reads a PASOE security config and writes properties and urls
procedure ParseXMLConfig:
    define input parameter pFileStream as FileInputStream no-undo.
    
    define variable saxReader as SaxReader no-undo.
    define variable fileName as character no-undo.
    
    logger:Info('Parsing XML config ' + pFileStream:FileName).
    
    if authMgr eq '':u then
    do:
        assign fileName = replace(pFileStream:FileName, StringConstant:BACKSLASH, '/':u)
               fileName = entry(num-entries(fileName, '/':u), fileName, '/':u)
               .
        if fileName begins 'oeablSecurity-':u then
        case num-entries(fileName, '-':u):
            //oeablSecurity-<container|anonymous>.xml
            when 2 then
            do:
                assign authMgr  = entry(1, entry(2, fileName, '-':u), '.':u).
                
                put stream strProps unformatted
                    '## PASOE Configuration file ':u pFileStream:FileName
                    skip
                    'client.login.model=':u authMgr
                    skip
                    .
                put stream strUrls unformatted
                    '## PASOE Configuration file ':u pFileStream:FileName 
                    skip.
            end.
            //oeablSecurity-<auth-mgr>-<login-model>.xml
            when 3 then
            do:
                assign authMgr  = entry(1, entry(3, fileName, '-':u), '.':u).
                put stream strProps unformatted
                    '## PASOE Configuration file ':u pFileStream:FileName
                    skip
                    'client.login.model=':u entry(2, fileName, '-':u)
                    skip
                    'http.all.authmanager=':u authMgr
                    skip
                    .
                put stream strUrls unformatted
                    '## PASOE Configuration file ':u pFileStream:FileName 
                    skip.
            end.
        end case.
    end.
    
    assign saxReader = new SaxReader().
    
    saxReader:SaxReaderStartElement:Subscribe('SaxReaderStartElementHandler':u).
    saxReader:SaxReaderCharacters  :Subscribe('SaxReaderCharactersHandler':u).
    saxReader:SaxReaderEndElement  :Subscribe('SaxReaderEndElementHandler':u).
    saxReader:SaxReaderFatalError  :Subscribe('SaxReaderFatalErrorHandler':u).
    saxReader:SaxReaderError       :Subscribe('SaxReaderErrorHandler':u).
    saxReader:SaxReaderWarning     :Subscribe('SaxReaderWarningHandler':u).
    
    saxReader:ParseFile(pFileStream:FileName).
    
    finally:
        saxReader:SaxReaderStartElement:Unsubscribe('SaxReaderStartElementHandler':u).
        saxReader:SaxReaderCharacters  :Unsubscribe('SaxReaderCharactersHandler':u).
        saxReader:SaxReaderEndElement  :Unsubscribe('SaxReaderEndElementHandler':u).
        saxReader:SaxReaderFatalError  :Unsubscribe('SaxReaderFatalErrorHandler':u).
        saxReader:SaxReaderError       :Unsubscribe('SaxReaderErrorHandler':u).
        saxReader:SaxReaderWarning     :Unsubscribe('SaxReaderWarningHandler':u).
    end finally.
end procedure.

/** START-ELEMENT event handler for the SAX-READER. Method implemented as per ABL documentation.  */
procedure  SaxReaderStartElementHandler:
    define input parameter pcLocalName  as character no-undo.
    define input parameter pcQName      as character no-undo.
    define input parameter phAttributes as handle    no-undo.
    
    define variable attrLoop as integer no-undo.
    define variable attrMax as integer no-undo.
    define variable attrValue as character no-undo.
    define variable attrId as integer no-undo.
    
    logger:Trace(substitute('Start element "&1" (&2)', pcLocalName, pcQName)).
    if valid-handle(phAttributes) then
        logger:Trace(substitute('Element "&1" has &2 attributes', pcLocalName, phAttributes:num-items)).
    
    assign currentElement = pcLocalName
           elementValue   = '':u
           .
    case pcLocalName:
        when 'context-param':u then
            assign parentName = pcLocalName.
        
        when 'http':u then
        do:
            assign httpTransport = phAttributes:get-value-by-qname('pattern':u)
                   
                   httpTransport = trim(httpTransport, '*':u)
                   httpTransport = trim(httpTransport, '/':u)
                   .
            if    httpTransport eq '':u 
               or httpTransport eq ? then
                assign httpTransport = 'all':u.
            
            put stream strProps unformatted
                StringConstant:LF '## Properties from http space ':u phAttributes:get-value-by-qname('pattern':u)
                skip
                '## Transport: ':u httpTransport
                skip
                .
            put stream strUrls unformatted
                skip
                StringConstant:LF '## Properties from http space ':u phAttributes:get-value-by-qname('pattern':u)
                skip
                '## Transport: ':u httpTransport
                skip
                '## "url-pattern","method","spring-access-expression"':u
                skip.
            
            assign attrId = phAttributes:get-index-by-qname('realm':u).
            if attrId gt 0 then
                put stream strProps unformatted
                    'http.':u httpTransport '.realm=':u phAttributes:get-value-by-index(attrId) 
                    skip.
        end.
        
        when 'intercept-url':u then 
            put stream strUrls unformatted
                quoter(phAttributes:get-value-by-qname('pattern':u))
                ',':u
                // the last argument uses "*" for ? values
                quoter(phAttributes:get-value-by-qname('method':u), ?, quoter( '*':u ) )
                ',':u
                // Use DenyAll() if we cannot determine the access mode
                quoter(phAttributes:get-value-by-qname('access':u), ?, quoter('denyAll()':u))
                skip
                .
        
        when 'import':u then
        do:
            if valid-handle(phAttributes) then
                assign attrValue = phAttributes:get-value-by-qname('resource':u).
            
            case true:
                when attrValue begins 'soap':u or
                when attrValue begins 'apsv':u then
                do:
                    assign file-info:file-name = inDir + '/':u + attrValue
                           //strip off the XML extension
                           attrValue = entry(1, attrValue, '.':u)
                           .
                    put stream strProps unformatted
                        entry(1, attrValue, '-':u) '.security.enable=':u entry(2, attrValue, '-':u)
                        skip.
                    
                    if file-info:full-pathname ne ? then
                        run ParseXMLConfig(new FileInputStream(file-info:full-pathname)).
                end.
            end case.
        end.
        
        when 'jee':u then
            put stream strProps unformatted
                'http.jee.':u httpTransport '.mappableRoles=':u
                phAttributes:get-value-by-qname('mappable-roles':u)
                skip.
        
        when 'bean':u then
        do:
            assign beanId = phAttributes:get-value-by-qname('id':u). 
            
            put stream strProps unformatted
                '## Properties from bean id=':u beanId
                skip.
            
            case beanId:
                when 'adAuthenticationProvider':u then
                    assign beanId = 'ldap.contxtSrc':u.
                when 'ldapAuthoritiesPopulator':u then
                    assign beanId = 'ldap.authpopulator':u.
                when 'ldapSearchBean':u then
                    assign beanId = 'ldap.search':u.  
                when 'OERealmUserDetails':u then
                    assign beanId = 'OERealm.UserDetails':u.
                when 'OERealmAuthProvider':u then
                    assign beanId = 'OERealm.AuthProvider':u.
            end case.
        end.
        
        when 'property':u then
        do:
            assign parentName = '':u.
            if phAttributes:get-index-by-qname('value':u) gt 0 then
                put stream strProps unformatted
                    substitute('&1.&2=&3':u,
                        beanId,
                        phAttributes:get-value-by-qname('name':u),
                        phAttributes:get-value-by-qname('value':u))
                    skip.
            else
                assign parentName = phAttributes:get-value-by-qname('name':u).
        end.
        
        when 'map':u then
            assign entryCnt = 0.
        
        when 'entry':u then
        do:
            assign entryCnt = entryCnt + 1.
            //OEClientPrincipalFilter.properties.x.key
            //OEClientPrincipalFilter.properties.x.value
            put stream strProps unformatted
                substitute('&1.&2.&3.key=&4':u,
                    beanId,
                    parentName,
                    entryCnt,
                    phAttributes:get-value-by-qname('key':u))
                skip
                
                substitute('&1.&2.&3.value=&4':u,
                    beanId,
                    parentName,
                    entryCnt,
                    phAttributes:get-value-by-qname('value':u))
                skip.
        end.
        
        when 'ldap-authentication-provider':u then
        do:
            assign attrMax = phAttributes:num-items
                   .
            do attrLoop = 1 to attrMax:
                put stream strProps unformatted
                    substitute('&1.&2=&3':u,
                        authMgr,
                        phAttributes:get-qname-by-index(attrLoop),
                        phAttributes:get-value-by-index(attrLoop))
                    skip.
            end.
        end.
        
        when 'ldap-server':u then
        do:
            put stream strProps unformatted
                '## LDAP server properties':u 
                skip.
            
            assign attrMax    = phAttributes:num-items
                   attrId     = phAttributes:get-index-by-qname('id':u)
                   parentName = phAttributes:get-value-by-index(attrId)
                   .
            ATTRBLK:
            do attrLoop = 1 to attrMax:
                if attrLoop eq attrId then
                    next ATTRBLK.
                    
                put stream strProps unformatted
                    substitute('&1.&2.&3=&4':u,
                        authMgr,
                        parentName,
                        phAttributes:get-qname-by-index(attrLoop),
                        phAttributes:get-value-by-index(attrLoop))
                    skip.
            end.
        end.
    end case.
end procedure.

/** END-ELEMENT event handler for the SAX-READER. Method implemented as per ABL documentation.  */
procedure SaxReaderEndElementHandler:
    define input parameter pcLocalName as character no-undo.
    define input parameter pcQName     as character no-undo.
    
    logger:Trace(substitute('End element "&1" (&2)', pcLocalName, pcQName)).
    
    case pcLocalName:
        when 'http':u then
        do:
            assign httpTransport = '':u.
            
            put stream strProps StringConstant:LF.
            put stream strUrls  StringConstant:LF.
        end.
        
        when 'bean':u then
        do:
            assign beanId = '':u.
            put stream strProps StringConstant:LF.
        end.
        
        when 'property':u then
            assign parentName = '':u.
        
        when 'param-name':u then
            {&_proparse_ prolint-nowarn(overflow)}
            assign currentElementCtx = string(elementValue).
        
        when 'param-value':u then
        case currentElementCtx:
            when 'contextConfigLocation':u then
            do:
                // only import things which are 'real' security, that we know about
                if parentName eq 'context-param':u then
                do:
                    /* malarkey caused by the fact that the web.xml has values beginning with WEB-INF
                       and we might already be in that folder */
                    assign elementValue = inDir + trim(trim(replace(elementValue, StringConstant:BACKSLASH, '/':u), StringConstant:LF)).
                    do while index(elementValue, '//':u) gt 0:
                       assign elementValue = replace(elementValue, '//':u, '/':u).
                    end.
                    
                    {&_proparse_ prolint-nowarn(overflow)}
                    assign elementValue        = replace(elementValue, '/WEB-INF/WEB-INF/':u, '/WEB-INF/':u)
                           file-info:file-name = string(elementValue)
                           .
                    if file-info:full-pathname ne ? then
                        run ParseXMLConfig(new FileInputStream(file-info:full-pathname)).
                    
                    assign parentName        = '':u
                           currentElementCtx = '':u.
                end.    /* context-param/param-value */
            end.
        end case.
    end case.
    
    assign currentElement = '':u
           elementValue   = '':u
           .
end procedure.

/** CHARACTERS event handler for the SAX-READER. Method implemented as per 
    ABL documentation.  */
procedure SaxReaderCharactersHandler:
    define input parameter pcCharData as longchar no-undo.
    
    case currentElement:
        when 'param-value':u or
        when 'param-name':u then
            assign elementValue = elementValue + pcCharData.
    end case.        
end procedure.

procedure SaxReaderWarninghandler:
    define input parameter phReader     as handle no-undo.
    define input parameter pcErrMessage as character no-undo.
    
    logger:Debug(substitute('Warning from reader: &1', phReader:private-data)).
    logger:Warn(pcErrMessage).
end procedure.

procedure SaxReaderErrorHandler:
    define input parameter phReader     as handle no-undo.
    define input parameter pcErrMessage as character no-undo.
    
    logger:Error(substitute('Error from reader: &1', phReader:private-data)).
    if currentElement ne '':u then
        logger:Error(substitute('Error in element &1', currentElement)).
    logger:Error(substitute('Error occurred at line &1 col &2', 
                    phReader:locator-line-number, phReader:locator-column-number)).
    logger:Error(pcErrMessage).
end procedure.

procedure SaxReaderFatalErrorHandler:
    define input parameter phReader     as handle no-undo.
    define input parameter pcErrMessage as character no-undo.
    
    logger:Fatal(substitute('Fatal error from reader: &1', phReader:private-data)).
    if currentElement ne '':u then
        logger:Fatal(substitute('Error in element &1', currentElement)).
    logger:Fatal(substitute('Fatal error occurred at line &1 col &2', 
                    phReader:locator-line-number, phReader:locator-column-number)).
    logger:Fatal(pcErrMessage).
end procedure.

/* EOF */
