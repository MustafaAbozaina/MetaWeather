//
//  String+substring.swift
//  MetaWeatherFeed
//
//  Created by mustafa salah eldin on 2/8/22.
//

import Foundation

 extension String {
    func getSubstringFromLastOccurrenceOf(character: Character) -> Substring {
        let lastIndex = self.lastIndex(of:character)
        guard let _ = lastIndex else {return ""}
        let nextIndex = self.index(after: lastIndex!)
        let substring = self[nextIndex..<self.endIndex]
        return substring
  }
}
