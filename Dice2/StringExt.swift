//
//  StringExt.swift
//  Dice2
//
//  Created by Ma Xueyuan on 2020/06/19.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
