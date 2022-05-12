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
                Stepper("Refresh Interval: \(refreshInterval) min",
                        value: $refreshInterval, in: 30...720)
                .disabled(!autoRefreshEnabled)
            }.frame(width: 200, alignment: .leading)
            
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
