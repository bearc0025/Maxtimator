//
//  URLUtil.swift
//  Maxtimator
//
//  Created by Bear on 5/20/24.
//

import Foundation

extension URL {
    var fileSize : Int? {
        if let attrDict = try? FileManager.default.attributesOfItem(atPath: self.path) {
            return attrDict[.size] as? Int
        }
        return 0
    }
}
