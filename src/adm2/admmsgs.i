/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/* admmsgs.i -- include file with translatable ADM messages (and others
   which need to be modifiable without changing ADM source procedures). */

  DEFINE VARIABLE cADMMessages AS CHARACTER NO-UNDO EXTENT 32
    INIT [
     "You must select a single row for deletion.",                                      /*  1 */
     "Current values must be saved or cancelled before Add or Copy.",                   /*  2 */
     "",                                                                                /*  3  see below */
      /* message 4 is no longer used by adm as commitTransaction 
         now has yes-no-cancel and are using message 3 */   
     "Current values must be saved or cancelled before Commit.",                        /*  4 */
     "Query Prepare in initProps failed.",                                              /*  5 */
     "You must complete or cancel the update before leaving the current row.",          /*  6 */
     "Current record has been changed. Do you wish to save those changes?",             /*  7 */
     "Field(s) &1 have been changed by another user. Your change has been rejected.",   /*  8 */
     "Unable to locate the r-code for &1. Executing its source file.",                  /*  9 */
     "Field:  ",  /* used in showDataMessages */                                        /* 10 */
     "Table:  ",  /* used in showDataMessages */                                        /* 11 */
     "You must complete the current update operation.",                                 /* 12 */
     "You must complete the current add operation.",                                    /* 13 */
     "You must complete the current copy operation.",                                   /* 14 */
     "Update cancelled.",                                                               /* 15 */
     "",                                                                                /* 16 - see below */
     "",                                                                                /* 17 - see below */
     "This database record does not exist or is locked by another user.",               /* 18 */
     "",                                                                                /* 19 - see below */
     "",                                                                                /* 20 - see below */
     "exit",  /* used in okToContinue()  */                                             /* 21 */
     "continue", /* used in okToContinue()  */                                          /* 22 */
     "Attempt to delete record failed.",                                                /* 23 */
     "",                                                                                /* 24 */
    "The JMS broker is unavailable.",                                                   /* 25 */
    "The message could not be sent because a valid JMS session is not available.",      /* 26 */
    "The XML message could not be routed. It has no 'xmlns' attribute or DTD reference.", /* 27 */
    "The XML message could not be routed. '&1' has no matching internal reference.",    /* 28 */
    "&1 was not found with &2.",                                                        /* 29 */
    "",                                                                                 /* 30 */
    "commit",                                                                           /* 31 */       
    ""].                                                                                /* 32 */


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
                       "Confirm undo of both unsaved and uncommitted changes?".
