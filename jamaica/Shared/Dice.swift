//
//  Dice.swift
//  jamaica
//
//  Created by Takaya Ito on 2023/04/08.
//

import Foundation

struct Dice {
    let values: [Int]
    
    func roll() -> Int {
        let randomIndex = Int.random(in: 0..<values.count)
        return values[randomIndex]
    }
}
