//
//  SoundSettingsView.swift
//
//
//  Created by Geoff Burns on 13/11/19.
//  Copyright © 2019 Geoff Burns. All rights reserved.
//

import SwiftUI 

public struct SoundSettingsView: View {
     
    @ObservedObject var sound : Sound = Sound.settings  
    
    public init()
    {
    }
    
    public var body: some View {
        Section(header:Text("Sound Effects".efLocal)) {
     
                Toggle(isOn: $sound.isPlaying) { Text("Enable".efLocal) }
             
                if sound.isPlaying
                {
                    Slider(value: $sound.volume, in: 0.0 ... 1.0)
                //    Text("\(Int(sound.volume*100))% volume")
                    
                    Text("%d%% volume".efLocalizeWith(Int(sound.volume*100)))
                }
            }
    }
}
    
