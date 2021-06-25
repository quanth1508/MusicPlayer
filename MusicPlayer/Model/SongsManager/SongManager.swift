//
//  SongManager.swift
//  MusicPlayer
//
//  Created by Quan Tran on 21/06/2021.
//

import Foundation

class SongManager {

    static var songs = [Song]()
    
    func fetchSongs() {
        
        SongManager.songs.append(Song(nameSong: "Bài Này Chill Phết", authorSong: "Đen Vâu ft. MIN", imageSong: "bai nay chill phet"))
        SongManager.songs.append(Song(nameSong: "Đưa Nhau Đi Trốn", authorSong: "Đen Vâu ft. Linh Cáo", imageSong: "dua nhau di tron"))
        SongManager.songs.append(Song(nameSong: "Let Her Go", authorSong: "Passenger", imageSong: "let her go"))
        SongManager.songs.append(Song(nameSong: "Lối Nhỏ", authorSong: "Đen Vâu ft. Phương Anh Đào", imageSong: "loi nho"))
        SongManager.songs.append(Song(nameSong: "Photograph", authorSong: "Ed Sheeran", imageSong: "photograph"))
        SongManager.songs.append(Song(nameSong: "Reality", authorSong: "Lost Frequencies", imageSong: "reality"))
        SongManager.songs.append(Song(nameSong: "See You Again", authorSong: "Wiz Khalifa ft. Charlie Puth", imageSong: "see you again"))
        SongManager.songs.append(Song(nameSong: "So Far Away", authorSong: "Martin Garrix & David Guetta", imageSong: "so far away"))
        SongManager.songs.append(Song(nameSong: "Thinking Out Loud", authorSong: "Ed Sheeran", imageSong: "thinking out loud"))
        SongManager.songs.append(Song(nameSong: "Until You", authorSong: "Shayne Ward", imageSong: "until you"))
        
    }
}
