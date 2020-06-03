//
//  VideoDownloadDataManager.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 20-01-20.
//  Copyright © 2020 Trust. All rights reserved.
//

import Foundation
import Alamofire

protocol VideoDownloadDataManagerProtocol: AnyObject {
    var managerOutput: VideoDownloadDataManagerOutputProtocol? { get set }

    func downloadVideo(url: String)
}

protocol VideoDownloadDataManagerOutputProtocol: AnyObject {
    func onDownloadSuccess(with url: URL)
    func onDownloadFailure()
}

class VideoDownloadDataManager: VideoDownloadDataManagerProtocol {
    
    var managerOutput: VideoDownloadDataManagerOutputProtocol?
    
    func downloadVideo(url: String) {
        
        var videoURL: URL?
        
        Alamofire.request(url)
        .downloadProgress(closure : { (progress) in
        print(progress.fractionCompleted)
        }).responseData{
        (response) in
           print(response)
           print(response.result.value!)
           print(response.result.description)
            if let data = response.result.value {

                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                videoURL = documentsURL.appendingPathComponent("video.mp4")
                guard let video = videoURL else {
                    return
                }
                do {
                    try data.write(to: video)
                    } catch {
                        self.managerOutput?.onDownloadFailure()
                }
                self.managerOutput?.onDownloadSuccess(with: video)
            }
        }
    }
    
}
