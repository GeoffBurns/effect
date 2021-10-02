//
//  SoundSettings.swift
//
//  Created by Geoff Burns on 28/9/21.
//

import Combine
import SwiftUI

public protocol ISoundSettings {
    var isPlaying : Bool { get set }
    var volume : Float { get set }
}

public class Sound: ObservableObject, ISoundSettings {
    public static var settings : Sound = Sound()
    public static var shared : ISoundSettings { settings }
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
    static public func sad()
   {
       player.playFastSound("sad_trombone")
   }
    
}

public class Music: ObservableObject, ISoundSettings { 
    public static var settings : Music = Music()
    public static var shared : ISoundSettings { settings }
    public static var resource : IResourceRegistry = MusicRegistry()
    public static var player : SoundManager { get { Sound.player }}
    
    @Published public var isPlaying : Bool = true
    @Published public var volume : Float = 0.3
}
