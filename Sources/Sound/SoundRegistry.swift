//
//  SoundRegistry.swift
//
//  Created by Geoff Burns on 28/9/21.
//

import Combine
import SwiftUI

public protocol IResourceRepository {
     func url(_ url: String) -> URL?
}
public protocol IResourceRegistry
{
     func register(_ repo : IResourceRepository)
     func url(_ url: String) -> URL?
}
public class SoundRegistry : IResourceRegistry
{
    public var registry : [IResourceRepository] = []
    
    public func register(_ repo : IResourceRepository)
    {
        registry.append(repo)
    }
    public func url(_ url: String) -> URL?
    {
        for  repo in registry
        {
            if let sound = repo.url(url)
            {
                return sound
            }
        }
        return Bundle.module.url(forResource: url, withExtension: "mp3")
    //    return Bundle.module.url(forResource: url, withExtension: "m4a") ?? Bundle.module.url(forResource: url, withExtension: "mp3")
    }
}
public class MusicRegistry : IResourceRegistry
{
    public var registry : [IResourceRepository] = []
    
    public func register(_ repo : IResourceRepository)
    {
        registry.append(repo)
    }
    public func url(_ url: String) -> URL?
    {
        for  repo in registry
        {
            if let sound = repo.url(url)
            {
                return sound
            }
        }
  //      return Bundle.module.url(forResource: url, withExtension: "mp3")
        return nil
    }
}

