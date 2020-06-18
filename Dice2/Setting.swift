//
//  Setting.swift
//  Dice2
//
//  Created by Ma Xueyuan on 2020/06/18.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import Foundation

import Foundation

struct Setting: Codable {
    static let sidesOptions = [4, 6, 8, 10, 12, 20]
    
    var sidesId: Int
    var dices: Int
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "setting")
        {
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode(Setting.self, from: data) {
                self = decoded
                return
            }
        }
        
        sidesId = 1
        dices = 1
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(self) {
            UserDefaults.standard.set(encoded, forKey: "setting")
            print("saved")
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
