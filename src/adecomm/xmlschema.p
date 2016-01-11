&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2001 by Progress Software Corporation ("PSC"),       *
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
/*------------------------------------------------------------------------
    File        : xmlschema.p
    Purpose     : Import/export the XML schema

    Syntax      :

    Description :

    Updated     : 04/18/00 adams@progress.com
                    initial version
                  04/18/01 thomas.wurl@taste-consulting.de
                    corrected node order to schema, not alpha, order
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .p file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{ adecomm/xmlwidg.i }

DEFINE VARIABLE cPrefix     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSimpleType AS CHARACTER  NO-UNDO INITIAL
"binary,boolean,byte,century,date,decimal,double,ENTITY,ENTITIES,float,ID,~
IDREF,IDREFS,int,integer,language,long,month,Name,NCName,negativeInteger,~
NMTOKEN,NMTOKENS,nonNegativeInteger,nonPositiveInteger,NOTATION,~
positiveInteger,QName,recurringDate,recurringDay,recurringDuration,short,~
string,time,timeDuration,timeInstant,timePeriod,unsignedByte,unsignedInt,~
unsignedLong,unsignedShort,uriReference,year":U.
DEFINE VARIABLE gcSmartB2B  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDoc        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hNodeRef    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRoot       AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCounter    AS INTEGER    NO-UNDO. /* child counter */
DEFINE VARIABLE iLastNode   AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPCounter   AS INTEGER    NO-UNDO. /* parent counter */
DEFINE VARIABLE ix          AS INTEGER    NO-UNDO.
DEFINE VARIABLE iy          AS INTEGER    NO-UNDO.
DEFINE VARIABLE lReturn     AS LOGICAL    NO-UNDO.

DEFINE BUFFER buf_tData FOR tData.
DEFINE BUFFER buf_tNode FOR tNode.

DEFINE TEMP-TABLE tMapping
  FIELD cField  AS CHARACTER CASE-SENSITIVE
  FIELD cParent AS CHARACTER CASE-SENSITIVE
  FIELD iHits   AS INTEGER
  INDEX cField cField cParent.

