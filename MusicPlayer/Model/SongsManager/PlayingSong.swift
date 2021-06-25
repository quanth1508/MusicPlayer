//
//  PlayingSong.swift
//  MusicPlayer
//
//  Created by Quan Tran on 22/06/2021.
//

import Foundation
import AVFoundation


class PlayingSongWithPath {
    
    var songPlayer: AVAudioPlayer! = nil

    func playingSong(_ indexSong: Int, _ songs: Array<Song>) ->  AVAudioPlayer {

        let song = songs[indexSong]
        
        let path = Bundle.main.path(forResource: song.nameSong, ofType: "mp3")
        let url = URL(fileURLWithPath: path!)
        
        do {
            songPlayer = try AVAudioPlayer(contentsOf: url)

        }
        catch {
            print("could not load file .mp3 :(")
        }
        
        return songPlayer
    }
    
}
