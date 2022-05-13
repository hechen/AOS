//
//  PreferenceView.swift
//  AOS
//
//  Created by chen he on 5/11/22.
//

import SwiftUI
import LaunchAtLogin

struct PreferenceView: View {
    @Preference(\.autoRefreshEnabled) var autoRefreshEnabled
    @Preference(\.refreshInterval) var refreshInterval
    @Preference(\.selectedState) var selectedState
    @Preference(\.searchZipCode) var searchZipCode
    
    var intProxy: Binding<Double>{
        Binding<Double>(get: {
            //returns the score as a Double
            return Double(refreshInterval)
        }, set: {
            //rounds the double to an Int
            print($0.description)
            refreshInterval = Int($0)
        })
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            Group {
                LaunchAtLogin.Toggle()
            }
            
            Spacer()
            
            Group {
                
                HStack(alignment: .center, spacing: 5) {
                    Text("Enter ZIP code:")
                    TextField("ZIP code", text: $searchZipCode)
                }
                
                Text("OR")
                
                Picker("Select state:", selection: $selectedState) {
                    ForEach(Array(DataStore.statesDictionary.keys), id: \.self) { name in
                        Text(name).tag(DataStore.codeByName(name)!)
                    }
                }
                .disabled(!searchZipCode.isEmpty)
                
            }
            .frame(width: 230)
            
            Spacer()
            
            Group() {
                Toggle("Auto Refresh", isOn: $autoRefreshEnabled)
                VStack(alignment: .leading) {
                    Text("Interval \(refreshInterval) Min: ")
                    Slider(value: intProxy, in: 10...60) {
                    } minimumValueLabel: {
                        Text("10 Min")
                    } maximumValueLabel: {
                        Text("60 Min")
                    } onEditingChanged: { _ in }
                        .disabled(!autoRefreshEnabled)
                }
            }.frame(width: 250, alignment: .leading)
            
            Spacer()
        }
        .frame(width: 270, height: 300)
        Spacer()
    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView()
    }
}
