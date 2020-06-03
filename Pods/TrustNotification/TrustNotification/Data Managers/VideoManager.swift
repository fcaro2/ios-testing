//
//  VideoManager.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 18-03-20.
//  Copyright © 2020 Trust. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import MaterialComponents
import MediaPlayer
import AudioToolbox

enum audioState{
    case enabled
    case disabled
}

protocol VideoManagerDelegate: AnyObject{
    func onStartPaused()
    func onStartSilent()
    func playerDidFinishPlaying()
    func onTimeProtected()
    
   
}

class VideoManager{
    var player: AVPlayer?
    let controller = AVPlayerViewController()
    var videoURL: URL?
    
    var notificationSpecificsDelegate: VideoManagerDelegate?
    
    func videoInit(){
        player = AVPlayer(url: videoURL!)
        controller.player = player
        addObservers()
        player?.play()
        notificationSpecificsDelegate?.onTimeProtected()
    }
    
    func closePlayer(){
        removeObservers()
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
    }
    func videoReplay(){
        player?.seek(to: CMTime.zero)
        player?.play()
        notificationSpecificsDelegate?.onTimeProtected()
    }
    func mutePlayer(){
        player?.isMuted = true
    }
    func unmutePlayer(){
        player?.isMuted = false
    }
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerFail), name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerTimeJumped), name: .AVPlayerItemTimeJumped, object: nil)

    }
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func playerDidFinishPlaying(){notificationSpecificsDelegate!.playerDidFinishPlaying()}
    @objc func playerFail(){}
    @objc func playerTimeJumped(){}
}
