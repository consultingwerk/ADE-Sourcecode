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

------------------------------------------------------------------------


SCM Tool : RTB - Roundtable
---------------------------

  The SCM tool RTB code that required has been copied and customized 
  in the SCM directory structure.
  This will facilitate in the distribution of the customized files.
  When using the SCM tool the PROPATH needs to be altered as follows:

  PROPATH = <path>/icf ; <path>/icf/af/sup2 ; <path>/icf/scm ; <path>/rtb9xx ; <path>/dlc9xx

  A copy of the file /af/sup/afproducts.i must be created in /scm/af/sup/afproducts.i
  The scmTool pre-prosessor must then be set to the appropriate value i.e. RTB

    &glob   scmTool         RTB


------------------------------------------------------------------------

  Anthony D Swindells   11 December 2000
  Pieter J. Meyer       01 October  2001

------------------------------------------------------------------------


Modifications/Cutomisations:
----------------------------

RTB's code:

 rtb_evnt.p
     Task, workspace, and import hooks.
 rtb/adecomm/_adeevnt.p
     Auto save hooks and editor extensions and ICF extensions
 rtb/adecomm/_getfile.p
     Open file intercept hook for appbuilder
 rtb/p/rtb_open.p
     MSword and Excel hooks

 Outstanding:
 rtb/adecomm/_getobject.p
     Open object intercept hook for appbuilder


ICF code:

1) /scm/af/sup/afproducts.i
     Changed the scmTool value to be RTB
     &glob   scmTool         RTB


Previously a copy of rtb/g/rtbglobl.i were in rtb/inc as for it to be in our path.
This has been removed and all reference has been changed to point to the actual rtb code.
If the SCM tool RTB is used the roundable must be included in the propath, i.e the /rtb9xx directory
We also have in the workspace root directory a copy of rtbrun.p for launching programs
from the RTB desktop.
