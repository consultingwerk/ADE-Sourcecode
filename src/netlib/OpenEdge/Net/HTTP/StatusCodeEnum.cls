/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : StatusCodeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 10 17:35:47 EST 2014
    Notes       : * http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.1.1
                  More definitively, http://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

enum OpenEdge.Net.HTTP.StatusCodeEnum:
    define enum         /* out-of bounds-handling */
                        None                          =  0
                        Unknown                       = -1
                            
                            /* 1xx: Informational - Request received, continuing process */
                        Continue                      = 100
                        SwitchingProtocols            = 101
                        Processing                    = 102
                        /* 103-199     Unassigned */
                            
                            /* 2xx: Success - The action was successfully received, understood, and accepted */
                        OK                            = 200
                        Created                       = 201
                        Accepted                      = 202
                        NonAuthoritativeInformation   = 203
                        NoContent                     = 204
                        ResetContent                  = 205
                        PartialContent                = 206
                        Multi-Status                  = 207
                        AlreadyReported               = 208
                        /* 209-225  Unassigned */     
                        IMUsed                        = 226
                            
                            /* 3xx: Redirection - Further action must be taken in order to complete the request */
                        MultipleChoices               = 300
                        MovedPermanently              = 301
                        Found                         = 302
                        SeeOther                      = 303
                        NotModified                   = 304
                        UseProxy                      = 305
                        /* 306 Unused */
                        TemporaryRedirect             = 307
                        PermanentRedirect             = 308
                        /* 309-399  Unassigned */
                            
                            /* 4xx: Client Error - The request contains bad syntax or cannot be fulfilled */
                        BadRequest                    = 400
                        Unauthorized                  = 401
                        PaymentRequired               = 402
                        Forbidden                     = 403
                        NotFound                      = 404
                        MethodNotAllowed              = 405
                        NotAcceptable                 = 406                                                                   
                        ProxyAuthenticationRequired   = 407
                        RequestTimeOut                = 408
                        Conflict                      = 409
                        Gone                          = 410
                        LengthRequired                = 411
                        PreconditionFailed            = 412
                        RequestEntityTooLarge         = 413
                        RequestURITooLarge            = 414
                        UnsupportedMediaType          = 415
                        RequestedRangeNotSatisfiable  = 416
                        ExpectationFailed             = 417
                        /* 418-420  Unassigned */
                        MisdirectedRequest            = 421
                        UnprocessableEntity           = 422
                        Locked                        = 423
                        FailedDependency              = 424
                        /* 425 Unassigned */
                        UpgradeRequired               = 426
                        /*427 Unassigned */
                        PreconditionRequired          = 428
                        TooManyRequests               = 429
                        /* 430 Unassigned */
                        RequestHeaderFieldsTooLarge   = 431
                        /* 432-499     Unassigned */
                        
                            
                            /* 5xx: Server Error - The server failed to fulfill an apparently valid request */
                        InternalServerError           = 500
                        NotImplemented                = 501
                        BadGateway                    = 502
                        ServiceUnavailable            = 503
                        GatewayTimeout                = 504
                        HTTPVersionNotSupported       = 505
                        VariantAlsoNegotiates         = 506
                        InsufficientStorage           = 507
                        LoopDetected                  = 508
                        /* 509 Unassigned */
                        NotExtended                   = 510
                        NetworkAuthenticationRequired = 511
                        /* 512-599     Unassigned */
                        .
end enum.
