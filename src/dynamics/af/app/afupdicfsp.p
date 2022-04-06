&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "CreateWizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? af/sup/afwizdeltp.p */
/* New Program Wizard
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*---------------------------------------------------------------------------------
  File: afupdicfsp.p

  Description:  Deployment Automation: UpdateDCU

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/08/2006  Author:     pjudge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afupdicfsp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

/* Defines Setups dataset and contained temp-tables (UpdateDCU) */
{af/app/afdcusetds.i}

define variable ghDeploymentHelper         as handle                no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* Start the Deployment helper procedure. We need it  */
run startProcedure in target-procedure ("ONCE|af/app/afdeplyhlp.p":U, output ghDeploymentHelper).
if not valid-handle(ghDeploymentHelper) then
    return error 'Unable to start Deployment Helper procedure (af/app/afdeplyhlp.p)'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */


&IF DEFINED(EXCLUDE-writeSetupXML) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeSetupXML Procedure
PROCEDURE writeSetupXML :
/*------------------------------------------------------------------------------
  Purpose:     Writes the Setup dataset to an XML file on disk
  Parameters:  (I) pcSetupTypeFile
               (I) pcEncoding
               (I) dataset Setups
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcSetupTypeFile        as character            no-undo.
    define input parameter pcEncoding             as character            no-undo.    
    define input parameter dataset for Setups.

    define variable cLong                as longchar                      no-undo.
    define variable cDirectory           as character                     no-undo.
    define variable iErrorNum            as integer                       no-undo.
        
    pcSetupTypeFile = replace(pcSetupTypeFile, '~\':u, '/':u).
    cDirectory = pcSetupTypeFile.
    entry(num-entries(cDirectory, '/':u), cDirectory, '/':u) = '':u.    
    cDirectory = right-trim(cDirectory, '/':u).
    
    iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                                 cDirectory,
                                 No,    /* empty directory */
                                 Yes    /*create missing */ ).
    if iErrorNum gt 0 then
        return error 'Error initializing directory for ' + pcSetupTypeFile.
    
    /* UTF-8 makes a good default for XML */
    if pcEncoding eq ? or pcEncoding eq '':u then
        pcEncoding = 'utf-8':u.
    
    dataset Setups:write-xml('longchar', cLong,
                             Yes,     /* formatted */
                             pcEncoding,     /* encoding */
                             ?,     /* schema location */
                             No,     /* write-xmlschema */
                             ?,     /* min-xmlschema */
                             ?      /*write-before-image */ ) no-error.
    if error-status:error then
        return error error-status:get-message(1).
    
    cLong = replace(cLong, '<ttDatabs>':u, '<Database>':u).             
    cLong = replace(cLong, '</ttDatabs>':u, '</Database>':u).
    cLong = replace(cLong, '<ttDatabs/>':u, '<Database/>':u).        
    
    /* The Page and Patch nodes have attributes so we skip the closing angle bracket */
    cLong = replace(cLong, '<ttPg ':u, '<Page ':u).
    cLong = replace(cLong, '</ttPg>':u, '</Page>':u).
    cLong = replace(cLong, '<ttPg/>':u, '<Page/>':u).        

    cLong = replace(cLong, '<ttMessg>':u, '<Message>':u).             
    cLong = replace(cLong, '</ttMessg>':u, '</Message>':u).
    cLong = replace(cLong, '<ttMessg/>':u, '</Message/>':u).
            
    cLong = replace(cLong, '<ttCntrl>':u, '<Control>':u).             
    cLong = replace(cLong, '</ttCntrl>':u, '</Control>':u).
    cLong = replace(cLong, '<ttCntrl/>':u, '<Control/>':u). 
        
    cLong = replace(cLong, '<CLabl>':u, '<Label>':u).
    cLong = replace(cLong, '</CLabl>':u, '</Label>':u).
    cLong = replace(cLong, '<CLabl/>':u, '<Label/>':u).
        
    cLong = replace(cLong, '<ttPch ':u, '<Patch ':u).
    cLong = replace(cLong, '</ttPch>':u, '</Patch>':u).
    cLong = replace(cLong, '<ttPch/>':u, '<Patch/>':u).
            
    cLong = replace(cLong, '<PgTtl>':u, '<Title>':u).
    cLong = replace(cLong, '</PgTtl>':u, '</Title>':u).
    cLong = replace(cLong, '<PgTtl/>':u, '<Title/>':u).
            
    cLong = replace(cLong, '<PgGrp>':u, '<Group>':u).
    cLong = replace(cLong, '</PgGrp>':u, '</Group>':u).
    cLong = replace(cLong, '<PgGrp/>':u, '<Group/>':u).

    cLong = replace(cLong, '<DbNaam>':u, '<DbName>':u).
    cLong = replace(cLong, '</DbNaam>':u, '</DbName>':u).
    cLong = replace(cLong, '<DbNaam/>':u, '<DbName/>':u).
            
    /* Write the XML out to disk */
    copy-lob from cLong to file pcSetupTypeFile no-error.
    if error-status:error then
        return error error-status:get-message(1).
    
    error-status:error = no.
    return.
