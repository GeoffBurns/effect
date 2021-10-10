//
//  MusicSettingsView.swift
//
//
//  Created by Geoff Burns on 13/11/19.
//  Copyright © 2019 Geoff Burns. All rights reserved.
//

import SwiftUI 

public struct MusicSettingsView: View {
    
    @ObservedObject var music : Music = Music.settings  
    
    public init()
    { 
    }
    
    public var body: some View {
        
        Section(header:Text("Music".efLocal)) {
     
                Toggle(isOn: $music.isPlaying) { Text("Play".efLocal) }
             
                if music.isPlaying
                {
                    Slider(value: $music.volume, in: 0.0 ... 1.0)
            //        Text("\(Int(music.volume*100))% volume")
                    Text("%d%% volume".efLocalizeWith(Int(music.volume*100)))
                }
            }
    }
}
    
