//
//  String+Extensions.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 17/11/24.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
