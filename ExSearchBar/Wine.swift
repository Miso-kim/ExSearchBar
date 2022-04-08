//
//  Wine.swift
//  ExSearchBar
//
//  Created by misoKim on 2022/04/08.
//

import Foundation

struct Wine: Decodable {
  let name: String
  let category: Category
  
  enum Category: Decodable {
    case all
    case red
    case white
    case others
  }
}

extension Wine.Category: CaseIterable { }

extension Wine.Category: RawRepresentable {
  typealias RawValue = String
  
  init?(rawValue: RawValue) {
    switch rawValue {
    case "All": self = .all
    case "Red": self = .red
    case "White": self = .white
    case "Others": self = .others
    default: return nil
    }
  }
  
  var rawValue: RawValue {
    switch self {
    case .all: return "All"
    case .red: return "Red"
    case .white: return "White"
    case .others: return "Others"
    }
  }
}

extension Wine {
  static func wines() -> [Wine] {
    guard
      let url = Bundle.main.url(forResource: "wines", withExtension: "json"),
      let data = try? Data(contentsOf: url)
      else {
        return []
    }
    
    do {
      let decoder = JSONDecoder()
      return try decoder.decode([Wine].self, from: data)
    } catch {
      return []
    }
  }
}
