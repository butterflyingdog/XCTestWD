//
//  XCTestAlertViewCommand.swift
//  XCTestWebdriver
//
//  Created by zhaoy on 21/4/17.
//  Copyright © 2017 XCTestWebdriver. All rights reserved.
//

import Foundation
import Swifter
import CocoaLumberjackSwift

internal class XCTestWDContextController: Controller {
    
    //MARK: Controller - Protocol
    static func routes() -> [(RequestRoute, RoutingCall)] {
        return [(RequestRoute("/context", "get"), getContext),
                (RequestRoute("/context", "post"), setContext),
                (RequestRoute("/contexts", "get"), getContexts)]
    }
    
    static func shouldRegisterAutomatically() -> Bool {
        return false
    }
    
    //MARK: Routing Logic Specification
    internal static func getContext(request: Swifter.HttpRequest) -> Swifter.HttpResponse {
        DDLogError("\(XCTestWDDebugInfo.DebugLogPrefix) calling empty method: getContext")
        return HttpResponse.ok(.html("getContext"))
    }
    
    internal static func setContext(request: Swifter.HttpRequest) -> Swifter.HttpResponse {
        DDLogError("\(XCTestWDDebugInfo.DebugLogPrefix) calling empty method: setContext")
        return HttpResponse.ok(.html("setContext"))
    }
    
    internal static func getContexts(request: Swifter.HttpRequest) -> Swifter.HttpResponse {
        DDLogError("\(XCTestWDDebugInfo.DebugLogPrefix) calling empty method: getContexts")
        return HttpResponse.ok(.html("getContexts"))
    }
}
