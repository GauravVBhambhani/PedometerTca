//
//  PedometerTcaTests.swift
//  PedometerTcaTests
//
//  Created by Gaurav Bhambhani on 8/6/24.
//

import ComposableArchitecture
import XCTest

@testable import PedometerTca

final class PedometerTcaTests: XCTestCase {
    
    @MainActor
    func testPedometerAvailable() async {
        
//        let clock = TestClock()
        
        let (stream, continuation) = AsyncThrowingStream.makeStream(of: Int.self)
        
        let store = TestStore(initialState: PedometerFeature.State()) {
            PedometerFeature()
        } withDependencies: {
            $0.pedometer = .mock(stream: stream)
//            $0.continuousClock = clock
        }
        
        // Start the pedometer
        
        await store.send(.startButtonTapped) {
            $0.isPedometerAvailable = true
            $0.isPedometerRunning = true
            $0.stepCount = 0
        }
        
        continuation.yield(100)
        
//        await store.skipReceivedActions()
        
        // Simulate receiving step count updates
//        await clock.advance(by: .seconds(3))
        
        await store.receive(\.pedometerResponse) {
            $0.stepCount = 100
        }
        
//        await store.skipInFlightEffects()
        
        // Stop the pedometer
        await store.send(.stopButtonTapped) {
            $0.isPedometerRunning = false
        }
//        
        continuation.finish()
        
        await store.finish()
        
    }
    
}
