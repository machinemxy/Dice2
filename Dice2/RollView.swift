//
//  RollView.swift
//  Dice2
//
//  Created by Ma Xueyuan on 2020/06/18.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct RollView: View {
    @Binding var setting: Setting
    
    @State private var diceRolled = false
    @State private var diceImageNames = Array.init(repeating: "square", count: 5)
    @State private var diceSizes = Array.init(repeating: CGFloat(200), count: 5)
    @State private var diceOffsetXs = Array.init(repeating: CGFloat(0), count: 5)
    @State private var diceOffsetYs = Array.init(repeating: CGFloat(0), count: 5)
    @State private var diceDegrees = Array.init(repeating: Double(0), count: 5)
    @State private var diceResult = "Result:".localized()
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                ZStack {
                    ForEach(0..<self.setting.dices) { i in
                        Image(systemName: self.diceImageNames[i])
                            .resizable()
                            .frame(width: self.diceSizes[i], height: self.diceSizes[i])
                            .offset(x: geo.size.width * self.diceOffsetXs[i], y: geo.size.height * self.diceOffsetYs[i])
                            .rotationEffect(.degrees(self.diceDegrees[i]))
                    }
                }
            }
            
            HStack {
                Text(diceResult).font(.title).padding([.top, .leading], 8.0)
                Spacer()
            }
            
            Button(action: {
                if self.diceRolled {
                    self.reset()
                } else {
                    self.roll()
                }
            }) {
                Text(diceRolled ? "Reset".localized() : "Roll".localized())
            }
            .font(.largeTitle).padding([.top, .bottom], 8)
            
        }
        .navigationBarTitle(Text("Dice".localized()), displayMode: .inline)
        .onAppear {
            self.feedback.prepare()
            self.setting.save()
        }
    }
    
    func roll() {
        var resultTemp = "Result:".localized()
        
        withAnimation {
            for i in 0..<self.setting.dices {
                let point = setting.roll()
                resultTemp.append(" \(point)")
                diceImageNames[i] = "\(point).square"
                diceSizes[i] = 50
                diceOffsetXs[i] = CGFloat.random(in: -0.3...0.3)
                diceOffsetYs[i] = CGFloat.random(in: -0.3...0.3)
                diceDegrees[i] = Double.random(in: -180...180)
            }
        }
        
        diceResult = resultTemp
        self.feedback.notificationOccurred(.error)

        diceRolled = true
    }
    
    func reset() {
        withAnimation {
            for i in 0..<self.setting.dices {
                diceImageNames[i] = "square"
                diceSizes[i] = 200
                diceOffsetXs[i] = 0
                diceOffsetYs[i] = 0
                diceDegrees[i] = 0
            }
        }
        
        diceResult = "Result:".localized()
        diceRolled = false
    }
}

struct RollView_Previews: PreviewProvider {
    static var previews: some View {
        RollView(setting: .constant(Setting()))
    }
}
