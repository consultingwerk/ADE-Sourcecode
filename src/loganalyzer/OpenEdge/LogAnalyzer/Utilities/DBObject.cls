 
/*------------------------------------------------------------------------
   File        : DBObject
   Purpose     : 
   Syntax      : 
   Description : ABL Class to read and parse DBCatalog.json
   Author(s)   : isyed
   Created     : Mon Jan 01 23:48:10 EST 2018
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

USING Progress.Json.ObjectModel.JsonObject FROM PROPATH.
USING Progress.Json.ObjectModel.JsonArray FROM PROPATH.
USING Progress.Json.ObjectModel.ObjectModelParser FROM PROPATH.
USING OpenEdge.Logging.Logger FROM PROPATH.
USING OpenEdge.Logging.LoggerBuilder FROM PROPATH.
USING OpenEdge.Logging.ILogWriter FROM PROPATH.



BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.LogAnalyzer.Utilities.DBObject: 
    
    CONSTRUCTOR DBObject():
        
      
        
    END CONSTRUCTOR.
    
    
    // Set logging 
    DEFINE PUBLIC PROPERTY logger AS ILogWriter
        GET(): 
            IF NOT VALID-OBJECT(THIS-OBJECT:logger) THEN
                ASSIGN THIS-OBJECT:logger = LoggerBuilder:GetLogger(GET-CLASS(OpenEdge.LogAnalyzer.Events.InvokeEvents)).
            
            RETURN THIS-OBJECT:logger.
        END GET.
        SET.
    
    
    METHOD PUBLIC JsonObject GetDBObject(INPUT db-name AS CHAR):
        
        DEF VAR parser AS ObjectModelParser NO-UNDO.
        DEF VAR JObj   AS JsonObject        NO-UNDO.
        DEF VAR JArr   AS JsonArray         NO-UNDO.
        DEF VAR i      AS INT               INIT 1 NO-UNDO.
        
        // Check if DBCatalog.json is available
        IF SEARCH('DBCatalog.json') EQ ? THEN
        DO:
            logger:Error('DBCatalog.json not found').
            RETURN ERROR 'DBCatalog.json not found'.
        END.
        ELSE 
            logger:Trace('DBCatalog.json found').
        
        // Read the DBCatalog file and check if the dbname passed by the user is avialable
        parser = NEW ObjectModelParser().
        JArr = CAST(parser:Parsefile(SEARCH('DBCatalog.json')),JsonArray).
        JObj = NEW JsonObject().
        
        logger:Trace('db-name value is ' + db-name).
        
        DO WHILE i LE JArr:LENGTH ON ERROR UNDO,NEXT :
            IF db-name EQ JArr:GetJsonObject(i):getCharacter('ConnectionName') THEN
            DO:
                JObj = JArr:GetJsonObject(i).
                logger:Trace('found JsonObject').
                logger:Trace(STRING(JObj:GetJsonText())).
                RETURN JObj.
               
            END.
            
            i = i + 1.
            
           
            
            CATCH e AS Progress.Lang.Error :
                logger:Trace('Could not find db in JSonArray').
                logger:Trace(e:GetMessage(1)).
                RETURN ERROR 'Could not find db in JsonArray'. 
            END CATCH.
            
            FINALLY:
                logger:Trace('GetDBObject response is: ' + String(JObj:GetJsonText())).    
            END FINALLY.
            
        END.
        
        
    END METHOD .
    
    // Check if the DB is avilable in DBCatalog.json and return result in boolean
    METHOD PUBLIC LOGICAL IsDBObjectAvailable(INPUT db-name AS CHAR):
        
        DEF VAR parser AS ObjectModelParser NO-UNDO.
        DEF VAR JObj   AS JsonObject        NO-UNDO.
        DEF VAR JArr   AS JsonArray         NO-UNDO.
        DEF VAR i      AS INT               INIT 1 NO-UNDO.
        DEF VAR retVal AS LOGICAL           NO-UNDO.
        
        IF SEARCH('DBCatalog.json') EQ ? THEN 
        DO:
            logger:Error('DBCatalog.json not found').
            RETURN ERROR 'DBCatalog.json not found'.
           
        END.
        ELSE 
        DO:
            logger:Trace('found DBCatalog.json').
        END.
        
        logger:Trace('db-name value is ' + db-name).
        parser = NEW ObjectModelParser().
        
        logger:Trace('db.json value is ' + SEARCH('DBCatalog.json')).
        JArr = CAST(parser:ParseFile(SEARCH('DBCatalog.json')),JsonArray).
        
        logger:Trace('db.json output is ' + String(JArr:GETJSONTEXT ())).
        
        DO WHILE i LE JArr:LENGTH ON ERROR UNDO,NEXT :
            IF db-name EQ JArr:GetJsonObject(i):getCharacter('ConnectionName') THEN
            DO:
                retVal = TRUE.
                LEAVE.
            END.
            ELSE 
            DO:
                logger:Trace('db-name is ' + String(db-name)).
                logger:Trace('db.json has ' + String(JArr:GetJsonObject(i):getCharacter('ConnectionName'))).
            END.
            i = i + 1.
        END.
        
        RETURN retVal.
        
        FINALLY:
            logger:Trace('IsDBObjectAvailable response is: ' + String(retVal)).    
        END FINALLY.
        
    END METHOD .
    
    // Create database parameters based on the configuration details.
    METHOD PUBLIC CHAR GetDBParam(INPUT dbval AS CHAR):
        
        DEF VAR db-param AS CHAR NO-UNDO.
        
        logger:Trace('dbval value is ' + dbval).
      
        DO ON ERROR UNDO,THROW:
            IF (THIS-OBJECT:IsDBObjectAvailable(dbval)) THEN
            DO:
      
                IF  ((GetDBObject(dbval):GetCharacter('Port') EQ "") 
                    OR
                    (GetDBObject(dbval):GetCharacter('Port') EQ ?) ) THEN
                    db-param = GetDBObject(dbval):GetCharacter('PhysicalName'). 
                ELSE
                    db-param = '-H ' + GetDBObject(dbval):GetCharacter('HostName')
                        + ' -S ' + GetDBObject(dbval):GetCharacter('Port')
                        + ' -db ' + GetDBObject(dbval):GetCharacter('PhysicalName').
                
            END.
            ELSE 
            DO:
                logger:Error('Database not found in registry').
                RETURN ERROR 'Database not found in registry'.
            
            END.
            
            CATCH e AS Progress.Lang.AppError :
                logger:Error(e:ReturnValue).
                RETURN ERROR (e:ReturnValue).
                    
            END CATCH.
        END.
        
        RETURN db-param.
        
        CATCH e AS Progress.Lang.AppError :
            logger:Error('Error executing GetDBParam ' + e:ReturnValue).
            RETURN ERROR ('Error executing GetDBParam ' + e:ReturnValue).
                    
        END CATCH.
        
        FINALLY:
            logger:Trace('GetDBparam response is: ' + db-param).    
        END FINALLY.
        
    END METHOD.
    
    
END CLASS.
