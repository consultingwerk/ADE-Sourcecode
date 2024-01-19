/**************************************************************************
Copyright (c) 2022-2023 by Progress Software Corporation. All rights reserved.
**************************************************************************/
/*------------------------------------------------------------------------
    File        : OEManagerEndpoint
    Purpose     : Provides easy access to API endpoints for substitutions
    Description : See https://docs.progress.com/bundle/pas-for-openedge-reference/page/REST-API-Reference-for-oemanager.war.html
    Author(s)   : Dustin Grau
    Created     : Wed Oct 26 10:18:21 EDT 2022
    Notes       : All URL's should include the WebApp name (eg. oemanager/)
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

class OpenEdge.ApplicationServer.Util.OEManagerEndpoint:

    /* Agent Manager Endpoints */

    define public static property AddAgent as character no-undo init "oemanager/applications/&1/addAgent" get.
        private set.

    define public static property Agents as character no-undo init "oemanager/applications/&1/agents" get.
        private set.

    define public static property AgentSessCombined as character no-undo init "oemanager/applications/&1/agents/sessions" get.
        private set.

    define public static property AgentManagerProperties as character no-undo init "oemanager/applications/&1/agents/properties" get.
        private set.

    define public static property AgentMetrics as character no-undo init "oemanager/applications/&1/agents/&2/metrics" get.
        private set.

    define public static property AgentSessions as character no-undo init "oemanager/applications/&1/agents/&2/sessions" get.
        private set.

    define public static property AgentSession as character no-undo init "oemanager/applications/&1/agents/&2/sessions/&3?terminateOpt=&4" get.
        private set.

    define public static property AgentSessionStacks as character no-undo init "oemanager/applications/&1/agents/&2/sessions/&3/stacks" get.
        private set.

    define public static property AgentStacks as character no-undo init "oemanager/applications/&1/agents/&2/stacks" get.
        private set.

    define public static property AgentStatData as character no-undo init "oemanager/applications/&1/agents/&2/agentStatData" get.
        private set.

    define public static property AgentStop as character no-undo init "oemanager/applications/&1/agents/&2" get.
        private set.

    define public static property AgentThreads as character no-undo init "oemanager/applications/&1/agents/&2/threads" get.
        private set.

    define public static property DynamicSessionLimit as character no-undo init "oemanager/applications/&1/agents/&2/dynamicSessionLimit" get.
        private set.

    define public static property FlushDeferredLog as character no-undo init "oemanager/applications/&1/agents/&2/flushDeferredLog" get.
        private set.

    define public static property ResetDeferredLog as character no-undo init "oemanager/applications/&1/agents/&2/resetDeferredLog" get.
        private set.

    /* Session Manager Endpoints */

    define public static property Applications as character no-undo init "oemanager/applications" get.
        private set.

    define public static property ClientSessions as character no-undo init "oemanager/applications/&1/sessions" get.
        private set.

    define public static property ClientSession as character no-undo init "oemanager/applications/&1/sessions?terminateOpt=&2" get.
        private set.

    define public static property SessionManagerProperties as character no-undo init "oemanager/applications/&1/properties" get.
        private set.

    define public static property SessionMetrics as character no-undo init "oemanager/applications/&1/metrics" get.
        private set.

    /* Tomcat Manager Endpoints (This intentionally uses the "manager" webapp, not oemanager) */

    define public static property TomcatSessions as character no-undo init "manager/text/expire" get.
        private set.

end class.
