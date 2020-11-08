/************************************************
Copyright (c) 2013-2020 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
   File        : ABLRunner
   Purpose     : Runner of the ABLUnit framework, which runs the testclasses, test procedures, testsuite classes,
                 testsuite procedures and ABL files inside a folder.
   Syntax      :
   Description :
   Author(s)   : hgarapat
   Created     : Wed Jun 27 18:18:40 IST 2012
   Notes       : Modified the annotations. The newly modified annotations are common for both class and procedure files.
                 Current annotations are Before, Setup, Test, TearDown, After.
 ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING OpenEdge.ABLUnit.Model.File FROM PROPATH.
USING OpenEdge.ABLUnit.Model.IRunnableEntity FROM PROPATH.
USING OpenEdge.ABLUnit.Model.TestCase FROM PROPATH.
USING OpenEdge.ABLUnit.Model.TestClass FROM PROPATH.
USING OpenEdge.ABLUnit.Model.TestEntity FROM PROPATH.
USING OpenEdge.ABLUnit.Model.TestMethod FROM PROPATH.
USING OpenEdge.ABLUnit.Model.TestProcedure FROM PROPATH.
USING OpenEdge.ABLUnit.Model.TestRootModel FROM PROPATH.
USING OpenEdge.ABLUnit.Model.TestSuite FROM PROPATH.
USING OpenEdge.ABLUnit.Reflection.AnnotationInfo FROM PROPATH.
USING OpenEdge.ABLUnit.Reflection.AnnotationUtil FROM PROPATH.
USING OpenEdge.ABLUnit.Reflection.ClassAnnotationInfo FROM PROPATH.
USING OpenEdge.ABLUnit.Reflection.ClassInfo FROM PROPATH.
USING OpenEdge.ABLUnit.Reflection.ProcedureAnnotationInfo FROM PROPATH.
USING OpenEdge.ABLUnit.Reflection.TestInfo FROM PROPATH.
USING OpenEdge.ABLUnit.Reflection.TypeInfo FROM PROPATH.
USING OpenEdge.ABLUnit.Results.TestResultEnum FROM PROPATH.
USING OpenEdge.ABLUnit.Results.TestTestResult FROM PROPATH.
USING OpenEdge.ABLUnit.Results.TestTypeResult FROM PROPATH.
USING OpenEdge.ABLUnit.Runner.TestConfig FROM PROPATH.
USING OpenEdge.ABLUnit.Writer.IResultsWriter FROM PROPATH.
USING OpenEdge.ABLUnit.Writer.ResultsXmlWriter FROM PROPATH.
USING OpenEdge.Core.Collections.Array FROM PROPATH.
USING Progress.Json.ObjectModel.JsonArray FROM PROPATH.
USING Progress.Json.ObjectModel.JsonObject FROM PROPATH.
USING Progress.Json.ObjectModel.JsonDataType FROM PROPATH.
USING Progress.Lang.AppError FROM PROPATH.
USING Progress.Lang.LockConflict FROM PROPATH.
USING OpenEdge.Core.Util.AnnotationWriter FROM PROPATH.
USING OpenEdge.Core.Json.JsonPropertyHelper FROM PROPATH.
USING OpenEdge.Core.StringConstant FROM PROPATH.
USING OpenEdge.Core.String FROM PROPATH.
USING OpenEdge.Logging.ILogWriter FROM PROPATH.
USING OpenEdge.Logging.ISupportLogging FROM PROPATH.
USING OpenEdge.Logging.LoggerBuilder FROM PROPATH.

CLASS OpenEdge.ABLUnit.Runner.ABLRunner IMPLEMENTS ISupportLogging:

    DEFINE PRIVATE STREAM dirlist.

    // A reference to the Logger in use by an implementer
    DEFINE PUBLIC PROPERTY Logger as ILogWriter NO-UNDO GET. SET.

    // Class members
    DEFINE PRIVATE VARIABLE TREE_DEPTH_END   AS CHARACTER  NO-UNDO INIT "~\NULL".

    DEFINE PRIVATE VARIABLE testModel AS TestRootModel NO-UNDO.
    DEFINE PRIVATE VARIABLE TEST_FOLDER_ROOT AS CHARACTER NO-UNDO INIT "TEST_ROOT".
    DEFINE PRIVATE VARIABLE currentID AS INTEGER NO-UNDO INIT 0.

    DEFINE PRIVATE VARIABLE testMethodInfo  AS TestInfo NO-UNDO.
    DEFINE PRIVATE VARIABLE testConfig AS TestConfig NO-UNDO.
    DEFINE PRIVATE VARIABLE updateFile AS CHARACTER NO-UNDO.
    DEFINE PRIVATE VARIABLE prevStackTraceProperty AS LOGICAL NO-UNDO.
    DEFINE PRIVATE VARIABLE oldWarningsList AS CHARACTER NO-UNDO.
    DEFINE PRIVATE VARIABLE ablResultsFile AS CHARACTER NO-UNDO.

    DEFINE PRIVATE TEMP-TABLE ttXrefs NO-UNDO
        FIELD ParentDir  AS CHARACTER
        FIELD FileName   AS CHARACTER
        FIELD FullPath   AS CHARACTER
        FIELD isDir      AS LOGICAL
        INDEX idxPrimary AS PRIMARY ParentDir FileName /* Must keep this index. */
        INDEX idxName               FileName
        .

    /* Default constructor */
    CONSTRUCTOR PUBLIC ABLRunner ( ):
        SUPER().
        testModel = NEW TestRootModel(currentID).
        currentID = currentID + 1.
        testModel:name = TEST_FOLDER_ROOT.
        updateStackTraceProperty().
        oldWarningsList = SESSION:SUPPRESS-WARNINGS-LIST.
        SESSION:SUPPRESS-WARNINGS-LIST = '6430,' + SESSION:SUPPRESS-WARNINGS-LIST.
        THIS-OBJECT:Logger = LoggerBuilder:GetLogger("ABLUnit").
        THIS-OBJECT:FindXrefFiles().
    END CONSTRUCTOR.

    METHOD PRIVATE VOID updateStackTraceProperty():
        prevStackTraceProperty = SESSION:ERROR-STACK-TRACE.
        SESSION:ERROR-STACK-TRACE = TRUE.
    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose: This is newly added constructor, which accepts formatted JSON object of configuration file.
     Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC ABLRunner ( INPUT inputConfig AS CLASS TestConfig, INPUT pUpdateFile AS CHARACTER ):
        THIS-OBJECT().
        IF not valid-object(inputConfig) THEN
            RETURN ERROR NEW AppError("TestConfig can not be null.", 0).
        testConfig = inputConfig.
        /*Get the ABLUnit results file*/
        ablResultsFile = testConfig:GetResultsFile().
        THIS-OBJECT:updateFile = pUpdateFile.
    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
     Purpose: This method will return the full path of a given file.
     Notes:
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE CHARACTER GetFullPathname ( INPUT pcFile AS CHARACTER ):
        DEFINE VARIABLE cReturn AS CHARACTER NO-UNDO.

        FILE-INFO:FILENAME = pcFile.
        cReturn = RIGHT-TRIM(REPLACE(FILE-INFO:FULL-PATHNAME,StringConstant:BACKSLASH,"/"),"/").

        IF cReturn NE ? AND
           index(FILE-INFO:FILE-TYPE, "D") NE 0 THEN
        cReturn = cReturn + "/".

        RETURN cReturn.
    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose: This method will locate any local XREF files if configured to do so.
     Notes:
    ------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID FindXrefFiles ( ):
        EMPTY TEMP-TABLE ttXrefs.

        IF VALID-OBJECT(testConfig) AND testConfig:useXref THEN DO:
            IF NOT CAN-DO("PWD,SRC", testConfig:xrefLocation) THEN
                /* When using pre-existing XREF files at a given location, get a listing of all available XREF files. */
                THIS-OBJECT:RecurseDir(testConfig:xrefLocation, SUBSTITUTE("*~~.&1", testConfig:xrefExtension)).
            ELSE
                /* Otherwise, get a listing for all available XREF files under the current working directory. */
                THIS-OBJECT:RecurseDir(THIS-OBJECT:getFullPathname("."), SUBSTITUTE("*~~.&1", testConfig:xrefExtension)).
        END. /* useXref */
    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose: This method will recurse into a directory and build a TT structure.
     Notes:
    ------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID RecurseDir ( INPUT pcFrom    AS CHARACTER,
                                       INPUT pcExtMask AS CHARACTER ):
        DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cFullName AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cCodes    AS CHARACTER NO-UNDO.

        INPUT STREAM dirlist FROM OS-DIR(pcFrom) NO-ECHO.
        DIRBLK:
        REPEAT:
            IMPORT STREAM dirlist cFileName cFullName cCodes.

            IF cFileName EQ "." OR
               cFileName EQ ".." OR
               cFileName BEGINS "~." THEN NEXT DIRBLK.

            /* If not examining a directory, skip any files that do not match the given extension. */
            IF (pcExtMask GT "") EQ TRUE AND (INDEX(cCodes, "D":U) EQ 0) THEN
                IF NOT (cFileName MATCHES pcExtMask) THEN NEXT DIRBLK.

            CREATE ttXrefs.
            ASSIGN
                ttXrefs.ParentDir = pcFrom
                ttXrefs.FileName  = cFileName
                ttXrefs.FullPath  = THIS-OBJECT:GetFullPathname(cFullName)
                ttXrefs.isDir     = (INDEX(cCodes, "D":U) NE 0) 
                .

            RELEASE ttXrefs.
        END.
        INPUT CLOSE.

        FOR EACH ttXrefs
           WHERE ttXrefs.ParentDir EQ pcFrom
             AND ttXrefs.isDir:
            THIS-OBJECT:RecurseDir(SUBSTITUTE("&1/&2", ttXrefs.ParentDir, ttXrefs.FileName), pcExtMask).
        END.
    END METHOD.

    /*------------------------------------------------------------------------------
     This method should return a valid XREF path which physically exists on disk. As
     XREF files can be created using different patterns for file extensions (based
     on how the file was compiled), we need to create a couple of standard candiate
     filenames using the expected file extension. The order for locating a valid XREF
     file will use the following steps:
         1. Use the given test case (type: class or procedure) replacing the file extension:
            1a. Create a candidate filename using a common pattern for the PCTCompile task.
            1b. Create a candidate filename using a common pattern for PDSOE/Explicit naming.
         2. Search for a matching XREF filename in a list of potential, available files.
         3. Return ? if no matching XREF file was located.

       @param  character The test case being examined for addition to ABLUnit
       @param  character The expected type of test case (class or proc[edure])
       @return character The located XREF file (or ? if not found)
    ------------------------------------------------------------------------------*/
    METHOD PROTECTED CHARACTER GetXRefFile ( INPUT pcTestCase AS CHARACTER, INPUT pcTestType AS CHARACTER ):
        DEFINE VARIABLE testCase      AS String    NO-UNDO.
        DEFINE VARIABLE testPath      AS Array     NO-UNDO.
        DEFINE VARIABLE baseName      AS CHARACTER NO-UNDO.
        DEFINE VARIABLE foundFile     AS CHARACTER NO-UNDO.
        DEFINE VARIABLE candidatePath AS CHARACTER NO-UNDO EXTENT 2.
        DEFINE VARIABLE candidateName AS CHARACTER NO-UNDO EXTENT 2.
        DEFINE VARIABLE matchedFiles  AS Array     NO-UNDO.
        DEFINE VARIABLE iMax          AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iLoop         AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iElem         AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iMatchScore   AS INTEGER   NO-UNDO EXTENT.
        DEFINE VARIABLE iBestScore    AS INTEGER   NO-UNDO INITIAL 0.

        IF NOT testConfig:useXref THEN RETURN ?. /* Not using existing XREF's */

        IF (pcTestCase GT "") NE TRUE THEN RETURN ?. /* No test case given. */
        IF (pcTestType GT "") NE TRUE THEN RETURN ?. /* No test type given. */

        /* Make sure path slashes are consistent and remove any double-slashes. */
        ASSIGN pcTestCase = REPLACE(REPLACE(pcTestCase, StringConstant:BACKSLASH, "/"), "//", "/").
        ASSIGN testCase = NEW String(pcTestCase). /* Allows us to use helper methods on the string. */

        /**
         * When explicitly configured to use an existing XREF file, we need to base the potential
         * filename on the given location and any files with a matching extension. Essentially the
         * same test case name but using the appropriate file extension expected for the XREF file.
         *
         * Therefore, we should first swap the file extension as appropriate:
         * -PCTCompile will just append .xref after the original file extension (eg. cls.xref)
         * -PDSOE will simply replace the original file extension with an explicit "xref.xml"
         * -Any custom pattern which replaces the original file extension 1:1 (eg. xml)
         *
         * This still results in 2 patterns: either appending an extension or replacing the extension.
         * Therefore, we need 2 candidates to test with since we don't know how the code was compiled.
         */
        IF NUM-ENTRIES(pcTestCase, ".") GT 0 THEN
        CASE ENTRY(NUM-ENTRIES(pcTestCase, "."), pcTestCase, "."):
            WHEN "cls" THEN DO:
                ASSIGN baseName = STRING(SUBSTRING(testCase:Value, 1, LENGTH(testCase:Value) - 4)).
                candidatePath[1] = STRING(testCase:Value) + "." + testConfig:xrefExtension. /* PCTCompile Format */
                candidatePath[2] = baseName + "." + testConfig:xrefExtension. /* PDSOE/Explicit Format */
            END. /* ABL Class */
            WHEN "p" THEN DO:
                ASSIGN baseName = STRING(SUBSTRING(testCase:Value, 1, LENGTH(testCase:Value) - 2)).
                candidatePath[1] = STRING(testCase:Value) + "." + testConfig:xrefExtension. /* PCTCompile Format */
                candidatePath[2] = baseName + "." + testConfig:xrefExtension. /* PDSOE/Explicit Format */
            END. /* Procedure */
            WHEN "r" THEN DO:
                /* For these XREF files, we need to restore the original file extension for the type of test. */
                ASSIGN baseName = STRING(SUBSTRING(testCase:Value, 1, LENGTH(testCase:Value) - 2)).
                IF pcTestType EQ "class" THEN DO:
                    candidatePath[1] = baseName + ".cls." + testConfig:xrefExtension. /* PCTCompile Format */
                    candidatePath[2] = baseName + "." + testConfig:xrefExtension. /* PDSOE/Explicit Format */
                END.
                ELSE DO:
                    candidatePath[1] = baseName + ".p." + testConfig:xrefExtension. /* PCTCompile Format */
                    candidatePath[2] = baseName + "." + testConfig:xrefExtension. /* PDSOE/Explicit Format */
                END.
            END. /* R-code */
        END CASE.

        /* We could check for empty values in our candidate paths. */
        IF candidatePath[1] EQ "" OR candidatePath[2] EQ "" THEN RETURN ?.

        ASSIGN /* Candidate paths will be identical, but the filename is not, so isolate the latter. */
            candidateName[1] = ENTRY(NUM-ENTRIES(candidatePath[1], "/"), candidatePath[1], "/")
            candidateName[2] = ENTRY(NUM-ENTRIES(candidatePath[2], "/"), candidatePath[2], "/")
            .

        THIS-OBJECT:Logger:Debug(SUBSTITUTE("Getting XREF for Test Case: &1", pcTestCase)).

        /**
         * We need the full path for an XREF file, so we use the directory listing previously generated.
         * First, locate all matching XREF files using just the candidate filenames.
         * This is sorted to give the shortest path first.
         */
        ASSIGN matchedFiles = NEW Array().
        FOR EACH ttXrefs NO-LOCK
           WHERE ttXrefs.FileName EQ candidateName[1]
              OR ttXrefs.FileName EQ candidateName[2]
              by ttXrefs.ParentDir
              by ttXrefs.FileName:
            matchedFiles:Add(NEW OpenEdge.Core.String(ttXrefs.FullPath)).
        END.

        /* No matching XREF files located for this test. */
        IF matchedFiles:Size EQ 0 THEN RETURN ?.

        /* Just one matching XREF? Let's go! */
        IF matchedFiles:Size EQ 1 THEN DO:
            ASSIGN foundFile = matchedFiles:GetValue(1):ToString().
        END. /* Single Match */
        ELSE DO:
            /**
             * For OCTA-22449 we need to solve a situation of the same test file may exist in different folders,
             * typically referring to different class packages. This results in the first-found-file wins, even
             * if the matched XREF file is incorrect. Therefore, the search for a matching XREF file must take
             * additional information into account.
             * Note: This predominantly affects searching for XREF files when only an R-code file is supplied.
             */
            ASSIGN
                testPath   = testCase:Split("/") /* Split the test case path to get directories. */
                iBestScore = ? /* Reset this to indicate no best score has been determined yet. */
                .

            /* Obtain a "score" of how many matching directories exist between matches and the test file. */
            ASSIGN iMatchScore = THIS-OBJECT:ScoreMatches(testPath, matchedFiles).

            /**
             * Pick the file with the higher score (# of matching dirs).
             * If both scores are 0, the likelyhood is high that the first matched item is the correct one
             * (shortest path), as the recursive search starts with files within the root directory.
             */
            FINALBLK:
            DO iLoop = 1 TO EXTENT(iMatchScore):
                THIS-OBJECT:Logger:Trace(SUBSTITUTE("Discovered XREF File #&1: &2 (Score: &3)",
                                                    iLoop, CAST(matchedFiles:GetValue(iLoop), String):ToString(), iMatchScore[iLoop])).

                IF iBestScore EQ ? OR iMatchScore[iLoop] GT iBestScore THEN
                    ASSIGN
                        foundFile  = STRING(CAST(matchedFiles:GetValue(iLoop), String):Value)
                        iBestScore = iMatchScore[iLoop]
                        .
            END. /* iLoop */
        END. /* Multiple Matches */

        THIS-OBJECT:Logger:Debug(SUBSTITUTE("Found a Suitable XREF File: &1", foundFile)).

        RETURN foundFile. /* Return a matched file if not already encountered a RETURN statement. */
    END METHOD.


    /*------------------------------------------------------------------------------
     Purpose: Produce a score for 2 files based on the # of matching directories.
     Notes:
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE INTEGER EXTENT ScoreMatches ( INPUT poTestPath AS Array, INPUT poMatchedFiles AS Array ):
        DEFINE VARIABLE xrefPath    AS Array   NO-UNDO.
        DEFINE VARIABLE iMatchScore AS INTEGER NO-UNDO EXTENT.
        DEFINE VARIABLE iMax        AS INTEGER NO-UNDO.
        DEFINE VARIABLE iLoop       AS INTEGER NO-UNDO.
        DEFINE VARIABLE iElem       AS INTEGER NO-UNDO.

        EXTENT(iMatchScore) = poMatchedFiles:Size. /* Keep score for each matched XREF file. */

        MATCHBLK:
        DO iLoop = 1 TO poMatchedFiles:Size:
            /* Loop through each of the matched files, as one of these should more closely match the test case. */
            ASSIGN xrefPath = CAST(poMatchedFiles:GetValue(iLoop), String):Split("/").

            /* The max for an element search is limited to the smallest path, less 1 (for the filename). */
            ASSIGN iMax = MIN(poTestPath:Size, xrefPath:Size) - 1.
            IF iMax LT 1 THEN NEXT MATCHBLK.

            ELEMBLK:
            DO iELem = 1 TO iMax:
                /**
                 * Work backwards along the path, starting with the directory just before the test case
                 * filename. So long as we match elements of the path, the matching XREF file scores
                 * another point and is probably a closer match. This feels like such a hack but there's
                 * no other/better way to get the class package from r-code, so here we are.
                 */
                IF CAST(poTestPath:GetValue(poTestPath:Size - iELem), String):Value EQ CAST(xrefPath:GetValue(xrefPath:Size - iELem), String):Value THEN
                    ASSIGN iMatchScore[iLoop] = iMatchScore[iLoop] + 1.
                ELSE
                    NEXT MATCHBLK. /* Otherwise move to the next matching XREF file. */
            END. /* iElem */
        END. /* iLoop */

        RETURN iMatchScore.
    END METHOD.


    /*------------------------------------------------------------------------------
     Purpose: This method runs the tests that are passed as JsonObject.
     Notes:
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID RunTests ( ):
        DEFINE VARIABLE testsArray AS JsonArray NO-UNDO.
        DEFINE VARIABLE testCasesArray AS JsonArray NO-UNDO.
        DEFINE VARIABLE testIndex AS INTEGER NO-UNDO.
        DEFINE VARIABLE testEntity AS TestEntity NO-UNDO.
        DEFINE VARIABLE writer AS IResultsWriter NO-UNDO.

        testsArray = testConfig:testsJson.

        DEFINE VARIABLE testJson AS JsonObject NO-UNDO.
        DEFINE VARIABLE testResource AS CHARACTER NO-UNDO.

        ASSIGN writer = NEW ResultsXmlWriter().

        THIS-OBJECT:FindXrefFiles().

        DO testIndex = 1 TO testsArray:Length:
            testJson = testsArray:GetJsonObject(testIndex).
            IF (testJson:Has("folder")) THEN DO:
                testResource = testJson:GetCharacter("folder").
                testEntity = populateTestModel(testResource, 1).
                updateFile(updateFile, "TEST_TREE" + " " + loadSerializedTree(testEntity), FALSE).
            END.
            ELSE IF (testJson:Has("test")) THEN DO:
                testResource = testJson:GetCharacter("test").
                IF (testJson:Has("cases")) THEN DO:
                    testCasesArray = testJson:GetJsonArray("cases").
                    DEFINE VARIABLE testCase AS CHARACTER NO-UNDO.
                    testCase = testCasesArray:GetCharacter(1).
                    testEntity = populateTestModel(testResource + "#" + testCase, testCasesArray:Length + 1).
                    updateFile(updateFile, "TEST_TREE" + " " + loadSerializedTree(testEntity), FALSE).
                END.
                ELSE DO:
                    testEntity = populateTestModel(testResource, 1).
                    updateFile(updateFile, "TEST_TREE" + " " + loadSerializedTree(testEntity), FALSE).
                END.
            END.
        END.

        IF testEntity NE ? THEN DO:
            runtests(testEntity, updateFile).
            writer:WriteToFile(ablResultsFile, testEntity).
        END.

        FINALLY:
            /* COMPLETE event has to be updated anyway to complete the session. */
            updateFile(updateFile, "COMPLETE", FALSE).
            SESSION:ERROR-STACK-TRACE = prevStackTraceProperty.
            SESSION:SUPPRESS-WARNINGS-LIST = oldWarningsList.
        END.
    END METHOD.

    /*------------------------------------------------------------------------------
        Generates the procedure information in xref xml file

        @param character The ABL program (.P, .CLS, or .R) file name
        @return TypeInfo Unit test type info about the program
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC TypeInfo BuildTypeInfo ( INPUT testCase AS CHARACTER,
                                           INPUT testType AS CHARACTER ):
        DEFINE VARIABLE xrefFile AS CHARACTER NO-UNDO.

        IF testConfig:useXref THEN DO:
            xrefFile = THIS-OBJECT:GetXRefFile(testCase, testType).

            /**
             * If the XREF file is not found, we should either continue with the default
             * (compile) behavior or throw an error as indicated by the config options.
             */
            IF (xrefFile GT "") NE TRUE AND testConfig:xrefThrowError THEN
                UNDO, THROW NEW AppError("Unable to find XREF file at expected location.", 0).
        END. /* useXref */

        IF (xrefFile GT "") NE TRUE THEN DO:
            /* We need a special case here in case we didn't throw an error already from lack of XREF file. */
            IF (testCase MATCHES "*~~.r") THEN
                UNDO, THROW NEW AppError("Cannot run test case using R-code and with no XREF file available.", 0).

            /**
             * If an XREF file was not found, then follow the traditional means
             * of creating the file during compilation of the source code.
             */
            xrefFile = SESSION:TEMP-DIR + testConfig:ResultsFileName + ".xref".
            COMPILE VALUE(testCase) XREF-XML VALUE(xrefFile).
        END. /* COMPILE */
        
        RETURN ParseXMLDocument(xrefFile).
        
        // If any one of the test case/suites doesn't compile, then the whole test run fails.
        // Return a better message so that we know which test case failed to build
        CATCH err AS Progress.Lang.Error:
            UNDO, THROW NEW AppError(SUBSTITUTE('Unable to build type info for &1: &2',
                                     testCase, err:GetMessage(1)),
                                     0).
        END CATCH.
        FINALLY:
            /* Adding a check for debug mode for users to inspect the file in case something unexpected happens. */
            /* Also we only want to delete this file if it may have been created as part of the compile process. */
            IF NOT testConfig:useXref AND NOT SESSION:DEBUG-ALERT THEN
                OS-DELETE value(xrefFile).
        END FINALLY.
    END METHOD.

    /* Builds the attribute value, as ABLUnit expects it "value,value2" etc
       
       The annotation data format is
           "anno-name" :
                {"x": "y"}  // x=y split up
                {"x": ["p", "q"]}  // x=y split up
                null        // no parens in source
       @param character The attribute name. If blank or null, the null string is returned
       @param JsonObject The annotation data. If invalid, the null string is returned
       @return character The attribute value, joined together   */
    method private character BuildAttributeValue(input pAttrName as character,
                                                 input pAttrData as JsonObject):
        define variable attrVal as character no-undo.
        define variable jsonVal as character no-undo.
        define variable delim as character no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        define variable ja as JsonArray no-undo.
        
        if not valid-object(pAttrData)
        or pAttrName eq ?
        or pAttrName eq '':u
        or not pAttrData:Has(pAttrName)
        then 
            return ?.
        
        case pAttrData:GetType(pAttrName):
            when JsonDataType:NULL   then assign attrVal = ?.
            when JsonDataType:STRING then assign attrVal = pAttrData:GetCharacter(pAttrName).
            when JsonDataType:ARRAY then 
            do:
                assign ja  = pAttrData:GetJsonArray(pAttrName)
                       cnt = ja:Length
                       . 
                DATA-LOOP:
                do loop = 1 to cnt:
                    case ja:GetType(loop):
                        when JsonDataType:NULL   then assign jsonVal = '?':u.
                        when JsonDataType:STRING then assign jsonVal = ja:GetCharacter(loop).
                                            otherwise assign jsonVal = string(ja:GetJsonText(loop)). 
                    end case.
                    assign attrVal = attrVal + delim + jsonVal 
                           delim   = ',':u
                           .
                end.
            end.
        end case.
        
        return attrVal.
    end method.
    
    /* Create an Array of AnnotationInfo objects from the JSON data
       
       @param JsonObject The annotation JSON data 
       @return Array An array of annotation data. Will always be a valid object */ 
    method private Array BuildAnnotationInfo(input pData as JsonObject):
        define variable annotationsInfo as Array no-undo.
        define variable propNames as longchar extent no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        define variable annoName as character no-undo.
        define variable attrName as character no-undo.
        define variable attrValue as character no-undo.
        define variable arrData as JsonArray no-undo.
        define variable annoLoop as integer no-undo.
        define variable annoCnt as integer no-undo.
        define variable annoData as JsonObject no-undo.
        define variable attribLoop as integer no-undo.
        define variable attribCnt as integer no-undo.
        define variable attribNames as longchar extent no-undo.
        define variable val as character no-undo.
        
        assign annotationsInfo            = new Array()
               annotationsInfo:AutoExpand = TRUE
               .
        if not valid-object(pData) then
            return annotationsInfo.
        
        assign propNames = pData:GetNames()
               cnt       = extent(propNames)
               .
        do loop = 1 to cnt:
            assign annoName = propNames[loop]
                   annoCnt  = 0
                   .
            /* annotation format is
                "anno-name" :
                {"x": "y"}  // x=y split up
                {"x": ["p", "q"]}  // x=y split up
                null        // no parens in source
                []          // combo of {} and null
            */
            case pData:GetType(annoName):
                // eg @Test or @Before
                when JsonDataType:NULL then
                    annotationsInfo:Add(new AnnotationInfo(annoName, '':u, '':u)).
                
                // eg @Test(expected="AppError") or @TestSuite(classes="foo,bar").
                when JsonDataType:OBJECT then
                do:
                    assign arrData = new JsonArray().
                    arrData:Add(pData:GetJsonObject(annoName)).
                end.                    
                    // array means multiple annots with the same name, just on a different line
                when JsonDataType:ARRAY then
                    assign arrData = pData:GetJsonArray(annoName).
            end case.
            
            if valid-object(arrData) then
                assign annoCnt = arrData:Length.
            ANNO-LOOP:
            do annoLoop = 1 to annoCnt:
                if not arrData:GetType(annoLoop) eq JsonDataType:OBJECT then
                    next ANNO-LOOP.
                
                assign annoData = arrData:GetJsonObject(annoLoop)
                       extent(attribNames) = ?
                       attribNames = annoData:GetNames()
                       attribCnt   = extent(attribNames)
                       
                       // the 'main' part of the annotation
                       attrName    = attribNames[1]
                       val          = BuildAttributeValue(attrName, annoData)
                       .
                if not val eq ? then
                    assign attrValue = val.
                do attribLoop = 2 to attribCnt:
                    assign attrValue = attrValue + ',':U 
                                     + attribNames[attribLoop]
                                     + '=':u
                                     + BuildAttributeValue(string(attribNames[attribLoop]), annoData). 
                end.
                // we add a distinct AnnotationInfo for each entry, even if they have the same name
                annotationsInfo:Add(new AnnotationInfo(annoName, attrName, attrValue)).
            end.
        end. // all annotations
        
        return annotationsInfo.
    end method.
    
    /*------------------------------------------------------------------------------
        Parses the XREF XML file for Test Methods and Procedures
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC TypeInfo ParseXMLDocument(INPUT xmlDocument AS CHARACTER):
        define variable annoWriter as AnnotationWriter no-undo.
        define variable fileAnnots as JsonObject no-undo.
        define variable propNames as longchar extent no-undo.
        define variable annots as JsonObject no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        define variable typeInfo as TypeInfo  no-undo.
        define variable annotationsInfo as Array no-undo.
        define variable testCaseName as character no-undo.
        define variable isSuite as logical no-undo.
        define variable fnData as JsonObject no-undo.
        define variable testInfo as TestInfo no-undo.
        define variable pos as integer no-undo.
        define variable params as character no-undo.
        
        assign annoWriter = new AnnotationWriter(xmlDocument)
               fileAnnots = annoWriter:GetAnnotations(?)
               propNames  = fileAnnots:GetNames()
               .
        // if there was a parsing error, then we get a valid JSON object but without any properties
        if extent(propNames) eq ? then
            undo, throw new AppError(substitute('Unable to extract annotations from XML XREF file: "&1"', xmlDocument), 0).
        
        assign // the first (and only) child is the test case (suite/class/proc)
               testCaseName = propNames[1]
               fileAnnots   = fileAnnots:GetJsonObject(testCaseName)
               // this program's typeinfo
               typeInfo                    = new TypeInfo()
               typeInfo:methods            = new Array()
               typeInfo:methods:AutoExpand = TRUE
               .
        if JsonPropertyHelper:HasTypedProperty(fileAnnots, 'program':u, JsonDataType:OBJECT) then
        do:
            assign annots          = fileAnnots:GetJsonObject('program':u)
                   annotationsInfo = BuildAnnotationInfo(annots)
                   isSuite         = AnnotationUtil:HasAnnotation(annotationsInfo, 'TestSuite':u)
                   .
            if isSuite then
            do:
                // add the empty method/procedure to hold the program annotations
                typeInfo:methods:Add(new TestInfo(annotationsInfo, annotationsInfo:Size,  ?)).
                assign typeInfo:methodsCount =  typeInfo:methodsCount + 1.
            end.
        end.
        else
            assign annotationsInfo = new Array().
        
        if fileAnnots:GetJsonObject('meta':u):Has('inherits':u) then
        do:
            // is a class
            assign typeInfo:classInfo = new ClassInfo(testCaseName, annotationsInfo).
            // now methods
            if not isSuite
            and JsonPropertyHelper:HasTypedProperty(fileAnnots, 'method':u, JsonDataType:OBJECT)
            then
            do:
                assign extent(propNames) = ?
                       fnData    = fileAnnots:GetJsonObject('method':u)
                       propNames = fnData:GetNames()
                       cnt       = extent(propNames) 
                       .
                METHOD-LOOP:
                do loop = 1 to cnt:
                    assign pos          = r-index(propNames[loop], '(':u)
                           testCaseName = substring(propNames[loop], 1, pos - 1)
                           params       = substring(propNames[loop], pos)
                           .
                    // only no-parameter methods are allowed. only protected and public methods appear
                    // in the xref/annotations
                    if not params eq '()':u then
                        next METHOD-LOOP.
                    
                    if JsonPropertyHelper:HasTypedProperty(fnData, testCaseName + params, JsonDataType:OBJECT) then 
                        assign annotationsInfo = BuildAnnotationInfo(fnData:GetJsonObject(testCaseName + params)).
                    else
                        assign annotationsInfo = ?.
                    
                    // only consider methods with annotations
                    if valid-object(annotationsInfo) then
                    do:
                        assign testInfo              = new TestInfo(annotationsInfo, annotationsInfo:Size, testCaseName)
                               typeInfo:methodsCount = typeInfo:methodsCount + 1
                               testInfo:isStatic     = ?        // we can deprecate this flag 
                               .
                        typeInfo:methods:Add(testInfo).
                    end.
                end.
            end.
        end.
        else
        do:
            // now internal procedures
            if not isSuite
            and JsonPropertyHelper:HasTypedProperty(fileAnnots, 'procedure':u, JsonDataType:OBJECT)
            then
            do:
                assign extent(propNames) = ?
                       fnData    = fileAnnots:GetJsonObject('procedure':u)
                       propNames = fnData:GetNames()
                       cnt       = extent(propNames) 
                       .
                PROCEDURE-LOOP:
                do loop = 1 to cnt:
                    assign testCaseName = propNames[loop].
                    if JsonPropertyHelper:HasTypedProperty(fnData, testCaseName, JsonDataType:OBJECT) then 
                        assign annotationsInfo = BuildAnnotationInfo(fnData:GetJsonObject(testCaseName)).
                    else
                        assign annotationsInfo = ?.
                    
                    // only consider methods with annotations
                    if valid-object(annotationsInfo) then
                    do:
                        assign testInfo              = new TestInfo(annotationsInfo, annotationsInfo:Size, testCaseName)
                               typeInfo:methodsCount = typeInfo:methodsCount + 1
                               .
                        typeInfo:methods:Add(testInfo).
                    end.
                end.
            end.
        end.
        
        // This condition is for testsuites, which has only one annotation preceding the class definition and no methods.
        // Remove the empty method/procedure we added up front
        if isSuite
        and typeInfo:methodsCount gt 1
        then
        do:
            // we added the empty proc first
            typeInfo:methods:Remove(1).
            typeInfo:methodsCount = typeInfo:methodsCount - 1.
        end.
        
        return TypeInfo.
    END METHOD.
    
    /*------------------------------------------------------------------------------
            Given a testclass and test method, this method will store and
            run the test methods and calls a method which writes the results in the xml file
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID populateTestModelForTestClass(INPUT testClassName AS CHARACTER,
                                                     INPUT testMethod AS CHARACTER,
                                                     INPUT testEntity AS TestEntity):
        {&_proparse_ prolint-nowarn(varusage)}
        DEFINE VARIABLE testClassType   AS Progress.Lang.Object NO-UNDO.
        DEFINE VARIABLE methodInfoList  AS Array                NO-UNDO.
        DEFINE VARIABLE testSuiteInfo   AS TestInfo             NO-UNDO.
        DEFINE VARIABLE classAnnotInfo  AS ClassAnnotationInfo  NO-UNDO.
        DEFINE VARIABLE i               AS INTEGER              NO-UNDO.
        DEFINE VARIABLE testSuiteCount  AS INTEGER              NO-UNDO INIT 0.
        DEFINE VARIABLE annotationName  AS CHARACTER            NO-UNDO.
        DEFINE VARIABLE ignoreTest      AS LOGICAL              NO-UNDO.
        DEFINE VARIABLE testResult      AS TestTestResult       NO-UNDO.
        DEFINE VARIABLE typeInfo        AS TypeInfo             NO-UNDO.
        DEFINE VARIABLE isTestClass     AS LOGICAL              NO-UNDO INITIAL NO.

        /** for qualified classes input **/
        testClassName = getRelativePathOfClasses(testClassName).
        typeInfo = BuildTypeInfo(testClassName, "class").

        methodInfoList = typeInfo:methods.
        classAnnotInfo = NEW ClassAnnotationInfo().

        // Check whether the test method is ignored
        ignoreTest = AnnotationUtil:HasIgnoreAnnotation(typeInfo:classInfo:annotationsInfo).
        /*
        Loop through the parsed method information from xref xml file
        */
        DEFINE VARIABLE testInfo AS TestInfo no-undo.

        DO i=1 TO typeInfo:methodsCount:
            testInfo = CAST(methodInfoList:GetValue(i), TestInfo).

            DEFINE VARIABLE annotations AS Array NO-UNDO.
            DEFINE VARIABLE annotationsCount AS INTEGER NO-UNDO.
            DEFINE VARIABLE annotationInfo AS AnnotationInfo NO-UNDO.
            DEFINE VARIABLE j AS INTEGER NO-UNDO.

            annotations = testInfo:annotations.
            annotationsCount = testInfo:annotationsCount.

            DO j=1 TO annotationsCount:
            annotationInfo = CAST(annotations:GetValue(j), AnnotationInfo).
            annotationName = annotationInfo:getAnnotationName().
            CASE annotationName:
                WHEN "TestSuite" THEN
                IF NOT ignoreTest THEN
                    ASSIGN testSuiteCount = testSuiteCount + 1
                           testSuiteInfo  = testInfo
                           isTestClass    = TRUE
                           .
                WHEN "Before" THEN
                    classAnnotInfo:setBeforeClass(testInfo).

                WHEN "Setup" THEN
                    classAnnotInfo:setBeforeMethod(testInfo).

                WHEN "Test" THEN
                DO:
                    classAnnotInfo:AddTestMethod(testInfo).

                    // if there's one annotated method, this is a test
                    ASSIGN isTestClass = TRUE.

                    IF testInfo:getTestName() = testMethod THEN
                        ASSIGN testMethodInfo = testInfo.
                END.

                WHEN "TearDown" THEN
                    classAnnotInfo:setAfterMethod(testInfo).

                WHEN "After" THEN
                    classAnnotInfo:setAfterClass(testInfo).
            END CASE.
            END.
        END.

        IF NOT isTestClass THEN
            RETURN.

        IF NOT testSuiteCount = 0  THEN
        DO:
            DEFINE VARIABLE testSuite AS TestSuite no-undo.
            testSuite = NEW TestSuite(currentID).
            currentID = currentID + 1.
            testSuite:Name = testClassName.
            testModel:addTestEntity(testSuite).
            testSuite:classInfo = typeInfo:classInfo.
            // Check whether the suite class is ignored
            IF ignoreTest THEN
                UpdateIgnoreDetails(testResult, testSuite, testClassName, testModel:Summary).
            ELSE
                populateTestModelForTestSuite(testSuiteInfo, testSuite).
        END.
        ELSE DO:
            DEFINE VARIABLE testClass AS TestClass NO-UNDO.
            
            assign testClass                = NEW TestClass(currentID)
                   currentID                = currentID + 1
                   testClass:Name           = testClassName
                   testClass:AnnotationInfo = classAnnotInfo
                   testClass:classInfo      = typeInfo:classInfo
                   .
            testEntity:addTestEntity(testClass).
            // Check whether the class is ignored
            IF ignoreTest THEN
                UpdateIgnoreDetails(testResult, testClass, testClassName, testModel:Summary).
            ELSE
            // The testMethod variable only has a value when we're testing a single test in a testcase. If it's a 
            // private/protected method then it won't appear in the annotations, and we will skip it since we cannot test it 
            if testMethod eq '':u
            or valid-object(testMethodInfo)
            then
                populateTestModelForTestMethod(testClassType, testClassName, classAnnotInfo, testMethodInfo, (testMethod = ""), testClass).
        END.

    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID UpdateIgnoreDetails( testResult AS TestTestResult, testEntity AS TestEntity, testName AS CHARACTER, summaryResult AS TestTypeResult ):
        ASSIGN testResult = NEW TestTestResult(testName).
        testResult:TestResult = TestResultEnum:StatusIgnored.

        testEntity:AddTestResult(testResult).

        summaryResult:Add(testResult).
    END METHOD.
    
    {&_proparse_ prolint-nowarn(varusage)}
    METHOD PUBLIC VOID populateTestModelForTestMethod(INPUT testClassType AS Progress.Lang.Object,
                                                      INPUT testClassName AS CHARACTER,
                                                      INPUT classAnnotInfo AS ClassAnnotationInfo,
                                                      INPUT pTestMethodInfo AS TestInfo,
                                                      INPUT runAllMethods AS LOGICAL,
                                                      INPUT testEntity AS TestEntity):
        DEFINE VARIABLE testmethod  AS TestMethod NO-UNDO.
        DEFINE VARIABLE testInfo AS TestInfo no-undo.
        DEFINE VARIABLE j AS INTEGER NO-UNDO.
        DEFINE VARIABLE testCount AS INTEGER NO-UNDO.

        ASSIGN testCount  = classAnnotInfo:Tests:Size.
        IF(runAllMethods) THEN
        DO j=1 TO testCount:
            testMethod = NEW TestMethod(currentID).
            currentID = currentID + 1.

            testInfo = CAST(classAnnotInfo:Tests:Get(j), TestInfo).

            testmethod:Name = testInfo:getTestName().
            testmethod:setTestInfo(testInfo).
            testEntity:addTestEntity(testmethod).
        END.
        ELSE
        DO:
            testMethod = NEW TestMethod(currentID).
            currentID = currentID + 1.
            testmethod:Name = pTestMethodInfo:getTestName().
            testmethod:setTestInfo(pTestMethodInfo).
            testEntity:addTestEntity(testmethod).
        END.
    END METHOD.

    {&_proparse_ prolint-nowarn(varusage)}
    METHOD PUBLIC VOID populateTestModelForInternalProcs(INPUT procHandle AS HANDLE,
                                                         INPUT testProcedureName AS CHARACTER,
                                                         INPUT procAnnotInfo AS ProcedureAnnotationInfo,
                                                         INPUT testProcInfo AS TestInfo,
                                                         INPUT runAllProcs AS LOGICAL,
                                                         INPUT testEntity AS TestEntity):
        DEFINE VARIABLE testProcsCount AS INTEGER NO-UNDO.
        DEFINE VARIABLE j AS INTEGER NO-UNDO.
        DEFINE VARIABLE internalProcTestEntity AS TestMethod NO-UNDO.
        DEFINE VARIABLE testInfo AS TestInfo no-undo.

        ASSIGN testProcsCount = procAnnotInfo:Tests:Size.
        IF(runAllProcs) THEN
        DO j=1 TO testProcsCount:
            internalProcTestEntity = NEW TestMethod(currentID).
            currentID = currentID + 1.

            testInfo = CAST(procAnnotInfo:Tests:Get(j), TestInfo).

            internalProcTestEntity:Name = testInfo:getTestName().
            internalProcTestEntity:setTestInfo(testInfo).
            testEntity:addTestEntity(internalProcTestEntity).
        END.
        ELSE
        DO:
            internalProcTestEntity = NEW TestMethod(currentID).
            currentID = currentID + 1.
            internalProcTestEntity:Name = testProcInfo:getTestName().
            internalProcTestEntity:setTestInfo(testProcInfo).
            testEntity:addTestEntity(internalProcTestEntity).
        END.
    END METHOD.

    /*------------------------------------------------------------------------------
            Given a test procedure and test internal procedure, this method will store and
            run the test procedures and calls a method which writes the results in the xml file
            Notes:
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID populateTestModelForProcedureType(INPUT testProcedureName AS CHARACTER, INPUT testInternalProcedure AS CHARACTER, INPUT testEntity AS TestEntity):
        {&_proparse_ prolint-nowarn(varusage)}
        DEFINE VARIABLE procHandle     AS        HANDLE NO-UNDO.
        DEFINE VARIABLE procInfoList   AS        Array NO-UNDO.
        DEFINE VARIABLE procAnnotInfo  AS        ProcedureAnnotationInfo NO-UNDO.
        DEFINE VARIABLE testSuiteList  AS        TestInfo NO-UNDO.
        DEFINE VARIABLE i              AS        INTEGER NO-UNDO.
        DEFINE VARIABLE testSuiteCount AS        INTEGER NO-UNDO INIT 0.
        DEFINE VARIABLE annotation AS             CHARACTER NO-UNDO.
        DEFINE VARIABLE testProcInfo   AS        TestInfo NO-UNDO.
        DEFINE VARIABLE procTestEntity   AS      TestProcedure     NO-UNDO.
        DEFINE VARIABLE typeInfo AS TypeInfo  NO-UNDO.
        DEFINE VARIABLE ignoreTest AS LOGICAL  NO-UNDO.
        DEFINE VARIABLE isTestProc AS LOGICAL NO-UNDO INITIAL NO.
        
        typeInfo = BuildTypeInfo(testProcedureName, "proc").
        procInfoList = typeInfo:methods.
        procAnnotInfo = NEW ProcedureAnnotationInfo().
        /*
        Loops through the procedure information obtained from xref xml file
        */
        DEFINE VARIABLE testInfo AS TestInfo no-undo.
        DO i=1 TO typeInfo:methodsCount:
            testInfo = CAST(procInfoList:GetValue(i), TestInfo).
            DEFINE VARIABLE annotations AS Array NO-UNDO.
            DEFINE VARIABLE annotationsCount AS INTEGER NO-UNDO.
            DEFINE VARIABLE annotationInfo AS AnnotationInfo NO-UNDO.
            DEFINE VARIABLE j AS INTEGER NO-UNDO.
            annotations = testInfo:annotations.
            annotationsCount = testInfo:annotationsCount.
            DO j=1 TO annotationsCount:
            annotationInfo = CAST(annotations:GetValue(j), AnnotationInfo).
            annotation = annotationInfo:getAnnotationName().
            CASE annotation:
                WHEN "TestSuite" THEN
                    ASSIGN testSuiteCount = testSuiteCount + 1
                           testSuiteList  = testInfo
                           isTestProc     = YES
                           .

                WHEN "Before" THEN
                DO:
                    procAnnotInfo:setBeforeProcedure(testInfo).
                    IF testInfo:getTestName() = testInternalProcedure THEN
                        testProcInfo = testInfo.
                END.

                WHEN "Setup" THEN
                DO:
                    procAnnotInfo:setBefore(testInfo).
                    IF testInfo:getTestName() = testInternalProcedure THEN
                        testProcInfo = testInfo.
                END.

                WHEN "Test" THEN
                DO:
                    procAnnotInfo:addTestProc(testInfo).

                    // if there's one annotated method, this is a test
                    ASSIGN isTestProc = TRUE.

                    IF testInfo:getTestName() = testInternalProcedure THEN
                        testProcInfo = testInfo.
                END.

                WHEN "TearDown" THEN
                DO:
                    procAnnotInfo:setAfter(testInfo).
                    IF testInfo:getTestName() = testInternalProcedure THEN
                        testProcInfo = testInfo.
                END.

                WHEN "After" THEN
                DO:
                    procAnnotInfo:setAfterProcedure(testInfo).
                    IF testInfo:getTestName() = testInternalProcedure THEN
                        testProcInfo = testInfo.
                END.
                WHEN "Ignore" THEN
                   ignoreTest = TRUE.
            END CASE.
            END.
        END.

        IF NOT isTestProc THEN
            RETURN.

        IF NOT testSuiteCount = 0  THEN
        DO:
            DEFINE VARIABLE testProcSuite AS TestEntity no-undo.
            testProcSuite = NEW TestSuite(currentID).
            currentID = currentID + 1.
            testProcSuite:Name = testProcedureName.
            testEntity:addTestEntity(testProcSuite).
            // Check whether the suite proc is ignored
            IF ignoreTest THEN
            DO:
                DEFINE VARIABLE testResult AS TestTestResult NO-UNDO.
                UpdateIgnoreDetails(testResult, testProcSuite, testProcedureName, testModel:Summary).
            END.
            ELSE
                populateTestModelForTestSuite(testSuiteList, testProcSuite).
        END.
        ELSE IF testSuiteCount = 0 THEN
        DO:
            procTestEntity = NEW TestProcedure(currentID).
            currentID = currentID + 1.
            procTestEntity:Name = testProcedureName.
            procTestEntity:AnnotationInfo = procAnnotInfo.
            testEntity:addTestEntity(procTestEntity).
            IF testInternalProcedure = "" THEN
                populateTestModelForInternalProcs(procHandle, testProcedureName, procAnnotInfo, testProcInfo, TRUE, procTestEntity).
            ELSE
                populateTestModelForInternalProcs(procHandle, testProcedureName, procAnnotInfo, testProcInfo, FALSE, procTestEntity).
        END.
    END METHOD.

    /*------------------------------------------------------------------------------
       Compiles and call the corresponding method or internal procedure to run the testcase
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID populateTestModelForTestCase(INPUT testCase AS CHARACTER, INPUT test AS CHARACTER, INPUT testEntity AS TestEntity):
        IF (testCase MATCHES "*~~.p") THEN
            populateTestModelForProcedureType(testCase, test, testEntity).
        ELSE IF (testCase MATCHES "*~~.cls") THEN
            populateTestModelForTestClass(testCase, test, testEntity).
        ELSE IF (testCase MATCHES "*~~.r") THEN DO:
            /* We should explicitly check that the file is class or not. */
            RCODE-INFORMATION:FILE-NAME = testCase.
            IF RCODE-INFORMATION:IS-CLASS THEN
                populateTestModelForTestClass(testCase, test, testEntity).
            ELSE
                populateTestModelForProcedureType(testCase, test, testEntity).
        END.
    END METHOD.

    /*------------------------------------------------------------------------------
            Runs the corresponding method based on the type of the testcase.
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC TestEntity populateTestModel(INPUT testCase AS CHARACTER, INPUT testCount AS INTEGER):
        populateTestModel(testCase, testCount, testModel).
        loadSerializedTree(testModel).
        RETURN testModel.
    END METHOD.

    /*------------------------------------------------------------------------------
            load serialized tree
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LONGCHAR loadSerializedTree(INPUT testEntity AS TestEntity):
        DEFINE VARIABLE testEntities AS Array NO-UNDO.
        DEFINE VARIABLE newTestEntity AS TestEntity NO-UNDO.
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        DEFINE VARIABLE serializedtree AS LONGCHAR NO-UNDO.
        DEFINE VARIABLE isTestSuite AS CHARACTER NO-UNDO INIT "false".
        
        testEntities = testEntity:getTestEntities().

        DO i=1 TO testEntity:getChildrenSize():
            newTestEntity = CAST(testEntities:GetValue(i), TestEntity).
            serializedTree = serializedTree + loadSerializedTree(newTestEntity).
        END.

        IF(TYPE-OF (testEntity, TestSuite)) THEN
            isTestSuite = "true".
        serializedTree = testEntity:Name + "?" + isTestSuite + "?" + String(testEntity:id) +  "*" + serializedTree + TREE_DEPTH_END + "*".
        RETURN serializedTree.
    END METHOD.

    /*------------------------------------------------------------------------------
            populates the model based on the test input. looks at all the relavant test methods,internal procedures in the test input.
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID populateTestModel(INPUT testCase AS CHARACTER, INPUT testCount AS INTEGER, INPUT testEntity AS TestEntity):
        DEFINE VARIABLE testClass  AS CHARACTER NO-UNDO.
        DEFINE VARIABLE testMethod AS CHARACTER NO-UNDO.
        
        IF testCount = 1 THEN
            assign testClass  = testCase
                   testMethod = '':u
                   .
        else
            assign testClass = ENTRY(1, testCase, "#")
                   testMethod = ENTRY(2, testCase, "#")
                   .
        assign FILE-INFO:FILE-NAME = testClass.
        IF (FILE-INFO:FILE-TYPE BEGINS "D") THEN
            populateTestModelForTestFolder(testClass, testEntity).
        ELSE
        IF testClass MATCHES "*~~.cls"
        OR testClass MATCHES "*~~.p" 
        OR testClass MATCHES "*~~.r" 
        THEN
            populateTestModelForTestCase(testClass, testMethod, testEntity).
    END METHOD.

    /*------------------------------------------------------------------------------
            populates the test model for the ABL Unit files inside the testfolder
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID populateTestModelForTestFolder(INPUT testFolder AS CHARACTER, INPUT testEnity AS TestEntity):

        DEFINE VARIABLE fileN     AS CHARACTER NO-UNDO.
        DEFINE VARIABLE fCodes    AS CHARACTER NO-UNDO.

        INPUT STREAM dirlist FROM OS-DIR(testFolder) NO-ECHO.
        DIRBLK:
        REPEAT:
            IMPORT STREAM dirlist fileN ^ fCodes.

            IF fileN EQ "." OR
               fileN EQ ".." OR
               fCodes BEGINS "D" THEN NEXT DIRBLK.

            IF (fileN MATCHES "*~~.cls" OR fileN MATCHES "*~~.p" OR fileN MATCHES "*~~.r") THEN
                populateTestModelForTestCase(testFolder + "~/" + fileN, "", testEnity).
        END.

        FINALLY:
            INPUT STREAM dirList CLOSE.
        END FINALLY.
    END METHOD.

    /*
        Iterates through all the test cases in the TestSuite annotations
    */
    METHOD PUBLIC VOID populateTestModelForTestSuite(INPUT testSuiteList AS TestInfo, INPUT testEntity AS TestEntity):
        DEFINE VARIABLE attrValue AS CHARACTER NO-UNDO.
        DEFINE VARIABLE attrName  AS CHARACTER NO-UNDO.
        DEFINE VARIABLE annotations AS Array NO-UNDO.
        DEFINE VARIABLE annotationsCount AS INTEGER NO-UNDO.
        DEFINE VARIABLE annotationInfo AS AnnotationInfo NO-UNDO.
        DEFINE VARIABLE j AS INTEGER NO-UNDO.
        DEFINE VARIABLE classes AS CHARACTER NO-UNDO.
        DEFINE VARIABLE procedures AS CHARACTER NO-UNDO.
        DEFINE VARIABLE proceduresIndex AS INTEGER NO-UNDO.
        DEFINE VARIABLE classesIndex AS INTEGER NO-UNDO.
        DEFINE VARIABLE procedureSyntax AS CHARACTER NO-UNDO INIT "procedures=".
        DEFINE VARIABLE classSyntax AS CHARACTER NO-UNDO INIT "classes=".

        annotations = testSuiteList:annotations.
        annotationsCount = testSuiteList:annotationsCount.
        ANNOBLK:
        DO j=1 TO annotationsCount:
            annotationInfo = CAST(annotations:GetValue(j), AnnotationInfo).

            IF annotationInfo:AnnotationType NE "TestSuite" THEN
                NEXT ANNOBLK.

            attrName = annotationInfo:getAttributeName().

            IF attrName EQ "classes" THEN
            DO:
                attrValue = annotationInfo:getAttributeValue().
                proceduresIndex = INDEX(attrValue, procedureSyntax).
                IF NOT proceduresIndex = 0 THEN
                DO:
                    classes = SUBSTRING(attrValue, 1, proceduresIndex - 1, "CHARACTER").
                    procedures = SUBSTRING(attrValue, proceduresIndex + LENGTH(procedureSyntax), -1, "CHARACTER").
                END.
                ELSE
                DO:
                    classes = attrValue.
                    procedures = "".
                END.
                attrValue = TRIM (classes).
                HandleTestSuiteClasses(testEntity, attrValue).
                attrValue = TRIM (procedures).
                HandleTestSuiteProcedures(testEntity, attrValue).
            END.
            ELSE IF attrName EQ "procedures" THEN
            DO:
                attrValue = annotationInfo:getAttributeValue().
                classesIndex = INDEX(attrValue, classSyntax).
                IF NOT classesIndex = 0 THEN
                DO:
                    procedures = SUBSTRING(attrValue, 1, classesIndex - 1, "CHARACTER").
                    classes = SUBSTRING(attrValue, classesIndex + LENGTH(classSyntax), -1, "CHARACTER").
                END.
                ELSE
                DO:
                    procedures = attrValue.
                    classes = "".
                END.
                attrValue = TRIM (procedures).
                HandleTestSuiteProcedures(testEntity, attrValue).
                attrValue = TRIM (classes).
                HandleTestSuiteClasses(testEntity, attrValue).
            END.
            ELSE
            MESSAGE "@TestSuite annotation attribute name should be 'classes' or 'procedures'"
                VIEW-AS ALERT-BOX.
        END.
    END METHOD.

    METHOD PUBLIC VOID HandleTestSuiteClasses(INPUT testEntity AS TestEntity, INPUT classes AS CHARACTER):
        DEFINE VARIABLE testClassesCount AS INTEGER NO-UNDO.
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        DEFINE VARIABLE testCase  AS CHARACTER NO-UNDO.
        testClassesCount = NUM-ENTRIES(classes, ",").
        DO i = 1 TO testClassesCount:
            testCase = ENTRY (i, classes, ",").
            testCase = TRIM(testCase).
            IF NOT testcase = "" THEN
            DO:
                testCase = getRelativePathOfClasses(testCase).
                populateTestModel(testCase, 1, testEntity).
            END.
        END.
    END METHOD.

    /**
    returns the relative path of the classes if the input is of qualified type.
    **/
    METHOD PUBLIC CHARACTER getRelativePathOfClasses(INPUT testcase AS CHARACTER):
        IF NOT (testCase MATCHES "*~~.cls" OR testCase MATCHES "*~~.r") THEN
        DO:
            testcase = REPLACE (testCase, ".", "/").
            testcase = testCase + ".cls".
        END.

        RETURN testcase.
    END METHOD.

    METHOD PUBLIC VOID HandleTestSuiteProcedures(INPUT testEntity AS TestEntity, INPUT procedures AS CHARACTER):
      DEFINE VARIABLE testProceduresCount AS INTEGER NO-UNDO.
      DEFINE VARIABLE i AS INTEGER NO-UNDO.
      DEFINE VARIABLE testCase  AS CHARACTER NO-UNDO.
      testProceduresCount = NUM-ENTRIES(procedures, ",").
            DO i = 1 TO testProceduresCount:
                testCase = ENTRY (i, procedures, ",").
                testCase = TRIM(testCase).
                IF NOT testcase = "" THEN
                    populateTestModel(testCase, 1, testEntity).
            END.
    END METHOD.

    /* Processes a test entity's TestResult based on status

       @param TestEntity     The entity to process
       @param TestTypeResult The summary to which this result aggregates */
    METHOD PRIVATE VOID ProcessTestResult(INPUT pEntity AS TestEntity,
                                          INPUT pSummary AS TestTypeResult):
        DEFINE VARIABLE tr AS TestTestResult EXTENT NO-UNDO.
        DEFINE VARIABLE cnt AS INTEGER NO-UNDO.
        DEFINE VARIABLE loop AS INTEGER NO-UNDO.
        DEFINE VARIABLE failType AS CHARACTER NO-UNDO.

        IF NOT VALID-OBJECT(pEntity) THEN
            RETURN.

        IF VALID-OBJECT(pSummary) THEN
            pSummary:Add(pEntity:Summary).

        IF pEntity:Summary:ignoreCount GT 0 THEN
            updateFile(updateFile, "TEST_IGNORED " + STRING(pEntity:Id), FALSE).
        ELSE
        IF    pEntity:Summary:errorCount GT 0
           OR pEntity:Summary:failureCount GT 0
        THEN
        DO:
            ASSIGN tr  = pEntity:GetTestResults()
                   cnt = EXTENT(tr)
                   .
            EXBLK:
            DO loop = 1 TO cnt:
                CASE tr[loop]:TestResult:
                    WHEN TestResultEnum:StatusFailed THEN
                        // errors > failures since they're not deliberate
                        IF NOT failType EQ 'TEST_EXCEPTION':u THEN
                            ASSIGN failType = 'TEST_FAIL':u.
                    WHEN TestResultEnum:StatusError THEN
                        ASSIGN failType = 'TEST_EXCEPTION':u.
                    OTHERWISE
                        NEXT EXBLK.
                END CASE.

                IF VALID-OBJECT(tr[loop]:Stop) THEN
                    updateStackTrace(tr[loop]:Stop, updateFile, STRING(pEntity:Id)).
                ELSE
                    updateStackTrace(tr[loop]:Error, updateFile, STRING(pEntity:Id)).
            END.

            updateFile(updateFile, failType + " " + STRING(pEntity:Id), FALSE).
        END.
        ELSE
        // no failures or errors mean success
            updateFile(updateFile, "TEST_END " + STRING(pEntity:Id) + " " + STRING(pEntity:timeTaken), FALSE).
    END METHOD.

    /* Runs a TestEntity and aggregates results

       @param TestEntity The entity being run (class/method/suite/root)
       @param character The ABLUnit output file (not results.xml)
       @return TestTypeResult  The aggregate result for this test entity  */
    METHOD PUBLIC TestTypeResult runtests(INPUT testEntity AS TestEntity,
                                          INPUT pUpdateFile AS CHARACTER):
        DEFINE VARIABLE children            AS Array                  NO-UNDO.
        DEFINE VARIABLE childrenSize        AS INTEGER                NO-UNDO.
        DEFINE VARIABLE j                   AS INTEGER                NO-UNDO.
        DEFINE VARIABLE childEntity AS TestEntity NO-UNDO.
        DEFINE VARIABLE startTime AS DATETIME NO-UNDO.
        DEFINE VARIABLE runnableEntity AS IRunnableEntity NO-UNDO.
        DEFINE VARIABLE tr AS TestTestResult NO-UNDO.

        updateFile(pUpdateFile, "TEST_START " + STRING(testEntity:Id), FALSE).

        ASSIGN startTime = NOW.
        /* Suite Class, Suite Procedure, Test Class may have configured with Ignore Annotation.
           The TestRootModel is a "virtual" TestEntity, that's at the top of the graph, and doesn't actually have any
           tests itself. This method - runtest() - is called recursively so as to run All The Tests. If the root model 
           has an ignored test, we continue; if there's a TestSuite/TestCase/TestProcedure/etc that has the @Ignored 
           annotation, we skip running just that test/case/suite. */
        /*Start*/
        
        IF  testEntity:Summary:ignoreCount GT 0 
        and not type-of(testEntity, TestRootModel)
        THEN
        DO:
            updateFile(pUpdateFile, "TEST_IGNORED " + STRING(testEntity:Id), FALSE).
            ASSIGN testEntity:TimeTaken = 0.
            updateFile(pUpdateFile, "TEST_END " + STRING(testEntity:Id) + " " + STRING(testEntity:TimeTaken) , FALSE).

            RETURN testEntity:Summary.
        END.
        /*End*/

        children = testEntity:getTestEntities().
        childrenSize = testEntity:getChildrenSize().

        IF TYPE-OF(testEntity, IRunnableEntity) THEN
        DO:
            ASSIGN runnableEntity = CAST(testEntity, IRunnableEntity).

            runnableEntity:StartEntity().
            IF    testEntity:Summary:errorCount GT 0
               OR testEntity:Summary:failureCount GT 0
            THEN
                RETURN testEntity:Summary.
            ELSE
                // ... but don't add success (since we're not _actually_ running a test here ...
                ProcessTestResult(testEntity, ?).
        END.

        DO j = 1 TO childrenSize:
            ASSIGN childEntity = CAST(children:GetValue(j), TestEntity).
            IF    TYPE-OF(childEntity, TestMethod)
              AND valid-object(runnableEntity)
            THEN
            DO:
                updateFile(pUpdateFile, "TEST_START " + STRING(childEntity:Id), FALSE).

                runnableEntity:RunChild(childEntity).
                // for individual tests, always add the count & process the result
                ProcessTestResult(childEntity, testEntity:Summary).
            END.
            ELSE
            DO:
                // suite, class, procedure
                runtests(childEntity, pUpdateFile).
                // add the counts from the children to this run
                testEntity:Summary:Add(childEntity:Summary).
            END.
        END.

        IF VALID-OBJECT(runnableEntity) THEN
        DO:
            runnableEntity:StopEntity().
            // if there's an error we don't want to write TEST_END
            IF    testEntity:Summary:errorCount GT 0
               OR testEntity:Summary:failureCount GT 0
            THEN
                RETURN testEntity:Summary.
            ELSE
                // ... but don't add success (since we're not _actually_ running a test here ...
                ProcessTestResult(testEntity, ?).
        END.  

        ASSIGN testEntity:TimeTaken = INTERVAL(NOW, startTime, 'milliseconds':u) / 1000.
        updateFile(pUpdateFile, "TEST_END " + STRING(testEntity:Id) + " " + STRING(testEntity:TimeTaken) , FALSE).

        CATCH stoi AS Progress.Lang.Stop :
            ASSIGN tr      = NEW TestTestResult(testEntity:name)
                   tr:Stop = stoi.
            testEntity:AddTestResult(tr).
            ProcessTestResult(testEntity, testEntity:Summary).
        END CATCH.
        CATCH runErr AS Progress.Lang.Error:
            ASSIGN tr       = NEW TestTestResult(testEntity:name)
                   tr:Error = runErr
                   .
            testEntity:AddTestResult(tr).
            ProcessTestResult(testEntity, testEntity:Summary).
        END CATCH.
        // always return a result, even if there was an error
        FINALLY:
            {&_proparse_ prolint-nowarn(returnfinally)}
            RETURN testEntity:Summary.
        END.
    END METHOD.

    /*------------------------------------------------------------------------------
           updates stack trace with the given error in the given file
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID updateStackTrace(INPUT errorResult AS Progress.Lang.Error,
                                         INPUT pUpdateFile AS CHARACTER,
                                         INPUT id AS CHARACTER):
        IF NOT pUpdateFile = "" THEN
        DO ON ERROR UNDO, THROW:
            DEFINE VARIABLE stackTrace     AS CHARACTER            NO-UNDO.
            DEFINE VARIABLE stackTraceLine AS CHARACTER            NO-UNDO.
            DEFINE VARIABLE i              AS INTEGER              NO-UNDO.
            DEFINE VARIABLE numMessages    AS INTEGER              NO-UNDO.

            OUTPUT TO VALUE(pUpdateFile) APPEND.

            IF NOT VALID-OBJECT(errorResult) THEN
            DO:
                PUT UNFORMATTED "STACK_TRACE " id " UNKNOWN ERROR " SKIP.
                RETURN.
            END.

            stackTrace = errorResult:CallStack.

            numMessages = errorResult:NumMessages.
            DO i=1 TO numMessages:
                PUT UNFORMATTED "STACK_TRACE " id " " errorResult:GetMessage(i) SKIP.
            END.

            IF TYPE-OF(errorResult, AppError) THEN
            DO:
                stackTraceLine = CAST(errorResult, AppError):ReturnValue.
                IF NOT stackTraceLine EQ '':u THEN
                    PUT UNFORMATTED "STACK_TRACE " id " " stackTraceLine SKIP.
            END.

            numMessages = NUM-ENTRIES(stackTrace,CHR(10) + CHR(13)).
            DO i=1 TO numMessages:
                stackTraceLine = ENTRY(i, stackTrace, CHR(10) + CHR(13)).
                PUT UNFORMATTED "STACK_TRACE " id " " stackTraceLine SKIP.
            END.

            FINALLY:
                OUTPUT close.
            END FINALLY.
        END.
    END METHOD.

    /* Writes a stack trace for a stop condition

       @param Progress.Lang.Stop THe stop condition
       @param character The file into which to write
       @param character The ID of the test entity   */
    METHOD PRIVATE VOID updateStackTrace(INPUT pStop AS Progress.Lang.Stop,
                                         INPUT pUpdateFile AS CHARACTER,
                                         INPUT pId AS CHARACTER):
        DEFINE VARIABLE loop AS INTEGER NO-UNDO.
        DEFINE VARIABLE cnt AS INTEGER NO-UNDO.
        DEFINE VARIABLE traceLine AS CHARACTER NO-UNDO.

        IF pUpdateFile EQ '':u THEN
            RETURN.

        OUTPUT to value(pUpdateFile) append.

        IF NOT VALID-OBJECT(pStop) THEN
        DO:
            PUT UNFORMATTED "STACK_TRACE " pId " UNKNOWN STOP CONDITION " SKIP.
            RETURN.
        END.

        PUT UNFORMATTED "STACK_TRACE " pId " STOP CONDITION: " pStop:GetClass():TypeName SKIP.

        IF TYPE-OF(pStop, LockConflict) THEN
        DO:
            // Device
            ASSIGN traceLine = CAST(pStop, LockConflict):Device.
            IF NOT traceLine EQ '':u THEN
                PUT UNFORMATTED "STACK_TRACE " pId " Device: " traceLine SKIP.
            // TableName
            ASSIGN traceLine = CAST(pStop, LockConflict):TableName.
            IF NOT traceLine EQ '':u THEN
                PUT UNFORMATTED "STACK_TRACE " pId " TableName: " traceLine SKIP.
            // User
            ASSIGN traceLine = CAST(pStop, LockConflict):User.
            IF NOT traceLine EQ '':u THEN
                PUT UNFORMATTED "STACK_TRACE " pId " User: " traceLine SKIP.
        END.
        //
        ASSIGN cnt = NUM-ENTRIES(pStop:CallStack, CHR(10) + CHR(13)).
        DO loop = 1  TO cnt:
            ASSIGN traceLine = ENTRY(loop, pStop:CallStack, CHR(10) + CHR(13)).
            PUT UNFORMATTED "STACK_TRACE " pId " " traceLine SKIP.
        END.
        FINALLY:
            OUTPUT close.
        END FINALLY.
    END METHOD.

     /*------------------------------------------------------------------------------
           writes to the update file the given content. If override is true, the file is overwritten.
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID updateFile(INPUT pUpdateFile AS CHARACTER, INPUT content AS LONGCHAR, INPUT override AS LOGICAL):
        IF NOT pUpdateFile = "" THEN
           DO:
                content = content + "~n".
                   IF override THEN
                    COPY-LOB content TO FILE pUpdateFile .
                   ELSE
                    COPY-LOB content TO FILE pUpdateFile  APPEND.
           END.
    END METHOD.

END CLASS.