&SCOPED-DEFINE DEBUG FALSE

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainer Procedure 
FUNCTION getContainer RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataType Procedure 
FUNCTION getDataType RETURNS CHARACTER
  ( INPUT pKey AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNodeHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNodeHandle Procedure 
FUNCTION getNodeHandle RETURNS HANDLE
  ( INPUT pNode AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSchemaType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSchemaType Procedure 
FUNCTION getSchemaType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainer Procedure 
FUNCTION setContainer RETURNS LOGICAL
  ( INPUT pValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPrefix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPrefix Procedure 
FUNCTION setPrefix RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trimPrefix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD trimPrefix Procedure 
FUNCTION trimPrefix RETURNS CHARACTER
  ( INPUT pValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 17.33
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN initializeObject.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addNodesRec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addNodesRec Procedure 
PROCEDURE addNodesRec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pAbstract             AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pAttributeFormDefault AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pBase                 AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pBlockValue           AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pContent              AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pDataForm             AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pDataType             AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pDataValue            AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pDefaultValue         AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pDerivedBy            AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pElement              AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pElementFormDefault   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pEquivClass           AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pFinal                AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pMapConversion        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pMapFile              AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pMapLink              AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pMapName              AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pMapObject            AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pMapParameter         AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pMapType              AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pMapUpdate            AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pMaxOccurs            AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pMinOccurs            AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pModel                AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pNameSpace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pNode                 AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pNodeName             AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pNullable             AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pOrder                AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pParentName           AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pParentNode           AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pProcessContents      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pRef                  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pSchemaLocation       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pSchemaPath           AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pTargetNamespace      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pUseValue             AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pXNodeRef             AS HANDLE     NO-UNDO.
  
  CREATE tNode.
  ASSIGN
    tNode.abstract             = pAbstract
    tNode.attributeFormDefault = pAttributeFormDefault
    tNode.base                 = pBase
    tNode.blockValue           = pBlockValue
    tNode.content              = pContent
    tNode.dataForm             = pDataForm
    tNode.dataType             = pDataType
    tNode.dataValue            = pDataValue
    tNode.defaultValue         = pDefaultValue
    tNode.derivedBy            = pDerivedBy
    tNode.element              = pElement
    tNode.elementFormDefault   = pElementFormDefault
    tNode.equivClass           = pEquivClass
    tNode.final                = pFinal
    tNode.mapConversion        = pMapConversion
    tNode.mapFile              = pMapFile
    tNode.mapLink              = pMapLink
    tNode.mapName              = pMapName
    tNode.mapUpdate            = pMapUpdate
    tNode.objectName           = pMapObject
    tNode.mapParameter         = pMapParameter
    tNode.mapType              = pMapType
    tNode.maxOccurs            = pMaxOccurs
    tNode.minOccurs            = pMinOccurs
    tNode.model                = pModel
    tNode.nameSpace            = pNameSpace
    tNode.node                 = pNode
    tNode.nodeName             = pNodeName
    tNode.nullable             = pNullable
    tNode.order                = pOrder
    tNode.parentName           = pParentName
    tNode.parentNode           = pParentNode
    tNode.processContents      = pProcessContents
    tNode.ref                  = pRef
    tNode.schemaLocation       = pSchemaLocation
    tNode.schemaPath           = pSchemaPath
    tNode.targetNamespace      = pTargetNamespace
    tNode.useValue             = pUseValue
    tNode.xNodeRef             = pXNodeRef.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteAttribute Procedure 
PROCEDURE deleteAttribute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER iNode AS INTEGER  NO-UNDO.
  
  DEFINE VARIABLE hChild  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lReturn AS LOGICAL    NO-UNDO.
  
  hChild = getNodeHandle(iNode).
  IF hChild <> ? THEN DO:
    lReturn = hChild:REMOVE-ATTRIBUTE("psc:file":U) NO-ERROR.
    lReturn = hChild:REMOVE-ATTRIBUTE("psc:link":U) NO-ERROR.
    lReturn = hChild:REMOVE-ATTRIBUTE("psc:name":U) NO-ERROR.
    lReturn = hChild:REMOVE-ATTRIBUTE("psc:object":U) NO-ERROR.
    lReturn = hChild:REMOVE-ATTRIBUTE("psc:parameter":U) NO-ERROR.
    lReturn = hChild:REMOVE-ATTRIBUTE("psc:type":U) NO-ERROR.
    lReturn = hChild:REMOVE-ATTRIBUTE("psc:update":U) NO-ERROR.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-expandNodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE expandNodes Procedure 
PROCEDURE expandNodes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       thomas.wurl@taste-consulting.de 04/18/01
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pName  AS CHARACTER  NO-UNDO. /* parent nodeName  */
  DEFINE INPUT  PARAMETER pNode  AS INTEGER    NO-UNDO. /* parent node      */
  DEFINE INPUT  PARAMETER pNType AS CHARACTER  NO-UNDO. /* parent node type */ 
  DEFINE INPUT  PARAMETER pDType AS CHARACTER  NO-UNDO. /* parent data type */
  DEFINE INPUT  PARAMETER pPath  AS CHARACTER  NO-UNDO. /* document path    */
  DEFINE INPUT  PARAMETER pRef   AS CHARACTER  NO-UNDO. /* reference        */
  
  DEFINE VARIABLE cBase     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDocPath  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hQuery    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iNode     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lReturn   AS LOGICAL    NO-UNDO.
  
  /* Procedure is called recursively, so use a buffer that is scoped to this 
     procedure. (thomas.wurl@taste-consulting.de 04/18/01) */
  DEFINE BUFFER tNode FOR tNode.

  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(BUFFER tNode:HANDLE).

  /* Sort by node number (thomas.wurl@taste-consulting.de 02/26/01) */
  cWhere = "FOR EACH tNode WHERE tNode.parentName = '":U +
           (     IF pRef <> ""  THEN pRef   /*books.xsd*/
            ELSE IF pDType = "" THEN pName  /*report.xsd*/
            ELSE                     pDType /*po.xsd*/) + "' BY tNode.node":U.
  hQuery:QUERY-PREPARE(cWhere).
  hQuery:QUERY-OPEN.

  REPEAT:
    hQuery:GET-NEXT.
    IF hQuery:QUERY-OFF-END THEN LEAVE.

    /* Update parent dataType */
    IF tNode.element = "simpleType":U THEN DO:
      FIND FIRST buf_tData WHERE buf_tData.node = pNode NO-ERROR.
      IF AVAILABLE buf_tData THEN
        buf_tData.dataType = trimPrefix(tNode.base).
    END.

    IF tNode.nodeName = "" AND tNode.ref = "" THEN NEXT.

    ASSIGN
      cDocPath = pPath + "/":U + 
                 (IF tNode.nodeName <> "" THEN tNode.nodeName ELSE tNode.ref)
      cName    = (IF CAN-DO("attributeGroup,group":U,tNode.element) THEN
                    pName ELSE tNode.nodeName)
      cType    = tNode.dataType
      iNode    = (IF CAN-DO("attributeGroup,group":U,tNode.element) THEN
                    pNode ELSE tNode.node).
    /*IF CAN-FIND(FIRST tData WHERE tData.documentPath = cDocPath) THEN NEXT.*/

    IF NOT CAN-DO("attributeGroup,group":U,tNode.element) AND 
      (tNode.nodeName <> "" OR tNode.ref <> "") THEN DO:
      CREATE tData.
      BUFFER-COPY tNode TO tData.
      ASSIGN
        tData.parentNode   = pNode
        tData.parentName   = pName
        tData.documentPath = cDocPath 
        iLastNode          = iLastNode + 1
        tData.node         = iLastNode
        iNode              = iLastNode.
     
      IF INDEX(tData.element,":":U) > 0 THEN
        tData.element      = trimPrefix(tData.element).

      IF INDEX(tData.dataType,":":U) > 0 THEN
        tData.dataType     = trimPrefix(tData.dataType).

      /* Update tData dataType based on ref attribute */
      IF tData.ref <> "" THEN DO:
        ASSIGN
          cName          = tData.ref
          tData.nodeName = cName.
        FIND FIRST buf_tNode WHERE buf_tNode.nodeName = cName NO-ERROR.
        IF AVAILABLE buf_tNode AND buf_tNode.dataType <> "" THEN
          ASSIGN
            cType          = buf_tNode.dataType
            tData.dataType = trimPrefix(cType).
      END.

      /* Update tData datatype based on type attribute */
      IF NOT CAN-DO(cSimpleType, tData.dataType) THEN DO:
        FIND FIRST buf_tNode
          WHERE buf_tNode.nodeName = tData.dataType AND
                buf_tNode.element  = "simpleType":U NO-ERROR.
        IF AVAILABLE buf_tNode AND buf_tNode.base <> "" THEN
          tData.dataType = trimPrefix(buf_tNode.base).
      END.
      
      /* Extract mapping data where this schema node is mapped to multiple 
         instance nodes */
      IF NUM-ENTRIES(tNode.mapFile) > 1 THEN
        RUN extractMapping.
    END.

    /* Drill down for more children */
    RUN expandNodes(/* name     */ cName, 
                    /* node     */ iNode, 
                    /* element  */ tNode.element,
                    /* datatype */ cType,
                    /* docpath  */ cDocPath,
                    /* ref      */ tNode.ref).
  END. /* REPEAT */
  hQuery:QUERY-CLOSE().
  DELETE OBJECT hQuery.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-extractMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extractMapping Procedure 
PROCEDURE extractMapping :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       This code uses current tNode and tData rows
------------------------------------------------------------------------------*/
  FIND FIRST tMapping WHERE 
    tMapping.cField  = tNode.nodeName AND
    tMapping.cParent = tNode.parentName NO-ERROR.
  IF NOT AVAILABLE tMapping THEN DO:
    CREATE tMapping.
    ASSIGN 
      tMapping.cField  = tNode.nodeName
      tMapping.cParent = tNode.parentName.
  END.
    
  ASSIGN
    tMapping.iHits      = tMapping.iHits + 1
    tData.mapFile       = ENTRY(tMapping.iHits, tNode.mapFile)
    tData.mapName       = ENTRY(tMapping.iHits, tNode.mapName)
    tData.objectName    = ENTRY(tMapping.iHits, tNode.objectName)
    tData.mapType       = ENTRY(tMapping.iHits, tNode.mapType).
    
  IF tNode.mapConversion <> "" THEN
    tData.mapConversion = ENTRY(tMapping.iHits, tNode.mapConversion).
    
  IF tNode.mapLink <> "" THEN
    tData.mapLink       = ENTRY(tMapping.iHits, tNode.mapLink).
    
  IF tNode.mapParameter <> 0 THEN
    tData.mapParameter  = INTEGER(ENTRY(tMapping.iHits, 
                            STRING(tNode.mapParameter))).
    
  IF tNode.mapUpdate <> "" THEN
    tData.mapUpdate     = ENTRY(tMapping.iHits, tNode.mapUpdate).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMSCChild) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMSCChild Procedure 
PROCEDURE getMSCChild :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Currently not supported.  This procedure is not complete and has
               not been maintained.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER hParent AS HANDLE    NO-UNDO. /* parent handle */
  DEFINE INPUT  PARAMETER pParent AS INTEGER   NO-UNDO. /* Parent ID     */
  DEFINE INPUT  PARAMETER cParent AS CHARACTER NO-UNDO. /* parent name   */
  DEFINE INPUT  PARAMETER cXPath  AS CHARACTER NO-UNDO. /* parent xpath  */
  
  DEFINE VARIABLE cContent      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDefaultValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cElement      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMaxOccurs    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMinOccurs    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cModel        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOrder        AS CHARACTER  NO-UNDO.
  /*DEFINE VARIABLE cRequired     AS LOGICAL    NO-UNDO.*/
  DEFINE VARIABLE ix            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iy            AS INTEGER    NO-UNDO.
  
  /* TBD: needs work (adams) */
  IF hParent:SUBTYPE <> "element":U THEN NEXT.  
    
  REPEAT ix = 1 TO hParent:NUM-CHILDREN:
    CREATE X-NODEREF hNodeRef.
    lReturn = hParent:GET-CHILD(hNodeRef, ix) NO-ERROR.
    IF NOT lReturn THEN LEAVE.  /* no child nodes */
    IF hNodeRef:SUBTYPE <> "element":U THEN NEXT.
    RELEASE tNode.
    
    ASSIGN
      cContent      = ""
      cDataType     = ""
      cDataValue    = ""
      cDefaultValue = ""
      cElement      = hNodeRef:name
      cMaxOccurs    = ""
      cMinOccurs    = ""
      cModel        = ""
      cOrder        = ""
      /*cRequired     = ?*/
      .
    
    CASE cElement:
      WHEN "attribute":U THEN DO:
        ASSIGN
          cNodeName     = hNodeRef:GET-ATTRIBUTE("type":U).
      END.
      WHEN "attributeType":U THEN DO:
        ASSIGN
          cDefaultValue = hNodeRef:GET-ATTRIBUTE("default":U)
          cNodeName     = hNodeRef:GET-ATTRIBUTE("name":U)
          /*cRequired     = (hNodeRef:GET-ATTRIBUTE("required":U) = "yes")*/
          cDataValue    = hNodeRef:GET-ATTRIBUTE("values":U).
          NEXT.
      END.
      WHEN "element":U THEN DO:
        ASSIGN
          cMaxOccurs    = hNodeRef:GET-ATTRIBUTE("maxOccurs":U)
          cMinOccurs    = hNodeRef:GET-ATTRIBUTE("minOccurs":U)
          cNodeName     = hNodeRef:GET-ATTRIBUTE("type":U).
      END.
      WHEN "elementType":U THEN DO:
        ASSIGN
          cContent      = hNodeRef:GET-ATTRIBUTE("content":U)
          cModel        = hNodeRef:GET-ATTRIBUTE("model":U)
          cNodeName     = hNodeRef:GET-ATTRIBUTE("name":U)
          cDataType     = hNodeRef:GET-ATTRIBUTE("dt:type":U)
          cOrder        = hNodeRef:GET-ATTRIBUTE("order":U).
      END.
      OTHERWISE NEXT.
    END CASE.

    IF cNodeName <> "" THEN
      iCounter = iCounter + 1.
    
    FIND FIRST tNode WHERE tNode.nodeName = cNodeName AND
                           tNode.element  = cElement NO-ERROR.
    IF AVAILABLE tNode THEN 
      ASSIGN
        tNode.parentName = (IF (cElement = "element":U) THEN 
                             cParent ELSE tNode.parentName)
        iPCounter        = tNode.node.

    IF NOT AVAILABLE tNode OR
      CAN-DO("attribute,element", cElement) THEN DO:
      iPCounter = iCounter.

      RUN addNodesRec (/* abstract             */ "",
                       /* attributeFormDefault */ "",
                       /* base                 */ "",
                       /* blockValue           */ "",
                       /* content              */ cContent,
                       /* dataForm             */ "",
                       /* dataType             */ cDataType,
                       /* dataValue            */ cDataValue,
                       /* defaultValue         */ cDefaultValue,
                       /* derivedBy            */ "",
                       /* element              */ cElement,
                       /* elementFormDefault   */ "",
                       /* equivClass           */ "",
                       /* final                */ "",
                       /* mapConversion        */ "",
                       /* mapFile              */ "",
                       /* mapLink              */ "",
                       /* mapName              */ "",
                       /* mapObject            */ "",
                       /* mapParameter         */ ?,
                       /* mapType              */ "",
                       /* mapUpdate            */ "",
                       /* maxOccurs            */ cMaxOccurs,
                       /* minOccurs            */ cMinOccurs,
                       /* model                */ cModel,
                       /* nameSpace            */ "",
                       /* node                 */ iCounter,
                       /* nodeName             */ cNodeName,
                       /* nullable             */ "",
                       /* order                */ cOrder,
                       /* parentName           */ cParent,
                       /* parentNode           */ pParent,
                       /* processContents      */ "",
                       /* ref                  */ "",
                       /* schemaLocation       */ "",
                       /* targetNamespace      */ "",
                       /* useValue             */ "",
                       /* xNodeRef             */ hNodeRef).
    END.
      
    /* Create nodes where this child might have multiple parents */
    FIND tNode WHERE tNode.nodeName = cParent NO-ERROR.
    IF AMBIGUOUS tNode THEN DO:
      FIND FIRST tNode WHERE tNode.nodeName = cParent NO-ERROR. /* skip */
      REPEAT:
        FIND NEXT tNode WHERE tNode.nodeName = cParent NO-ERROR.
        IF NOT AVAILABLE tNode THEN LEAVE.
        
        iCounter  = iCounter + 1.

        RUN addNodesRec (/* abstract             */ "",
                         /* attributeFormDefault */ "",
                         /* base                 */ "",
                         /* blockValue           */ "",
                         /* content              */ cContent,
                         /* dataForm             */ "",
                         /* dataType             */ cDataType,
                         /* dataValue            */ cDataValue,
                         /* defaultValue         */ cDefaultValue,
                         /* derivedBy            */ "",
                         /* element              */ cElement,
                         /* elementFormDefault   */ "",
                         /* equivClass           */ "",
                         /* final                */ "",
                         /* mapConversion        */ "",
                         /* mapFile              */ "",
                         /* mapLink              */ "",
                         /* mapName              */ "",
                         /* mapObject            */ "",
                         /* mapParameter         */ ?,
                         /* mapType              */ "",
                         /* mapUpdate            */ "",
                         /* maxOccurs            */ cMaxOccurs,
                         /* minOccurs            */ cMinOccurs,
                         /* model                */ cModel,
                         /* nameSpace            */ "",
                         /* node                 */ iCounter,
                         /* nodeName             */ cNodeName,
                         /* nullable             */ "",
                         /* order                */ cOrder,
                         /* parentName           */ cParent,
                         /* parentNode           */ tNode.node,
                         /* processContents      */ "",
                         /* ref                  */ "",
                         /* schemaLocation       */ "",
                         /* targetNamespace      */ "",
                         /* useValue             */ "",
                         /* xNodeRef             */ hNodeRef).
      END.
    END.

    /* Get child nodes */
    RUN getMSCChild(hNodeRef, iPCounter, cNodeName, cXPath).    
    
  END. /* hParent:NUM-CHILDREN */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getW3CChild) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getW3CChild Procedure 
PROCEDURE getW3CChild :
/*------------------------------------------------------------------------------
  Purpose:     Parse XML Schema format elements and attribute nodes
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER hParent     AS HANDLE    NO-UNDO. /* parent handle  */
  DEFINE INPUT  PARAMETER pParent     AS INTEGER   NO-UNDO. /* parent node    */
  DEFINE INPUT  PARAMETER cParent     AS CHARACTER NO-UNDO. /* parent name    */
  DEFINE INPUT  PARAMETER pSchemaPath AS CHARACTER NO-UNDO. /* schema path    */
  
  DEFINE VARIABLE cAbstract             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttr                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeFormDefault AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBase                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBlockValue           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBlockDefault         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContent              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataForm             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataType             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataValue            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDefaultValue         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDerivedBy            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cElement              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cElementFormDefault   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEquivClass           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinal                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalDefault         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFixed                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cID                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMapConversion        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMapFile              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMapLink              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMapName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMapObject            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iMapParameter         AS INTEGER    NO-UNDO INITIAL ?.
  DEFINE VARIABLE cMapType              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMapUpdate            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMaxOccurs            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMinOccurs            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cModel                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNameSpace            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNullable             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOrder                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProcessContents      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRef                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRefer                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSchemaLocation       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargetNamespace      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUseValue             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cVersion              AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE ix                    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iy                    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE tmpcParent            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE tmpPath               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE tmppParent            AS INTEGER    NO-UNDO.
  
  IF hParent:SUBTYPE <> "element":U THEN RETURN.
    
  child-loop:
  REPEAT ix = 1 TO hParent:NUM-CHILDREN:
    CREATE X-NODEREF hNodeRef.
    
    lReturn = hParent:GET-CHILD(hNodeRef, ix) NO-ERROR.
    IF NOT lReturn THEN LEAVE.  /* no child nodes */
    IF hNodeRef:SUBTYPE <> "element":U THEN NEXT.
    RELEASE tNode.
    
    ASSIGN
      cAbstract             = ""
      cAttributeFormDefault = ""
      cBase                 = ""
      cBlockValue           = ""
      cBlockDefault         = ""
      cContent              = ""
      cDataForm             = ""
      cDataType             = ""
      cDataValue            = ""
      cDefaultValue         = ""
      cDerivedBy            = ""
      cElement              = hNodeRef:name
      cElementFormDefault   = ""
      cEquivClass           = ""
      cFinal                = ""
      cFinalDefault         = ""
      cFixed                = ""
      cID                   = ""
      cMapConversion        = ""
      cMapFile              = ""
      cMapLink              = ""
      cMapName              = ""
      cMapObject            = ""
      iMapParameter         = ?
      cMapType              = ""
      cMapUpdate            = ""
      cMaxOccurs            = ""
      cMinOccurs            = ""
      cNameSpace            = ""
      cNodeName             = ""
      cNullable             = ""
      cProcessContents      = ""
      cRef                  = ""
      cRefer                = ""
      cSchemaLocation       = ""
      cTargetNamespace      = ""
      cUseValue             = ""
      cVersion              = ""
      .
    
    CASE trimPrefix(cElement):
      WHEN "all":U THEN DO: 
        ASSIGN
          cID         = hNodeRef:GET-ATTRIBUTE("id":U)
          cMaxOccurs  = hNodeRef:GET-ATTRIBUTE("maxOccurs":U)
          cMinOccurs  = hNodeRef:GET-ATTRIBUTE("minOccurs":U).
      END.
      WHEN "annotation":U THEN NEXT. /* TBD */
      WHEN "any":U THEN DO:
        NEXT. /* TBD */
        ASSIGN
          cID              = hNodeRef:GET-ATTRIBUTE("id":U)
          cMaxOccurs       = hNodeRef:GET-ATTRIBUTE("maxOccurs":U)
          cMinOccurs       = hNodeRef:GET-ATTRIBUTE("minOccurs":U)
          cNameSpace       = hNodeRef:GET-ATTRIBUTE("nameSpace":U)
          cProcessContents = hNodeRef:GET-ATTRIBUTE("processContents":U).
      END.
      WHEN "anyAttribute":U THEN DO:
        NEXT. /* TBD */
        ASSIGN
          cID              = hNodeRef:GET-ATTRIBUTE("id":U)
          cProcessContents = hNodeRef:GET-ATTRIBUTE("processContents":U)
          cNamespace       = hNodeRef:GET-ATTRIBUTE("nameSpace":U).
      END.
      WHEN "appInfo":U THEN NEXT. /* TBD */
      WHEN "attribute":U THEN DO:
        ASSIGN
          cDataForm          = hNodeRef:GET-ATTRIBUTE("form":U)
          cDataType          = hNodeRef:GET-ATTRIBUTE("type":U)
          cDataValue         = hNodeRef:GET-ATTRIBUTE("value":U)
          cID                = hNodeRef:GET-ATTRIBUTE("id":U)
          cNodeName          = hNodeRef:GET-ATTRIBUTE("name":U)
          cRef               = hNodeRef:GET-ATTRIBUTE("ref":U)
          cUseValue          = hNodeRef:GET-ATTRIBUTE("use":U).
      END.
      WHEN "attributeGroup":U THEN DO:
        ASSIGN
          cID         = hNodeRef:GET-ATTRIBUTE("id":U)
          cNodeName   = hNodeRef:GET-ATTRIBUTE("name":U)
          cRef        = hNodeRef:GET-ATTRIBUTE("ref":U).
          
        /* Experimental 
        IF cNodeName = "" THEN
          cNodeName = cRef.
        */
      END.
      WHEN "choice":U THEN DO:
        ASSIGN
          cID         = hNodeRef:GET-ATTRIBUTE("id":U)
          cMaxOccurs  = hNodeRef:GET-ATTRIBUTE("maxOccurs":U)
          cMinOccurs  = hNodeRef:GET-ATTRIBUTE("minOccurs":U).
      END.
      WHEN "complexType":U OR 
      WHEN "type":U THEN DO: /* node with children */
        ASSIGN
          cAbstract   = hNodeRef:GET-ATTRIBUTE("abstract":U)
          cBase       = hNodeRef:GET-ATTRIBUTE("base":U)
          cBlockValue = hNodeRef:GET-ATTRIBUTE("block":U)
          cContent    = hNodeRef:GET-ATTRIBUTE("content":U)
          cDerivedBy  = hNodeRef:GET-ATTRIBUTE("derivedBy":U)
          cFinal      = hNodeRef:GET-ATTRIBUTE("final":U)
          cID         = hNodeRef:GET-ATTRIBUTE("id":U)
          cNodeName   = hNodeRef:GET-ATTRIBUTE("name":U).
      END.
      WHEN "documentation":U THEN NEXT. /* TBD */
      WHEN "element":U THEN DO: /* child node */
        ASSIGN
          cAbstract     = hNodeRef:GET-ATTRIBUTE("abstract":U)
          cBlockValue   = hNodeRef:GET-ATTRIBUTE("block":U)
          cDataForm     = hNodeRef:GET-ATTRIBUTE("form":U)
          cDataType     = hNodeRef:GET-ATTRIBUTE("type":U)
          cDefaultValue = hNodeRef:GET-ATTRIBUTE("default":U)
          cEquivClass   = hNodeRef:GET-ATTRIBUTE("equivClass":U)
          cFinal        = hNodeRef:GET-ATTRIBUTE("final":U)
          cFixed        = hNodeRef:GET-ATTRIBUTE("fixed":U)
          cID           = hNodeRef:GET-ATTRIBUTE("id":U)
          cMaxOccurs    = hNodeRef:GET-ATTRIBUTE("maxOccurs":U)
          cMinOccurs    = hNodeRef:GET-ATTRIBUTE("minOccurs":U)
          cNodeName     = hNodeRef:GET-ATTRIBUTE("name":U)
          cNullable     = hNodeRef:GET-ATTRIBUTE("nullable":U)
          cRef          = hNodeRef:GET-ATTRIBUTE("ref":U).
          
        /*IF cNodeName = "" THEN
          cNodeName = cRef.
        */
      END.
      WHEN "enumeration":U THEN NEXT. /* TBD */
      WHEN "field":U THEN NEXT. /* TBD */
      WHEN "group":U THEN DO:  
        ASSIGN
          cID        = hNodeRef:GET-ATTRIBUTE("id":U)
          cMaxOccurs = hNodeRef:GET-ATTRIBUTE("maxOccurs":U)
          cMinOccurs = hNodeRef:GET-ATTRIBUTE("minOccurs":U)
          cNodeName  = hNodeRef:GET-ATTRIBUTE("name":U)
          cRef       = hNodeRef:GET-ATTRIBUTE("ref":U).
          
        /*IF cNodeName = "" THEN
          cNodeName = cRef.
        */
      END.
      WHEN "import":U THEN DO:
        NEXT. /* TBD */
        ASSIGN
          cSchemaLocation = hNodeRef:GET-ATTRIBUTE("schemaLocation":U).
      END.
      WHEN "include":U THEN DO:
        NEXT. /* TBD */
        ASSIGN
          cNameSpace      = hNodeRef:GET-ATTRIBUTE("nameSpace":U)
          cSchemaLocation = hNodeRef:GET-ATTRIBUTE("schemaLocation":U).
      END.
      WHEN "key":U THEN DO:
        NEXT. /* TBD */
        ASSIGN
          cID       = hNodeRef:GET-ATTRIBUTE("id":U)
          cNodeName = hNodeRef:GET-ATTRIBUTE("name":U).
      END.
      WHEN "keyref":U THEN DO:
        NEXT. /* TBD */
        ASSIGN
          cID       = hNodeRef:GET-ATTRIBUTE("id":U)
          cNodeName = hNodeRef:GET-ATTRIBUTE("name":U)
          cRefer    = hNodeRef:GET-ATTRIBUTE("refer":U).
      END.
      WHEN "length":U THEN NEXT. /* TBD */
      WHEN "maxInclusive":U THEN NEXT. /* TBD */
      WHEN "maxLength":U THEN NEXT. /* TBD */
      WHEN "minInclusive":U THEN NEXT. /* TBD */
      WHEN "minLength":U THEN NEXT. /* TBD */
      WHEN "pattern":U THEN NEXT. /* TBD */
      WHEN "schema":U THEN DO:
        ASSIGN 
          cAttributeFormDefault = hNodeRef:GET-ATTRIBUTE("attributeFormDefault":U)
          cBlockDefault         = hNodeRef:GET-ATTRIBUTE("blockDefault":U)
          cElementFormDefault   = hNodeRef:GET-ATTRIBUTE("elementFormDefault":U)
          cFinalDefault         = hNodeRef:GET-ATTRIBUTE("finalDefault":U)
          cID                   = hNodeRef:GET-ATTRIBUTE("id":U)
          cTargetNamespace      = hNodeRef:GET-ATTRIBUTE("targetNamespace":U)
          cVersion              = hNodeRef:GET-ATTRIBUTE("version":U).
      END.
      WHEN "selector":U THEN NEXT. /* TBD */
      WHEN "sequence":U THEN DO: 
        ASSIGN
          cID        = hNodeRef:GET-ATTRIBUTE("id":U)
          cMaxOccurs = hNodeRef:GET-ATTRIBUTE("maxOccurs":U)
          cMinOccurs = hNodeRef:GET-ATTRIBUTE("minOccurs":U).
      END.
      WHEN "simpleType":U THEN DO:
        ASSIGN      
          cBase      = hNodeRef:GET-ATTRIBUTE("base":U)
          cDerivedBy = hNodeRef:GET-ATTRIBUTE("derivedBy":U)
          cNodeName  = hNodeRef:GET-ATTRIBUTE("name":U).
      END.
      WHEN "unique":U THEN DO:
        NEXT. /* TBD */
        ASSIGN
          cID         = hNodeRef:GET-ATTRIBUTE("id":U)
          cNodeName   = hNodeRef:GET-ATTRIBUTE("name":U).
      END.
      OTHERWISE NEXT.
    END CASE.
    
    /* Read XML Schema mapping information. */
    ASSIGN
      cMapConversion = hNodeRef:GET-ATTRIBUTE("psc:conversion")
      cMapFile       = hNodeRef:GET-ATTRIBUTE("psc:file")
      cMapLink       = hNodeRef:GET-ATTRIBUTE("psc:link")
      cMapName       = hNodeRef:GET-ATTRIBUTE("psc:name")
      cMapObject     = hNodeRef:GET-ATTRIBUTE("psc:object")
      cMapType       = hNodeRef:GET-ATTRIBUTE("psc:type")
      cMapUpdate     = hNodeRef:GET-ATTRIBUTE("psc:update")
      cElement       = trimPrefix(cElement)
      iMapParameter  = INTEGER(hNodeRef:GET-ATTRIBUTE("psc:parameter"))
      iCounter       = iCounter + 1
      iPCounter      = iCounter
      /*
      tmpPath        = (IF cNodeName = "" THEN pSchemaPath ELSE 
                          pSchemaPath + "/":U + cNodeName).
      */
      tmpPath        = pSchemaPath +
                       (     IF cRef <> ""      THEN "/":U + cRef
                        ELSE IF cNodeName <> "" THEN "/":U + cNodeName
                        ELSE "").

    RUN addNodesRec (/* abstract             */ cAbstract,
                     /* attributeFormDefault */ cAttributeFormDefault,
                     /* base                 */ cBase,
                     /* blockValue           */ cBlockValue,
                     /* content              */ cContent,
                     /* dataForm             */ cDataForm,
                     /* dataType             */ cDataType,
                     /* dataValue            */ cDataValue,
                     /* defaultValue         */ cDefaultValue,
                     /* derivedBy            */ cDerivedBy,
                     /* element              */ cElement,
                     /* elementFormDefault   */ cElementFormDefault,
                     /* equivClass           */ cequivClass,
                     /* final                */ cFinal,
                     /* mapConversion        */ cMapConversion,
                     /* mapFile              */ cMapFile,
                     /* mapLink              */ cMapLink,
                     /* mapName              */ cMapName,
                     /* mapObject            */ cMapObject,
                     /* mapParameter         */ iMapParameter,
                     /* mapType              */ cMapType,
                     /* mapUpdate            */ cMapUpdate,
                     /* maxOccurs            */ cMaxOccurs,
                     /* minOccurs            */ cMinOccurs,
                     /* model                */ cModel,
                     /* nameSpace            */ cNameSpace,
                     /* node                 */ iCounter,
                     /* nodeName             */ cNodeName,
                     /* nullable             */ cNullable,
                     /* order                */ cOrder,
                     /* parentName           */ cParent,
                     /* parentNode           */ pParent,
                     /* processContents      */ cProcessContents,
                     /* ref                  */ cRef,
                     /* schemaLocation       */ cSchemaLocation,
                     /* schemaPath           */ tmpPath,
                     /* targetNamespace      */ cTargetNamespace,
                     /* useValue             */ cUseValue,
                     /* xNodeRef             */ hNodeRef).
      
    /*IF trimPrefix(cElement) = "attribute":U THEN NEXT.*/
    
    ASSIGN
      tmpcParent = (IF cNodeName = "" THEN cParent ELSE cNodeName)
      tmppParent = (IF cNodeName = "" THEN pParent ELSE iPCounter).

    RUN getW3CChild (hNodeRef, tmppParent, tmpcParent, tmpPath).
  END. /* child-loop */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadSchema) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadSchema Procedure 
PROCEDURE loadSchema :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pXMLFile     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pDelete      AS LOGICAL    NO-UNDO. /* after load */
  DEFINE OUTPUT PARAMETER TABLE-HANDLE hNode.   /* tNode - schema structure */
  DEFINE OUTPUT PARAMETER TABLE-HANDLE hData.   /* tData - data structure */
  DEFINE OUTPUT PARAMETER TABLE-HANDLE hSchema. /* tSchema - <SCHEMA> attributes*/

  DEFINE VARIABLE iRoot   AS INTEGER    NO-UNDO. /* root node */
  DEFINE VARIABLE cFormat AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lReturn AS LOGICAL    NO-UNDO.

  RUN reset.
  
  CREATE X-DOCUMENT hDoc.
  CREATE X-NODEREF hRoot.
  
  /* Read in XML schema file without validation. */
  lReturn = hDoc:LOAD("file":U, pXMLFile, FALSE) NO-ERROR.
  IF ERROR-STATUS:ERROR OR lReturn = ? OR lReturn = FALSE THEN DO:
    RUN reset.
    RETURN ERROR ERROR-STATUS:GET-MESSAGE(1).
  END.
  
  /* Get root node. */
  lReturn = hDoc:GET-DOCUMENT-ELEMENT(hRoot) NO-ERROR.
  IF ERROR-STATUS:ERROR OR lReturn = ? OR lReturn = FALSE OR 
    (VALID-HANDLE(hRoot) AND INDEX(hRoot:NAME, "SCHEMA":U) = 0) OR
    (VALID-HANDLE(hRoot) AND hRoot:NUM-CHILDREN = 0) THEN DO:
    RUN reset.
    RETURN ERROR ERROR-STATUS:GET-MESSAGE(1).
  END.

  ASSIGN
    cFormat   = getSchemaType() /* creates <SCHEMA> attribute records */
    lReturn   = setPrefix() NO-ERROR.
  IF cFormat = ? THEN DO:
    RUN reset.
    RETURN ERROR ERROR-STATUS:GET-MESSAGE(1).
  END.
    
  /* Create root temp-table record */
  RUN addNodesRec (/* abstract             */ "",
                   /* attributeFormDefault */ "",
                   /* base                 */ "",
                   /* blockValue           */ "",
                   /* content              */ "",
                   /* dataForm             */ "",
                   /* dataType             */ "",
                   /* dataValue            */ "",
                   /* defaultValue         */ "",
                   /* derivedBy            */ "",
                   /* element              */ hRoot:name,
                   /* elementFormDefault   */ "",
                   /* equivClass           */ "",
                   /* final                */ "",
                   /* mapConversion        */ "",
                   /* mapFile              */ "",
                   /* mapLink              */ "",
                   /* mapName              */ "",
                   /* mapObject            */ "",
                   /* mapParameter         */ "",
                   /* mapType              */ "",
                   /* mapUpdate            */ "",
                   /* maxOccurs            */ "",
                   /* minOccurs            */ "",
                   /* model                */ "",
                   /* nameSpace            */ "",
                   /* node                 */ iCounter,
                   /* nodeName             */ hRoot:GET-ATTRIBUTE("name":U),
                   /* nullable             */ "",
                   /* order                */ "",
                   /* parentName           */ "",
                   /* parentNode           */ iPCounter,
                   /* processContents      */ "",
                   /* ref                  */ "",
                   /* schemaLocation       */ "",
                   /* schemaPath           */ hRoot:GET-ATTRIBUTE("name":U),
                   /* targetNamespace      */ "",
                   /* useValue             */ "",
                   /* xNodeRef             */ hRoot).

  /* Find child nodes */
  CASE cFormat:
    WHEN "msc":U THEN
      RUN getMSCChild(/* parent handle      */ hRoot, 
                      /* parent node        */ iPCounter, 
                      /* parent name        */ hRoot:GET-ATTRIBUTE("name":U),
                      /* parent schema path */ hRoot:GET-ATTRIBUTE("name":U)).
    
    WHEN "w3c":U THEN 
      RUN getW3CChild(/* parent handle      */ hRoot, 
                      /* parent node        */ iPCounter, 
                      /* parent name        */ hRoot:GET-ATTRIBUTE("name":U),
                      /* parent schema path */ hRoot:GET-ATTRIBUTE("name":U)).
  END CASE.

  /* Find root node.  Multiple root nodes are not supported. */
  FOR EACH tNode WHERE tNode.node > 0 AND tNode.parentNode = 0:
    IF trimPrefix(tNode.element) = "element" AND
      NOT CAN-DO(cSimpleType, trimPrefix(tNode.dataType)) THEN DO:
      iRoot = tNode.node.
      LEAVE.
    END.
  END.
  
  /* Seed tData, expand nodes, create data structure file from schema */
  FIND tNode WHERE tNode.node = iRoot NO-ERROR.
  IF NOT AVAILABLE tNode THEN DO:
    RUN reset.
    RETURN ERROR ERROR-STATUS:GET-MESSAGE(1).
  END.
  ELSE DO:
    CREATE tData.
    BUFFER-COPY tNode TO tData.
    FIND LAST buf_tNode.
    ASSIGN
      tData.documentPath = ("/":U + tData.nodeName)
      iLastNode          = buf_tNode.node.
  
    RUN expandNodes(/* name     */ tNode.nodeName, 
                    /* node     */ tNode.node, 
                    /* element  */ tNode.element,
                    /* datatype */ tNode.dataType,
                    /* docpath  */ tData.documentPath,
                    /* ref      */ tData.ref).
  END. 
  
  ASSIGN
    hNode   = TEMP-TABLE tNode:HANDLE
    hData   = TEMP-TABLE tData:HANDLE
    hSchema = TEMP-TABLE tSchema:HANDLE.

  /* Cleanup */
  IF pDelete THEN DO:
    DELETE OBJECT hDoc NO-ERROR.
    DELETE OBJECT hRoot NO-ERROR.
  
    /* When the object is deleted the handle may/will be reused.
       We set the 'globals' to unknown to ensure that reset doesn't
       delete the wrong objects. */
    ASSIGN
      hDoc  = ?
      hRoot = ?.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reset Procedure 
PROCEDURE reset :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DELETE OBJECT    hDoc     NO-ERROR.
  DELETE OBJECT    hRoot    NO-ERROR.
  
  EMPTY TEMP-TABLE tNode    NO-ERROR.
  EMPTY TEMP-TABLE tData    NO-ERROR.
  EMPTY TEMP-TABLE tSchema  NO-ERROR.
  EMPTY TEMP-TABLE tMapping NO-ERROR.

  ASSIGN
    hDoc      = ?
    hRoot     = ?
    iCounter  = 0
    iPCounter = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveSchema) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveSchema Procedure 
