//
//  MusicPlayerViewController.swift
//  MusicPlayer
//
//  Created by Quan Tran on 21/06/2021.
//

import UIKit
import AVFoundation
import ESTMusicIndicator

protocol getDataSongDelegate {
    func getCurrneIndexSong(_ indexSong: Int, _ stateIsPlaying: Bool)
    func getSongPlayer(_ songPlayer: AVAudioPlayer)
}

class MusicPlayerViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var imageSong: UIImageView!
    @IBOutlet var nameSong: UILabel!
    @IBOutlet var authorSong: UILabel!
    @IBOutlet var startRunTimeMusic: UILabel!
    @IBOutlet var endRunTimeMusic: UILabel!
    @IBOutlet var runTimeSlider: UISlider!
    @IBOutlet var changeVolume: UISlider!
    @IBOutlet var pauseSong: UIButton!
    @IBOutlet var nextSong: UIButton!
    @IBOutlet var forwardSong: UIButton!
    @IBOutlet var shuffleSong: UIButton!
    @IBOutlet var repeatSong: UIButton!
    
    var nameOfSong: String?
    var authorOfSong: String?
    var imageOfSong: String?
    
    var indexSong = 0
    var animatePlaying: ESTMusicIndicatorView!
    
    private var songPlayer: AVAudioPlayer! = nil
    
    private var timer: Timer?
    private var lengthOfSong = 0.0
    private var shuffleState = false
    private var newIndexSong = 0
    private var repeatState = false
    private var buttonRepeatCounter = 0
    
    var delegate: getDataSongDelegate?
    var stateIsPlaying: Bool = true
    var playingSongWithPath = PlayingSongWithPath()
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = UIImage(named: Constants.BrandColors.background)
        fetchUI(indexSong)
        playingSong(indexSong)
        changeRunTimeSlider()
        changeVolumSlider()
        imageSong.layer.cornerRadius = imageSong.frame.size.width / 21
        imageSong.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Music Player"
        creatItemBar()
