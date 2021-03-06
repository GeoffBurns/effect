//
//  MusicCommands.swift
//
//
//  Created by Geoff Burns on 6/10/21.

//

import SwiftUI

public struct SoundCommands: Commands {
    
    public init()
    {
    }

    @CommandsBuilder public var body: some Commands {
         CommandMenu("Sound Effects")
        {
            SoundCommandView()
        }
    }
     
}

public struct SoundCommandView: View {
    
   @ObservedObject var sound : Sound = Sound.settings
    
   public init()
    {
    }

   @ViewBuilder public var body: some View {
            Button("Increase Volume", action: increaseSound)
                    .disabled(!sound.isPlaying)
                    .keyboardShortcut("d")
                
            Button("Decrease Volume", action: decreaseSound)
                        .disabled(!sound.isPlaying)
                        .keyboardShortcut("s")
       
            Divider()
            if sound.isPlaying
            {
                Button("Mute Sound", action: muteSound)
                    .keyboardShortcut("f")
            } else
            {
                Button("Unmute Sound", action: muteSound)
                    .keyboardShortcut("f")
            }
        }
    
    private func increaseSound() {
        sound.volume += 0.1
    }
    private func decreaseSound() {
        sound.volume -= 0.1
    }
    private func muteSound() {
        sound.isPlaying.toggle()
    }
}