PROCEDURE saveSchema :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pSaveFile AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER TABLE FOR tData.   /* data structure */

  DEFINE VARIABLE cAttrs      AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cConversion AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExtension  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFile       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLink       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObject     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParameter  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cType       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdate     AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hAttr       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hChild      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNode       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lMultiple   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lReturn     AS LOGICAL    NO-UNDO.
  
  DEFINE BUFFER buf_data FOR tData.
  
  RUN adecomm/_setcurs.p ("WAIT":U).
  RUN adecomm/_osfext.p (pSaveFile, OUTPUT cExtension).
  
  /* Create namespace */
  hRoot:SET-ATTRIBUTE("xmlns:psc":U, 
    "urn:schemas-progress-com:data-mapping:91b").
    
  /* Update root attributes */
  IF getContainer() <> "" THEN
    hRoot:SET-ATTRIBUTE("psc:container":U, getContainer()).
  ELSE
    hRoot:REMOVE-ATTRIBUTE("psc:container":U) NO-ERROR.
    
  IF gcSmartB2B <> "" THEN
    hRoot:SET-ATTRIBUTE("psc:smartb2b":U, gcSmartB2B).
  ELSE
    hRoot:REMOVE-ATTRIBUTE("psc:smartb2b":U).
  
  /* Clear out any previously saved attributes */
  FOR EACH tNode:
    hChild  = tNode.xNodeRef.
    
    IF hChild:GET-ATTRIBUTE("psc:conversion":U) <> "" THEN
      hChild:REMOVE-ATTRIBUTE("psc:conversion":U) NO-ERROR.
      
    IF hChild:GET-ATTRIBUTE("psc:file":U) <> "" THEN
      hChild:REMOVE-ATTRIBUTE("psc:file":U) NO-ERROR.
    
    IF hChild:GET-ATTRIBUTE("psc:link":U) <> "" THEN
      hChild:REMOVE-ATTRIBUTE("psc:link":U) NO-ERROR.
    
    IF hChild:GET-ATTRIBUTE("psc:name":U) <> "" THEN
      hChild:REMOVE-ATTRIBUTE("psc:name":U) NO-ERROR.
    
    IF hChild:GET-ATTRIBUTE("psc:object":U) <> "" THEN
      hChild:REMOVE-ATTRIBUTE("psc:object":U) NO-ERROR.
    
    IF hChild:GET-ATTRIBUTE("psc:parameter":U) <> "" THEN
      hChild:REMOVE-ATTRIBUTE("psc:parameter":U) NO-ERROR.
    
    IF hChild:GET-ATTRIBUTE("psc:type":U) <> "" THEN
      hChild:REMOVE-ATTRIBUTE("psc:type":U) NO-ERROR.
    
    IF hChild:GET-ATTRIBUTE("psc:update":U) <> "" THEN
      hChild:REMOVE-ATTRIBUTE("psc:update":U) NO-ERROR.
  END.
  
  FOR EACH tNode WHERE tNode.instance > 0:
    tNode.instance = 0.
  END.
  
  /* Update all child nodes */
  FOR EACH tData, EACH tNode WHERE tNode.xNodeRef = tData.xNodeRef:
    ASSIGN
      hChild         = tData.xNodeRef
      lMultiple      = CAN-FIND(FIRST tMapping WHERE 
                         tMapping.cField  = tNode.nodeName AND
                         tMapping.cParent = tNode.parentName)
      tNode.instance = (IF lMultiple THEN tNode.instance + 1 ELSE 0).
    
    IF (tData.mapConversion <> "" OR lMultiple) THEN DO:
      ASSIGN
        cConversion = hChild:GET-ATTRIBUTE("psc:conversion":U)
        cConversion = cConversion + 
                     (IF cConversion <> "" OR (lMultiple AND tNode.instance > 1)
                        THEN ",":U ELSE "") +
                      tData.mapConversion.
      hChild:SET-ATTRIBUTE("psc:conversion":U, cConversion) NO-ERROR.
    END.
    
    IF tData.mapFile <> "" OR lMultiple THEN DO:
      ASSIGN
        cFile = hChild:GET-ATTRIBUTE("psc:file":U)
        cFile = cFile + 
               (IF cFile <> "" OR (lMultiple AND tNode.instance > 1) 
                 THEN ",":U ELSE "") + 
                tData.mapFile.
      hChild:SET-ATTRIBUTE("psc:file":U, cFile) NO-ERROR.
    END.
    
    /* not used
    IF tData.mapLink <> "" OR lMultiple THEN DO:
      ASSIGN
        cLink = hChild:GET-ATTRIBUTE("psc:link":U)
        cLink = cLink + (IF cLink = "" THEN "" ELSE ",":U) + tData.mapLink.
      hChild:SET-ATTRIBUTE("psc:link":U, cLink) NO-ERROR.
    END.
    */
    
    IF tData.mapName <> "" OR lMultiple THEN DO:
      ASSIGN
        cName = hChild:GET-ATTRIBUTE("psc:name":U)
        cName = cName + 
               (IF cName <> "" OR (lMultiple AND tNode.instance > 1) 
                  THEN ",":U ELSE "") + 
                tData.mapName.
      hChild:SET-ATTRIBUTE("psc:name":U, cName) NO-ERROR.
    END.
    
    IF tData.objectName <> "" OR lMultiple THEN DO:
      ASSIGN
        cObject = hChild:GET-ATTRIBUTE("psc:object":U)
        cObject = cObject + 
                 (IF cObject <> "" OR (lMultiple AND tNode.instance > 1)
                    THEN ",":U ELSE "") + 
                  tData.objectName.
      hChild:SET-ATTRIBUTE("psc:object":U, cObject) NO-ERROR.
    END.
    
    IF ((tData.mapParameter <> ? AND tData.mapParameter <> 0) OR lMultiple) AND 
      CAN-DO("function,procedure":U, tData.mapType) THEN DO:
      ASSIGN
        cParameter = hChild:GET-ATTRIBUTE("psc:parameter":U)
        cParameter = cParameter + 
                    (IF cParameter <> "" OR (lMultiple AND tNode.instance > 1)
                       THEN ".":U ELSE "") + 
                     STRING(tData.mapParameter).
      hChild:SET-ATTRIBUTE("psc:parameter":U, cParameter) NO-ERROR.
    END.
    
    IF tData.mapType <> "" OR lMultiple THEN DO:
      ASSIGN
        cType = hChild:GET-ATTRIBUTE("psc:type":U)
        cType = cType + 
               (IF cType <> "" OR (lMultiple AND tNode.instance > 1) 
                  THEN ",":U ELSE "") + 
                tData.mapType.
      hChild:SET-ATTRIBUTE("psc:type":U, cType) NO-ERROR.
    END.
    
    IF (tData.mapUpdate <> "" OR lMultiple) 
      AND cExtension <> ".xmp":U THEN DO:
      ASSIGN
        cUpdate = hChild:GET-ATTRIBUTE("psc:update":U)
        cUpdate = cUpdate + 
                 (IF cUpdate <> "" OR (lMultiple AND tNode.instance > 1) 
                    THEN ",":U ELSE "") + 
                  tData.mapUpdate.
      hChild:SET-ATTRIBUTE("psc:update":U, cUpdate) NO-ERROR.
    END.
  END.

  hDoc:SAVE("file":U, pSaveFile).

  RUN adecomm/_setcurs.p ("":U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSmartB2B) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSmartB2B Procedure 
