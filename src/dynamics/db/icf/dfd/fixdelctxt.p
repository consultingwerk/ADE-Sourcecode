/* fixdelctxtp.p
   Deletes all context data from the repository. */
   
DISABLE TRIGGERS FOR LOAD OF gst_session.   
DISABLE TRIGGERS FOR DUMP OF gst_session.   
DISABLE TRIGGERS FOR LOAD OF gst_context_scope.   
DISABLE TRIGGERS FOR DUMP OF gst_context_scope.   
DISABLE TRIGGERS FOR LOAD OF gsm_server_context.   
DISABLE TRIGGERS FOR DUMP OF gsm_server_context.   
FOR EACH gst_session:
  DELETE gst_session.
END.
FOR EACH gst_context_scope:
  DELETE gst_context_scope.
END.
FOR EACH gsm_server_context:
  DELETE gsm_server_context.
END.
