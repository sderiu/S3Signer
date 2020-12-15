//
//  File.swift
//  
//
//  Created by Simone Deriu on 15/12/2020.
//
import Vapor

extension Dictionary where Key == String, Value == String {
    
    public var vaporHeaders: HTTPHeaders {
        return HTTPHeaders.init(self.map { ($0.key, $0.value) })
    }
}
