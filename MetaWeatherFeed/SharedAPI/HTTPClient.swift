//
//  HTTPClient.swift
//  MetaWeatherFeed
//
//  Created by mustafa salah eldin on 2/3/22.
//

import Foundation


public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient: AnyObject {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    @discardableResult
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
    
}
