//
//  URLUtil.swift
//  Maxtimator
//
//  Created by Bear on 5/20/24.
//

import Foundation

extension URL {
    
    /// Return the file size, in bytes, of the file at the given URL.
    ///  - Returns: Int - bytes of file or 0 if unable.
    var fileSize : Int? {
        if let attrDict = try? FileManager.default.attributesOfItem(atPath: self.path) {
            return attrDict[.size] as? Int
        }
        return 0
    }
}
