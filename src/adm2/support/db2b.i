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
  FIELD destination LIKE mapping.destination FORMAT "X(50)"~
  FIELD name LIKE mapping.name FORMAT "X(20)"~
  FIELD replyreq LIKE mapping.replyreq~
  FIELD replysel LIKE mapping.replysel FORMAT "X(100)"~
  FIELD xmlschema LIKE mapping.xmlschema FORMAT "X(50)" LABEL "XML Mapping File"~
  FIELD dtdPublicId LIKE mapping.dtdPublicId~
  FIELD dtdSystemId LIKE mapping.dtdSystemId
