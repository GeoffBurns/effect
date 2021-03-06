//
//  MusicCommands.swift
//  
//
//  Created by Geoff Burns on 6/10/21.
//

import SwiftUI

public struct MusicCommands: Commands {
    
   public init()
    {
    }
    
   @CommandsBuilder public var body: some Commands {
       CommandMenu("Music")
        {
         MusicCommandsView()
        }
    }
}


public struct MusicCommandsView: View {
    
   @ObservedObject var music : Music = Music.settings
    
    public init()
    {
    }
    
    public var body: some View {
   
        Button("Increase Volume", action: increaseMusic)
               .disabled(!music.isPlaying)
               
        Button("Decrease Volume", action: decreaseMusic)
           .disabled(!music.isPlaying)
        Divider()
        if music.isPlaying
           {
                Button("Stop Music", action: muteMusic)
           }
        else
           {
               Button("Play Music", action: muteMusic)
           } 
    }
    private func increaseMusic() {
            music.volume += 0.1
    }
    private func decreaseMusic() {
            music.volume -= 0.1
    }
    private func muteMusic() {
        music.isPlaying.toggle()
    }
}

