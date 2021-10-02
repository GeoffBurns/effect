//
//  SoundSettings.swift
//
//  Created by Geoff Burns on 28/9/21.
//

import Combine
import SwiftUI

 
public class Sound: ObservableObject, ISoundSettings {
    public static let settings : Sound = Sound()
    public static var shared : ISoundSettings { settings }
    public static var defaults : ISoundSettings = SoundDefaults()
    public static var resource : IResourceRegistry = SoundRegistry()
    public static var player : SoundManager = SoundManager()
    
    @Published public var isPlaying : Bool = Sound.defaults.isPlaying { didSet {
        Sound.defaults.isPlaying = self.isPlaying
        if !self.isPlaying  {
            Sound.player.stopAllSound()
        }
    }}
    @Published public var volume : Float  = Sound.defaults.volume
    
    public func save()
    {
        Sound.defaults.volume = self.volume
        Sound.player.soundVolume(volume: self.volume)
    }
    
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
    public static let settings : Music = Music()
    public static var shared : ISoundSettings { settings }
    public static var defaults : ISoundSettings = MusicDefaults()
    public static var resource : IMusicRegistry = MusicRegistry()
    public static var player : SoundManager { get { Sound.player }}
     
    @Published public var isPlaying : Bool = Music.defaults.isPlaying { didSet {
        Music.defaults.isPlaying = self.isPlaying
        if self.isPlaying  {
            Music.player.playMusic()
        } else {
            Music.player.stopAllMusic()
        }
    }}
    @Published public var volume : Float = Music.defaults.volume
    
    public func save()
    {
        Music.defaults.volume = self.volume
        Music.player.musicVolume(volume: self.volume)
    }
}
