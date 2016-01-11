/* rmseqrvdata.p
   Removes the sequence record versioning data from the repository */

DISABLE TRIGGERS FOR LOAD OF gst_record_version.
DISABLE TRIGGERS FOR LOAD OF gst_release_version.
FOR EACH gst_record_version 
    WHERE gst_record_version.entity_mnemonic = "GSCSQ":
    FOR EACH gst_release_version
        WHERE gst_release_version.record_version_obj = gst_record_version.record_version_obj:
        DELETE gst_release_version.
    END.
    DELETE gst_record_version.
END.

