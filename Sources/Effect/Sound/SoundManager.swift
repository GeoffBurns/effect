//
//  SoundManager.swift
//
//  Created by Geoff Burns on 9/11/19.
//  Copyright © 2019 Geoff Burns. All rights reserved.
//


import Foundation
import Utilities

#if os(macOS)

import AppKit

public class SoundManager : NSObject
{
    public var lastSounds : [String] = []
    fileprivate var previousRequest : String = ""
    fileprivate var soundQueue : [String] = []
    public var _sounds =  [String : NSSound?] ()
    override init() {
        
        super.init()
    }
    public var isPlaying = false
 
    func sounds(_ key:String) -> NSSound?
    {
        if let sound = _sounds[key]
        {
            return sound
        }
        
        let lower = key.lowercased().underscore
        let localkey = lower
        guard let url = Sound.resource.url(localkey)
            else { return nil }
       
        guard  let sound = NSSound(contentsOfFile: url.description, byReference: true)
            else { return nil }
        sound.loops = false
        _sounds[key] = sound
        return sound
    }
    
    public func playSound(_ soundName: String)
    {
        self.previousRequest = soundName
        guard Sound.shared.isPlaying else {
            stopAll()
            return }
        
        guard let sound = sounds(soundName) else {return}
        if isPlaying {
            soundQueue.append(soundName)
            return
        }
        isPlaying = true

        sound.volume = Sound.shared.volume
        sound.play()

    }
    public func playSingleSound(_ soundName: String)
    {
        guard previousRequest != soundName else { return }
        playFastSound(soundName)
    }
    public func playFastSound(_ soundName: String)
    {
         self.previousRequest = soundName
        guard Sound.shared.isPlaying else {
            stopAll()
            return }
        
        guard let sound = sounds(soundName) else {return}
        if isPlaying {
            soundQueue.removeAll()
            soundQueue.append(soundName)
            return
        }
        isPlaying = true
  
        sound.volume = Sound.shared.volume
        sound.play()
    }
    public func playSoundNow(_ soundName: String)
    {
         self.previousRequest = soundName
        guard Sound.shared.isPlaying else {
            stopAll()
            return }
        
        guard let sound = sounds(soundName) else {return}
        if isPlaying {
            soundQueue.removeAll()
            soundQueue.append(soundName)
            stopAll()
            return
        }
        isPlaying = true
    
        sound.volume = Sound.shared.volume
        sound.play()

    }
    public func playQueuedSound(_ soundName: String) -> Bool
    {
        guard Sound.shared.isPlaying else {
            stopAll()
            return true }
        
        guard let sound = sounds(soundName) else {return false}
        

        sound.volume = Sound.shared.volume
        sound.play()
 
        return true
    }
    public func playSounds(_ soundNames: [String])
    {
        if soundNames.elementsEqual(lastSounds) { return }
        lastSounds = soundNames
        for soundName in soundNames
        {
            playSound(soundName)
        }
    }
    public func stopAll()
    {
        soundQueue = []
        for (_, sound) in _sounds where sound != nil
        {
            sound!.stop()
        }
    }
    public func volume(_ volume:Float)
    {
        for (_, sound) in _sounds where sound != nil
        {
            sound!.volume = volume
        }
    } 
    /*
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        
        while true {
            guard soundQueue.count > 0 else {
                isPlaying = false
                return
            }
            let soundName = soundQueue.remove(at: 0)
            if playQueuedSound(soundName) { return }
        }
    }
    */
}
#else

import AVFoundation


public class Audio
{
    public static let shared = Audio()
    public static var session : AVAudioSession { shared.session }
    
    public var session : AVAudioSession
    
    init() {
        session = AVAudioSession.sharedInstance()
           do {
            try session.setCategory(AVAudioSession.Category.playback,mode: .default)
           } catch {
               print("Setting category to AVAudioSessionCategoryPlayback failed.")
           }
                  do {
                   try session.setActive(true)
                  } catch {
                      print("Setting session to Active failed.")
                  }
    }
}

public class SoundManager : NSObject, AVAudioPlayerDelegate
{
    public var lastSounds : [String] = []
    fileprivate var previousRequest : String = ""
    fileprivate var soundQueue : [String] = []
    public var _sounds =  [String : AVAudioPlayer?] () 
    override init() { 
        super.init()
        let _ = Audio.session
    }
    public var isPlaying = false
    
    func sounds(_ key:String) -> AVAudioPlayer?
    {
        
        if let sound = _sounds[key]
        {
            return sound
        }
        
        let lower = key.lowercased().underscore
        guard let url =  Sound.resource.url(lower) else { return nil }
        do {
            
            let sound = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue )
            
            sound.numberOfLoops = 0
            sound.prepareToPlay()
            sound.delegate = self
            _sounds[key] = sound
            return sound
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    public func playSound(_ soundName: String)
    {
        self.previousRequest = soundName
        guard Sound.shared.isPlaying else {
            stopAll()
            return }
        
        guard let sound = sounds(soundName) else {return}
        if isPlaying {
            soundQueue.append(soundName)
            return
        }
        isPlaying = true

        sound.volume = Sound.shared.volume
        sound.play()

    }
    public func playSingleSound(_ soundName: String)
    {
        guard previousRequest != soundName else { return }
        playFastSound(soundName)
    }
    public func playFastSound(_ soundName: String)
    {
         self.previousRequest = soundName
        guard Sound.shared.isPlaying else {
            stopAll()
            return }
        
        guard let sound = sounds(soundName) else {return}
        if isPlaying {
            soundQueue.removeAll()
            soundQueue.append(soundName)
            return
        }
        isPlaying = true
  
        sound.volume = Sound.shared.volume
        sound.play()
    }
    public func playSoundNow(_ soundName: String)
    {
         self.previousRequest = soundName
        guard Sound.shared.isPlaying else {
            stopAll()
            return }
        
        guard let sound = sounds(soundName) else {return}
        if isPlaying {
            soundQueue.removeAll()
            soundQueue.append(soundName)
            stopAll()
            return
        }
        isPlaying = true
    
        sound.volume = Sound.shared.volume
        sound.play()

    }
    public func playQueuedSound(_ soundName: String) -> Bool
    {
        guard Sound.shared.isPlaying else {
            stopAll()
            return true }
        
        guard let sound = sounds(soundName) else {return false}
        

        sound.volume = Sound.shared.volume
        sound.play()
 
        return true
    }
    public func playSounds(_ soundNames: [String])
    {
        if soundNames.elementsEqual(lastSounds) { return }
        lastSounds = soundNames
        for soundName in soundNames
        {
            playSound(soundName)
        }
    }
  
    public func stopAll()
    {
        soundQueue = []
        for (_, sound) in _sounds where sound != nil
        {
            sound!.stop()
        }
    }
    public func volume(_ volume:Float)
    {
        for (_, sound) in _sounds where sound != nil
        {
            sound!.volume = volume
        }
    }
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        while true {
            guard soundQueue.count > 0 else {
                isPlaying = false
                return
            }
            let soundName = soundQueue.remove(at: 0)
            if playQueuedSound(soundName) { return }
        }
    }
    
}
#endif
