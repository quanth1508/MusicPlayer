//
//  CustomTableViewCell.swift
//  MusicPlayer
//
//  Created by Quan Tran on 21/06/2021.
//

import UIKit
import ESTMusicIndicator

class CustomTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet var imageMusic: UIImageView!
    @IBOutlet var nameMusic: UILabel!
    @IBOutlet var authorMusic: UILabel!
    @IBOutlet var musicIndicator: ESTMusicIndicatorView!
    
    var state: ESTMusicIndicatorViewState = .stopped {
        didSet {
            musicIndicator.state = state
        }
    }
    
    //MARK: - Override Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageMusic.layer.cornerRadius = imageMusic.frame.size.height / 2
        imageMusic.clipsToBounds = true
        
        nameMusic.numberOfLines = 0
        authorMusic.numberOfLines = 0
        
        musicIndicator.hidesWhenStopped = true
        musicIndicator.sizeToFit()
        musicIndicator.tintColor = UIColor(named: Constants.BrandColors.colorRunTimeSlider)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
}
