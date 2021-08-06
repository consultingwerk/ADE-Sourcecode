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
  FIELD profile_type_obj LIKE gsc_profile_type.profile_type_obj VALIDATE ~
  FIELD profile_type_code LIKE gsc_profile_type.profile_type_code VALIDATE ~
  FIELD profile_type_description LIKE gsc_profile_type.profile_type_description VALIDATE ~
  FIELD client_profile_type LIKE gsc_profile_type.client_profile_type VALIDATE ~
  FIELD server_profile_type LIKE gsc_profile_type.server_profile_type VALIDATE ~
  FIELD profile_type_active LIKE gsc_profile_type.profile_type_active VALIDATE 
