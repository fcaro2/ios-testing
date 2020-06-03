//
//  DialogViewController.swift
//  appNotifications
//
//  Created by Jesenia Salazar on 9/2/19.
//  Copyright © 2019 Cristian Parra. All rights reserved.
//

import UIKit
import MediaPlayer
import MaterialComponents
import Foundation

enum LoadingStatus {
    case loading
    case loaded
}

class DialogViewController: UIViewController {
    
    var presenter: DialogPresenterProtocol?
    var urlLeftButton: String?
    var urlRightButton: String?
    var data: NotificationInfo?
    
//    var viewState: LoadingStatus = .loaded {
//        didSet {
//            switch viewState {
//            case .loaded:
//               // activityIndicator.stopAnimating()
//                closeButton.isHidden = false
//                persistenceButton.isHidden = false
//            case .loading:
//                activityIndicator.startAnimating()
//                closeButton.isHidden = true
//                persistenceButton.isHidden = true
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var screenArea: UIView!
    @IBOutlet weak var dialogView: UIView!{
        didSet{
            dialogView.layer.cornerRadius = 5
            dialogView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            dialogView.layer.shadowRadius = 13
            dialogView.layer.shadowOpacity = 0.25
        }
    }
    @IBOutlet weak var persistenceButton: UIButton!{
        didSet{
            persistenceButton.addTarget(
                self,
                action: #selector(onPersistenceButtonPressed(sender:)),
                for: .touchUpInside)
        }
    }
    @IBOutlet weak var closeButton: UIButton!{
        didSet{
            let bundle = Bundle(for: DialogViewController.self)
            let buttonImage = UIImage(named: "close_icon", in: bundle, compatibleWith: nil)
            closeButton.setImage(buttonImage, for: .normal)
            closeButton.addTarget(
                self,
                action: #selector(onCloseButtonPressed(sender:)),
                for: .touchUpInside)
        }
    }
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 5
            imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var body: UILabel!{
        didSet{
            body.textAlignment = NSTextAlignment.center
            body.numberOfLines = 0
            body.lineBreakMode = .byWordWrapping
            body.sizeToFit()
        }
    }
    @IBOutlet weak var leftMargin: UIView!
    @IBOutlet weak var rightMargin: UIView!
    @IBOutlet weak var upperMargin: UIView!
    @IBOutlet weak var lowerMargin: UIView!

    @IBOutlet weak var buttonsMargin: UIView!{
        didSet{
            buttonsMargin.clipsToBounds = true
            buttonsMargin.layer.cornerRadius = 5
            buttonsMargin.layer.maskedCorners = [.layerMinXMaxYCorner]

        }
    }
    
    /**
     Left button, in case that the notification has two buttons
     */
    @IBOutlet weak var buttonL: MDCButton!{
        didSet{
            buttonL.addTarget(
                self,
                action: #selector(onLeftButtonPressed(sender:)),
                for: .touchUpInside)
        }
    }
    
    /**
     Right button, in case that the notification has one or two buttons
     */
    @IBOutlet weak var buttonR: MDCButton!{
        didSet{
            buttonR.addTarget(
                self,
                action: #selector(onRightButtonPressed(sender:)),
                for: .touchUpInside)
        }
    }
    
    
    /**
     This function is call in case that you have a video notification with two buttons, and the left button is pressed.
     */
    @objc func onLeftButtonPressed(sender: UIButton) {
        presenter?.onActionButtonPressed(action: urlLeftButton!)
    }
    
    /**
     This function is call in case that you have a video notification with one or two buttons, and the right (or only) button is pressed.
     */
    @objc func onRightButtonPressed(sender: UIButton) {
        presenter?.onActionButtonPressed(action: urlRightButton!)
    }
    
    @objc func onCloseButtonPressed(sender: UIButton) {
        presenter?.onCloseButtonPressed()
    }
    
    @objc func onPersistenceButtonPressed(sender: UIButton) {
        presenter?.onCloseButtonPressed()
    }
}

