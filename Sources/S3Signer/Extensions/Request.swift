//
//  File.swift
//  
//
//  Created by Simone Deriu on 15/12/2020.
//

import Vapor

extension Request {
    var s3: S3SignerAWS {
        self.application.s3!
    }
}
