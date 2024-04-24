/************************************************
Copyright (c) 2013-2024 by Progress Software Corporation. All rights reserved.
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
                 Current annotations are BeforeAll, BeforeEach, Test, AfterEach, AfterAll, and Ignore.
                 Legacy annotations Before, Setup, TearDown, and After are supported but logged as deprecated.
 ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.ABLUnit.Model.File from propath.
using OpenEdge.ABLUnit.Model.IRunnableEntity from propath.
using OpenEdge.ABLUnit.Model.TestCase from propath.
using OpenEdge.ABLUnit.Model.TestClass from propath.
using OpenEdge.ABLUnit.Model.TestEntity from propath.
using OpenEdge.ABLUnit.Model.TestMethod from propath.
using OpenEdge.ABLUnit.Model.TestProcedure from propath.
using OpenEdge.ABLUnit.Model.TestRootModel from propath.
using OpenEdge.ABLUnit.Model.TestSuite from propath.
using OpenEdge.ABLUnit.Reflection.AnnotationInfo from propath.
using OpenEdge.ABLUnit.Reflection.AnnotationUtil from propath.
using OpenEdge.ABLUnit.Reflection.ClassAnnotationInfo from propath.
using OpenEdge.ABLUnit.Reflection.ClassInfo from propath.
using OpenEdge.ABLUnit.Reflection.ProcedureAnnotationInfo from propath.
using OpenEdge.ABLUnit.Reflection.TestInfo from propath.
using OpenEdge.ABLUnit.Reflection.TypeInfo from propath.
using OpenEdge.ABLUnit.Results.TestResultEnum from propath.
using OpenEdge.ABLUnit.Results.TestTestResult from propath.
using OpenEdge.ABLUnit.Results.TestTypeResult from propath.
using OpenEdge.ABLUnit.Runner.TestConfig from propath.
using OpenEdge.ABLUnit.Writer.IResultsWriter from propath.
using OpenEdge.ABLUnit.Writer.ResultsXmlWriter from propath.
using OpenEdge.Core.Collections.Array from propath.
using Progress.Json.ObjectModel.JsonArray from propath.
using Progress.Json.ObjectModel.JsonObject from propath.
using Progress.Json.ObjectModel.JsonDataType from propath.
using Progress.Lang.AppError from propath.
using Progress.Lang.LockConflict from propath.
using OpenEdge.Core.Util.AnnotationWriter from propath.
using OpenEdge.Core.Json.JsonPropertyHelper from propath.
using OpenEdge.Core.StringConstant from propath.
using OpenEdge.Core.String from propath.
using OpenEdge.Logging.ILogWriter from propath.
using OpenEdge.Logging.ISupportLogging from propath.
using OpenEdge.Logging.LoggerBuilder from propath.

// This is the full list of expected annotations reserved for the ABLUnit framework. Any others in use will be ingnored.
&scoped-define ANNOTATIONS "Before,BeforeAll,BeforeEach,After,AfterAll,AfterEach,Ignore,Setup,Teardown,Test,TestSuite"

class OpenEdge.ABLUnit.Runner.ABLRunner implements ISupportLogging:

    define private stream dirlist.

    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo get. set.

    // Class members
    define private variable TREE_DEPTH_END         as character     no-undo init "~\NULL".

    define private variable testModel              as TestRootModel no-undo.
    define private variable TEST_FOLDER_ROOT       as character     no-undo init "TEST_ROOT".
    define private variable currentID              as integer       no-undo init 0.

    define private variable testMethodInfo         as TestInfo      no-undo.
    define private variable testConfig             as TestConfig    no-undo.
    define private variable updateFile             as character     no-undo.
    define private variable prevStackTraceProperty as logical       no-undo.
    define private variable oldWarningsList        as character     no-undo.
    define private variable ablResultsFile         as character     no-undo.

    define private temp-table ttXrefs no-undo
        field ParentDir as character
        field FileName  as character
        field FullPath  as character
        field isDir     as logical
        index idxPrimary as primary ParentDir FileName /* Must keep this index. */
        index idxName               FileName
        .

    /* Default constructor */
    constructor public ABLRunner ( ):
        super().
        testModel = new TestRootModel(currentID).
        currentID = currentID + 1.
        testModel:name = TEST_FOLDER_ROOT.
        updateStackTraceProperty().
        oldWarningsList = session:suppress-warnings-list.
        session:suppress-warnings-list = '6430,' + session:suppress-warnings-list.
        this-object:Logger = LoggerBuilder:GetLogger("ABLUnit").
        this-object:FindXrefFiles().
    end constructor.

    method private void updateStackTraceProperty():
        prevStackTraceProperty = session:error-stack-trace.
        session:error-stack-trace = true.
    end method.

    /*------------------------------------------------------------------------------
        Constructor, which accepts formatted JSON object of configuration file.

        @param TestConfig Configuration for this test run
        @param character  The name of the 'update' file, used by PDSOE for incremental reporting of this test run
    ------------------------------------------------------------------------------*/
    constructor public ABLRunner ( input inputConfig as class TestConfig,
                                   input pUpdateFile as character ):
        this-object().

        if not valid-object(inputConfig) then
            return error new AppError("TestConfig can not be null.", 0).

        testConfig = inputConfig.

        /*Get the ABLUnit results file*/
        ablResultsFile = testConfig:GetResultsFile().
        if not pUpdateFile eq ? then
            assign this-object:updateFile = pUpdateFile.
    end constructor.

    /*------------------------------------------------------------------------------
        This method will return the full path of a given file.

        @param  character A single, simple file name
        @return character The full path to the file on disk
    ------------------------------------------------------------------------------*/
    method private character GetFullPathname ( input pcFile as character ):
        define variable cReturn as character no-undo.

        file-info:filename = pcFile.
        cReturn = right-trim(replace(file-info:full-pathname,StringConstant:BACKSLASH,"/"),"/").

        if cReturn ne ? and index(file-info:file-type, "D") ne 0 then
            cReturn = cReturn + "/".

        return cReturn.
    end method.

    /*------------------------------------------------------------------------------
        This method will locate any local XREF files if configured to do so.
    ------------------------------------------------------------------------------*/
    method protected void FindXrefFiles ( ):
        empty temp-table ttXrefs.

        if valid-object(testConfig) and testConfig:useXref then do:
            if not can-do("PWD,SRC", testConfig:xrefLocation) then
                /* When using pre-existing XREF files at a given location, get a listing of all available XREF files. */
                this-object:RecurseDir(testConfig:xrefLocation, substitute("*~~.&1", testConfig:xrefExtension)).
            else
                /* Otherwise, get a listing for all available XREF files under the current working directory. */
                this-object:RecurseDir(this-object:getFullPathname("."), substitute("*~~.&1", testConfig:xrefExtension)).
        end. /* useXref */
    end method.

    /*------------------------------------------------------------------------------
        This method will recurse into a directory and build a TT structure.

        @param character
        @param character
    ------------------------------------------------------------------------------*/
    method protected void RecurseDir ( input pcFrom    as character,
                                       input pcExtMask as character ):
        define variable cFileName as character no-undo.
        define variable cFullName as character no-undo.
        define variable cCodes    as character no-undo.

        input stream dirlist from os-dir(pcFrom) no-echo.
        DIRBLK:
        repeat:
            import stream dirlist cFileName cFullName cCodes.

            if cFileName eq "." or
               cFileName eq ".." or
               cFileName begins "~." then next DIRBLK.

            /* If not examining a directory, skip any files that do not match the given extension. */
            if (pcExtMask gt "") eq true and (index(cCodes, "D":U) eq 0) then
                if not (cFileName matches pcExtMask) then next DIRBLK.

            create ttXrefs.
            assign
                ttXrefs.ParentDir = pcFrom
                ttXrefs.FileName  = cFileName
                ttXrefs.FullPath  = this-object:GetFullPathname(cFullName)
                ttXrefs.isDir     = (index(cCodes, "D":U) ne 0)
                .

            release ttXrefs.
        end.
        input close.

        for each ttXrefs
            where ttXrefs.ParentDir eq pcFrom
            and ttXrefs.isDir:
            this-object:RecurseDir(substitute("&1/&2", ttXrefs.ParentDir, ttXrefs.FileName), pcExtMask).
        end.
    end method.

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
    method protected character GetXRefFile ( input pcTestCase as character,
                                             input pcTestType as character ):
        define variable testCase      as String    no-undo.
        define variable testPath      as Array     no-undo.
        define variable baseName      as character no-undo.
        define variable foundFile     as character no-undo.
        define variable candidatePath as character no-undo extent 2.
        define variable candidateName as character no-undo extent 2.
        define variable matchedFiles  as Array     no-undo.
        define variable iLoop         as integer   no-undo.
        define variable iMatchScore   as integer   no-undo extent.
        define variable iBestScore    as integer   no-undo initial 0.

        if not testConfig:useXref then return ?. /* Not using existing XREF's */

        if (pcTestCase gt "") ne true then return ?. /* No test case given. */
        if (pcTestType gt "") ne true then return ?. /* No test type given. */

        /* Make sure path slashes are consistent and remove any double-slashes. */
        assign pcTestCase = replace(replace(pcTestCase, StringConstant:BACKSLASH, "/"), "//", "/").
        assign testCase = new String(pcTestCase). /* Allows us to use helper methods on the string. */

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
        if num-entries(pcTestCase, ".") gt 0 then
            case entry(num-entries(pcTestCase, "."), pcTestCase, "."):
                when "cls" then do:
                    assign baseName = string(substring(testCase:Value, 1, length(testCase:Value) - 4)).
                    {&_proparse_ prolint-nowarn(overflow)}
                    candidatePath[1] = string(testCase:Value) + "." + testConfig:xrefExtension. /* PCTCompile Format */
                    candidatePath[2] = baseName + "." + testConfig:xrefExtension. /* PDSOE/Explicit Format */
                end. /* ABL Class */

                when "p" then do:
                    assign baseName = string(substring(testCase:Value, 1, length(testCase:Value) - 2)).
                    {&_proparse_ prolint-nowarn(overflow)}
                    candidatePath[1] = string(testCase:Value) + "." + testConfig:xrefExtension. /* PCTCompile Format */
                    candidatePath[2] = baseName + "." + testConfig:xrefExtension. /* PDSOE/Explicit Format */
                end. /* Procedure */

                when "r" then do:
                    /* For these XREF files, we need to restore the original file extension for the type of test. */
                    assign baseName = string(substring(testCase:Value, 1, length(testCase:Value) - 2)).
                    if pcTestType eq "class" then
                    do:
                        candidatePath[1] = baseName + ".cls." + testConfig:xrefExtension. /* PCTCompile Format */
                        candidatePath[2] = baseName + "." + testConfig:xrefExtension. /* PDSOE/Explicit Format */
                    end.
                    else
                    do:
                        candidatePath[1] = baseName + ".p." + testConfig:xrefExtension. /* PCTCompile Format */
                        candidatePath[2] = baseName + "." + testConfig:xrefExtension. /* PDSOE/Explicit Format */
                    end.
                end. /* R-code */
            end case.

        /* We could check for empty values in our candidate paths. */
        if candidatePath[1] eq "" or candidatePath[2] eq "" then return ?.

        assign /* Candidate paths will be identical, but the filename is not, so isolate the latter. */
            candidateName[1] = entry(num-entries(candidatePath[1], "/"), candidatePath[1], "/")
            candidateName[2] = entry(num-entries(candidatePath[2], "/"), candidatePath[2], "/")
            .

        this-object:Logger:Debug(substitute("Getting XREF for Test Case: &1", pcTestCase)).

        /**
         * We need the full path for an XREF file, so we use the directory listing previously generated.
         * First, locate all matching XREF files using just the candidate filenames.
         * This is sorted to give the shortest path first.
         */
        assign matchedFiles = new Array().
        for each ttXrefs no-lock
            where ttXrefs.FileName eq candidateName[1]
            or ttXrefs.FileName eq candidateName[2]
            by ttXrefs.ParentDir
            by ttXrefs.FileName:
            matchedFiles:Add(new OpenEdge.Core.String(ttXrefs.FullPath)).
        end.

        /* No matching XREF files located for this test. */
        if matchedFiles:Size eq 0 then return ?.

        /* Just one matching XREF? Let's go! */
        if matchedFiles:Size eq 1 then do:
            assign foundFile = matchedFiles:GetValue(1):ToString().
        end. /* Single Match */
        else
        do:
            /**
             * For OCTA-22449 we need to solve a situation of the same test file may exist in different folders,
             * typically referring to different class packages. This results in the first-found-file wins, even
             * if the matched XREF file is incorrect. Therefore, the search for a matching XREF file must take
             * additional information into account.
             * Note: This predominantly affects searching for XREF files when only an R-code file is supplied.
             */
            assign
                testPath   = testCase:Split("/") /* Split the test case path to get directories. */
                iBestScore = ? /* Reset this to indicate no best score has been determined yet. */
                .

            /* Obtain a "score" of how many matching directories exist between matches and the test file. */
            assign iMatchScore = this-object:ScoreMatches(testPath, matchedFiles).

            /**
             * Pick the file with the higher score (# of matching dirs).
             * If both scores are 0, the likelyhood is high that the first matched item is the correct one
             * (shortest path), as the recursive search starts with files within the root directory.
             */
            FINALBLK:
            do iLoop = 1 to extent(iMatchScore):
                this-object:Logger:Trace(substitute("Discovered XREF File #&1: &2 (Score: &3)",
                    iLoop, cast(matchedFiles:GetValue(iLoop), String):ToString(), iMatchScore[iLoop])).

                if iBestScore eq ? or iMatchScore[iLoop] gt iBestScore then
                    {&_proparse_ prolint-nowarn(overflow)}
                    assign
                        foundFile  = string(cast(matchedFiles:GetValue(iLoop), String):Value)
                        iBestScore = iMatchScore[iLoop]
                        .
            end. /* iLoop */
        end. /* Multiple Matches */

        this-object:Logger:Debug(substitute("Found a Suitable XREF File: &1", foundFile)).

        return foundFile. /* Return a matched file if not already encountered a RETURN statement. */
    end method.

    /*------------------------------------------------------------------------------
        Produce a score for 2 files based on the # of matching directories.

        @param  Array     A list of test paths
        @oaram  Array     A list of matched files
        @return integer[] A list of scores
    ------------------------------------------------------------------------------*/
    method private integer extent ScoreMatches ( input poTestPath     as Array,
                                                 input poMatchedFiles as Array ):
        define variable xrefPath    as Array   no-undo.
        define variable iMatchScore as integer no-undo extent.
        define variable iMax        as integer no-undo.
        define variable iLoop       as integer no-undo.
        define variable iElem       as integer no-undo.

        extent(iMatchScore) = poMatchedFiles:Size. /* Keep score for each matched XREF file. */

        MATCHBLK:
        do iLoop = 1 to poMatchedFiles:Size:
            /* Loop through each of the matched files, as one of these should more closely match the test case. */
            assign xrefPath = cast(poMatchedFiles:GetValue(iLoop), String):Split("/").

            /* The max for an element search is limited to the smallest path, less 1 (for the filename). */
            assign iMax = MIN(poTestPath:Size, xrefPath:Size) - 1.
            if iMax lt 1 then next MATCHBLK.

            ELEMBLK:
            do iELem = 1 to iMax:
                /**
                 * Work backwards along the path, starting with the directory just before the test case
                 * filename. So long as we match elements of the path, the matching XREF file scores
                 * another point and is probably a closer match. This feels like such a hack but there's
                 * no other/better way to get the class package from r-code, so here we are.
                 */
                if cast(poTestPath:GetValue(poTestPath:Size - iELem), String):Value eq cast(xrefPath:GetValue(xrefPath:Size - iELem), String):Value then
                    assign iMatchScore[iLoop] = iMatchScore[iLoop] + 1.
                else
                    next MATCHBLK. /* Otherwise move to the next matching XREF file. */
            end. /* iElem */
        end. /* iLoop */

        return iMatchScore.
    end method.

    /*------------------------------------------------------------------------------
        This method runs the tests that are passed as JsonObject.
    ------------------------------------------------------------------------------*/
    method public void RunTests ( ):
        define variable testsArray     as JsonArray      no-undo.
        define variable testCasesArray as JsonArray      no-undo.
        define variable testIndex      as integer        no-undo.
        define variable testEntity     as TestEntity     no-undo.
        define variable writer         as IResultsWriter no-undo.

        testsArray = testConfig:testsJson.

        define variable testJson     as JsonObject no-undo.
        define variable testResource as character  no-undo.

        // Check if there's a ServiceManager and if that has a results writer defined
        if valid-object(Ccs.Common.Application:ServiceManager) then do:
            assign writer = cast(Ccs.Common.Application:ServiceManager:getService(get-class(IResultsWriter)), IResultsWriter) no-error.
            // in case an error was raised by the getService() call, clear it out (ie totally ignore it)
            assign error-status:error = no.
        end.

        if not valid-object(writer) then
            assign writer = new ResultsXmlWriter().

        this-object:FindXrefFiles().

        do testIndex = 1 to testsArray:Length:
            testJson = testsArray:GetJsonObject(testIndex).
            if (testJson:Has("folder")) then do:
                testResource = testJson:GetCharacter("folder").
                testEntity = this-object:populateTestModel(testResource, 1).
                this-object:updateFile(updateFile, "TEST_TREE" + " " + loadSerializedTree(testEntity), false).
            end.
            else if (testJson:Has("test")) then do:
                testResource = testJson:GetCharacter("test").
                if (testJson:Has("cases")) then do:
                    testCasesArray = testJson:GetJsonArray("cases").
                    define variable testCase as character no-undo.
                    testCase = testCasesArray:GetCharacter(1).
                    testEntity = this-object:populateTestModel(testResource + "#" + testCase, testCasesArray:Length + 1).
                    this-object:updateFile(updateFile, "TEST_TREE" + " " + loadSerializedTree(testEntity), false).
                end.
                else do:
                    testEntity = this-object:populateTestModel(testResource, 1).
                    this-object:updateFile(updateFile, "TEST_TREE" + " " + loadSerializedTree(testEntity), false).
                end.
            end.
        end.

        Logger:Debug(substitute('&1 tests loaded',testsArray:Length)).

        if testEntity ne ? then do:
            runtests(testEntity, updateFile).
            Logger:Debug(substitute('&1 tests run',testsArray:Length)).

            writer:WriteToFile(ablResultsFile, testEntity).
            Logger:Debug(substitute('Results output created at &1', ablResultsFile)).
        end.

        finally:
            /* COMPLETE event has to be updated anyway to complete the session. */
            this-object:updateFile(updateFile, "COMPLETE", false).
            session:error-stack-trace = prevStackTraceProperty.
            session:suppress-warnings-list = oldWarningsList.
        end.
    end method.

    /*------------------------------------------------------------------------------
        Generates the procedure information in xref xml file

        @param  character The test case being examined for addition to ABLUnit
        @param  character The expected type of test case (class or proc[edure])
        @return TypeInfo  Unit test type info about the program
    ------------------------------------------------------------------------------*/
    method public TypeInfo BuildTypeInfo ( input testCase as character,
                                           input testType as character ):
        define variable cXrefFile as character no-undo.
        return this-object:BuildTypeInfo(testCase, testType, output cXrefFile).
    end method.

    /*------------------------------------------------------------------------------
        Generates the procedure information in xref xml file

        @param  character The test case being examined for addition to ABLUnit
        @param  character The expected type of test case (class or proc[edure])
        @param  character The name of the found/generated XREF file
        @return TypeInfo  Unit test type info about the program
    ------------------------------------------------------------------------------*/
    method public TypeInfo BuildTypeInfo ( input  testCase as character,
                                           input  testType as character,
                                           output xrefFile as character ):
        define variable lXrefGen as logical no-undo initial false.

        /**
         * When the useXref is set it means ABLUnit should fine an existing
         * XREF file in a specified location using a specified extension.
         */
        if testConfig:useXref then do:
            xrefFile = this-object:GetXRefFile(testCase, testType).

            /**
             * If the XREF file is not found, we should either continue with the default
             * (compile) behavior or throw an error as indicated by the config options.
             */
            if (xrefFile gt "") ne true and testConfig:xrefThrowError then
                undo, throw new AppError("Unable to find XREF file at expected location.", 0).
        end. /* useXref */

        /**
         * If an XREF file was not available at a specified location, create one for use.
         */
        if (xrefFile gt "") ne true then do:
            /* We need a special case here in case we didn't throw an error already from lack of XREF file. */
            if (testCase matches "*~~.r") then
                undo, throw new AppError("Cannot run test case using R-code and with no XREF file available.", 0).

            /**
             * If an XREF file was not found, then follow the traditional means of creating
             * the file through compilation of the source code. For cases where multiple ABLUnit
             * executions utilize the same session temp directory a GUID will be used for the
             * file name. This may result in a large number of temporary files so the FINALLY
             * block for this method will delete the file once it has been parsed for use.
             */
            xrefFile = substitute("&1&2.xref", session:temp-dir, guid).
            compile VALUE(testCase) xref-xml value(xrefFile).
            lXrefGen = true. // Denote that the XREF was generated directly.
        end. /* COMPILE */

        return ParseXMLDocument(xrefFile). // Return the parsed information from the XREF file.

        // If any one of the test case/suites doesn't compile, then the whole test run fails.
        // Return a better message so that we know which test case failed to build
        catch err as Progress.Lang.Error:
            undo, throw new AppError(substitute('Unable to build type info for &1: &2', testCase, err:GetMessage(1)), 0).
        end catch.
        finally:
            /**
             * Normally we should delete the XREF file ONLY if it was created as part of a compile statement.
             * Though if the user enabled the debug option, then the xref files will be kept for inspection.
             */
            if lXrefGen and not testConfig:debugEnabled then
                os-delete value(xrefFile).
        end finally.
    end method.

    /*------------------------------------------------------------------------------
        Builds the attribute value, as ABLUnit expects it "value,value2" etc
        The annotation data format is:
           "anno-name" :
                       {"x": "y"}         // x=y split up
                       {"x": ["p", "q"]}  // x=y split up
                       null               // no parens in source
                       []                 // combo of {} and null

        @param  character  The attribute name. If blank or null, the null string is returned
        @param  JsonObject The annotation data. If invalid, the null string is returned
        @return character  The attribute value, joined together
    ------------------------------------------------------------------------------*/
    method private character BuildAttributeValue ( input pAttrName as character,
                                                   input pAttrData as JsonObject ):
        define variable attrVal as character no-undo.
        define variable jsonVal as character no-undo.
        define variable delim   as character no-undo.
        define variable cnt     as integer   no-undo.
        define variable loop    as integer   no-undo.
        define variable ja      as JsonArray no-undo.

        if not valid-object(pAttrData)
            or pAttrName eq ?
            or pAttrName eq '':u
            or not pAttrData:Has(pAttrName) then
            return ?.

        case pAttrData:GetType(pAttrName):
            when JsonDataType:NULL   then
                assign attrVal = ?.
            when JsonDataType:STRING then
                assign attrVal = pAttrData:GetCharacter(pAttrName).
            when JsonDataType:ARRAY then do:
                assign
                    ja  = pAttrData:GetJsonArray(pAttrName)
                    cnt = ja:Length
                    .

                DATA-LOOP:
                do loop = 1 to cnt:
                    case ja:GetType(loop):
                        when JsonDataType:NULL   then
                            assign jsonVal = '?':u.
                        when JsonDataType:STRING then
                            assign jsonVal = ja:GetCharacter(loop).
                        otherwise
                            {&_proparse_ prolint-nowarn(overflow)}
                            assign jsonVal = string(ja:GetJsonText(loop)).
                    end case.

                    assign
                        attrVal = attrVal + delim + jsonVal
                        delim   = ',':u
                        .
                end.
            end. // JsonDataType:ARRAY
        end case.

        return attrVal.
    end method.

    /*------------------------------------------------------------------------------
        Create an Array of AnnotationInfo objects from the JSON data

        @param  JsonObject The annotation JSON data
        @return Array      An array of annotation data. Will always be a valid object
    ------------------------------------------------------------------------------*/
    method private Array BuildAnnotationInfo ( input pData as JsonObject ):
        define variable annotationsInfo as Array      no-undo.
        define variable propNames       as longchar   extent no-undo.
        define variable cnt             as integer    no-undo.
        define variable loop            as integer    no-undo.
        define variable annoName        as character  no-undo.
        define variable attrName        as character  no-undo.
        define variable attrValue       as character  no-undo.
        define variable arrData         as JsonArray  no-undo.
        define variable annoLoop        as integer    no-undo.
        define variable annoCnt         as integer    no-undo.
        define variable annoData        as JsonObject no-undo.
        define variable attribLoop      as integer    no-undo.
        define variable attribCnt       as integer    no-undo.
        // LONGCHAR arrays don't suffer from certain size constraints
        define variable attribNames     as longchar   extent no-undo.
        define variable val             as character  no-undo.

        assign
            annotationsInfo            = new Array()
            annotationsInfo:AutoExpand = true
            .

        if not valid-object(pData) then
            return annotationsInfo.

        assign
            propNames = pData:GetNames()
            cnt       = extent(propNames)
            .

        ANNOBLK:
        do loop = 1 to cnt:
            {&_proparse_ prolint-nowarn(overflow)}
            assign
                annoName = propNames[loop]
                annoCnt  = 0
                .

            /**
             * Only select annotation names are supported for operation of ABLUnit
             * so we should skip anything which does not fit the expected pattern.
             *
             * BTW, in the JSON object passed as a param the Annotation format is:
             *   "anno-name" :
             *               {"x": "y"}         // x=y split up
             *               {"x": ["p", "q"]}  // x=y split up
             *               null               // no parens in source
             *               []                 // combo of {} and null
             */

            if lookup(annoName, {&ANNOTATIONS}) eq 0 then next ANNOBLK. // Skip unknown names.

            case pData:GetType(annoName):
                // eg @Test or @Before/@BeforeAll
                when JsonDataType:NULL then
                    annotationsInfo:Add(new AnnotationInfo(annoName, '':u, '':u)).

                // eg @Test(expected="AppError") or @TestSuite(classes="foo,bar").
                when JsonDataType:OBJECT then do:
                    assign arrData = new JsonArray().
                    arrData:Add(pData:GetJsonObject(annoName)).
                end.

                // array means multiple annotations with the same name, just on a different line
                when JsonDataType:ARRAY then
                    assign arrData = pData:GetJsonArray(annoName).
            end case.

            if valid-object(arrData) then
                assign annoCnt = arrData:Length.

            ANNO-LOOP:
            do annoLoop = 1 to annoCnt:
                if not arrData:GetType(annoLoop) eq JsonDataType:OBJECT then
                    next ANNO-LOOP.

                assign
                    annoData            = arrData:GetJsonObject(annoLoop)
                    extent(attribNames) = ?
                    attribNames         = annoData:GetNames()
                    attribCnt           = extent(attribNames)
                    // the 'main' part of the annotation
                    {&_proparse_ prolint-nowarn(overflow)}
                    attrName            = attribNames[1]
                    val                 = BuildAttributeValue(attrName, annoData)
                    .

                if not val eq ? then
                    assign attrValue = val.

                do attribLoop = 2 to attribCnt:
                    {&_proparse_ prolint-nowarn(overflow)}
                    assign
                        attrValue = attrValue + ',':U
                                              + attribNames[attribLoop]
                                              + '=':u
                                              + BuildAttributeValue(string(attribNames[attribLoop]), annoData)
                                              .
                end.

                // we add a distinct AnnotationInfo for each entry, even if they have the same name
                annotationsInfo:Add(new AnnotationInfo(annoName, attrName, attrValue)).
            end.
        end. // all annotations

        return annotationsInfo.
    end method.

    /*------------------------------------------------------------------------------
        Parses the XREF XML file for Test Methods and Procedures

        @param  character The XREF data as an XML file
        @return TypeInfo  Unit test type info about the program
    ------------------------------------------------------------------------------*/
    method public TypeInfo ParseXMLDocument ( input xmlDocument as character ):
        define variable annoWriter      as AnnotationWriter no-undo.
        define variable fileAnnots      as JsonObject       no-undo.
        // LONGCHAR arrays don't suffer from certain size constraints
        define variable propNames       as longchar         extent no-undo.
        define variable annots          as JsonObject       no-undo.
        define variable cnt             as integer          no-undo.
        define variable loop            as integer          no-undo.
        define variable typeInfo        as TypeInfo         no-undo.
        define variable annotationsInfo as Array            no-undo.
        define variable testCaseName    as character        no-undo.
        define variable isSuite         as logical          no-undo.
        define variable fnData          as JsonObject       no-undo.
        define variable testInfo        as TestInfo         no-undo.
        define variable pos             as integer          no-undo.
        define variable params          as character        no-undo.

        assign
            annoWriter = new AnnotationWriter(xmlDocument)
            fileAnnots = annoWriter:GetAnnotations(?)
            propNames  = fileAnnots:GetNames()
            .

        // if there was a parsing error, then we get a valid JSON object but without any properties
        if extent(propNames) eq ? then
            undo, throw new AppError(substitute('Unable to extract annotations from XML XREF file: "&1"', xmlDocument), 0).

        assign
            // the first (and only) child is the test case (suite/class/proc)
            {&_proparse_ prolint-nowarn(overflow)}
            testCaseName                = propNames[1]
            fileAnnots                  = fileAnnots:GetJsonObject(testCaseName)
            // this program's typeinfo
            typeInfo                    = new TypeInfo()
            typeInfo:methods            = new Array()
            typeInfo:methods:AutoExpand = true
            .

        if JsonPropertyHelper:HasTypedProperty(fileAnnots, 'program':u, JsonDataType:OBJECT) then do:
            assign
                annots          = fileAnnots:GetJsonObject('program':u)
                annotationsInfo = BuildAnnotationInfo(annots)
                isSuite         = AnnotationUtil:HasAnnotation(annotationsInfo, 'TestSuite':u)
                .

            if isSuite then do:
                // add the empty method/procedure to hold the program annotations
                typeInfo:methods:Add(new TestInfo(annotationsInfo, annotationsInfo:Size,  ?)).
                assign typeInfo:methodsCount = typeInfo:methodsCount + 1.
            end.
        end.
        else
            assign annotationsInfo = new Array().

        case fileAnnots:GetJsonObject('meta':u):GetCharacter('programType':u):
            when 'CLASS':u then do:
                assign typeInfo:classInfo = new ClassInfo(testCaseName, annotationsInfo).
                // now methods
                if not isSuite and JsonPropertyHelper:HasTypedProperty(fileAnnots, 'method':u, JsonDataType:OBJECT) then do:
                    assign
                        extent(propNames) = ?
                        fnData            = fileAnnots:GetJsonObject('method':u)
                        propNames         = fnData:GetNames()
                        cnt               = extent(propNames)
                        .

                    METHOD-LOOP:
                    do loop = 1 to cnt:
                        assign
                            pos          = r-index(propNames[loop], '(':u)
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
                        if valid-object(annotationsInfo) then do:
                            assign
                                testInfo              = new TestInfo(annotationsInfo, annotationsInfo:Size, testCaseName)
                                typeInfo:methodsCount = typeInfo:methodsCount + 1
                                testInfo:isStatic     = ?        // we can deprecate this flag
                                .
                            typeInfo:methods:Add(testInfo).
                        end.
                    end.
                end.
            end.    // CLASS

            when 'PROCEDURE':u then do:
                // now internal procedures
                if not isSuite and JsonPropertyHelper:HasTypedProperty(fileAnnots, 'procedure':u, JsonDataType:OBJECT) then do:
                    assign
                        extent(propNames) = ?
                        fnData            = fileAnnots:GetJsonObject('procedure':u)
                        propNames         = fnData:GetNames()
                        cnt               = extent(propNames)
                        .
                    PROCEDURE-LOOP:
                    do loop = 1 to cnt:
                        {&_proparse_ prolint-nowarn(overflow)}
                        assign testCaseName = propNames[loop].
                        if JsonPropertyHelper:HasTypedProperty(fnData, testCaseName, JsonDataType:OBJECT) then
                            assign annotationsInfo = BuildAnnotationInfo(fnData:GetJsonObject(testCaseName)).
                        else
                            assign annotationsInfo = ?.

                        // only consider methods with annotations
                        if valid-object(annotationsInfo) then do:
                            assign
                                testInfo              = new TestInfo(annotationsInfo, annotationsInfo:Size, testCaseName)
                                typeInfo:methodsCount = typeInfo:methodsCount + 1
                                .
                            typeInfo:methods:Add(testInfo).
                        end.
                    end.
                end.
            end. // PROCEDURE

            // we don't know how to handle interfaces and other types
            otherwise
                return ?.
        end case.

        // This condition is for testsuites, which has only one annotation preceding the class definition and no methods.
        // Remove the empty method/procedure we added up front
        if isSuite and typeInfo:methodsCount gt 1 then do:
            // we added the empty proc first
            typeInfo:methods:Remove(1).
            typeInfo:methodsCount = typeInfo:methodsCount - 1.
        end.

        return typeInfo.
    end method.

    /*------------------------------------------------------------------------------
        Given a testclass and test method, this method will store and run the
        test methods and calls a method which writes the results in the xml file

        @param  character  The test class name
        @param  character  The test class method name
        @return TestEntity The entity being run (class/method/suite/root)
    ------------------------------------------------------------------------------*/
    method public void populateTestModelForTestClass ( input testClassName as character,
                                                       input testMethod    as character,
                                                       input testEntity    as TestEntity ):
        {&_proparse_ prolint-nowarn(varusage)}
        define variable testClassType  as Progress.Lang.Object no-undo.
        define variable methodInfoList as Array                no-undo.
        define variable testSuiteInfo  as TestInfo             no-undo.
        define variable classAnnotInfo as ClassAnnotationInfo  no-undo.
        define variable i              as integer              no-undo.
        define variable testSuiteCount as integer              no-undo init 0.
        define variable annotationName as character            no-undo.
        define variable ignoreTest     as logical              no-undo.
        {&_proparse_ prolint-nowarn(varusage)}
        define variable testResult  as TestTestResult no-undo.
        define variable typeInfo    as TypeInfo       no-undo.
        define variable isTestClass as logical        no-undo initial no.
        define variable testInfo    as TestInfo       no-undo.

        /** for qualified classes input **/
        testClassName = this-object:getRelativePathOfClasses(testClassName).
        typeInfo = this-object:BuildTypeInfo(testClassName, "class").

        // May be invalid for interfaces. This does not indicate an error condition
        if not valid-object(typeInfo) then return.

        methodInfoList = typeInfo:methods.
        classAnnotInfo = new ClassAnnotationInfo().

        // Check whether the test method is ignored
        ignoreTest = AnnotationUtil:HasIgnoreAnnotation(typeInfo:classInfo:annotationsInfo).

        // Loop through the parsed method information from xref xml file
        do i = 1 to typeInfo:methodsCount:
            testInfo = cast(methodInfoList:GetValue(i), TestInfo).

            define variable annotations      as Array          no-undo.
            define variable annotationsCount as integer        no-undo.
            define variable annotationInfo   as AnnotationInfo no-undo.
            define variable j                as integer        no-undo.

            annotations = testInfo:annotations.
            annotationsCount = testInfo:annotationsCount.

            TESTBLK:
            do j = 1 to annotationsCount:
                annotationInfo = cast(annotations:GetValue(j), AnnotationInfo).
                annotationName = annotationInfo:getAnnotationName().

                // Log a warning that these annotations are deprecated in favor of more user-friendly alternatives.
                case annotationName:
                    when "Before" then
                        this-object:Logger:Warn(substitute("Test class '&1' method '&2' uses @Before annotation which will be deprecated, please use @BeforeAll.", testClassName, testInfo:testName)).

                    when "Setup" then
                        this-object:Logger:Warn(substitute("Test class '&1' method '&2' uses @Setup annotation which will be deprecated, please use @BeforeEach.", testClassName, testInfo:testName)).

                    when "TearDown" then
                        this-object:Logger:Warn(substitute("Test class '&1' method '&2' uses @TearDown annotation which will be deprecated, please use @AfterEach.", testClassName, testInfo:testName)).

                    when "After" then
                        this-object:Logger:Warn(substitute("Test class '&1' method '&2' uses @After annotation which will be deprecated, please use @AfterAll.", testClassName, testInfo:testName)).
                end case.

                // Take action as based on the annotation.
                case annotationName:
                    when "TestSuite" then
                        if not ignoreTest then
                            assign testSuiteCount = testSuiteCount + 1
                                testSuiteInfo  = testInfo
                                isTestClass    = true
                                .

                    when "BeforeAll" or
                    when "Before" then
                        // @BeforeAll (legacy: @Before) - Executed once; runs before the tests and methods marked with @BeforeEach (legacy: @Setup).
                        classAnnotInfo:setBeforeClass(testInfo).

                    when "BeforeEach" or
                    when "Setup" then
                        // @BeforeEach (legacy: @Setup) - Executed before each test.
                        classAnnotInfo:setBeforeMethod(testInfo).

                    when "Test" then do:
                        classAnnotInfo:AddTestMethod(testInfo).

                        // if there's one annotated method, this is a test
                        assign isTestClass = true.

                        if testInfo:getTestName() = testMethod then
                            assign testMethodInfo = testInfo.
                    end.

                    when "AfterEach" or
                    when "TearDown" then
                        // @AfterEach (legacy: @TearDown) - Executed after each test.
                        classAnnotInfo:setAfterMethod(testInfo).

                    when "AfterAll" or
                    when "After" then
                        // @AfterAll (legacy: @After) - Executed once; runs after all tests and methods marked with @AfterEach.
                        classAnnotInfo:setAfterClass(testInfo).

                    when "Ignore" then
                        // Any annotation not found above would be skipped anyway, but just make it explicit.
                        next TESTBLK.
                end case.
            end. // annotationsCount
        end. // typeInfo:methodsCount

        if not isTestClass then
            return.

        if not testSuiteCount eq 0 then do:
            define variable testSuite as TestSuite no-undo.
            testSuite = new TestSuite(currentID).
            currentID = currentID + 1.
            testSuite:Name = testClassName.
            testModel:addTestEntity(testSuite).
            testSuite:classInfo = typeInfo:classInfo.
            // Check whether the suite class is ignored
            if ignoreTest then
                UpdateIgnoreDetails(testResult, testSuite, testClassName, testModel:Summary).
            else
                populateTestModelForTestSuite(testSuiteInfo, testSuite).
        end.
        else do:
            define variable testClass as TestClass no-undo.

            assign
                testClass                = new TestClass(currentID)
                testClass:Logger         = this-object:Logger
                currentID                = currentID + 1
                testClass:Name           = testClassName
                testClass:AnnotationInfo = classAnnotInfo
                testClass:classInfo      = typeInfo:classInfo
                .
            testEntity:addTestEntity(testClass).

            // Check whether the class is ignored
            if ignoreTest then
                UpdateIgnoreDetails(testResult, testClass, testClassName, testModel:Summary).
            else if testMethod eq '':u or valid-object(testMethodInfo) then
                populateTestModelForTestMethod(testClassType, testClassName, classAnnotInfo, testMethodInfo, (testMethod = ""), testClass).
        end.
    end method.

    /*------------------------------------------------------------------------------
         Modify properties for ignored test

         @param TestTestResult
         @param TestEntity The entity being run (class/method/suite/root)
         @param character
         @param TestTypeResult
    ------------------------------------------------------------------------------*/
    method private void UpdateIgnoreDetails ( input testResult    as TestTestResult,
                                              input testEntity    as TestEntity,
                                              input testName      as character,
                                              input summaryResult as TestTypeResult ):
        assign testResult = new TestTestResult(testName).
        testResult:TestResult = TestResultEnum:StatusIgnored.

        testEntity:AddTestResult(testResult).

        summaryResult:Add(testResult).
    end method.

    {&_proparse_ prolint-nowarn(varusage)}
    method public void populateTestModelForTestMethod  ( input testClassType   as Progress.Lang.Object,
                                                         input testClassName   as character,
                                                         input classAnnotInfo  as ClassAnnotationInfo,
                                                         input pTestMethodInfo as TestInfo,
                                                         input runAllMethods   as logical,
                                                         input testEntity      as TestEntity ):
        define variable testmethod as TestMethod no-undo.
        define variable testInfo   as TestInfo   no-undo.
        define variable j          as integer    no-undo.
        define variable testCount  as integer    no-undo.

        assign testCount = classAnnotInfo:Tests:Size.

        if(runAllMethods) then
        do j = 1 to testCount:
            testMethod = new TestMethod(currentID).
            currentID = currentID + 1.

            testInfo = cast(classAnnotInfo:Tests:Get(j), TestInfo).

            testmethod:Name = testInfo:getTestName().
            testmethod:setTestInfo(testInfo).
            testEntity:addTestEntity(testmethod).
        end.
        else do:
            testMethod = new TestMethod(currentID).
            currentID = currentID + 1.
            testmethod:Name = pTestMethodInfo:getTestName().
            testmethod:setTestInfo(pTestMethodInfo).
            testEntity:addTestEntity(testmethod).
        end.
    end method.

    /*------------------------------------------------------------------------------
         Populate test model for internal procedures

         @param handle
         @param character
         @param ProcedureAnnotationInfo
         @param TestInfo
         @param logical
         @param TestEntity The entity being run (class/method/suite/root)
    ------------------------------------------------------------------------------*/
    {&_proparse_ prolint-nowarn(varusage)}
    method public void populateTestModelForInternalProcs ( input procHandle        as handle,
                                                           input testProcedureName as character,
                                                           input procAnnotInfo     as ProcedureAnnotationInfo,
                                                           input testProcInfo      as TestInfo,
                                                           input runAllProcs       as logical,
                                                           input testEntity        as TestEntity ):
        define variable testProcsCount         as integer    no-undo.
        define variable j                      as integer    no-undo.
        define variable internalProcTestEntity as TestMethod no-undo.
        define variable testInfo               as TestInfo   no-undo.

        assign testProcsCount = procAnnotInfo:Tests:Size.

        if(runAllProcs) then
        do j = 1 to testProcsCount:
            internalProcTestEntity = new TestMethod(currentID).
            currentID = currentID + 1.

            testInfo = cast(procAnnotInfo:Tests:Get(j), TestInfo).

            internalProcTestEntity:Name = testInfo:getTestName().
            internalProcTestEntity:setTestInfo(testInfo).
            testEntity:addTestEntity(internalProcTestEntity).
        end.
        else
        do:
            internalProcTestEntity = new TestMethod(currentID).
            currentID = currentID + 1.
            internalProcTestEntity:Name = testProcInfo:getTestName().
            internalProcTestEntity:setTestInfo(testProcInfo).
            testEntity:addTestEntity(internalProcTestEntity).
        end.
    end method.

    /*------------------------------------------------------------------------------
        Given a test procedure and test internal procedure, this method will store and
        run the test procedures and calls a method which writes the results in the xml file.

        @param character
        @param character
        @param TestEntity The entity being run (class/method/suite/root)
    ------------------------------------------------------------------------------*/
    method public void populateTestModelForProcedureType ( input testProcedureName     as character,
                                                           input testInternalProcedure as character,
                                                           input testEntity            as TestEntity ):
        {&_proparse_ prolint-nowarn(varusage)}
        define variable procHandle     as handle                  no-undo.
        define variable procInfoList   as Array                   no-undo.
        define variable procAnnotInfo  as ProcedureAnnotationInfo no-undo.
        define variable testSuiteList  as TestInfo                no-undo.
        define variable i              as integer                 no-undo.
        define variable testSuiteCount as integer                 no-undo init 0.
        define variable annotationName as character               no-undo.
        define variable testProcInfo   as TestInfo                no-undo.
        define variable procTestEntity as TestProcedure           no-undo.
        define variable typeInfo       as TypeInfo                no-undo.
        define variable ignoreTest     as logical                 no-undo.
        define variable isTestProc     as logical                 no-undo initial no.
        define variable testInfo       as TestInfo                no-undo.

        typeInfo = this-object:BuildTypeInfo(testProcedureName, "proc").
        // May be invalid for interfaces. This does not indicate an error condition
        if not valid-object(typeInfo) then return.

        procInfoList = typeInfo:methods.
        procAnnotInfo = new ProcedureAnnotationInfo().

        // Loops through the procedure information obtained from xref xml file
        do i = 1 to typeInfo:methodsCount:
            define variable annotations      as Array          no-undo.
            define variable annotationsCount as integer        no-undo.
            define variable annotationInfo   as AnnotationInfo no-undo.
            define variable j                as integer        no-undo.

            testInfo = cast(procInfoList:GetValue(i), TestInfo).
            annotations = testInfo:annotations.
            annotationsCount = testInfo:annotationsCount.

            do j = 1 to annotationsCount:
                annotationInfo = cast(annotations:GetValue(j), AnnotationInfo).
                annotationName = annotationInfo:getAnnotationName().

                // Log a warning that these annotations are deprecated in favor of more user-friendly alternatives.
                case annotationName:
                    when "Before" then
                        this-object:Logger:Warn(substitute("Test procedure '&1' in '&2' uses @Before annotation which will be deprecated, please use @BeforeAll.", testInfo:testName, testProcedureName)).

                    when "Setup" then
                        this-object:Logger:Warn(substitute("Test procedure '&1' in '&2' uses @Setup annotation which will be deprecated, please use @BeforeEach.", testInfo:testName, testProcedureName)).

                    when "TearDown" then
                        this-object:Logger:Warn(substitute("Test procedure '&1' in '&2' uses @TearDown annotation which will be deprecated, please use @AfterEach.", testInfo:testName, testProcedureName)).

                    when "After" then
                        this-object:Logger:Warn(substitute("Test procedure '&1' in '&2' uses @After annotation which will be deprecated, please use @AfterAll.", testInfo:testName, testProcedureName)).
                end case.

                // Take action as based on the annotation.
                case annotationName:
                    when "TestSuite" then
                        assign
                            testSuiteCount = testSuiteCount + 1
                            testSuiteList  = testInfo
                            isTestProc     = yes
                            .

                    when "BeforeAll" or
                    when "Before" then do:
                        // @BeforeAll (legacy: @Before) - Executed once; runs before the tests and methods marked with @BeforeEach (legacy: @Setup).
                        procAnnotInfo:setBeforeProcedure(testInfo).
                        if testInfo:getTestName() = testInternalProcedure then
                            testProcInfo = testInfo.
                    end.

                    when "BeforeEach" or
                    when "Setup" then do:
                        // @BeforeEach (legacy: @Setup) - Executed before each test.
                        procAnnotInfo:setBefore(testInfo).
                        if testInfo:getTestName() = testInternalProcedure then
                            testProcInfo = testInfo.
                    end.

                    when "Test" then do:
                        procAnnotInfo:addTestProc(testInfo).

                        // if there's one annotated method, this is a test
                        assign
                            isTestProc = true.

                        if testInfo:getTestName() = testInternalProcedure then
                            testProcInfo = testInfo.
                    end.

                    when "AfterEach" or
                    when "TearDown" then do:
                        // @AfterEach (legacy: @TearDown) - Executed after each test.
                        procAnnotInfo:setAfter(testInfo).
                        if testInfo:getTestName() = testInternalProcedure then
                            testProcInfo = testInfo.
                    end.

                    when "AfterAll" or
                    when "After" then do:
                        // @AfterAll (legacy: @After) - Executed once; runs after all tests and methods marked with @AfterEach.
                        procAnnotInfo:setAfterProcedure(testInfo).
                        if testInfo:getTestName() = testInternalProcedure then
                            testProcInfo = testInfo.
                    end.

                    when "Ignore" then
                        ignoreTest = true.
                end case.
            end. // annotationsCount
        end. // typeInfo:methodsCount

        if not isTestProc then return.

        if not testSuiteCount = 0  then do:
            define variable testProcSuite as TestEntity no-undo.
            testProcSuite = new TestSuite(currentID).
            currentID = currentID + 1.
            testProcSuite:Name = testProcedureName.
            testEntity:addTestEntity(testProcSuite).

            // Check whether the suite proc is ignored
            if ignoreTest then
            do:
                {&_proparse_ prolint-nowarn(varusage)}
                define variable testResult as TestTestResult no-undo.
                UpdateIgnoreDetails(testResult, testProcSuite, testProcedureName, testModel:Summary).
            end.
            else
                populateTestModelForTestSuite(testSuiteList, testProcSuite).
        end.
        else if testSuiteCount = 0 then do:
            assign
                procTestEntity                = new TestProcedure(currentID)
                currentID                     = currentID + 1
                procTestEntity:Logger         = this-object:Logger
                procTestEntity:Name           = testProcedureName
                procTestEntity:AnnotationInfo = procAnnotInfo
                .

            testEntity:addTestEntity(procTestEntity).
            if testInternalProcedure = "" then
                populateTestModelForInternalProcs(procHandle, testProcedureName, procAnnotInfo, testProcInfo, true, procTestEntity).
            else
                populateTestModelForInternalProcs(procHandle, testProcedureName, procAnnotInfo, testProcInfo, false, procTestEntity).
        end.
    end method.

    /*------------------------------------------------------------------------------
        Compiles and call the corresponding method or internal procedure to run the testcase

        @param  character
        @param  character
        @return TestEntity The entity being run (class/method/suite/root)
    ------------------------------------------------------------------------------*/
    method public void populateTestModelForTestCase ( input testCase   as character,
                                                      input test       as character,
                                                      input testEntity as TestEntity ):
        if (testCase matches "*~~.p") then
            populateTestModelForProcedureType(testCase, test, testEntity).
        else if (testCase matches "*~~.cls") then
            populateTestModelForTestClass(testCase, test, testEntity).
        else if (testCase matches "*~~.r") then do:
            /* We should explicitly check that the file is class or not. */
            rcode-information:file-name = testCase.
            if rcode-information:is-class then
                populateTestModelForTestClass(testCase, test, testEntity).
            else
                populateTestModelForProcedureType(testCase, test, testEntity).
        end.
    end method.

    /*------------------------------------------------------------------------------
        Runs the corresponding method based on the type of the testcase.

        @param  character
        @param  integer
        @return TestEntity The entity being run (class/method/suite/root)
    ------------------------------------------------------------------------------*/
    method public TestEntity populateTestModel ( input testCase  as character,
                                                 input testCount as integer ):
        this-object:populateTestModel(testCase, testCount, testModel).
        return testModel.
    end method.

    /*------------------------------------------------------------------------------
        Load serialized tree

        @param  TestEntity The entity being run (class/method/suite/root)
        @return longchar
    ------------------------------------------------------------------------------*/
    method public longchar loadSerializedTree ( input testEntity as TestEntity ):
        define variable testEntities   as Array      no-undo.
        define variable newTestEntity  as TestEntity no-undo.
        define variable i              as integer    no-undo.
        define variable serializedtree as longchar   no-undo.
        define variable isTestSuite    as character  no-undo init "false".
        define variable cnt            as integer    no-undo.

        // no point in doing this work if it's never going to be written to disk
        if this-object:updateFile eq '' then
            return ''.

        assign
            testEntities = testEntity:getTestEntities()
            cnt          = testEntity:getChildrenSize()
            .

        do i = 1 to cnt:
            newTestEntity = cast(testEntities:GetValue(i), TestEntity).
            serializedTree = serializedTree + loadSerializedTree(newTestEntity).
        end.

        if(type-of (testEntity, TestSuite)) then
            isTestSuite = "true".

        serializedTree = testEntity:Name + "?" + isTestSuite + "?" + String(testEntity:id) +  "*" + serializedTree + TREE_DEPTH_END + "*".

        return serializedTree.
    end method.

    /*------------------------------------------------------------------------------
        Populates the model based on the test input. looks at all the relevant
        test methods, internal procedures in the test input.

        @param character
        @param integer
        @param TestEntity The entity being run (class/method/suite/root)
    ------------------------------------------------------------------------------*/
    method private void populateTestModel ( input testCase   as character,
                                            input testCount  as integer,
                                            input testEntity as TestEntity ):
        define variable testClass  as character no-undo.
        define variable testMethod as character no-undo.

        if testCount = 1 then
            assign
                testClass  = testCase
                testMethod = '':u
                .
        else
            assign
                testClass  = entry(1, testCase, "#")
                testMethod = entry(2, testCase, "#")
                .
        assign file-info:file-name = testClass.
        if (file-info:file-type begins "D") then
            populateTestModelForTestFolder(testClass, testEntity).
        else if testClass matches "*~~.cls" or testClass matches "*~~.p" or testClass matches "*~~.r" then
            populateTestModelForTestCase(testClass, testMethod, testEntity).
    end method.

    /*------------------------------------------------------------------------------
        Populates the test model for the ABL Unit files inside the testfolder

        @param character
        @param TestEntity The entity being run (class/method/suite/root)
    ------------------------------------------------------------------------------*/
    method public void populateTestModelForTestFolder ( input testFolder as character,
                                                        input testEnity  as TestEntity ):
        define variable fileN  as character no-undo.
        define variable fCodes as character no-undo.

        input stream dirlist from os-dir(testFolder) no-echo.

        DIRBLK:
        repeat:
            import stream dirlist fileN ^ fCodes.

            if fileN eq "." or
                fileN eq ".." or
                fCodes begins "D" then next DIRBLK.

                // only use r-code if xrefs are in use
            if (testConfig:useXref
                and fileN matches "*~~.r")
                or (fileN matches "*~~.cls"
                or fileN matches "*~~.p") then
                populateTestModelForTestCase(testFolder + "~/" + fileN, "", testEnity).
        end.

        finally:
            input stream dirList close.
        end finally.
    end method.

    /*------------------------------------------------------------------------------
        Iterates through all the test cases in the TestSuite annotations

        @param TestInfo
        @param TestEntity The entity being run (class/method/suite/root)
    ------------------------------------------------------------------------------*/
    method public void populateTestModelForTestSuite ( input testSuiteList as TestInfo,
                                                       input testEntity    as TestEntity ):
        define variable attrValue        as character      no-undo.
        define variable attrName         as character      no-undo.
        define variable annotations      as Array          no-undo.
        define variable annotationsCount as integer        no-undo.
        define variable annotationInfo   as AnnotationInfo no-undo.
        define variable j                as integer        no-undo.
        define variable classes          as character      no-undo.
        define variable procedures       as character      no-undo.
        define variable proceduresIndex  as integer        no-undo.
        define variable classesIndex     as integer        no-undo.
        define variable procedureSyntax  as character      no-undo init "procedures=".
        define variable classSyntax      as character      no-undo init "classes=".

        annotations = testSuiteList:annotations.
        annotationsCount = testSuiteList:annotationsCount.
        ANNOBLK:
        do j = 1 to annotationsCount:
            annotationInfo = cast(annotations:GetValue(j), AnnotationInfo).

            if annotationInfo:AnnotationType ne "TestSuite" then
                next ANNOBLK.

            attrName = annotationInfo:getAttributeName().

            if attrName eq "classes" then
            do:
                attrValue = annotationInfo:getAttributeValue().
                proceduresIndex = index(attrValue, procedureSyntax).
                if not proceduresIndex = 0 then do:
                    classes = substring(attrValue, 1, proceduresIndex - 1, "CHARACTER").
                    procedures = substring(attrValue, proceduresIndex + LENGTH(procedureSyntax), -1, "CHARACTER").
                end.
                else do:
                    classes = attrValue.
                    procedures = "".
                end.
                attrValue = trim (classes).
                HandleTestSuiteClasses(testEntity, attrValue).
                attrValue = trim (procedures).
                HandleTestSuiteProcedures(testEntity, attrValue).
            end.
            else if attrName eq "procedures" then do:
                attrValue = annotationInfo:getAttributeValue().
                classesIndex = index(attrValue, classSyntax).
                if not classesIndex = 0 then do:
                    procedures = substring(attrValue, 1, classesIndex - 1, "CHARACTER").
                    classes = substring(attrValue, classesIndex + LENGTH(classSyntax), -1, "CHARACTER").
                end.
                else do:
                    procedures = attrValue.
                    classes = "".
                end.
                attrValue = trim (procedures).
                HandleTestSuiteProcedures(testEntity, attrValue).
                attrValue = trim (classes).
                HandleTestSuiteClasses(testEntity, attrValue).
            end.
            else
                message "@TestSuite annotation attribute name should be 'classes' or 'procedures'" view-as alert-box.
        end. // annotationsCount
    end method.

    /*------------------------------------------------------------------------------
        Handler for test suite classes

        @param  TestEntity
        @return character
    ------------------------------------------------------------------------------*/
    method public void HandleTestSuiteClasses ( input testEntity as TestEntity,
                                                input classes    as character ):
        define variable testClassesCount as integer   no-undo.
        define variable i                as integer   no-undo.
        define variable testCase         as character no-undo.

        testClassesCount = num-entries(classes, ",").

        do i = 1 to testClassesCount:
            testCase = entry (i, classes, ",").
            testCase = trim(testCase).
            if not testcase = "" then do:
                testCase = this-object:getRelativePathOfClasses(testCase).
                this-object:populateTestModel(testCase, 1, testEntity).
            end.
        end.
    end method.

    /*------------------------------------------------------------------------------
        Returns the relative path of the classes if the input is of qualified type.

        @param  character
        @return character
    ------------------------------------------------------------------------------*/
    method public character getRelativePathOfClasses ( input testcase as character ):
        if not (testCase matches "*~~.cls" or testCase matches "*~~.r") then do:
            testcase = replace (testCase, ".", "/").
            testcase = testCase + ".cls".
        end.

        return testcase.
    end method.

    /*------------------------------------------------------------------------------
        Runs a TestEntity and aggregates results

        @param TestEntity The entity being run (class/method/suite/root)
        @param character
    ------------------------------------------------------------------------------*/
    method public void HandleTestSuiteProcedures ( input testEntity as TestEntity,
                                                   input procedures as character ):
        define variable testProceduresCount as integer   no-undo.
        define variable i                   as integer   no-undo.
        define variable testCase            as character no-undo.

        testProceduresCount = num-entries(procedures, ",").

        do i = 1 to testProceduresCount:
            testCase = entry (i, procedures, ",").
            testCase = trim(testCase).
            if not testcase = "" then
                this-object:populateTestModel(testCase, 1, testEntity).
        end.
    end method.

    /*------------------------------------------------------------------------------
        Processes a test entity's TestResult based on status

        @param TestEntity The entity being run (class/method/suite/root)
        @param TestTypeResult The summary to which this result aggregates
    ------------------------------------------------------------------------------*/
    method private void ProcessTestResult ( input pEntity  as TestEntity,
                                            input pSummary as TestTypeResult ):
        define variable tr       as TestTestResult extent no-undo.
        define variable cnt      as integer        no-undo.
        define variable loop     as integer        no-undo.
        define variable failType as character      no-undo.

        if not valid-object(pEntity) then return.

        if valid-object(pSummary) then
            pSummary:Add(pEntity:Summary).

        if pEntity:Summary:ignoreCount gt 0 then
            this-object:updateFile(updateFile, "TEST_IGNORED " + STRING(pEntity:Id), false).
        else if pEntity:Summary:errorCount gt 0 or pEntity:Summary:failureCount gt 0 then
        do:
            assign
                tr  = pEntity:GetTestResults()
                cnt = extent(tr)
                .
            EXBLK:
            do loop = 1 to cnt:
                case tr[loop]:TestResult:
                    when TestResultEnum:StatusFailed then
                        // errors > failures since they're not deliberate
                        if not failType eq 'TEST_EXCEPTION':u then
                            assign failType = 'TEST_FAIL':u.
                    when TestResultEnum:StatusError then
                        assign failType = 'TEST_EXCEPTION':u.
                    otherwise
                        next EXBLK.
                end case.

                if valid-object(tr[loop]:Stop) then
                    updateStackTrace(tr[loop]:Stop, updateFile, string(pEntity:Id)).
                else
                    updateStackTrace(tr[loop]:Error, updateFile, string(pEntity:Id)).
            end.

            this-object:updateFile(updateFile, failType + " " + STRING(pEntity:Id), false).
        end.
        else
            // no failures or errors mean success
            this-object:updateFile(updateFile, "TEST_END " + STRING(pEntity:Id) + " " + STRING(pEntity:timeTaken), false).
    end method.

    /*------------------------------------------------------------------------------
        Runs a TestEntity and aggregates results

        @param  TestEntity The entity being run (class/method/suite/root)
        @param  character The ABLUnit output file (not results.xml)
        @return TestTypeResult  The aggregate result for this test entity
    ------------------------------------------------------------------------------*/
    method public TestTypeResult runtests ( input testEntity  as TestEntity,
                                            input pUpdateFile as character ):
        define variable children       as Array           no-undo.
        define variable childrenSize   as integer         no-undo.
        define variable j              as integer         no-undo.
        define variable childEntity    as TestEntity      no-undo.
        define variable startTime      as datetime        no-undo.
        define variable runnableEntity as IRunnableEntity no-undo.
        define variable tr             as TestTestResult  no-undo.

        this-object:updateFile(pUpdateFile, "TEST_START " + STRING(testEntity:Id), false).

        assign startTime = now.

        /* Suite Class, Suite Procedure, Test Class may have configured with Ignore Annotation.
           The TestRootModel is a "virtual" TestEntity, that's at the top of the graph, and doesn't actually have any
           tests itself. This method - runtest() - is called recursively so as to run All The Tests. If the root model
           has an ignored test, we continue; if there's a TestSuite/TestCase/TestProcedure/etc that has the @Ignored
           annotation, we skip running just that test/case/suite. */

        /*Start*/
        if testEntity:Summary:ignoreCount gt 0 and not type-of(testEntity, TestRootModel) then do:
            this-object:updateFile(pUpdateFile, "TEST_IGNORED " + STRING(testEntity:Id), false).
            assign testEntity:TimeTaken = 0.
            this-object:updateFile(pUpdateFile, "TEST_END " + STRING(testEntity:Id) + " " + STRING(testEntity:TimeTaken) , false).

            return testEntity:Summary.
        end.
        /*End*/

        children = testEntity:getTestEntities().
        childrenSize = testEntity:getChildrenSize().

        if type-of(testEntity, IRunnableEntity) then do:
            assign runnableEntity = cast(testEntity, IRunnableEntity).

            runnableEntity:StartEntity().

            // Update the updatefile ... but don't add to the numbers
            ProcessTestResult(testEntity, ?).

            // if there's an error we want to write TEST_EXCEPTION
            if testEntity:Summary:errorCount gt 0 or testEntity:Summary:failureCount gt 0 then
                return testEntity:Summary.
        end.

        do j = 1 to childrenSize:
            assign  childEntity = cast(children:GetValue(j), TestEntity).
            if type-of(childEntity, TestMethod) and valid-object(runnableEntity) then do:
                this-object:updateFile(pUpdateFile, "TEST_START " + STRING(childEntity:Id), false).

                runnableEntity:RunChild(childEntity).
                    // for individual tests, always add the count & process the result
                ProcessTestResult(childEntity, testEntity:Summary).
            end.
            else do:
                // suite, class, procedure
                runtests(childEntity, pUpdateFile).
                // add the counts from the children to this run
                testEntity:Summary:Add(childEntity:Summary).
            end.
        end.

        if valid-object(runnableEntity) then do:
            runnableEntity:StopEntity().

            // Don't add to the counts since we're not _actually_ running a test here ...
            ProcessTestResult(testEntity, ?).

            // if there's an error we want to write TEST_EXCEPTION
            if testEntity:Summary:errorCount gt 0 or testEntity:Summary:failureCount gt 0 then
                return testEntity:Summary.
        end.

        assign testEntity:TimeTaken = interval(now, startTime, 'milliseconds':u) / 1000.
        this-object:updateFile(pUpdateFile, "TEST_END " + STRING(testEntity:Id) + " " + STRING(testEntity:TimeTaken) , false).

        catch stoi as Progress.Lang.Stop:
            assign
                tr      = new TestTestResult(testEntity:name)
                tr:Stop = stoi
                .
            testEntity:AddTestResult(tr).
            ProcessTestResult(testEntity, testEntity:Summary).
        end catch.
        catch runErr as Progress.Lang.Error:
            assign
                tr       = new TestTestResult(testEntity:name)
                tr:Error = runErr
                .
            testEntity:AddTestResult(tr).
            ProcessTestResult(testEntity, testEntity:Summary).
        end catch.

        // always return a result, even if there was an error
        finally:
            {&_proparse_ prolint-nowarn(returnfinally)}
            return testEntity:Summary.
        end.
    end method.

    /*------------------------------------------------------------------------------
        Updates stack trace with the given error in the given file

        @param PLO
        @param character
        @param character
    ------------------------------------------------------------------------------*/
    method private void updateStackTrace ( input errorResult as Progress.Lang.Error,
                                           input pUpdateFile as character,
                                           input id          as character ):
        if not pUpdateFile = "" then
        do on error undo, throw:
            define variable stackTrace     as character no-undo.
            define variable stackTraceLine as character no-undo.
            define variable i              as integer   no-undo.
            define variable numMessages    as integer   no-undo.

            output to value(pUpdateFile) append.

            if not valid-object(errorResult) then do:
                put unformatted "STACK_TRACE " id " UNKNOWN ERROR " skip.
                return.
            end.

            stackTrace = errorResult:CallStack.
            numMessages = errorResult:NumMessages.
            do i = 1 to numMessages:
                put unformatted "STACK_TRACE " id " " errorResult:GetMessage(i) skip.
            end.

            if type-of(errorResult, AppError) then do:
                stackTraceLine = cast(errorResult, AppError):ReturnValue.
                if not stackTraceLine eq '':u then
                    put unformatted "STACK_TRACE " id " " stackTraceLine skip.
            end.

            numMessages = num-entries(stackTrace, StringConstant:LF).
            do i = 1 to numMessages:
                stackTraceLine = entry(i, stackTrace, StringConstant:LF).
                put unformatted "STACK_TRACE " id " " stackTraceLine skip.
            end.

            finally:
                output close.
            end finally.
        end.
    end method.

    /*------------------------------------------------------------------------------
        Writes a stack trace for a stop condition

        @param Progress.Lang.Stop THe stop condition
        @param character The file into which to write
        @param character The ID of the test entity
    ------------------------------------------------------------------------------*/
    method private void updateStackTrace ( input pStop       as Progress.Lang.Stop,
                                           input pUpdateFile as character,
                                           input pId         as character ):
        define variable loop      as integer   no-undo.
        define variable cnt       as integer   no-undo.
        define variable traceLine as character no-undo.

        if pUpdateFile eq '':u then return.

        output to value(pUpdateFile) append.

        if not valid-object(pStop) then do:
            put unformatted "STACK_TRACE " pId " UNKNOWN STOP CONDITION " skip.
            return.
        end.

        put unformatted "STACK_TRACE " pId " STOP CONDITION: " pStop:GetClass():TypeName skip.

        if type-of(pStop, LockConflict) then do:
            // Device
            assign traceLine = cast(pStop, LockConflict):Device.
            if not traceLine eq '':u then
                put unformatted "STACK_TRACE " pId " Device: " traceLine skip.

            // TableName
            assign traceLine = cast(pStop, LockConflict):TableName.

            if not traceLine eq '':u then
                put unformatted "STACK_TRACE " pId " TableName: " traceLine skip.

            // User
            assign traceLine = cast(pStop, LockConflict):User.

            if not traceLine eq '':u then
                put unformatted "STACK_TRACE " pId " User: " traceLine skip.
        end.

        assign cnt = num-entries(pStop:CallStack, StringConstant:LF).
        do loop = 1  to cnt:
            assign traceLine = entry(loop, pStop:CallStack, StringConstant:LF).
            put unformatted "STACK_TRACE " pId " " traceLine skip.
        end.

        finally:
            output close.
        end finally.
    end method.

    /*------------------------------------------------------------------------------
        Writes to the update file the given content.
        If override is true, the file is overwritten.

        @param character
        @param longchar
        @param logical
    ------------------------------------------------------------------------------*/
    method public void updateFile ( input pUpdateFile as character,
                                    input content     as longchar,
                                    input lOverride   as logical ):
        if not pUpdateFile eq "" then do:
            content = content + StringConstant:LF.
            if lOverride then
                copy-lob content to file pUpdateFile.
            else
                copy-lob content to file pUpdateFile  append.
        end.
    end method.

end class.
