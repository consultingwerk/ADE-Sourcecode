/************************************************
Copyright (c) 2020 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IResultsWriter
    Purpose     : Interface for writing ABLUnit test results
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2020-02-05
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.ABLUnit.Model.TestEntity.

interface OpenEdge.ABLUnit.Writer.IResultsWriter:  
    /* Writes the test results to a longchar
       
       @param TestEntity The test to write (root)   
       @param longchar The XML output, with a UTF-8 codepage */
    method public longchar WriteToLongchar(input pTestEntity as TestEntity).
    
    /* Writes the test results in the xml file
       
       @param character The XML file name.
       @param TestEntity The test to write (root)   */
    method public void WriteToFile(input pXmlFileName as character,
                                   input pTestEntity as TestEntity).

end interface.