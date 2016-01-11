/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* admmsgs.i -- include file with translatable ADM messages (and others
   which need to be modifiable without changing ADM source procedures). */

  DEFINE VARIABLE cADMMessages AS CHARACTER NO-UNDO EXTENT 100
    INIT [
     "You must select a single row for deletion.",                                        /*  1 */
     "Current values must be saved or cancelled before Add or Copy.",                     /*  2 */
     "",                                                                                  /*  3  see below */
      /* message 4 is no longer used by adm as commitTransaction                          
         now has yes-no-cancel and are using message 3 */                                 
     "Current values must be saved or cancelled before Commit.",                          /*  4 */
     "Query Prepare in initProps failed.",                                                /*  5 */
     "You must complete or cancel the update before leaving the current row.",            /*  6 */
     "Current record has been changed. Do you wish to save those changes?",               /*  7 */
     "Field(s) &1 have been changed by another user. Your change has been rejected.",     /*  8 */
     "Unable to locate the r-code for &1. Executing its source file.",                    /*  9 */
     "Field:  ",  /* used in showDataMessages */                                          /* 10 */
     "Table:  ",  /* used in showDataMessages */                                          /* 11 */
     "You must complete the current update operation.",                                   /* 12 */
     "You must complete the current add operation.",                                      /* 13 */
     "You must complete the current copy operation.",                                     /* 14 */
     "Update cancelled.",                                                                 /* 15 */
     "",                                                                                  /* 16 - see below */
     "",                                                                                  /* 17 - see below */
     "This database record does not exist or is locked by another user.",                 /* 18 */
     "",                                                                                  /* 19 - see below */
     "",                                                                                  /* 20 - see below */
     "exit",  /* used in okToContinue()  */                                               /* 21 */
     "continue", /* used in okToContinue()  */                                            /* 22 */
     "Attempt to delete record failed.",                                                  /* 23 */
     "",                                                                                  /* 24 */
     "The JMS broker is unavailable.",                                                    /* 25 */
     "The message could not be sent because a valid JMS session is not available.",       /* 26 */
     "The XML message could not be routed. It has no 'xmlns' attribute or DTD reference.",/* 27 */
     "The XML message could not be routed. '&1' has no matching internal reference.",     /* 28 */
     "&1 was not found with &2.",                                                         /* 29 */
     "",                                                                                  /* 30 */
     "commit",                                                                            /* 31 */       
     "",                                                                                  /* 32 */
     "The business logic procedure &1 was not found.",                                    /* 33 */ 
     "",                                                                                  /* 34 - see Below */
     "",                                                                                  /* 35 - see Below */
     "Action error: ",                                                                    /* 36 */   
     "undo",                                                                              /* 37 */
     "",                                                                                  /* 38 */
     "",                                                                                  /* 39 */
     "&1 could not find class action ~'&2~'",                                             /* 40 */
     "",                                                                                  /* 41 */
     "",                                                                                  /* 42 */
     "",                                                                                  /* 43 */
     "",                                                                                  /* 44 */
     "Query Prepare in Browser failed.",                                                  /* 45 */
     "",                                                                                  /* 46 */
     "",                                                                                  /* 47 */
     "",                                                                                  /* 48 */
     "The copy of Crystal reports dataobject &1 details failed.",                         /* 49 */
     "",                                                                                  /* 50 */
     "",                                                                                  /* 51 */
     "No data to print",                                                                  /* 52 */
     "Column name &1 not found in the SmartDataObject.",                                  /* 53 */
     "Column &1 may not be updated.",                                                     /* 54 */
     "",                                                                                  /* 55 */
     "Excel not installed or running version prior to Office 97",                         /* 56 */
     "No data to export to &1",                                                        /* 57 */
     "Function &1 called with wrong mode &2",                                             /* 58 */
     "",                                                                                  /* 59 */
     "Function &1 not defined.",                                                          /* 60 */
     "Property &1 not defined in &2",                                                     /* 61 */
     "No UpdateTarget present for Add operation.",                                        /* 62 */
     "No UpdateTarget present for Copy operation.",                                       /* 63 */
     "No UpdateTarget present for Delete operation.",                                     /* 64 */
     "No UpdateTarget present for Save operation.",                                       /* 65 */
     "",                                                                                  /* 66 */
     "Message could not be sent for the following reason:",                               /* 67 */
     "TransferRows does not support mode &1 when appending.",                             /* 68 */
     "&1 should only be called on the client half of an &2",                              /* 69 */
     "",                                                                                  /* 70 */
     "Unknown Object Name ~'&1~' passed to &1",                                           /* 71 */
     "Property &1 not defined.",                                                          /* 72 */
     "No Record Available. Table IO operations not supported on One-to-Zero relations.",  /* 73 */
     "",                                                                                  /* 74 */
     "",                                                                                  /* 75 */
     "",                                                                                  /* 76 */
     "",                                                                                  /* 77 */
     "&1: List of items is too large.",                                                   /* 78 */
     "SmartObject &1 does not support multiple &2 Sources.",                              /* 79 */
     "SmartObject &1 does not support multiple &2 Targets.",                              /* 80 */
     "Property Dialog not defined or did not execute successfully.",                      /* 81 */
     "Add/Remove flag not recognized in modify-list-attribute call.",                     /* 82 */
     "The specified node key &1 already exists. You must specify a unique node.",         /* 83 */
     "The specified parent node key &1 does not exist." ,                                 /* 84 */
     "You cannot search for a blank key value.",                                          /* 85 */
     "Unknown Data Source Specified (&1)",                                                /* 86 */
     "",                                                                                  /* 87 */
     "SmartObject &1 with Version &2 cannot be run by the {&ADM-VERSION} support code."   /* 88 */
    ].

    ASSIGN
    cADMMessages[3] = "Current values have not been saved." + CHR(10) + CHR(10) +
                      "Do you wish to save current values before you &1?"
    cADMMessages[16] = "It is necessary to commit (or undo) current changes" + CHR(10) +
                       "before trying to reposition to a record that is not" + CHR(10) +
                       "in the current batch of records."
    
    cADMMessages[17] = "It is necessary to commit (or undo) current changes" + CHR(10) +
                       "before fetching another batch of records."
    
    cADMMessages[19] = "Field(s) &1 is not available in the data object." + CHR(10) +
                       "The initialization of &2 could not be completed." + CHR(10) +
                       "You should exit or cancel."  
    
    cADMMessages[20] = "Current changes have not been committed." + CHR(10) + CHR(10) +
                       "Do you wish to commit changes before you &1?"

    cADMMessages[24] = "It is necessary to commit (or undo) current changes" + CHR(10) +
                       "before refreshing the current row."
    cADMMessages[30] = "Unknown or ambiguous buffer reference ~'&1~'. Could not add expression to query.&2"
    cADMMessages[32] = "Current values have not been saved." + CHR(10) + CHR(10) +
                       "Confirm undo of both unsaved and uncommitted changes?"
    cADMMessages[34] = "Do you wish to delete the current record?" + CHR(10)
    cADMMessages[35] = "(extracted records = &1) (max. records = &2)"
    cADMMessages[38] = "Cannot create class action ~'&1~'." + CHR(10) + "It already exists as an instance action."
    cADMMessages[39] = "Cannot create instance action ~'&1~'." + CHR(10) + "It already exists as a class action."
    cADMMessages[41] = "&1 called unbindserver with a blank input parameter." + CHR(10) + 
                       "This is currently not supported."
    cADMMessages[42] = "Not enough information to find a row in object: &1" + CHR(10) + 
                       "Ensure that there are nodes mapped to the object's KeyFields"
    cADMMessages[43] = "Could not find data source object"
    cADMMessages[44] = "Function 'storeNodeValue()' did not find data source information." +
                       "for object ~'&1~' when trying to store value for column ~'&2~'" + CHR(10) + 
                       "This should have been created in 'startDataRow()' if the object is" +
                       "properly mapped to one of the column's parent nodes in the XML Mapping."
    cADMMessages[46] = "SmartDataObject ~'&1~' is part of SmartBusinessObject ~'&2~' that has no AppServer partition defined and is "  +
                       "running locally without proper database connection(s)."
    cADMMessages[47] = "SmartDataObject has no AppServer partition defined and is "  +
                       "running locally without proper database connection(s)."
    cADMMessages[48] = "Crystal reports dataobject &1 is not set up. Please contact your system administrator."
    cADMMessages[50] = "Crystal reports landscape template &1 is not set up. Please contact your system administrator."
    .
    ASSIGN
    cADMMessages[51] = "Crystal reports portrait template &1 is not set up. Please contact your system administrator."
    cADMMessages[55] = "<not in use>"
    cADMMessages[59] = "Unable to Re-Open Query as a Folder Window is Active. Please close the Folder Window first."
    cADMMessages[66] = "No UpdateTarget present for Add/Copy operation."
    cADMMessages[70] = "SmartBusinessObject has no AppServer partition defined and is running locally without proper database connection(s)."
    cADMMessages[74] = "Unable to update column ~'&1~'."  + CHR(10) +
                       "Object ~'&2~' is either not available or not updatable"
    cADMMessages[75] = "Unable to find an appropriate data-source for object ~'&1~'" + CHR(10) +   
                       "All columns must exist in the SmartBusinessObject's contained objects."
    cADMMessages[76] = "Unable to find an appropriate data-source for object ~'&1~'" + CHR(10) +   
                       "All columns must exist in &2 the SmartBusinessObject's contained objects."
    cADMMessages[77] = "The SmartBusinessObject &1 cannot update &2 together." + 
                       " Either make sure that only fields from the SmartDataObject Update" +
                       " Target are enabled or if these objects have a one-to-one relationship and should be" +
                       " updated together, specify that the Data Target is to be updated" +
                       " from the Data Source in the SmartDataObject's Instance Properties." + CHR(10) + CHR(10) +
                       " The enabled fields and the update link will be disabled for now."
    cADMMessages[87] = "Could not launch extract program  ~'&1~' on AppServer." + CHR(10) + 
                       "Error returned from launch program: &2."
    cADMMessages[90] = "About to transfer selected data into Excel." + CHR(10) + CHR(10) +
                       "This may take a long time if the data set is large and has not been filtered." + CHR(10) +
                       "You may specify the maximum records to return for large data sets." + CHR(10)
    cADMMessages[91] = "About to transfer selected data into a Report Preview Window" + CHR(10) + CHR(10) +
                       "This may take a long time if the data set is large and has not been filtered." + CHR(10) + 
                       "You may specify the maximum records to return for large data sets." + CHR(10) + CHR(10) +
                       "NOTE : The report will only display the fields that do not exceed the maximum width of the report layout." + CHR(10)
    cADMMessages[92] = "Could not find or open file &1"
    cADMMessages[93] = "Copy of large object to column ~'&1~' failed. &2" 
    cADMMessages[94] = "Copy of large object to before image column ~'&1~' failed. &2" 
    cADMMessages[95] = "&1 does not support retrieval of large data." + CHR(10) 
                     + "Column '&2' is &3 data-type."
    cADMMessages[96] = "The newly added or changed record was successfully saved, but falls outside of the current filter criteria." + chr(10)
                     + "To be able to view this record, adjust the filter criteria."
    /* getUndoChangeCaption returns these as substitute text for the tableio UndoAction */
    cADMMessages[97] = "record" + chr(10) 
                     + "screen changes" + chr(10)
                     + "create" + chr(10)
                     + "saved changes" + chr(10)
                     + "add" + chr(10)
                     + "copy"
    cADMMessages[98] = "Fetch of '&1' definitions failed due to an unexpected error."
    cADMMessages[99] = "Fetch of '&1' data failed due to an unexpected error."
    cADMMessages[100] = "Save of '&1' data failed due to an unexpexted error." 
    .         
    /* Assigns to cADMMessages are separated in multiple groups to avoid 
       exceeding the default number of input characters: -inp 4096
       when compiling.
     */
