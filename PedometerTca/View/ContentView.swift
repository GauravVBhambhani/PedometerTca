//
//  ContentView.swift
//  PedometerTca
//
//  Created by Gaurav Bhambhani on 7/21/24.
//

import SwiftUI
import ComposableArchitecture

struct PedometerView: View {
    let store: StoreOf<PedometerFeature>
//    let stringData = ["Hello World", "Test"]
    
    var body: some View {
        
        VStack {
            
            if store.isPedometerAvailable {
                
                Text(store.isPedometerRunning ? "Pedometer is running..." : "Pedometer is stopped.")
                    .foregroundColor(store.isPedometerRunning ? .green : .red)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                
                Text("Steps: \(store.stepCount)")
                    .font(.largeTitle)
                    .padding()
                
                if store.isPedometerRunning {
                    Button("Stop Pedometer") {
                        store.send(.stopButtonTapped)
                    }
                    .padding()
                } else {
                    Button("Start Pedometer") {
                        store.send(.startButtonTapped)
                    }
                    .padding()
                }
                
                Text("History")
                List {
                    ForEach(store.historyList, id: \.self) { stepCountData in
                        Text("\(stepCountData)")
                    }
                }

            } else {
                Text("Pedometer not available")
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
            }
        }
        
        .onAppear {
            store.send(.startButtonTapped)
        }
        
        .onDisappear {
            store.send(.stopButtonTapped)
        }
        
    }
}

#Preview {
    PedometerView(store: Store(initialState: PedometerFeature.State(), reducer: {
        PedometerFeature()
    }))
}
