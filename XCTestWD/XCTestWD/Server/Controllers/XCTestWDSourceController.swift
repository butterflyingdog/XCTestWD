//
//  XCTestAlertViewCommand.swift
//  XCTestWebdriver
//
//  Created by zhaoy on 21/4/17.
//  Copyright © 2017 XCTestWebdriver. All rights reserved.
//

import Foundation
import Swifter
import SwiftyJSON

internal class XCTestWDSourceController: Controller {
    
    //MARK: Controller - Protocol
     static func routes() -> [(RequestRoute, RoutingCall)] {
        return [(RequestRoute("/wd/hub/session/:sessionId/source", "get"), source),
                (RequestRoute("/wd/hub/source", "get"), sourceWithoutSession),
                (RequestRoute("/wd/hub/session/:sessionId/accessibleSource", "get"), accessiblitySource),
                (RequestRoute("/wd/hub/accessibleSource", "get"), accessiblitySourceWithoutSession)]
    }
    
    static func shouldRegisterAutomatically() -> Bool {
        return false
    }
    
    //MARK: Routing Logic Specification
    internal static func source(request: Swifter.HttpRequest) -> Swifter.HttpResponse {
        let _application   = request.session?.application;
        
        if(_application?.state == XCUIApplication.State.runningForeground ) {
            let _ = _application?.query();
            _application?.resolve();
            let temp = _application?.tree();
            return XCTestWDResponse.response(session: request.session, value: JSON(JSON(temp).rawString() ?? ""))
        }
        return XCTestWDResponse.response(session: request.session, value: JSON(""));
    }
    
    internal static func sourceWithoutSession(request: Swifter.HttpRequest) -> Swifter.HttpResponse {
        let temp = XCTestWDSession.activeApplication()?.tree()
        return XCTestWDResponse.response(session: request.session, value: JSON(temp!))
    }
    
    internal static func accessiblitySource(request: Swifter.HttpRequest) -> Swifter.HttpResponse {
        let _ = request.session?.application.query()
        request.session?.application.resolve()
        let temp = request.session?.application.accessibilityTree()
        return XCTestWDResponse.response(session: request.session, value: JSON(JSON(temp!).rawString() ?? ""))
    }
    
    internal static func accessiblitySourceWithoutSession(request: Swifter.HttpRequest) -> Swifter.HttpResponse {
        let temp = XCTestWDSessionManager.singleton.checkDefaultSession().application.accessibilityTree()
        return XCTestWDResponse.response(session: request.session, value: JSON(temp!))
    }
}
