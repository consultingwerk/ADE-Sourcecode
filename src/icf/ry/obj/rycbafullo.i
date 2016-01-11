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
  FIELD band_name LIKE ryc_band.band_name VALIDATE ~
  FIELD band_action_sequence LIKE ryc_band_action.band_action_sequence VALIDATE ~
  FIELD action_reference LIKE ryc_action.action_reference VALIDATE ~
  FIELD action_label LIKE ryc_action.action_label VALIDATE ~
  FIELD action_obj LIKE ryc_band_action.action_obj VALIDATE ~
  FIELD band_obj LIKE ryc_band_action.band_obj VALIDATE ~
  FIELD band_action_obj LIKE ryc_band_action.band_action_obj VALIDATE 
