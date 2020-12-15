//
//  File.swift
//  
//
//  Created by Simone Deriu on 15/12/2020.
//

import Vapor

struct S3ConfigurationKey: StorageKey {
    typealias Value = S3SignerAWS
}

extension Application {
    var s3: S3SignerAWS? {
        get {
            self.storage[S3ConfigurationKey.self]
        }
        set {
            self.storage[S3ConfigurationKey.self] = newValue
        }
    }
}
