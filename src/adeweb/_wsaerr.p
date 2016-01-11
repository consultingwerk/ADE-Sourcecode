/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------
    File        : _wsaerr.p
    Purpose     : Return a Winsock error message

    Syntax      :
    Description :

    Author(s)   : D.M.Adams
    Created     : May 5, 1998
    Notes       :
  ----------------------------------------------------------------------*/

/* **************************  Definitions  *************************** */
 
DEFINE INPUT  PARAMETER p_errorNum AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER p_errorMsg AS CHARACTER NO-UNDO.

/* ***************************  Main Block  *************************** */

CASE p_errorNum:
  WHEN      4 THEN
    p_errorMsg = "Interrupted system call.".
  WHEN      9 THEN
    p_errorMsg = "Bad file number.".
  WHEN     13 THEN
    p_errorMsg = "Permission denied.".
  WHEN     14 THEN
    p_errorMsg = "Bad address.".
  WHEN     22 THEN
    p_errorMsg = "Invalid argument.".
  WHEN     24 THEN
    p_errorMsg = "Too many open files.".
  WHEN     35 THEN
    p_errorMsg = "Operation would block.".
  WHEN     36 THEN
    p_errorMsg = "Operation now in progress.".
  WHEN     37 THEN
    p_errorMsg = "Operation already in progress.".
  WHEN     38 THEN
    p_errorMsg = "Socket operation on non-socket.".
  WHEN     39 THEN
    p_errorMsg = "Destination address required.".
  WHEN     40 THEN
    p_errorMsg = "Message too long.".
  WHEN     41 THEN
    p_errorMsg = "Protocol wrong type for socket.".
  WHEN     42 THEN
    p_errorMsg = "Bad protocol option.".
  WHEN     43 THEN
    p_errorMsg = "Protocol not supported.".
  WHEN     44 THEN
    p_errorMsg = "Socket type not supported.".
  WHEN     45 THEN
    p_errorMsg = "Operation not supported on socket.".
  WHEN     46 THEN
    p_errorMsg = "Protocol family not supported.".
  WHEN     47 THEN
    p_errorMsg = "Address family not supported by protocol family.".
  WHEN     48 THEN
    p_errorMsg = "Address already in use.".
  WHEN     49 THEN
    p_errorMsg = "Can't assign requested address.".
  WHEN     50 THEN
    p_errorMsg = "Network is down.".
  WHEN     51 THEN
    p_errorMsg = "Network is unreachable.".
  WHEN     52 THEN
    p_errorMsg = "Net dropped connection or reset.".
  WHEN     53 THEN
    p_errorMsg = "Software caused connection abort.".
  WHEN     54 THEN
    p_errorMsg = "Connection reset by peer.".
  WHEN     55 THEN
    p_errorMsg = "No buffer space available.".
  WHEN     56 THEN
    p_errorMsg = "Socket is already connected.".
  WHEN     57 THEN
    p_errorMsg = "Socket is not connected.".
  WHEN     58 THEN
    p_errorMsg = "Can't send after socket shutdown.".
  WHEN     59 THEN
    p_errorMsg = "Too many references, can't splice.".
  WHEN     60 THEN
    p_errorMsg = "Connection timed out.".
  WHEN     61 THEN
    p_errorMsg = "Connection refused.".
  WHEN     62 THEN
    p_errorMsg = "Too many levels of symbolic links.".
  WHEN     63 THEN
    p_errorMsg = "File name too long.".
  WHEN     64 THEN
    p_errorMsg = "Host is down.".
  WHEN     65 THEN
    p_errorMsg = "No Route to Host.".
  WHEN     66 THEN
    p_errorMsg = "Directory not empty.".
  WHEN     67 THEN
    p_errorMsg = "Too many processes.".
  WHEN     68 THEN
    p_errorMsg = "Too many users.".
  WHEN     69 THEN
    p_errorMsg = "Disc Quota Exceeded.".
  WHEN     70 THEN
    p_errorMsg = "Stale NFS file handle.".
  WHEN     91 THEN
    p_errorMsg = "Network SubSystem is unavailable.".
  WHEN     92 THEN
    p_errorMsg = "WINSOCK DLL Version out of range.".
  WHEN     93 THEN
    p_errorMsg = "Successful WSASTARTUP not yet performed.".
  WHEN     71 THEN
    p_errorMsg = "Too many levels of remote in path.".
  WHEN     80 THEN
    p_errorMsg = "File Exists.".
  WHEN     87 THEN
    p_errorMsg = "Bad or Missing Parameter.".
  WHEN   1001 THEN
    p_errorMsg = "Host not found.".
  WHEN   1002 THEN
    p_errorMsg = "Non-Authoritative Host not found.".
  WHEN   1003 THEN
    p_errorMsg = "Non-Recoverable errors: FORMERR, REFUSED, NOTIMP.".
  WHEN   1004 THEN
    p_errorMsg = "Valid name, no data record of requested type *OR* No address, look for MX record.".
  WHEN  12001 THEN
    p_errorMsg = "No more handles could be generated at this time.".
  WHEN  12002 THEN
    p_errorMsg = "The request has timed out.".
  WHEN  12003 THEN
    p_errorMsg = "An extended error was returned from the server. This is typically a string or buffer containing a verbose error message. Call InternetGetLastResponseInfo to retrieve the error text.".
  WHEN  12004 THEN
    p_errorMsg = "An internal error has occurred.".
  WHEN  12005 THEN
    p_errorMsg = "The URL is invalid.".
  WHEN  12006 THEN
    p_errorMsg = "The URL scheme could not be recognized, or is not supported.".
  WHEN  12007 THEN
    p_errorMsg = "The server name could not be resolved.".
  WHEN  12008 THEN
    p_errorMsg = "The requested protocol could not be located.".
  WHEN  12009 THEN
    p_errorMsg = "A request to InternetQueryOption or InternetSetOption specified an invalid option value.".
  WHEN  12010 THEN
    p_errorMsg = "The length of an option supplied to InternetQueryOption or InternetSetOption is incorrect for the type of option specified.".
  WHEN  12011 THEN
    p_errorMsg = "The request option can not be set, only queried.".
  WHEN  12012 THEN
    p_errorMsg = "The Win32 Internet function support is being shut down or unloaded.".
  WHEN  12013 THEN
    p_errorMsg = "The request to connect and log on to an FTP server could not be completed because the supplied user name is incorrect.".
  WHEN  12014 THEN
    p_errorMsg = "The request to connect and log on to an FTP server could not be completed because the supplied password is incorrect.".
  WHEN  12015 THEN
    p_errorMsg = "The request to connect to and log on to an FTP server failed.".
  WHEN  12016 THEN
    p_errorMsg = "The requested operation is invalid.".
  WHEN  12017 THEN
    p_errorMsg = "The operation was canceled, usually because the handle on which the request was operating was closed before the operation completed.".
  WHEN  12018 THEN
    p_errorMsg = "The type of handle supplied is incorrect for this operation.".
  WHEN  12019 THEN
    p_errorMsg = "The requested operation cannot be carried out because the handle supplied is not in the correct state.".
  WHEN  12020 THEN
    p_errorMsg = "The request cannot be made via a proxy.".
  WHEN  12021 THEN
    p_errorMsg = "A required registry value could not be located.".
  WHEN  12022 THEN
    p_errorMsg = "A required registry value was located but is an incorrect type or has an invalid value.".
  WHEN  12023 THEN
    p_errorMsg = "Direct network access cannot be made at this time.".
  WHEN  12024 THEN
    p_errorMsg = "An asynchronous request could not be made because a zero context value was supplied.".
  WHEN  12025 THEN
    p_errorMsg = "An asynchronous request could not be made because a callback function has not been set.".
  WHEN  12026 THEN
    p_errorMsg = "The required operation could not be completed because one or more requests are pending.".
  WHEN  12027 THEN
    p_errorMsg = "The format of the request is invalid.".
  WHEN  12028 THEN
    p_errorMsg = "The requested item could not be located.".
  WHEN  12029 THEN
    p_errorMsg = "The attempt to connect to the server failed.".
  WHEN  12030 THEN
    p_errorMsg = "The connection with the server has been terminated.".
  WHEN  12031 THEN
    p_errorMsg = "The connection with the server has been reset.".
  WHEN  12032 THEN
    p_errorMsg = "Calls for the Win32 Internet function to redo the request.".
  WHEN  12033 THEN
    p_errorMsg = "ERROR_INTERNET_PROXY_REQUEST".
  WHEN  12034 THEN
    p_errorMsg = "ERROR_INTERNET_NEED_UI".
  WHEN  12036 THEN
    p_errorMsg = "The request failed because the handle already exists.".
  WHEN  12037 THEN
    p_errorMsg = "ERROR_INTERNET_SEC_CERT_DATE_INVALID".
  WHEN  12038 THEN
    p_errorMsg = "ERROR_INTERNET_SEC_CERT_CN_INVALID".
  WHEN  12039 THEN
    p_errorMsg = "ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR".
  WHEN  12040 THEN
    p_errorMsg = "ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR".
  WHEN  12041 THEN
    p_errorMsg = "The content is not entirely secure. Some of the content being viewed may have come from unsecured servers.".
  WHEN  12042 THEN
    p_errorMsg = "ERROR_INTERNET_CHG_POST_IS_NON_SECURE".
  WHEN  12043 THEN
    p_errorMsg = "ERROR_INTERNET_POST_IS_NON_SECURE".
  WHEN  12044 THEN
    p_errorMsg = "ERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED".
  WHEN  12045 THEN
    p_errorMsg = "ERROR_INTERNET_INVALID_CA".
  WHEN  12046 THEN
    p_errorMsg = "Client authorization is not set up on this computer.".
  WHEN  12047 THEN
    p_errorMsg = "ERROR_INTERNET_ASYNC_THREAD_FAILED".
  WHEN  12048 THEN
    p_errorMsg = "ERROR_INTERNET_REDIRECT_SCHEME_CHANGE".
  WHEN  12110 THEN
    p_errorMsg = "The FTP operation was not completed because the session was aborted.".
  WHEN  12111 THEN
    p_errorMsg = "Non-Recoverable errors: FORMERR, REFUSED, NOTIMP.".
  WHEN -10000 THEN
    p_errorMsg = "No error.".
  OTHERWISE
    p_errorMsg = "Unknown error.".
END CASE.

p_errorMsg = "WSAERROR:":U + CHR(10) + p_errorMsg + " (":U + STRING(p_errorNum) + ")":U.

IF p_ErrorNum = 1001 THEN
  p_ErrorMsg = p_ErrorMsg                              
               + CHR(10)
               + 'Check Broker URL in Preferences'.

/* _wsaerr.p - end of file */

