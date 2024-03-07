//
//  Settingsview.swift
//  DashDrop
//
//  Created by Arjun Takhar on 3/1/24.
//

struct Settingsview_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView{ (user: dev.mockuser)
            }
        }
    }
}
