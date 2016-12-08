//
//  GCD.swift
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/8/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