extension DialogViewController: DialogViewProtocol{
    
    func fillDialog() {
        if(data != nil){
            //setViewState(state: .loading)
            dialogView.frame = CGRect(x:0, y: 0, width: 0.9 * screenArea.frame.width, height: 0.2 * screenArea.frame.height)
            presenter?.verifyImageURL(imageUrl: data?.dialogNotification?.imageUrl ?? "")
            setCloseButton(cancelable: data?.dialogNotification?.isCancelable ?? true)
            setPersistenceButton(persistence: data?.dialogNotification?.isPersistent ?? false)
            setBody(text: data?.dialogNotification?.textBody ?? "")
            setActionButtons(buttons: data?.dialogNotification?.buttons ?? [])
            //setViewState(state: .loaded)
        }
    }

//    func setViewState(state: LoadingStatus) {
//        viewState = state
//    }
    func setBackground(color: backgroundColor){
        switch color {
        case .SOLID:
            view.backgroundColor = UIColor(red:0.17, green:0.16, blue:0.16, alpha:1)
        case .TRANSPARENT:
            view.backgroundColor = UIColor(red:0.17, green:0.16, blue:0.16, alpha:0.6)
        case .NO_BACKGROUND:
            view.backgroundColor = UIColor.clear
        }
    }
    
    func setCloseButton(cancelable: Bool) {
        if(!(cancelable)){
            closeButton.isEnabled = false
            closeButton.isHidden = true
        }else{
            closeButton.isEnabled = true
            closeButton.isHidden = false
        }
    }
    
    func setImage(image: URL) {
        imageView.load(url: image)
        imageView.contentMode = .scaleAspectFill
    }
    
    func setPersistenceButton(persistence: Bool) {
        if(!(persistence)){
            persistenceButton.isEnabled = true
            persistenceButton.isHidden = false
            setBackground(color: .NO_BACKGROUND)
        }else{
            persistenceButton.isEnabled = false
            persistenceButton.isHidden = true
            setBackground(color: .TRANSPARENT)
        }
    }
    
    func setBody(text: String){
        if(text != ""){
            body.text = text
            let aspectRatioConstraint = NSLayoutConstraint(item: self.imageView,attribute: .height,relatedBy: .equal,toItem: self.imageView,attribute: .width, multiplier: (320.0 / 340.0),constant: 0)
            self.imageView.addConstraint(aspectRatioConstraint)
        }else{
            body.isHidden = true
            leftMargin.isHidden = true
            rightMargin.isHidden = true
            upperMargin.isHidden = true
            lowerMargin.isHidden = true
            labelStackView.isHidden = true
            let aspectRatioConstraint = NSLayoutConstraint(item: self.imageView,attribute: .height,relatedBy: .equal,toItem: self.imageView,attribute: .width, multiplier: (400.0 / 340.0),constant: 0)
            self.imageView.addConstraint(aspectRatioConstraint)
        }
    }
    
    func setActionButtons(buttons: [Button]) {
            
            let buttonCounter = buttons.count
        
            if buttonCounter == 0{
                buttonsMargin.isHidden = true
                buttonL.isHidden = true
                buttonR.isHidden = true
            }
            
            if(buttonCounter == 1){
                
                buttonL.isHidden = true
                buttonR.setTitle(buttons[0].text , for: .normal)
                buttonR.setupButtonWithType(color: buttons[0].color, type: .whiteButton, mdcType: .text)
                urlRightButton = buttons[0].action
            }
            
            if(buttonCounter == 2){
                
                buttonL.setTitle(buttons[1].text , for: .normal)
                buttonL.setupButtonWithType(color: buttons[1].color, type: .whiteButton, mdcType: .text)
                urlLeftButton = buttons[1].action
                buttonR.setTitle(buttons[0].text , for: .normal)
                buttonR.setupButtonWithType(color: buttons[0].color, type: .whiteButton, mdcType: .text)
                urlRightButton = buttons[0].action
                
            }
    }
}