END PROCEDURE.    /* writeSetupXML */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-readSetupXML) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readSetupXML Procedure
PROCEDURE readSetupXML :
/*------------------------------------------------------------------------------
  Purpose:    Loads the setup XML file for UpdateDCU
  Parameters: (I) pcSetupFile
  			  (O) Dataset Setups
  Notes:      - We need to do some finagling because of temp-table naming issues.
------------------------------------------------------------------------------*/
    define input  parameter pcSetupFile            as character            no-undo.
    define output parameter dataset for Setups.
    
    define variable cLong                as longchar                       no-undo.
    
    pcSetupFile = search(pcSetupFile).
    if pcSetupFile eq ? then
        return error {aferrortxt.i 'AF' '5' '?' '?' '"setup XML file"'}.
        
    copy-lob from file pcSetupFile to cLong no-error.
    if error-status:error then
        return error error-status:get-message(1).
            
    cLong = replace(cLong, '<Database>':u, '<ttDatabs>':u).             
    cLong = replace(cLong, '</Database>':u, '</ttDatabs>':u).
    
    /* The Page and Patch nodes have attributes so we skip the closing angle bracket */
    cLong = replace(cLong, '<Page ':u, '<ttPg ':u).
    cLong = replace(cLong, '</Page>':u, '</ttPg>':u).    
    cLong = replace(cLong, '<Page/':u, '<ttPg/>':u).
            
    cLong = replace(cLong, '<Message>':u, '<ttMessg>':u).
    cLong = replace(cLong, '</Message>':u, '</ttMessg>':u).
    cLong = replace(cLong, '<Message/>':u, '<ttMessg/>':u).
            
    cLong = replace(cLong, '<Control>':u, '<ttCntrl>':u).
    cLong = replace(cLong, '</Control>':u, '</ttCntrl>':u).
    cLong = replace(cLong, '<Control/>':u, '<ttCntrl/>':u).
            
    cLong = replace(cLong, '<Label>':u, '<CLabl>':u).
    cLong = replace(cLong, '</Label>':u, '</CLabl>':u).
    cLong = replace(cLong, '<Label/>':u, '<CLabl/>':u).
            
    cLong = replace(cLong, '<Patch ':u, '<ttPch ':u).
    cLong = replace(cLong, '</Patch>':u, '</ttPch>':u).
    cLong = replace(cLong, '<Patch/>':u, '<ttPch/>':u).
            
    cLong = replace(cLong, '<Title>':u, '<PgTtl>':u).
    cLong = replace(cLong, '</Title>':u, '</PgTtl>':u).
    cLong = replace(cLong, '<Title/>':u, '<PgTtl/>':u).
            
    cLong = replace(cLong, '<Group>':u, '<PgGrp>':u).
    cLong = replace(cLong, '</Group>':u, '</PgGrp>':u).
    cLong = replace(cLong, '<Group/>':u, '<PgGrp/>':u).
            
    cLong = replace(cLong, '<DbName>':u, '<DbNaam>':u).
    cLong = replace(cLong, '</DbName>':u, '</DbNaam>':u).
    cLong = replace(cLong, '<DbName/>':u, '<DbNaam/>':u).
        
    dataset Setups:read-xml('longchar', cLong,
                            ?,     /* read mode */
                            ?,     /* schema location */
                            ?,     /* override mapping */
                            ?,     /* field type mapping */
                            'Ignore':u         ) /*no-error */.
    if error-status:error then
        return error error-status:get-message(1).
    
    error-status:error = no.
    return.
END PROCEDURE.    /* readSetupXML */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
