//
//  VideoView.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 20-03-20.
//  Copyright © 2020 Trust. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class VideoView: UIView {
    var playerLayer: AVPlayerLayer {
        guard let layer = layer as? AVPlayerLayer else {
            fatalError("Layer expected is of type VideoPreviewLayer")
        }
        return layer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
