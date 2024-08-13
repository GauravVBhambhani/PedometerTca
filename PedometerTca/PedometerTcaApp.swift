//
//  PedometerTcaApp.swift
//  PedometerTca
//
//  Created by Gaurav Bhambhani on 7/21/24.
//

import SwiftUI
import ComposableArchitecture
import CoreMotion

@main
struct PedometerTcaApp: App {
    var body: some Scene {
        WindowGroup {
            PedometerView(
                store: Store(initialState: PedometerFeature.State()) {
                    PedometerFeature()
                }
            )
        }
    }
}
