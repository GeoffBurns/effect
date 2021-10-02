
//  SoundDefaults.swift
//
//  Created by Geoff Burns on 2/10/21.
//

import Combine
import SwiftUI

public protocol ISoundSettings {
    var isPlaying : Bool { get set }
    var volume : Float { get set }
}

public class SoundDefaults:   ISoundSettings {
    public var isPlaying: Bool
    {
        get {
            SavedSoundSettings.isPlayingSound
        }
        set {
            SavedSoundSettings.isPlayingSound = newValue
        }
    }
    
    public var volume: Float
    {
        get {
            SavedSoundSettings.soundVolume
        }
        set {
                SavedSoundSettings.soundVolume = newValue
        }
    }
        
    }
public class MusicDefaults:   ISoundSettings {
    public var isPlaying: Bool
    {
        get {
            SavedSoundSettings.isPlayingMusic
        }
        set {
                SavedSoundSettings.isPlayingMusic = newValue
        }
    }
    
    public var volume: Float
    {
        get {
            SavedSoundSettings.musicVolume
        }
        set {
            SavedSoundSettings.musicVolume = newValue
        }
    }
        
}
