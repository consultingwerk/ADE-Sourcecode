DEFINE VARIABLE lProblem AS LOGICAL    NO-UNDO INITIAL YES.

trn-blk:
DO TRANSACTION ON ERROR UNDO trn-blk, LEAVE trn-blk:

    FIND ryc_attribute EXCLUSIVE-LOCK
         WHERE ryc_attribute.attribute_label = "tokenSecurity"
         NO-ERROR.

    IF NOT AVAILABLE ryc_Attribute 
    THEN DO:
        ASSIGN lProblem = NO.
        UNDO trn-blk, LEAVE trn-blk.
    END.

    FOR EACH ryc_attribute_value EXCLUSIVE-LOCK
       WHERE ryc_attribute_value.attribute_label = ryc_attribute.attribute_label:

        DELETE ryc_attribute_value NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
            UNDO trn-blk, LEAVE trn-blk.
    END.
    DELETE ryc_attribute NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
        UNDO trn-blk, LEAVE trn-blk.

    ASSIGN lProblem = NO.
END.

IF lProblem THEN
    MESSAGE "An error occured while deleting attribute 'tokenSecurity'." SKIP
            "Please delete this attribute manually from Attribute Control on the Development menu."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

