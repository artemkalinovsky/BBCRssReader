//
//  SimpleMiddleware.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/15/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import ReSwift

typealias SimpleMiddleware<State: StateType> = (Action, MiddlewareContext<State>) -> Action?

struct MiddlewareContext<State: StateType> {

    /// Closure that can be used to emit additional actions
    let dispatch: DispatchFunction
    let getState: () -> State?

    /// Closure that can be used forward your action if an async operation is performed.
    /// Just return `nil` in your middleware function in that case.
    let next: DispatchFunction

    var state: State? {
        return getState()
    }
}

/// Creates a middlewar function using SimpleMiddleware to create a ReSwift Middleware function.
func createMiddleware<State: StateType>(_ middleware: @escaping SimpleMiddleware<State>) -> ReSwift.Middleware<State> {

    return { dispatch, getState in
        return { next in
            return { action in

                let context = MiddlewareContext(dispatch: dispatch, getState: getState, next: next)
                if let newAction = middleware(action, context) {
                    next(newAction)
                }
            }
        }
    }
}