//        stop()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        animatePlaying.isHidden = true
        if songPlayer.isPlaying {
            stateIsPlaying = true
        } else {
            stateIsPlaying = false
        }
        delegate?.getCurrneIndexSong(indexSong, stateIsPlaying)
        delegate?.getSongPlayer(songPlayer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        stop()
    }
    
    //MARK: - Functions
    
    private func creatItemBar() {
        let screenSize = UIScreen.main.bounds
        animatePlaying = ESTMusicIndicatorView.init(frame: CGRect(origin: CGPoint(x: (screenSize.width - 50), y: 0), size: CGSize(width: 60, height: 55)))
        animatePlaying.tintColor = UIColor(named: Constants.BrandColors.colorRunTimeSlider)
        animatePlaying.hidesWhenStopped = false
        animatePlaying.tintColor = UIColor.red
        animatePlaying.state = .playing
        navigationController?.navigationBar.addSubview(animatePlaying)
    }
    
    private func fetchUI (_ indexSong: Int) {
        let song = SongManager.songs[indexSong]
        imageSong.image = UIImage(named: song.imageSong)
        nameSong.text = song.nameSong
        authorSong.text = song.authorSong
        authorSong.textColor = UIColor(named: Constants.BrandColors.colorRunTimeSlider)
    }
    
    private func playingSong(_ indexSong: Int) {
        // Set up and active the session.
        let session = AVAudioSession.sharedInstance()
            do {
                try session.setActive(true)
                try session.setCategory(.playback, mode: .default,  options: .defaultToSpeaker)
            } catch let error {
                fatalError("*** Unable to set up the audio session: \(error.localizedDescription) ***")
            }
        
        songPlayer = playingSongWithPath.playingSong(indexSong, SongManager.songs)
                                                     
        songPlayer.delegate = self
        
        lengthOfSong = songPlayer.duration
        runTimeSlider.maximumValue = Float(songPlayer.duration)
        runTimeSlider.minimumValue = 0.0
        runTimeSlider.value = 0.0
        startTimer()
        showTimeOfSong()
        changeVolume.value = UserDefaults.standard.float(forKey: "changeVolume")
        
        self.songPlayer?.play()
        
    }
    
    private func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
            timer?.fire()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    @objc func updateTimer(_ timer: Timer) {
        let time = calculateTimeFromTimeInterval(songPlayer.currentTime)
        startRunTimeMusic.text = "\(time.minute):\(time.second)"
        runTimeSlider.value = Float(songPlayer.currentTime)
    }
    
    // Set up start time and end time lables to display
    private func showTimeOfSong() {
        let time = calculateTimeFromTimeInterval(lengthOfSong)
        endRunTimeMusic.text = "\(time.minute):\(time.second)"
    }
    
    // This returns song length
    private func calculateTimeFromTimeInterval(_ duration: TimeInterval) -> (minute: String, second: String) {
        let minute = abs(Int((duration / 60)))
        let second = abs(Int(duration.truncatingRemainder(dividingBy: 60)))
        let minuteReturn = minute > 9 ? "\(minute)" : "0\(minute)"
        let secondReturn = second > 9 ? "\(second)" : "0\(second)"
        return (minuteReturn, secondReturn)
    }
    
    private func stop() {
        songPlayer.stop()
        timer?.invalidate()
        timer = nil
    }
    
    private func playNextSong() {
        stop()
        if indexSong == SongManager.songs.count - 1 {
            indexSong = 0
            playingSong(indexSong)
        } else {
            indexSong = indexSong + 1
            playingSong(indexSong)
        }
        fetchUI(indexSong)
    }
    
    private func playForwardSong() {
        stop()
        if indexSong == 0 {
            indexSong = SongManager.songs.count - 1
            playingSong(indexSong)
        } else {
            indexSong = indexSong - 1
            playingSong(indexSong)
        }
        fetchUI(indexSong)
    }
    
    // change time in slider
    private func changeRunTimeSlider() {
        runTimeSlider.setThumbImage(UIImage(named: "barSlider"), for: .normal)
        runTimeSlider.minimumTrackTintColor = UIColor(named: Constants.BrandColors.colorRunTimeSlider)
        
        runTimeSlider.addTarget(self, action: #selector(changeRunTime(_:)), for: .valueChanged)
    }
    
    // change volume in slider
    private func changeVolumSlider() {
        let currentVolome = UserDefaults.standard.float(forKey: "changeVolume")
        
        if currentVolome != 0 {
            changeVolume.value = currentVolome
        } else {
            changeVolume.value = 0.6
        }
        
        changeVolume.setThumbImage(UIImage(named: "barSlider"), for: .normal)
        changeVolume.minimumValueImage = UIImage(systemName: "speaker.fill")
        changeVolume.minimumTrackTintColor = UIColor(named: Constants.BrandColors.colorChangeVolume)
        changeVolume.maximumValueImage = UIImage(systemName: "speaker.wave.3.fill")
        
        changeVolume.addTarget(self, action: #selector(changeVolum(_:)), for: .valueChanged)
    }
    
    private func activeAnimateImageSong() {
        UIView.animate(withDuration: 0.26, delay: 0, options: [.curveEaseInOut], animations: {
            self.imageSong.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
        }, completion: nil)
    }
    
    @objc func changeVolum(_ slider: UISlider) {
        songPlayer.volume = slider.value
        UserDefaults.standard.set(slider.value, forKey: "changeVolume")
    }
    
    @objc func changeRunTime(_ slider: UISlider) {
        if songPlayer.isPlaying == true {
            songPlayer.pause()
            songPlayer.currentTime = TimeInterval(runTimeSlider.value)
            songPlayer.play()
        } else {
            songPlayer.pause()
            songPlayer.currentTime = TimeInterval(runTimeSlider.value)
        }
    }
    
    //MARK: - Action
    
    @IBAction func didTapPlaySong(_ sender: UIButton) {
        if songPlayer?.isPlaying == true {
            songPlayer?.pause()
            pauseSong.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            
            activeAnimateImageSong()
            animatePlaying.state = .paused
        } else {
            pauseSong.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            songPlayer?.play()
            
            UIView.animate(withDuration: 0.26, delay: 0, options: [.curveEaseInOut], animations: {
                self.imageSong.transform = .identity
            }, completion: nil)
            
            animatePlaying.state = .playing

        }
    }
    
    @IBAction func didTapForwardSong(_ sender: UIButton) {
        playForwardSong()
    }
    
    @IBAction func didTapNextSong(_ sender: UIButton) {
        playNextSong()
    }
    
    @IBAction func didTapRepeatSong(_ sender: UIButton) {
        buttonRepeatCounter += 1
        switch buttonRepeatCounter {
        case 1:
            repeatState = true
            repeatSong.setBackgroundImage(UIImage(systemName: "repeat.1"), for: .normal)
            repeatSong.tintColor = .black
        case 2:
            repeatState = true
            repeatSong.setBackgroundImage(UIImage(systemName: "repeat"), for: .normal)
            repeatSong.tintColor = .black
        default:
            buttonRepeatCounter = 0
            repeatState = false
            repeatSong.setBackgroundImage(UIImage(systemName: "repeat"), for: .normal)
            repeatSong.tintColor = .lightGray
        }
//        print(buttonRepeatCounter)
    }
    
    @IBAction func didTapShuffleSong(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            shuffleState = false
            shuffleSong.setBackgroundImage(UIImage(systemName: "shuffle"), for: .normal)
            shuffleSong.tintColor = .lightGray
        } else {
            sender.isSelected = true
            shuffleState = true
            shuffleSong.setBackgroundImage(UIImage(systemName: "shuffle"), for: .focused)
            shuffleSong.tintColor = .black
        }
    }
}

//MARK: -  Extension AvAudioPlayerDelegate

/*
 logic play when i choose button shuffle, repeat the song
 */

extension MusicPlayerViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            if !shuffleState, !repeatState {
                if indexSong == SongManager.songs.count - 1 {
                    pauseSong.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
                    animatePlaying.state = .paused
                    activeAnimateImageSong()
                    return
                } else {
                    fetchUI(indexSong)
                    playNextSong()
                }
            } else if (!shuffleState || shuffleState), buttonRepeatCounter == 1 {
                playingSong(indexSong)
            } else if !shuffleState, buttonRepeatCounter == 2 {
                fetchUI(indexSong)
                playNextSong()
            } else if shuffleState, (buttonRepeatCounter == 0 || buttonRepeatCounter == 2) {
                repeat {
                    newIndexSong = Int.random(in: 0...SongManager.songs.count - 1)
                } while newIndexSong == indexSong
                
                indexSong = newIndexSong
                fetchUI(indexSong)
                playingSong(indexSong)
            }
        }
    }
    
}
