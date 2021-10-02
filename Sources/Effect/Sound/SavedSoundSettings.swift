
//  SavedSoundSettings.swift
//
//  Created by Geoff Burns on 13/11/19.
//  Copyright © 2019 Geoff Burns. All rights reserved.
//

import Foundation
 
enum SoundProperties : String
{
    case playMusic = "playMusic"
    case silenceMusic = "silenceMusic"
    case playSound  = "playSound"
    case silenceSound = "silenceSound"
    case musicVolume = "musicVolume"
    case soundVolume = "soundVolume"
}
public enum SavedSoundSettings
{
    static public var _soundVolume : Int  {
           get {
            let result = UserDefaults.standard.integer(forKey: SoundProperties.soundVolume.rawValue)
                    if result == 0
                        {
                            return 31
                        }
                return result
               }
           set (newValue) {
               UserDefaults.standard.set(newValue, forKey: SoundProperties.soundVolume.rawValue)
               }
        }
    static public var soundVolume : Float  {
            get {
                Float(_soundVolume-1)/100.0
                }
            set (newValue) {
                  _soundVolume = Int(newValue * 100.0)+1
                }
         }
    static public var isPlayingSound : Bool  {
        get { return !UserDefaults.standard.bool(forKey: SoundProperties.silenceSound.rawValue)  }
        set (newValue) {
            UserDefaults.standard.set(!newValue  , forKey: SoundProperties.silenceSound.rawValue)
        }
    }
    
    static public var _musicVolume : Int  {
           get {
            let result = UserDefaults.standard.integer(forKey: SoundProperties.musicVolume.rawValue)
                    if result == 0
                        {
                            return 31
                        }
                return result
               }
           set (newValue) {
               UserDefaults.standard.set(newValue, forKey: SoundProperties.musicVolume.rawValue)
               }
        }
    static public var musicVolume : Float  {
            get {
                Float(_musicVolume-1)/100.0
                }
            set (newValue) {
                  _musicVolume = Int(newValue * 100.0)+1
                }
         }
    static public var isPlayingMusic : Bool  {
        get { return !UserDefaults.standard.bool(forKey: SoundProperties.silenceMusic.rawValue)  }
        set (newValue) {
            UserDefaults.standard.set(!newValue  , forKey: SoundProperties.silenceMusic.rawValue)
        }
    }
}
