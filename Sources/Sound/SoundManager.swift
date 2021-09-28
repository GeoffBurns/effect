//
//  SoundManager.swift
//
//  Created by Geoff Burns on 9/11/19.
//  Copyright © 2019 Geoff Burns. All rights reserved.
//


import Foundation
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
        let playitem = playlist[i]
        guard let url = Bundle.main.url(forResource: playitem, withExtension: "mp3") else { return nil }
        do {
            //  try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            // try AVAudioSession.sharedInstance().setActive(true)
            
            
            //  if #available(iOS 11.0, *) {
            _songs[i] = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue )
            
            return _songs[i]
            //  } else {
            //      musicPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3.rawValue)
            //  }
            
            
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
        
        
        // let lang = Locale.current.languageCode ?? "en"
        let localkey = lower //"\(lower)-\(lang)"
        guard let url = Bundle.main.url(forResource: localkey, withExtension: "m4a") ?? Bundle.main.url(forResource: localkey, withExtension: "mp3")
            else { return nil }
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

