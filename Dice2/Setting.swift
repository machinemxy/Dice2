//
//  Setting.swift
//  Dice2
//
//  Created by Ma Xueyuan on 2020/06/18.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct Setting: Codable {
    static let sidesOptions = [4, 6, 8, 10, 12, 20]
    static let colors: [String: Color] = [
        "Default": .primary,
        "Red": .red,
        "Green": .green,
        "Blue": .blue,
        "Yellow": .yellow,
        "Pink": .pink,
        "Gray": .gray,
        "Orange": .orange,
        "Purple": .purple
    ]
    
    var sidesId: Int
    var dices: Int
    var color: String
    
    init() {
        if let data = UserDefaults.standard.data(forKey: Key.setting)
        {
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode(Setting.self, from: data) {
                self = decoded
                return
            }
        }
        
        sidesId = 1
        dices = 1
        color = "Default"
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(self) {
            UserDefaults.standard.set(encoded, forKey: Key.setting)
        }
    }
    
    func roll() -> Int {
        // 10 side dice is special, whose output is 0...9
        if sidesId == 3 {
            return Int.random(in: 0...9)
        } else {
            let max = Self.sidesOptions[sidesId]
            return Int.random(in: 1...max)
        }
    }
}
