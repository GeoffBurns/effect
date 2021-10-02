//
//  MusicManager.swift
//
//  Created by Geoff Burns on 2/10/21
//


import Foundation
import Utilities

#if os(macOS)

import AppKit

public class MusicManager : NSObject
{
    public var playlist : [String] = []
    public var _songs =  [NSSound?] (repeating: nil, count: 7)
    override init() {
        
        super.init()
    }
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
 
    public func stopAll(except:Int)
    {
        for (i,song) in _songs.enumerated() where song != nil && i != except
        {
            song!.stop()
        }
    }
    public func stopAll()
    {
        for song in _songs where song != nil
        {
            song!.stop()
        }
    }
  
    public func volume(_ volume:Float)
    {
        for song in _songs where song != nil
        {
            song!.volume = volume
        }
    }
    public func playMusic(_ n: Int = 0) {
        guard n < 7 && playlist.count > n else { return }
        stopAll(except:n)
        guard Music.shared.isPlaying else {
            stopAll()
            return }
        guard let song = songs(n) else { return }
        
        song.loops = false
        song.volume =  Music.shared.volume
        if song.isPlaying {return}
        song.play()
    }
}
#else

import AVFoundation

 
public class MusicManager : NSObject, AVAudioPlayerDelegate
{
    public var playlist : [String] = []
    public var _songs =  [AVAudioPlayer?] (repeating: nil, count: 7)
    override init() {
        super.init()
        let _ = Audio.session
    }
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
    public func stopAll(except:Int)
    {
        for (i,song) in _songs.enumerated() where song != nil && i != except
        {
            song!.stop()
        }
    }
    public func stopAll()
    {
        for song in _songs where song != nil
        {
            song!.stop()
        }
    }
    public func volume(_ volume:Float)
    {
        for song in _songs where song != nil
        {
            song!.volume = volume
        }
    }
    public func playMusic(_ n: Int = 0) {
        guard n < 7 && playlist.count > n else { return }
        
        stopAll(except:n)
        guard Music.shared.isPlaying else {
            stopAll()
            return }
        guard let song = songs(n) else { return }
        
        song.numberOfLoops = -1
        song.volume =  Music.shared.volume
        if song.isPlaying {return}
        song.play()
    }
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    
}
#endif
