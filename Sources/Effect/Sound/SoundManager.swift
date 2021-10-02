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
    public var playlist : [String] = []
    public var lastSounds : [String] = []
    fileprivate var previousRequest : String = ""
    public var _songs =  [NSSound?] (repeating: nil, count: 7)
    fileprivate var soundQueue : [String] = []
    public var _sounds =  [String : NSSound?] ()
    override init() {
        
        super.init()
    }
    public var isPlaying = false
    func songs(_ index:Int) -> NSSound?
    {
        let i = index % _songs.count
        
        if let song = _songs[i]
        {
            return song
        }
        guard playlist.count > i else { return nil }
        let playitem = playlist[i]
        guard let url = Music.resource.url(playitem) else { return nil }
      
        _songs[i] = NSSound(contentsOfFile: url.description, byReference: true)
            
            return _songs[i]
  
    
    }
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
            stopAllSound()
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
            stopAllSound()
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
            stopAllSound()
            return }
        
        guard let sound = sounds(soundName) else {return}
        if isPlaying {
            soundQueue.removeAll()
            soundQueue.append(soundName)
            stopAllSound()
            return
        }
        isPlaying = true
    
        sound.volume = Sound.shared.volume
        sound.play()

    }
    public func playQueuedSound(_ soundName: String) -> Bool
    {
        guard Sound.shared.isPlaying else {
            stopAllSound()
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
    public func stopAllMusic(except:Int)
    {
        for (i,song) in _songs.enumerated() where song != nil && i != except
        {
            song!.stop()
        }
    }
    public func stopAllMusic()
    {
        for song in _songs where song != nil
        {
            song!.stop()
        }
    }
    public func stopAllSound()
    {
        soundQueue = []
        for (_, sound) in _sounds where sound != nil
        {
            sound!.stop()
        }
    }
    public func musicVolume(volume:Float)
    {
        for song in _songs where song != nil
        {
            song!.volume = volume
        }
    }
    public func soundVolume(volume:Float)
    {
        for (_, sound) in _sounds where sound != nil
        {
            sound!.volume = volume
        }
    }
    public func playMusic(_ n: Int = 0) {
        guard n < 7 && playlist.count > n else { return }
        stopAllMusic(except:n)
        guard Music.shared.isPlaying else {
            stopAllMusic()
            return }
        guard let song = songs(n) else { return }
        
        song.loops = false
        song.volume =  Music.shared.volume
        if song.isPlaying {return}
        song.play()
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

public class SoundManager : NSObject, AVAudioPlayerDelegate
{
    public var playlist : [String] = []
    public var lastSounds : [String] = []
    fileprivate var previousRequest : String = ""
    public var _songs =  [AVAudioPlayer?] (repeating: nil, count: 7)
    fileprivate var soundQueue : [String] = []
    public var _sounds =  [String : AVAudioPlayer?] () 
    override init() {
        
        super.init()
        
        let audioSession = AVAudioSession.sharedInstance()
           do {
            try audioSession.setCategory(AVAudioSession.Category.playback,mode: .default)
           } catch {
               print("Setting category to AVAudioSessionCategoryPlayback failed.")
           }
                  do {
                   try audioSession.setActive(true)
                  } catch {
                      print("Setting session to Active failed.")
                  }
    }
    public var isPlaying = false
    func songs(_ index:Int) -> AVAudioPlayer?
    {
        
        let i = index % _songs.count
        
        if let song = _songs[i]
        {
            return song
        }
        guard playlist.count > i else { return nil }
        let playitem = playlist[i]
        guard let url =  Music.resource.url(playitem) else { return nil }
        do {
            _songs[i] = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue )
            return _songs[i]
          
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
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
            stopAllSound()
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
            stopAllSound()
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
            stopAllSound()
            return }
        
        guard let sound = sounds(soundName) else {return}
        if isPlaying {
            soundQueue.removeAll()
            soundQueue.append(soundName)
            stopAllSound()
            return
        }
        isPlaying = true
    
        sound.volume = Sound.shared.volume
        sound.play()

    }
    public func playQueuedSound(_ soundName: String) -> Bool
    {
        guard Sound.shared.isPlaying else {
            stopAllSound()
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
    public func stopAllMusic(except:Int)
    {
        for (i,song) in _songs.enumerated() where song != nil && i != except
        {
            song!.stop()
        }
    }
    public func stopAllMusic()
    {
        for song in _songs where song != nil
        {
            song!.stop()
        }
    }
    public func stopAllSound()
    {
        soundQueue = []
        for (_, sound) in _sounds where sound != nil
        {
            sound!.stop()
        }
    }
    public func musicVolume(volume:Float)
    {
        for song in _songs where song != nil
        {
            song!.volume = volume
        }
    }
    public func soundVolume(volume:Float)
    {
        for (_, sound) in _sounds where sound != nil
        {
            sound!.volume = volume
        }
    }
    public func playMusic(_ n: Int = 0) {
        guard n < 7 && playlist.count > n else { return }
        
        stopAllMusic(except:n)
        guard Music.shared.isPlaying else {
            stopAllMusic()
            return }
        guard let song = songs(n) else { return }
        
        song.numberOfLoops = -1
        song.volume =  Music.shared.volume
        if song.isPlaying {return}
        song.play()
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
