//
//  PurchaseView.swift
//  Dice2
//
//  Created by Ma Xueyuan on 2020/07/28.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SwiftUI
import SwiftyStoreKit

struct PurchaseView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var paid: Bool
    @State private var purchaseString = "Purchase colorful dice".localized()
    @State private var isPurchaseError = false
    @State private var isRestoreError = false
    
    var body: some View {
        VStack {
            Text("After purchasing colorful dice you can set dice to your lucky color. It's cool!").padding()
            
            Button(purchaseString) {
                SwiftyStoreKit.purchaseProduct(Key.purchaseId) { (result) in
                    switch result {
                    case .success(let purchase):
                        print("Purchase Success: \(purchase.productId)")
                        self.getColorfulDice()
                    case .error(let error):
                        print((error as NSError).localizedDescription)
                        self.isPurchaseError = true
                    }
                }
            }.padding()
            .alert(isPresented: $isPurchaseError) { () -> Alert in
                Alert(title: Text("Purchase failed"))
            }
            
            Button("Restore purchase") {
                SwiftyStoreKit.restorePurchases(atomically: true) { results in
                    if results.restoredPurchases.count > 0 {
                        self.getColorfulDice()
                    } else {
                        self.isRestoreError = true
                    }
                }
            }.padding()
            .alert(isPresented: $isRestoreError) { () -> Alert in
                Alert(title: Text("Restore failed"))
            }
        }
        .navigationBarTitle(Text("Purchase"), displayMode: .inline)
        .onAppear {
            SwiftyStoreKit.retrieveProductsInfo([Key.purchaseId]) { (result) in
                if let product = result.retrievedProducts.first {
                    let priceString = product.localizedPrice!
                    let format = "PurchaseFormat".localized()
                    self.purchaseString = String(format: format, priceString)
                }
            }
        }
    }
    
    func getColorfulDice() {
        UserDefaults.standard.set(true, forKey: Key.paid)
        paid = true
        presentationMode.wrappedValue.dismiss()
    }
}

struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView(paid: .constant(false))
    }
}
