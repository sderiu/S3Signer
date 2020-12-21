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
    public var s3: S3SignerAWS {
        get {
            guard let key = self.storage[S3ConfigurationKey.self] else {
                fatalError("Missing S3 Credentials!")
            }
            return key
        }
        set {
            self.storage[S3ConfigurationKey.self] = newValue
        }
    }
}