PROCEDURE setSmartB2B :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER cSmartB2B AS CHARACTER  NO-UNDO.

  gcSmartB2B = cSmartB2B.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainer Procedure 
FUNCTION getContainer RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainer AS CHARACTER  NO-UNDO.
  
  FIND FIRST tSchema WHERE tSchema.attrName = "psc:container":U NO-ERROR.
  IF AVAILABLE tSchema THEN
    cContainer = tSchema.attrValue.
    
  RETURN cContainer.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataType Procedure 
FUNCTION getDataType RETURNS CHARACTER
  ( INPUT pKey AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND tData WHERE tData.node = pKey NO-ERROR.

  RETURN (IF AVAILABLE tData THEN tData.dataType ELSE "").

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNodeHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNodeHandle Procedure 
FUNCTION getNodeHandle RETURNS HANDLE
  ( INPUT pNode AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND FIRST tData WHERE tData.node = pNode NO-ERROR.
  IF AVAILABLE tData THEN
    RETURN tData.xNodeRef.
  ELSE
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSchemaType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSchemaType Procedure 
FUNCTION getSchemaType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAttrList AS CHARACTER  NO-UNDO
    INITIAL "xmlns,xmlns:xsd,targetNamespace":U.
  DEFINE VARIABLE cTypeList AS CHARACTER  NO-UNDO
    INITIAL "http://www.w3.org/1999/XMLSchema,w3c":U.

  DEFINE VARIABLE cReturn   AS CHARACTER  NO-UNDO INITIAL ?.
  DEFINE VARIABLE lFound    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE ix        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iy        AS INTEGER    NO-UNDO.
  
  EMPTY TEMP-TABLE tSchema.
  DO ix = 1 TO NUM-ENTRIES(hRoot:ATTRIBUTE-NAMES):
    CREATE tSchema.
    ASSIGN
      attrName  = ENTRY(ix, hRoot:ATTRIBUTE-NAMES)
      attrValue = hRoot:GET-ATTRIBUTE(attrName).
      
    /* Find the schema type. */
    IF NOT lFound AND CAN-DO(cAttrList, tSchema.attrName) THEN
    DO iy = 1 TO NUM-ENTRIES(cTypeList) BY 2:
      /*IF INDEX(tSchema.attrValue, ENTRY(iy, cTypeList)) > 0 THEN DO:*/
      IF tSchema.attrValue = ENTRY(iy, cTypeList) THEN DO:
        ASSIGN
          cReturn = ENTRY(iy + 1, cTypeList)
          lFound  = TRUE.
        LEAVE.
      END.
    END.
  END.
    
  RETURN cReturn.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainer Procedure 
FUNCTION setContainer RETURNS LOGICAL
  ( INPUT pValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lReturn    AS LOGICAL    NO-UNDO.
  
  FIND FIRST tSchema WHERE tSchema.attrName = "psc:container":U NO-ERROR.
  IF AVAILABLE tSchema THEN DO:
    IF pValue = "" OR pValue = ? THEN DO:
      DELETE tSchema.
      RETURN TRUE.
    END.
  END.
  ELSE IF pValue <> "" AND pValue <> ? THEN DO:
    CREATE tSchema.
    ASSIGN
      tSchema.attrName = "psc:container":U.
  END.
  IF AVAILABLE tSchema THEN
    tSchema.attrValue = pValue.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPrefix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPrefix Procedure 
FUNCTION setPrefix RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Return the prefix that is associated with the XML schema namespace.
    Notes:  
------------------------------------------------------------------------------*/

  cPrefix = (IF NUM-ENTRIES(hRoot:NAME, ":":U) = 1 THEN "" ELSE
               ENTRY(1, hRoot:NAME, ":":U)).
             
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trimPrefix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION trimPrefix Procedure 
FUNCTION trimPrefix RETURNS CHARACTER
  ( INPUT pValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN TRIM(TRIM(pValue, cPrefix), ":":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

