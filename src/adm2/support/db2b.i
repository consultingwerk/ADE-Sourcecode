/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
  FIELD destination LIKE mapping.destination FORMAT "X(50)"~
  FIELD name LIKE mapping.name FORMAT "X(20)"~
  FIELD replyreq LIKE mapping.replyreq~
  FIELD replysel LIKE mapping.replysel FORMAT "X(100)"~
  FIELD xmlschema LIKE mapping.xmlschema FORMAT "X(50)" LABEL "XML Mapping File"~
  FIELD dtdPublicId LIKE mapping.dtdPublicId~
  FIELD dtdSystemId LIKE mapping.dtdSystemId
