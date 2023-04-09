//
//  caluculateDice.swift
//  jamaica
//
//  Created by Takaya Ito on 2023/04/08.
//

import Foundation

import SwiftUI
import Combine

class CaluculateDice: ObservableObject {
    
    @Published var timeElapsed: TimeInterval = 0
    @Published var timer: Timer? = nil
    @Published var lastDate: Date? = nil
    
    @Published var buttonTappedCount = 0
    @Published var showAlert = false
    @Published var showRule = false
    
    @Published var dice1Result = 6
    @Published var dice2Result = 60
    @Published var sum: Int = 0
    @Published var solution: String = ""
    @Published var display: String = ""
    
    @Published var dicesToFindResult: [Int] = [1,2,3,4,5,6]
    
    func rollDicesToFindResult() {
        var randomNumbers: [Int] = []
        for _ in 0..<5 {
            let randomNumber = Dice(values: [1, 2, 3, 4, 5, 6]).roll()
            randomNumbers.append(randomNumber)
        }
        self.dicesToFindResult = randomNumbers
    }

    func rollDiceResult()  {
        self.dice1Result = Dice(values: [1, 2, 3, 4, 5, 6]).roll()
        self.dice2Result = Dice(values: [10, 20, 30, 40, 50, 60]).roll()
    }
    
    func sumDemandNumber(){
        self.sum = self.dice1Result + self.dice2Result
    }
    
    func displaySolution()  {
        if self.solution == ""  { return self.display = "回答はありません" }
        self.display = "解答例: \(solution)"
    }
    func reset() {
        self.solution = ""
        self.display = ""
        rollDiceResult()
        sumDemandNumber()
        rollDicesToFindResult()
        main(input:
            dicesToFindResult.joinedAsString(separator: "")
        )
    }
    func countTappedButton() {
        buttonTappedCount += 1
        if buttonTappedCount % 5 == 0 {
            showAlert = true
        }
    }
}

extension Array where Element == Int {
    func joinedAsString(separator: String = ",") -> String {
        return self.map { String($0) }.joined(separator: separator)
    }
}

extension CaluculateDice {
    func main(input: String) {
        guard input.count == 5 else {
            print("usage: input (5 digits number)")
            return
        }

        var numbers: [NumStr] = []
        for char in input {
            let num = Double(String(char))!
            numbers.append(NumStr(num: num, str: String(char)))
        }

        solve(&numbers, 5)
    }

    struct NumStr {
        var num: Double
        var str: String
    }
    
    func solve(_ numbers: inout [NumStr], _ n: Int) {
        if n == 1 {
            if abs(numbers[0].num - Double(self.sum)) < 1e-5 {
                print("\(numbers[0].str)=\(self.sum)")
                self.solution = "\(numbers[0].str)=\(self.sum)"
            }
            return
        }

        var newNumbers = [NumStr](repeating: NumStr(num: 0, str: ""), count: n - 1)

        for i in 0..<n - 1 {
            for j in (i + 1)..<n {
                var l = 0
                for k in 0..<n {
                    if k != i && k != j {
                        newNumbers[l] = numbers[k]
                        l += 1
                    }
                }

                newNumbers[l].num = numbers[i].num + numbers[j].num
                newNumbers[l].str = "(\(numbers[i].str)+\(numbers[j].str))"
                solve(&newNumbers, n - 1)

                newNumbers[l].num = numbers[i].num - numbers[j].num
                newNumbers[l].str = "(\(numbers[i].str)-\(numbers[j].str))"
                solve(&newNumbers, n - 1)

                newNumbers[l].num = numbers[j].num - numbers[i].num
                newNumbers[l].str = "(\(numbers[j].str)-\(numbers[i].str))"
                solve(&newNumbers, n - 1)

                newNumbers[l].num = numbers[i].num * numbers[j].num
                newNumbers[l].str = "(\(numbers[i].str)*\(numbers[j].str))"
                solve(&newNumbers, n - 1)

                if abs(numbers[j].num) > 1e-5 {
                    newNumbers[l].num = numbers[i].num / numbers[j].num
                    newNumbers[l].str = "(\(numbers[i].str)/\(numbers[j].str))"
                    solve(&newNumbers, n - 1)
                }

                if abs(numbers[i].num) > 1e-5 {
                    newNumbers[l].num = numbers[j].num / numbers[i].num
                    newNumbers[l].str = "(\(numbers[j].str)/\(numbers[i].str))"
                    solve(&newNumbers, n - 1)
                }
            }
        }
    }
    
    
}




