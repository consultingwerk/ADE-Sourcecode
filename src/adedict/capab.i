/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------
File: capab.i

Description:   
   Definitions related to capabilities for various gateways.
 
Author: Laura Stern

Date Created: 06/05/92 
hutegger    94/01/27    added CAPAB_SEQ and CAPAB_MODIFY
----------------------------------------------------------------------------*/

/* Capability categories */
&global-define 	  CAPAB_TBL   	    1
&global-define 	  CAPAB_FLD   	    2
&global-define 	  CAPAB_IDX   	    3
&global-define 	  CAPAB_IDXMAX      4
&global-define 	  CAPAB_SEQ   	    5

/* Capabilities within the categories */
&global-define CAPAB_ADD     	      "a"  /* can add */

&global-define CAPAB_RENAME           "r"  /* can rename */
&global-define CAPAB_FOR_NAME         "n"  /* has foreign name */
&global-define CAPAB_CHANGE_FOR_NAME  "f"  /* can change foreign name */
&global-define CAPAB_OWNER            "o"  /* has owner name */  
&global-define CAPAB_TBL_NUMBER       "#"  /* has table number */
&global-define CAPAB_TBL_SIZE	      "s"  /* has table size */
&global-define CAPAB_CHANGE_TBL_SIZE  "z"  /* can change table size */
&global-define CAPAB_TBL_TYPE_ADD     "t"  /* can set table type on add */
&global-define CAPAB_TBL_TYPE_MOD     "m"  /* can change table type */

&global-define CAPAB_COPY	      "c"  /* can copy fields */
&global-define CAPAB_CHANGE_DATA_TYPE "t"  /* can change data type */
&global-define CAPAB_CHANGE_EXTENT    "e"  /* can change extent 
      	       	     	      	       	      (if not in index) */
&global-define CAPAB_OFFLEN_REQ       "l"  /* offset & length required */
&global-define CAPAB_DECIMALS_REQ     "d"  /* decimals required */
&global-define CAPAB_CHAR_LEN_IN_DEC  "s"  /* store character length in 
      	       	     	      	       	      _Decimals field */
&global-define CAPAB_CHANGE_MANDATORY "m"  /* can change mandatory */
&global-define CAPAB_CHANGE_CASE_SENS "v"  /* can change case sensitivity */

&global-define CAPAB_DELETE  	      "d"  /* can delete */
&global-define CAPAB_INACTIVATE       "i"  /* can inactivate index */
&global-define CAPAB_CHANGE_PRIMARY   "p"  /* can change primary index */
&global-define CAPAB_WORD_INDEX       "w"  /* word index allowed */
&global-define CAPAB_FIELD_COMP       "f"  /* index has field components 
      	       	     	      	       	      (not pos/offset components) */
&global-define CAPAB_CHANGE_UNIQ      "u"  /* can change uniqueness */
&global-define CAPAB_GATE_IDXNUM      "#"  /* call gateway specific routine 
      	       	     	      	       	      to get index # */
&global-define CAPAB_MODIFY           "m"  /* can modify anything beyond name */
&global-define CAPAB_SEQ_SUPPORTED    "s"  /* seq sup. on that DataServer */


