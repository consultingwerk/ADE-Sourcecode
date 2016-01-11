##Include:[StandardHeaderComment]##

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
/* tell smart.i that we can use the default destroyObject */ 
&SCOPED-DEFINE include-destroyobject
{src/adm2/ttlookup.i}

##If:[GenerateThinRendering]##
/* ThinRendering Enabled */
&GLOBAL-DEFINE ADM-EXCLUDE-PROTOTYPES
&GLOBAL-DEFINE ADM-EXCLUDE-STATIC
&SCOPED-DEFINE exclude-start-super-proc
/* ThinRendering */
##If:End##

&scoped-define adm-prepare-static-object yes
&scoped-define adm-prepare-class-name ##[ClassName]##
##If:generateSuperInConstructor()##
&scoped-define adm-prepare-super-procedure ##[ObjectSuperProcedure]##
&scoped-define adm-prepare-super-procedure-mode ##[ObjectSuperProcedureMode]##
##If:End##

&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frLookup
&Scoped-define ADM-CONTAINER-HANDLE frame {&Frame-Name}:handle

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frLookup
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 50 BY 1.


/* *********************** Procedure Settings ************************ */
/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

/* ************************* Included-Libraries *********************** */
{src/adm2/lookup.i}

&scoped-define xp-Assign
{set ContainerType ''}
{set ObjectType 'SmartDataField'}.
&undefine xp-Assign

/* ***********  Runtime Attributes and AppBuilder Settings  *********** */
ASSIGN FRAME frLookup:SCROLLABLE       = FALSE
       FRAME frLookup:HIDDEN           = TRUE
       FRAME frLookup:SELECTABLE       = TRUE
       FRAME frLookup:MOVABLE          = TRUE
       FRAME frLookup:RESIZABLE        = TRUE
       FRAME frLookup:PRIVATE-DATA     = "nolookups".

/* ************************  Control Triggers  ************************ */
&Scoped-define SELF-NAME frLookup
ON SELECTION OF FRAME frLookup
DO:
  DEFINE VARIABLE cMode AS CHARACTER  NO-UNDO.
  
  {get UIBMode cMode}.
  IF cMode = "":U THEN /* Run Time */
    RETURN NO-APPLY.
END.

ON START-MOVE OF FRAME frLookup
DO:
  DEFINE VARIABLE cMode AS CHARACTER  NO-UNDO.
  
  {get UIBMode cMode}.
  IF cMode = "":U THEN /* Run Time */
    RETURN NO-APPLY.
END.
&UNDEFINE SELF-NAME


/* ***************************  Main Block  *************************** */


/* **********************  Internal Procedures  *********************** */
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME frLookup.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose: Override of initializeObject in order to subscribe to 
           the ChangedEvent if defined and initializeSelection      
  Parameters:  <none>
  Notes:   This is in here rather than the super procedure as when put
           in lookup.p it did not work and the target-procedure in the
           subscribed procedures was wrong.
---------------------------------------------------------------------------*/

  DEFINE VARIABLE cUIBMode              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer            AS HANDLE     NO-UNDO.

  {get ContainerSource hContainer}. /* SDV */
  {get UIBMode cUIBMode}.
  
  RUN SUPER.
  
  RUN initializeLookup IN TARGET-PROCEDURE.

  RETURN.
END PROCEDURE.

FUNCTION adm-assignObjectProperties returns logical:
 /*------------------------------------------------------------------------------ 
  Purpose:  Sets the properties for the object.
    Notes: 
  ------------------------------------------------------------------------------*/ 
    /* Assignable properties */
    &scoped-define xp-Assign
    {set LogicalObjectName '##[ObjectName]##'}
    {set ObjectTranslated ##initialObjectTranslated([ObjectName])##}
    {set ObjectSecured ##initialObjectSecured([ObjectName])##}    
	##If:generateSuperInProperty()##
	{set SuperProcedure '##[ObjectSuperProcedure]##'}
	{set SuperProcedureMode '##[ObjectSuperProcedureMode]##'} 
	##If:End##
 	##If:generateSuperInLine()##
	{set SuperProcedure ''}
	{set SuperProcedureMode ''} 
	##If:End##
	##If:generateSuperInConstructor()##
	{set SuperProcedure ''}
	{set SuperProcedureMode ''} 
	##If:End##
     
    ##Loop:ObjectProperties-Assign##
    {set ##[PropertyName]## ##[PropertyValue]##}
    ##Exclude:##
    /* Break up the assign statement every 50 properties or so,
       since they all make up one assign statement.
    */
    ##Exclude:End##
    ##Every:50##
    .
    &undefine xp-Assign
    &scoped-define xp-Assign
    ##Every:End##    
    ##Loop:End##
    .
    &undefine xp-Assign
        
    /* Keep forced 'Set' properties separate. */
    &scoped-define xp-Assign
    {set LogicalVersion '##[ObjectVersion]##'}
    {set PhysicalObjectName ##[PhysicalObjectName]##}
    {set PhysicalVersion '##[ObjectVersion]##'}    
    ##Loop:ObjectProperties-Set##
    {set ##[PropertyName]## ##[PropertyValue]##}
    ##Loop:End##
    .
    &undefine xp-Assign

    RETURN TRUE.
END FUNCTION.        /* adm-assignObjectProperties */
