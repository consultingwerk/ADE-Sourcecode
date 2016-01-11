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
/*
 *  _mnudefs.i
 *
 *    defines the tables and other variables used for the menu and
 *    tool bar subsystem
 */

define {1} shared temp-table mnuFeatures

    field appId             as character
    field featureId         as character
    field functionId        as character
    field args              as character
    field prvData           as character
    field defaultLabel      as character
    field defaultUpIcon     as character
    field defaultDownIcon   as character
    field defaultInsIcon    as character
    field microHelp         as character
    field userDefined       as logical
    field type              as character
    field state             as character
    field securityList      as character
    field secure            as logical

    index featuresDex is unique appId featureId.

define {1} shared temp-table mnuItems

    field appId         as character
    field featureId     as character
    field parentId      as character
    field labl          as character
    field type		as character
    field userDefined   as logical
    field handle        as widget
    field prvData       as character
    field origParent    as character
    field state         as character
    field sNum          as integer

    index seqDex is unique appId sNum
.

define {1} shared temp-table mnuMenu

    field appId         as character
    field menuId        as character
    field menuHandle    as widget
    field labl          as character
    field prvData       as character
    field sensFunction  as character
    field type          as character
    field state         as character
.

define {1} shared temp-table tbItem

    field appId         as character
    field featureId     as character
    field toolbarId     as character
    field upImage       as character
    field downImage     as character
    field insImage      as character
    field type		as character
    field userDefined   as logical
    field x             as integer
    field y             as integer
    field w             as integer
    field h             as integer
    field handle        as widget
    field prvData       as character
    field editHandle    as widget
    field state         as character
.

define {1} shared temp-table mnuApp

    field appId           as character
    field sensFunction    as character
    field secureFunction  as character
    field menuBar         as widget
    field mFeatureList    as character
    field mSensList       as character
    field mToggList       as character
    field toolbar         as widget
    field tFeatureList    as character
    field tSensList       as character
    field tToggList       as character
    field statusArea      as widget
    field sepCount        as integer
    field prvHandle       as widget
    field prvData         as character
    field displayMessages as logical
    field sNum            as integer
.

/*
 * Of the following menu types, make sure that mnuSubMenuType is
 * last alphabetically
 */

&GLOBAL-DEFINE mnuItemType     "MenuItem"
&GLOBAL-DEFINE mnuToggleType   "MenuTogg"
&GLOBAL-DEFINE mnuSepType      "MenuSeperator"
&GLOBAL-DEFINE mnuSubMenuType  "SubMenu"
&GLOBAL-DEFINE tbItemType      "TbItem"

&GLOBAL-DEFINE mnuFeatureType  "Feature"
&GLOBAL-DEFINE mnuMenuType     "Menu"

&GLOBAL-DEFINE mnuExtension    ".mnu"
&GLOBAL-DEFINE mnuVersion      "1.0"
&GLOBAL-DEFINE mnuSepFeature   "----------------"
&GLOBAL-DEFINE mnuSepHelp      "A Menu Separator"

/*
 * The icon sizes are used by toolbar calculations
 */

&GLOBAL-DEFINE mnuIconSize      25
&GLOBAL-DEFINE mnuIconOffset    1
&GLOBAL-DEFINE mnuIconY         1
&GLOBAL-DEFINE sNumOffSet       10



