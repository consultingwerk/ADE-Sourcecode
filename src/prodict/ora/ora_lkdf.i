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

/*--------------------------------------------------------------------

File: prodict/ora/ora_lkdf.i

Description:
    defines the link - temp-table 
    
Text-Parameters:  
    &new    "new" or "" for the shared temp-table

    
History:
    hutegger    94/09/11    creation
    
--------------------------------------------------------------------*/
/*h-*/

define {&new} shared temp-table s_ttb_link
            field name       as   character format "x(32)"
            field level      as   integer   format "z9"
            field slctd      as   logical   format "*/ "
            field srchd      as   logical   format "done/open"
            field master     as   character format "x(42)"
            field presel-n   as   character format "x(30)" initial "*"
            field presel-o   as   character format "x(30)" initial "*"
            field presel-q   as   character format "x(30)" initial "*"
            field presel-t   as   character format "x(30)" initial "*"
            field presel-v   as   logical              /*  initial no */
            index us                           srchd level master
            index uit        is unique         master name slctd
            index upi        is unique primary level master name.

define {&new} shared variable s_ldbconct    as character.
define {&new} shared variable s_level       as integer.
define {&new} shared variable s_ldbname     as character.
define {&new} shared variable s_lnkname     as character.
define {&new} shared variable s_master      as character.
define {&new} shared variable s_name-hlp    as character.
define {&new} shared variable s_owner-hlp   as character.
define {&new} shared variable s_qual-hlp    as character.
define {&new} shared variable s_type-hlp    as character.
define {&new} shared variable s_vrfy-hlp    as logical.
define {&new} shared variable s_trig-reass  as logical.

/*------------------------------------------------------------------*/

