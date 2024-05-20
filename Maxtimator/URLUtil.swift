//
//  URLUtil.swift
//  Maxtimator
//
//  Created by Bear on 5/20/24.
//

import Foundation

extension URL {
    var fileSize : UInt64? {
        if let attrDict = try? FileManager.default.attributesOfItem(atPath: self.path) {
            return attrDict[.size] as? UInt64
        }
        return 0
    }
}
