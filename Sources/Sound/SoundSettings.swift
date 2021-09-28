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

public class Sound: ObservableObject, ISoundSettings {
    public static var shared : ISoundSettings = Sound()
    public static var resource : IResourceRegistry = SoundRegistry()
    public static var player : SoundManager = SoundManager()
    
    @Published public var isPlaying : Bool = true
    @Published public var volume : Float = 0.3
    
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

public class Music: ObservableObject, ISoundSettings {
    public static var shared : ISoundSettings = Music()
    public static var resource : IResourceRegistry = MusicRegistry()
    public static var player : SoundManager { get { Sound.player }}
    
    @Published public var isPlaying : Bool = true
    @Published public var volume : Float = 0.3
}
