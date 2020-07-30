//
//  RollView.swift
//  Dice2
//
//  Created by Ma Xueyuan on 2020/06/18.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SwiftUI
import StoreKit

struct RollView: View {
    @Binding var setting: Setting
    
    @State private var diceRolled = false
    @State private var diceImageNames = Array.init(repeating: "square", count: 5)
    @State private var diceSizes = Array.init(repeating: CGFloat(200), count: 5)
    @State private var diceOffsets = Array.init(repeating: CGFloat(0), count: 5)
    @State private var diceDegrees = Array.init(repeating: Double(0), count: 5)
    @State private var diceResult = "Result:".localized()
    @State private var feedback = UINotificationFeedbackGenerator()
    @State private var times = 0
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                ZStack {
                    ForEach(0..<self.setting.dices) { i in
                        Image(systemName: self.diceImageNames[i])
                            .resizable()
                            .foregroundColor(Setting.colors[self.setting.color])
                            .frame(width: self.diceSizes[i], height: self.diceSizes[i])
                            .offset(x: CGFloat.minimum(geo.size.width, geo.size.height) * self.diceOffsets[i], y: 0)
                            .rotationEffect(.degrees(self.diceDegrees[i]))
                    }
                }.frame(width: geo.size.width, height: geo.size.height)
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
                Text(diceRolled ? "Reset" : "Roll")
            }
            .font(.largeTitle).padding([.top, .bottom], 8)
            
        }
        .navigationBarTitle(Text("Dice"), displayMode: .inline)
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
                diceOffsets[i] = CGFloat.random(in: -0.4...0.4)
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
                diceOffsets[i] = 0
                diceDegrees[i] = 0
            }
        }
        
        diceResult = "Result:".localized()
        diceRolled = false
        
        times += 1
        if times == 10 {
            SKStoreReviewController.requestReview()
        }
    }
}

struct RollView_Previews: PreviewProvider {
    static var previews: some View {
        RollView(setting: .constant(Setting()))
    }
}
