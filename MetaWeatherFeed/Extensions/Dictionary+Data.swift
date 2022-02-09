//
//  Dictionary+Data.swift
//  MetaWeatherFeed
//
//  Created by mustafa salah eldin on 2/9/22.
//

import Foundation

extension Dictionary {
    func toData() -> Data?{
        guard let jsonData = try? JSONSerialization.data(
            withJSONObject: self,
            options: .prettyPrinted
        ) else {
            return nil
        }
        return jsonData
    }
}
