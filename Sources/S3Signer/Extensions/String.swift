//
//  File.swift
//  
//
//  Created by Simone Deriu on 15/12/2020.
//

import Foundation
extension String{
    func convertToData() -> Data{
        return Data(self.utf8)
    }
}
