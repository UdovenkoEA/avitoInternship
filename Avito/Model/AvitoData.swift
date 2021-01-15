//
//  AvitoData.swift
//  Avito
//
//  Created by Егор on 10.01.2021.
//

import Foundation

struct AvitoData: Codable {
    let result: Result
}

struct Result: Codable {
    let title: String
    let actionTitle: String
    let selectedActionTitle: String
    let list: [List]
}

struct List: Codable {
    let id: String
    let title: String
    let description: String?
    let price: String
    let isSelected: Bool
    let icon: Icon
}

struct Icon: Codable {
    let _52x52: String
    
    enum CodingKeys: String, CodingKey {
        case _52x52 = "52x52"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self._52x52 = try container.decode(String.self, forKey: ._52x52)
    }
}


