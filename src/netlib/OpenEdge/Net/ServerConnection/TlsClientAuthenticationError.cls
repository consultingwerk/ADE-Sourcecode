/************************************************
Copyright (c) 2021, 2023, 2024 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : TlsClientAuthenticationError
    Purpose     : Wrapper for P.L.SysError #9318 (SSL Failure)
    Description : Created in OCTA-34843, updated in OCTA-56721
    Author(s)   : pjudge/dugrau
    Created     : 2021-03-17
    Notes       :

    This class is used to encapsulate any errors which may have been raised by
    an SSL failure, as indicated as a SysError #9318. While this was originally
    created for the TLS Client Authentication feature, the 9318 error is more
    of a catch-all to any TLS/SSL error which may be encountered by the ABL
    Sockets layer. These may be errors related to failed DNS, SSL handshakes,
    incorrect certificates or passphrases, unsupported TLS groups, or any other
    error condition related to HTTPS communications.

    The format of this error object is intended to provide an easier means of
    accessing the inner error noted by an SSL failure, and if necessary to change
    the message to a more user-friendly condition. As of TLS v1.3 multiple error
    numbers may refer to the same underlying condition so those are treated as
    a group when translated. Another reason for translation is to avoid returning
    an error message which may be directly used by a malicious user to gain
    knowledge of application security--providing generic messages for certain
    conditions will obfuscate the result but still allow a developer to trace
    back to the originating condition in the application logic.

    By default, this object will return 4 values within its error messages:
        1) The inner error code extracted from the 9318 SSL failure message
        2) The hostname from the request URI
        3) The port number from the request URI
        4) An error message either translated from the inner error code,
           or a generic message to indicate a TLS error was encountered

    Additionally, this error object will provide that same data via the
    following object properties, listed in the same order as their message
    counterparts above:

        TlsErrorNum: The inner SSL error code
        Host: Request hostname
        Port: Request port number
        TlsError: Translated or generic error message

    An ABL developer may then make use of the error messages or object properties
    as part of their business logic to assist either the user or a system admin
    to understand the reason for failure of a request.

    In cases where the new error messages are not desired, it is possible to
    revert to using the original SysError messages while still retaining the
    ability to utilize this new object's properties and error translations.

    Usage: Set a static property within the application code, either in a
           startup procedure or close to the execution of a request to the
           Http Client. This will force the order and contents of messages
           to remain consistent to the original object thrown.

    Example:
        using OpenEdge.Net.ServerConnection.TlsClientAuthenticationError.
        TlsClientAuthenticationError:ReturnOriginalMessages = true.

  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Net.ServerConnection.TlsClientAuthenticationError.
using OpenEdge.Net.URI.
using OpenEdge.Net.UriSchemeEnum.
using Progress.Lang.SysError.

class OpenEdge.Net.ServerConnection.TlsClientAuthenticationError
inherits ApplicationError
serializable:

    /**
     To allow this error object throw the original, expected error messages, set this property true.
     Example: OpenEdge.Net.ServerConnection.TlsClientAuthenticationError:ReturnOriginalMessages = true.
     */
    define public static property ReturnOriginalMessages as logical initial false no-undo get. set.

    /** Host name from the request which resulted in an SSL failure. */
    define public property Host as character no-undo initial ? get. private set.

    /** Port number of the request which resulted in an SSL failure. */
    define public property Port as integer no-undo initial ? get. private set.

    /** The SSL failure error number extracted from the SysError #9318. */
    define public property TlsErrorNum as integer no-undo initial ? get. private set.

    /** The SSL failure error number extracted from the SysError #9318. */
    define public property TlsError as character no-undo initial ? get. private set.

    /* Static constructor */
    constructor static TlsClientAuthenticationError():
        // Sets some generic messages, though the methods which return these will
        // be overriden in this class to access the instance properties extracted.
        ApplicationError:AddError(get-class(TlsClientAuthenticationError),
                                  /* short message */
                                  'TLS Client Authentication Error':u,
                                  /* error message */
                                  'TLS Client Authentication Error':u).
    end constructor.

    /* Constructor

       @param URI The host that raised the stop condition
       @param PLStop The stop condition raised */
    constructor public TlsClientAuthenticationError (input pURI as URI,
                                                     input pInnerStop as Progress.Lang.Stop):
        super(pInnerStop).

        Assert:NotNull(pURI, 'Host URI').

        if valid-object(pInnerStop) then
            AddMessage(pInnerStop:GetClass():TypeName, 1). // Report the type of Stop error encountered.

        this-object:Host = pUri:Host.
        this-object:Port = pUri:Port.
        this-object:TlsError = 'Unknown Error':u.
        this-object:TlsErrorNum = ?.
    end constructor.

    /* Constructor

       @param URI The host that raised the error condition
       @param PLError The error raised. SysError 9318 is parsed for the error code */
    constructor public TlsClientAuthenticationError (input pURI as URI,
                                                     input pInnerError as Progress.Lang.Error):
        var character cFlag.
        var integer ix.

        super(pInnerError).

        Assert:NotNull(pURI, 'Host URI'). // We MUST have a URI to parse as part of the message.

        // Set the hostname from the request URI.
        this-object:Host = pUri:Host.

        // Set the port (or a default) from the request URI.
        case true:
            when pUri:Port ne ? then
                this-object:Port = pUri:Port.
            when pUri:Scheme eq string(UriSchemeEnum:http) then
                this-object:Port = 80. // Use default for HTTP
            when pUri:Scheme eq string(UriSchemeEnum:https) then
                this-object:Port = 443. // Use default for HTTPS
        end case.

        // Only perform inspection on a valid error object if of type SysError and message number is 9318.
        if valid-object(pInnerError) and
           type-of(pInnerError, SysError) and
           pInnerError:GetMessageNum(1) eq 9318 then
        do:
            // This will extract the inner error number used to determine the expected error message.
            this-object:ParseErrorNum(pInnerError:GetMessage(1)).
        end.
        else
            this-object:TlsErrorNum = ?. // No error number available as this was not a 9318 error.

        // Set a user-friendly error based on the internal SSL error number discovered.
        case this-object:TlsErrorNum:
            // Added for TLS v1.3 (SSL Failure: SSL routines)
            when 336151538 or
            when 167773170 then
                this-object:TlsError = 'Group Authorization Failed':u.

            // Applies primarily to any client authentication (using a client-side cert).
            when 336151570 or
            when 336151574 or
            when 101077092 or
            when 151584876 or
            when -124 then
                /**
                 * Set a combined, generic message for any bad certificates or credentials.
                 * Error codes such as 478150756 (Provider Routines), 75497573 (PEM Routines),
                 * 167773202 (Bad Certificate), and 336151574 (Certificate not known) should
                 * all be handled as part of the new -124 error returned by the ABL Socket.
                 */
                this-object:TlsError = 'User Authentication Failed':u.

            otherwise do:
                // Set a generic message for TLS errors we're not sure how to deal with.
                this-object:TlsError = 'Unknown TLS Error':u.
            end.
        end case.

        // Determine the order and values for each error message contained.
        if TlsClientAuthenticationError:ReturnOriginalMessages then do:
            // Always pass-through any messages, even though the original
            // error object will be stored as the InnerError property.
            do ix = 1 to pInnerError:NumMessages:
                AddMessage(pInnerError:GetMessage(ix), ix).
            end.
        end.
        else do:
            // Output the new, expected error messages for this class.
            AddMessage(string(this-object:TlsErrorNum), 1).
            AddMessage(this-object:Host, 2).
            AddMessage(string(this-object:Port), 3).
            AddMessage(this-object:TlsError, 4).
        end.
    end constructor.

    method private void ParseErrorNum ( input pcMessage as character ):
        var integer[2] pos.

        // Parse the expected error message: "Secure Socket Layer (SSL) failure. error code <#>:  SSL routines (9318)"
        // Note the above does have an intentional double-space after the ":" character.
        if pcMessage begins "Secure Socket Layer (SSL) failure." then do:
            assign
                pos[1] = index(pcMessage, ':':u) // Look for the first ":" character in the message
                pos[2] = r-index(pcMessage, OpenEdge.Core.StringConstant:SPACE, pos[1]) // Get right-most space before that ":"
                .

            // Get the error code if we can (starting just after the " " and before the ":")
            if pos[2] + 1 lt pos[1] then
                // Set the isolated SSL failure error number to the error object property.
                this-object:TlsErrorNum = integer(trim(substring(pcMessage, pos[2] + 1, pos[1] - pos[2] - 1))).
            else
                this-object:TlsErrorNum = ?. // No error number derived from the inner error message.
        end.
        else
            this-object:TlsErrorNum = ?. // No error message provided with the expected pattern.
    end method.

    /** Returns an error message constructed from the extracted properties from the 9318 error.

        @return character Error message. */
    method public override character GetShortMessage():
        // Returns an error using the properties available, derived from the inner 9318 error.
        return substitute('TLS Client Authentication Error for &1:&2: &3 (code: &4)':u,
                          this-object:Host, this-object:Port, this-object:TlsError, this-object:TlsErrorNum).
    end method.

    /** Returns an error message constructed from the extracted properties from the 9318 error.

        @return longchar Error message. */
    method public override longchar GetErrorMessage():
        // Returns the same text as the "short" message.
        return this-object:GetShortMessage().
    end method.

end class.