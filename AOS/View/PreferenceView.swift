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
    
    
    var body: some View {
        Spacer()
        VStack(alignment: .leading) {
            Spacer()
            
            LaunchAtLogin.Toggle()
            
            Toggle("Auto Refresh", isOn: $autoRefreshEnabled)
            
            Spacer()
            
            Picker("Select state: ", selection: $selectedState) {
                ForEach(Array(DataStore.statesDictionary.keys), id: \.self) { name in
                    Text(name).tag(DataStore.codeByName(name)!)
                }
            }
            .frame(width: 200)
            
            Picker("Frequency: ", selection: $refreshInterval) {
                ForEach(Frequency.allCases, id: \.id) { freq in
                    Text(freq.timeDesc)
                        .tag(freq)
                }
            }
            .frame(width: 200)
            .disabled(!autoRefreshEnabled)
            
            Spacer()
        }
        .frame(width: 270, height: 180)
        Spacer()
    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView()
    }
}
