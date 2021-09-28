//
//  SoundSettings.swift
//
//  Created by Geoff Burns on 28/9/21.
//

import Combine
import SwiftUI

protocol ISoundSettings {
    var isPlaying : Bool { get set }
    var volume : Float { get set }
}

class Sound: ObservableObject, ISoundSettings {
    static var shared : ISoundSettings = Sound()
    static var resource : IResourceRegistry = SoundRegistry()
    static var player : SoundManager = SoundManager()
    
    @Published var isPlaying : Bool = true
    @Published var volume : Float = 0.3
    
    static public func chime()
    {
        player.playFastSound("magic_chime")
    }
    static public func fail()
    {
        player.playFastSound("fail_buzzer")
    }
     static public func click()
    {
        player.playFastSound("shutter_click")
    }
}

class Music: ObservableObject, ISoundSettings {
    static var shared : ISoundSettings = Music()
    static var resource : IResourceRegistry = MusicRegistry()
    static var player : SoundManager { get { Sound.player }}
    
    @Published var isPlaying : Bool = true
    @Published var volume : Float = 0.3
}
