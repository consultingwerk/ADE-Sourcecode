/* fixprintpreviewstylesheetprop.p                                           */
/*                                                                           */
/* This procedure is meant to remove "src" from the print_preview_stylesheet */
/* session property (path) value. It must only do so if it has not been      */
/* customized, that is, if it still has its original value.                  */
/*                                                                           */
/* Jun/25/2004 - mauricio - mdsantos@progress.com                            */

FIND gsc_session_property EXCLUSIVE-LOCK 
    WHERE gsc_session_property.session_property_name = "print_preview_stylesheet" 
    NO-ERROR.

IF AVAILABLE gsc_session_property THEN DO: 

    /* fix property default value */
    IF gsc_session_property.default_property_value = "src/dynamics/af/rep/xmlreport.xsl" THEN
        gsc_session_property.default_property_value = "af/rep/xmlreport.xsl".
    
    /* fix session type property */
    FIND gsm_session_type NO-LOCK 
        WHERE gsm_session_type.session_type_code = "Dynamics"
        NO-ERROR.
    IF NOT AVAILABLE gsm_session_type THEN
        RETURN.
    FIND gsm_session_type_property EXCLUSIVE-LOCK 
        WHERE gsm_session_type_property.session_type_obj = gsm_session_type.session_type_obj
          AND gsm_session_type_property.session_property_obj = gsc_session_property.session_property_obj
         NO-ERROR.
    IF AVAILABLE gsm_session_type_property 
    AND gsm_session_type_property.property_value = "src/dynamics/af/rep/xmlreport.xsl" THEN
        gsm_session_type_property.property_value = "af/rep/xmlreport.xsl".
END.

/* end */
