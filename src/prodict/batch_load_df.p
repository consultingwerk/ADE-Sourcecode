/***************************************************************************
* Copyright (C) 2023 by Progress Software Corporation.                     *
* All rights reserved. Prior versions of this work may contain portions    *
* contributed by participants of Possenet.                                 *
*                                                                          *
****************************************************************************/
/*------------------------------------------------------------------------
    File        : batch_load_df.p
    Purpose     : 

    Syntax      :

    Description : Batch program to load DDM schema and/or DDM settings.

    Author(s)   : Talha Masood
    Created     : Mon Jul 24 10:08:35 IST 2023
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

DEFINE VARIABLE strFileName      AS CHARACTER NO-UNDO.

/* ********************  Preprocessor Definitions  ******************** */

/* ***************************  Main Block  *************************** */

/* Go through the Session Startup Parameter List */
IF NUM-ENTRIES(SESSION:PARAMETER) > 0 THEN 
    ASSIGN strFileName = SESSION:PARAMETER.
   
RUN prodict/load_df.p(INPUT strFileName).              

