//
//  MainViewController.swift
//  MusicPlayer
//
//  Created by Quan Tran on 21/06/2021.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    var songsManager = SongManager()
    var indexSongUpdate = 0
    var checkIsFirst = true
    var checkIsPlaying = true
    var playingSongWithPath = PlayingSongWithPath()
    var playerSong: AVAudioPlayer! = nil
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = UIImage(named: Constants.BrandColors.background)
        songsManager.fetchSongs()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.Identifiers.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.Identifiers.cellIdentifier)
        checkIsFirst = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        title = Constants.name
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue-Light", size: 25), size: 25)]
        let backButtonBarItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButtonBarItem.tintColor = UIColor(named: Constants.BrandColors.colorRunTimeSlider)
        navigationItem.backBarButtonItem = backButtonBarItem
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: Constants.BrandColors.colorRunTimeSlider)!]
        
        if !checkIsFirst {
            updateCurrentIsPlayingSong(indexSongUpdate)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if !checkIsFirst {
            playerSong.stop()
        }
    }

}

//MARK: - Extension UITableViewDataSource

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SongManager.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.cellIdentifier, for: indexPath) as! CustomTableViewCell
        let song = SongManager.songs[indexPath.row]
        cell.nameMusic.text = song.nameSong
        cell.authorMusic.text = song.authorSong
        cell.imageMusic.image = UIImage(named: song.imageSong)
        cell.selectionStyle = .none
        cell.state = .stopped
//        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height / 8.5
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0, y: cell.frame.height)

                UIView.animate(
                    withDuration: 1.0,
                    delay: 0.01 * Double(indexPath.row),
                    usingSpringWithDamping: 0.4,
                    initialSpringVelocity: 0.1,
                    options: [.curveEaseInOut],
                    animations: {
                        cell.transform = CGAffineTransform(translationX: 0, y: 0)
                })
        
    }
    
}

//MARK: - Extension UITableViewDataSource
    
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerVC = storyboard?.instantiateViewController(identifier: Constants.Identifiers.playerIdentifierVC) as! MusicPlayerViewController
        playerVC.nameOfSong = SongManager.songs[indexPath.row].nameSong
        playerVC.authorOfSong = SongManager.songs[indexPath.row].authorSong
        playerVC.imageOfSong = SongManager.songs[indexPath.row].imageSong
        
        playerVC.indexSong = indexPath.row
        playerVC.delegate = self
        
        navigationController?.pushViewController(playerVC, animated: true)
    }
    
}

//MARK: - Extension getDataSongDelegate

extension MainViewController: getDataSongDelegate {
    
    private func updateCurrentIsPlayingSong(_ index: Int) {
        let indexPathNew = IndexPath(row: index, section: 0)
        
        for cell in tableView.visibleCells as! [CustomTableViewCell] {
            cell.state = .stopped
        }
        
        let musicCell = tableView.cellForRow(at: indexPathNew)  as! CustomTableViewCell
        if checkIsPlaying {
            musicCell.state = .playing
        } else {
            musicCell.state = .paused
        }
    }
    
    func getCurrneIndexSong(_ indexSong: Int, _ checkIsPlaying: Bool) {
        indexSongUpdate = indexSong
        checkIsFirst = false
        self.checkIsPlaying = checkIsPlaying
//        print(indexSongUpdate)
    }
    
    func getSongPlayer(_ songPlayer: AVAudioPlayer) {
        self.playerSong = songPlayer
    }
}
