//
//  PedometerFeature.swift
//  PedometerTca
//
//  Created by Gaurav Bhambhani on 7/21/24.
//

import SwiftUI
import ComposableArchitecture
import CoreMotion
import XCTestDynamicOverlay

@Reducer
struct PedometerFeature {
    
    @ObservableState
    struct State: Equatable{
        var stepCount: Int = 0
        var isPedometerAvailable: Bool = false
        var isPedometerRunning: Bool = false
        
        var historyList: [Int] = []
    }
    
    enum Action: Equatable {
        case startButtonTapped
        case stopButtonTapped
        
//        case stepsUpdated(Int)
        case pedometerAvailability(Bool)
        
        case pedometerResponse(Int?)
//        case pedometerStarted
    }
    
    @Dependency(\.pedometer) var pedometer
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .startButtonTapped:
                print("pedometer has started...")
                guard pedometer.isStepCountingAvailable() else {
                    print("pedometer not available")
                    return .send(.pedometerAvailability(false))
                }
                
                state.isPedometerAvailable = true
                // did it manually here to make sure it works
                state.isPedometerRunning = true
                state.stepCount = 0
                
                print("is it running ?")
                print(state.isPedometerRunning)
                
                return .run { send in
                    let stream = self.pedometer.startUpdates(Date())
                    for try await stepCount in stream {
                        print("step count")
                        print(stepCount)
                        await send(.pedometerResponse(stepCount))
                    }
                }
                
            case .stopButtonTapped:
                pedometer.stopUpdates()
                state.isPedometerRunning = false
                state.historyList.append(state.stepCount)
                print("Pedometer is stopped...")
                return .none
                
            case let .pedometerAvailability(isAvailable):
                state.isPedometerAvailable = isAvailable
                return .none
                
            case let .pedometerResponse(stepCount):
                if let stepCount = stepCount {
                    state.stepCount = stepCount
                }
                return .none
                
                //            case let .stepsUpdated(stepCount):
                //                state.stepCount = stepCount
                //                return .none
                
                //            case .pedometerStarted:
                //                state.isPedometerRunning = true
                //                print("pedometer is running...")
                //                return .none
            }
        }
    }
}
