//
//  ContentView.swift
//  Dice2
//
//  Created by Ma Xueyuan on 2020/06/18.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var setting = Setting()
    @State private var paid = UserDefaults.standard.bool(forKey: Key.paid)
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Dice Sides")) {
                    Picker("", selection: $setting.sidesId) {
                        ForEach(0 ..< Setting.sidesOptions.count) {
                            Text("\(Setting.sidesOptions[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Dice Amount")) {
                    Stepper(value: $setting.dices, in: 1...5) {
                        Text("\(setting.dices)")
                    }
                }
                
                Section(header: Text("Dice Color")) {
                    if paid {
                        Text("Paid")
                    } else {
                        NavigationLink(destination: PurchaseView()) {
                            Text("Purchase colorful dice")
                        }
                    }
                }
            }
            .navigationBarItems(trailing: NavigationLink(destination: RollView(setting: $setting), label: {
                Text("Done")
            }))
            .navigationBarTitle(Text("Setting"), displayMode: .inline)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
