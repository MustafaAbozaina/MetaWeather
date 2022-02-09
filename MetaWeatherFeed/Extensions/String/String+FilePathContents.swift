//
//  String+FilePathContents.swift
//  MetaWeatherFeed
//
//  Created by mustafa salah eldin on 2/9/22.
//

import Foundation

extension String {
    func getDataContentsFromPath() -> Data? {
            guard  let data = try? Data(contentsOf: URL(fileURLWithPath: self)) else {
                return nil
            }
        return data
    }
    
    func getContentFromPath() -> Any?{
        guard let contents = try? String(contentsOf: URL(fileURLWithPath: self)) else {
            return nil
        }
        return contents
    }
}
