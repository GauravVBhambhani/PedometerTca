//
//  PedometerClient.swift
//  PedometerTca
//
//  Created by Gaurav Bhambhani on 7/30/24.
//

import Foundation
import ComposableArchitecture
import CoreMotion

@DependencyClient
struct PedometerClient {
    
    static let fetchPedometerValue = {
        
        let pedometer = CMPedometer()
        
        
        return Self(
            
            isStepCountingAvailable: {
                CMPedometer.isStepCountingAvailable()
            },
            
            startUpdates: { startDate in
                return AsyncThrowingStream { continuation in
                    
                    pedometer.startUpdates(from: startDate) { data, error in
                        if let data {
                            continuation.yield(data.numberOfSteps.intValue)
                        } 
                        
                        else if let error {
                            continuation.finish(throwing: error)
                        } 
                        
                        else {
                            continuation.finish()
                        }
                    }
                }
            },
            
            stopUpdates: {
                pedometer.stopUpdates()
            }
            
        )
    } ()
    
    var isStepCountingAvailable: () -> Bool = {
        unimplemented(placeholder: false)
//        fatalError()
//        return false
    }
    
    var startUpdates: (Date) -> AsyncThrowingStream<Int, Error> = { _ in
        .finished()
    }
    
    var stopUpdates: () -> ()
}

// Unique key for accessing PedometerClient
extension PedometerClient: DependencyKey {
    static let liveValue = PedometerClient.fetchPedometerValue
}

// for overriding values of dependency
extension DependencyValues {
    var pedometer: PedometerClient {
        get { self[PedometerClient.self] }
        set { self[PedometerClient.self] = newValue }
    }
}


// extension for mock pedometer client
extension PedometerClient {
    static func mock (stream: AsyncThrowingStream<Int, Error>) -> Self   {
        
        Self(
            
            isStepCountingAvailable: {true},
            
            startUpdates: { _ in
                stream
            },
            
            stopUpdates: { }
            
        )
    }
}
