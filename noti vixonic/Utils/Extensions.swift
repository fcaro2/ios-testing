//
//  Extensions.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import Alamofire
import ObjectMapper
import UIKit
import MaterialComponents
import RealmSwift


// MARK: - Extension UIApplication
extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}

// MARK: -  Typealias
typealias CompletionHandler = (()->Void)?
typealias SuccessHandler<T> = ((T)-> Void)?

// MARK: - App Strings / Constants / Default values
extension String {
    static let empty = ""
    static let zero = "0"
    
    static let defaultAcceptActionTitle = "Aceptar"
    static let defaultAlertTitle = "Atención"
    static let defaultAlertMessage = "Ha ocurrido un error, vuelta a intentar más tarde"
    static let cancel = "Cancelar"
    static let ok = "OK"
    
    static let passwordPattern = "\\b^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$\\b"
    static let passwordsDontMatch = "Contraseñas no coinciden"
    
    static let notAValidRut = "No es un RUT válido"
    static let thereIsNoAvailableBrowser = "No hay un navegador disponible"
    static let noEmptyPassword = "Debe ingresar su contraseña para continuar"
    
    static let selectDocuments = "Seleccionar documentos"
    static let signed = "FIRMADO"
    
    static let appLocale = "es_CL"
    static let yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    static let ddMMyyyyHHmmss = "dd/MM/yyyy HH:mm:ss"
    static let ddMMMHHmm = "dd MMM / HH:mm"
    static let dMy = "d/M/y"
}

extension String {
    func parse() -> String {
        print(self)
        guard self.contains(".") else {
            let auxDv = self.last!
            let auxDni1 = self.dropLast(2)
            let auxDni2 = String(auxDni1)
            let leftDniSide = auxDni2.addDecimalDots()!
            return "\(leftDniSide) - \(auxDv)"
        }
        return self
    }
}

// MARK: - App Ints / Constants / Default values
extension Int {
    static let defaultIntValue = -1
}

// MARK: - CustomStringConvertible
extension CustomStringConvertible {
    var description: String {
        var description: String = .empty
        let selfMirror = Mirror(reflecting: self)
        
        for child in selfMirror.children {
            if let propertyName = child.label {
                description += "\(propertyName): \(child.value)\n"
            }
        }
        
        return description
    }
}

// MARK: - Extension UserDefaults
extension UserDefaults {
    struct OAuth2URLData: StringUserDefaultable {
        enum StringDefaultKey: String {
            case code
            case acrValues = "acr_values"
            case scope
            case sessionID = "session_id"
            case state
            case sessionState = "session_state"
        }
    }
    
    static func deleteAll() {
        let dictionary = UserDefaults.standard.dictionaryRepresentation()
        
        dictionary.keys.forEach {
            (key) in
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}

// MARK: - Date
extension Date {
    func toString(with format: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: .appLocale)
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}

// MARK: - Injectable
protocol Injectable {
    associatedtype Item
    
    func inject(item: Item)
    func assertDependencies(items: Item?...)
}

extension Injectable {
    func assertDependencies(items: Item?...) {
        _ = items.map {item in assert(item != nil)}
    }
}

// MARK: - Int
extension Int {
    func addDecimalDotsAndReturnAsString() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: .appLocale)
        
        return numberFormatter.string(from: NSNumber(value: self))
    }
    
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
}

// MARK: - MDCTextInputControllerFilled
extension MDCTextInputControllerFilled {
    func set(errorText: String?) {
        self.setErrorText(errorText, errorAccessibilityValue: errorText)
    }
}

// MARK: - UIBarButtonItem
extension UIBarButtonItem {
    func enable(tintColor: UIColor? = .orange) {
        
        guard let tintColor = tintColor else {
            return
        }
        
        self.tintColor = tintColor
        self.isEnabled = true
    }
    
    func disable(alpha: CGFloat = 0.5) {
        guard let currentTintColor = self.tintColor else {
            return
        }
        
        self.tintColor = currentTintColor.withAlphaComponent(alpha)
        self.isEnabled = false
    }
}

// MARK: - UIControl
extension UIControl {
    func enable(animated: Bool = true) {
        self.set(alpha: 1, animated: animated)
        self.isEnabled = true
    }
    
    func disable(animated: Bool = true) {
        self.set(alpha: 0.7, animated: animated)
        self.isEnabled = false
    }
}

// MARK: - UIImage
extension UIImage {
    
    /// Represents a scaling mode
    enum ScalingMode {
        case aspectFill
        case aspectFit
        
        /// Calculates the aspect ratio between two sizes
        ///
        /// - parameters:
        ///     - size:      the first size used to calculate the ratio
        ///     - otherSize: the second size used to calculate the ratio
        ///
        /// - return: the aspect ratio between the two sizes
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width/otherSize.width
            let aspectHeight = size.height/otherSize.height
            
            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }
    
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    ///
    /// - parameter:
    ///     - newSize:     the size of the bounds the image must fit within.
    ///     - scalingMode: the desired scaling mode
    ///
    /// - returns: a new scaled image.
    func scaled(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFit) -> UIImage {
        
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
        
        /* Build the rectangle representing the area to be drawn */
        var scaledImageRect = CGRect.zero
        
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        
        /* Draw and retrieve the scaled image */
        UIGraphicsBeginImageContext(newSize)
        
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}

// MARK: - Extension UILabel
extension UILabel {
    func clearText() {
        self.text = .empty
    }
}

// MARK: - Extension UITextField
extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            
            guard let placeholder = self.placeholder, let newValue = newValue else {
                
                self.attributedPlaceholder = NSAttributedString(
                    string: .empty,
                    attributes:[
                        .foregroundColor: placeHolderColor!
                    ]
                )
                
                return
            }
            
            self.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes:[
                    .foregroundColor: newValue
                ]
            )
        }
    }
    
    func clearText() {
        self.text = .empty
    }
}

// MARK: - Extension UIView
extension UIView {
    
    var defaultAnimationDuration: TimeInterval {
        return 0.25
    }
    
    func hide(animated: Bool = true) {
        
        guard animated else {
            self.isHidden = !animated
            return
        }
        
        DispatchQueue.main.async {
            [weak self] in
            
            guard let `self` = self else {
                return
            }
            
            self.alpha = 1
            
            UIView.animate(withDuration: self.defaultAnimationDuration) {
                self.alpha = 0
                self.isHidden = animated
            }
        }
    }
    
    func show(animated: Bool = true) {
        
        guard animated else {
            self.isHidden = animated
            return
        }
        
        DispatchQueue.main.async {
            [weak self] in
            
            guard let `self` = self else {
                return
            }
            
            self.alpha = 0
            
            UIView.animate(withDuration: self.defaultAnimationDuration) {
                self.alpha = 1
                self.isHidden = !animated
            }
        }
    }
    
    func set(alpha value: CGFloat, animated: Bool = true) {
        
        guard animated else {
            self.alpha = value
            return
        }
        
        DispatchQueue.main.async {
            [weak self] in
            
            guard let self = self else {
                return
            }
            
            UIView.animate(withDuration: self.defaultAnimationDuration) {
                self.alpha = value
            }
        }
    }
    
    func changeBorder(to newWidth: Double, animated: Bool = true) {
        
        guard animated else {
            self.borderWidth = CGFloat(newWidth)
            return
        }
        
        DispatchQueue.main.async {
            [weak self] in
            
            guard let `self` = self else {
                return
            }
            
            UIView.animate(withDuration: self.defaultAnimationDuration) {
                self.borderWidth = CGFloat(newWidth)
            }
        }
    }
    
    func changeBackgroundColor(to color: UIColor, animated: Bool = true) {
        
        guard animated else {
            self.backgroundColor = color
            return
        }
        
        DispatchQueue.main.async {
            [weak self] in
            
            guard let `self` = self else {
                return
            }
            
            UIView.animate(withDuration: self.defaultAnimationDuration) {
                self.backgroundColor = color
            }
        }
    }
}

// MARK: - Extension UIView IBInspectable
extension UIView {
    @IBInspectable
    var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    @IBInspectable
    var layerCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

// MARK: - Extension UIViewController
extension UIViewController {
    var safeAreaHeight: CGFloat {
        return self.view.safeAreaLayoutGuide.layoutFrame.size.height
    }
    
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    enum AlertViewTypes {
        case emptyAlert
        case genericError
        case customAlert(title: String, message: String)
        case customMessage(message: String)
    }
    
    enum NavigationBarColors {
        case empty
        case white
        case orange
    }
    
    func copyStringToPasteboard(string: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = string
    }
    
    func getStringFromPasteboard() -> String? {
        let pasteboard = UIPasteboard.general
        return pasteboard.string
    }
    
    func openUrlOnBrowser(url: String) {
        
        guard let url = URL(string: url) else {
            presentAlertView(type: .genericError)
            return
        }
        
        openUrlOnBrowser(url: url)
    }
    
    func openUrlOnBrowser(url: URL) {
        
        guard UIApplication.shared.canOpenURL(url) else {
            presentAlertView(type: .customMessage(message: .thereIsNoAvailableBrowser))
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
    
    func presentAlertView(type: AlertViewTypes, acceptAction: ((UIAlertAction) -> Void)? = nil, cancelAction: ((UIAlertAction) -> Void)? = nil) {
        
        var alertTitle: String = .defaultAlertTitle
        var alertMessage: String = .empty
        
        switch (type) {
        case .genericError:
            alertMessage = .defaultAlertMessage
        case .customMessage(let message):
            alertMessage = message
        case .emptyAlert:
            break
        case .customAlert(let title, let message):
            alertTitle = title
            alertMessage = message
        }
        
        let alertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(
                title: .defaultAcceptActionTitle,
                style: .default,
                handler: acceptAction
            )
        )
        
        if let cancelAction = cancelAction {
            alertController.addAction(
                UIAlertAction(
                    title: .cancel,
                    style: .cancel,
                    handler: cancelAction
                )
            )
        }
        
        applyDefaultAlertStyle(
            alertController: alertController,
            alertTitle: alertTitle,
            alertMessage: alertMessage
        )
        
        self.present(
            alertController,
            animated: true
        )
    }
    
    func applyDefaultAlertStyle(alertController: UIAlertController, alertTitle: String, alertMessage: String) {
        
        alertController.view.tintColor = .lightishBlue
        
        let attributedTitle = NSMutableAttributedString(
            string: alertTitle,
            attributes: [
                .font: UIFont(name: "Roboto-Bold", size: 17.0)!,
                .foregroundColor: UIColor(white: 33.0 / 255.0, alpha: 1.0)
            ]
        )
        
        let attributedMessage = NSMutableAttributedString(
            string: alertMessage,
            attributes: [
                .font: UIFont(name: "Roboto-Regular", size: 13.0)!,
                .foregroundColor: UIColor(white: 33.0 / 255.0, alpha: 1.0)
            ]
        )
        
        alertController.setValue(
            attributedTitle,
            forKey: "attributedTitle"
        )
        
        alertController.setValue(
            attributedMessage,
            forKey: "attributedMessage"
        )
    }
    
    func sendEmail(with body: String) {
        
        let subject = ""
        
        guard
            let coded = "mailto:?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let emailURL = URL(string: coded) else {
                return
        }
        
        guard UIApplication.shared.canOpenURL(emailURL) else {
            return
        }
        
        UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
    }
    
    func setNavigationBar(tintColor: UIColor? = nil, titleFont: UIFont? = nil, leftBarButtomItemTintColor: UIColor? = nil, rightBarButtomItemTintColor: UIColor? = nil, barButtonItemFont: UIFont? = nil, hasShadow: Bool = true, isTranslucent: Bool = true) {
        
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        navigationBar.isTranslucent = isTranslucent
        
        if !hasShadow {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        }
        
        if let barTintColor = tintColor {
            navigationBar.barTintColor = barTintColor
        }
        
        if let titleFont = titleFont {
            navigationBar.titleTextAttributes = [.font: titleFont]
        }
        
        if let leftItem = navigationItem.leftBarButtonItem {
            if let leftBarButtomItemTintColor = leftBarButtomItemTintColor {
                leftItem.tintColor = leftBarButtomItemTintColor
            }
            
            if let barButtonItemFont = barButtonItemFont {
                leftItem.setTitleTextAttributes(
                    [.font: barButtonItemFont],
                    for: .normal
                )
            }
        }
        
        if let rightItem = navigationItem.rightBarButtonItem {
            if let rightBarButtomItemTintColor = rightBarButtomItemTintColor {
                rightItem.tintColor = rightBarButtomItemTintColor
            }
            
            if let barButtonItemFont = barButtonItemFont {
                rightItem.setTitleTextAttributes(
                    [.font: barButtonItemFont],
                    for: .normal
                )
            }
        }
    }
    
    /*func setupNavigationBar(navigationBarColor: NavigationBarColors = .white) {
        
        guard let navigationBar = self.navigationController?.navigationBar else {
            return
        }
        
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Lato-Bold", size: 18)!], for: UIControlState())
        
        var color: UIColor?
        
        switch navigationBarColor {
        case .empty:
            color = .white
            
            if let leftItem = self.navigationItem.leftBarButtonItem {
                leftItem.disable(alpha: 0)
            }
            
            if let rightItem = self.navigationItem.rightBarButtonItem {
                rightItem.disable(alpha: 0)
            }
            
        case .white:
            color = .white
            
        case .orange:
            navigationBar.isTranslucent = true
            color = .orange
        }
        
        navigationBar.barTintColor = color
        navigationBar.tintColor = .white
    }*/
    
    func toggleNavigationBarVisibility(showNavigationBar status: Bool) {
        guard let nc = self.navigationController else {
            return
        }
        
        nc.setNavigationBarHidden(!status, animated: false)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func animateConstraintChanges(constraintChanges: () -> Void, completion: CompletionHandler = nil) {
        
        constraintChanges()
        
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.view.layoutIfNeeded()
        }
        ) { _ in
            
            guard let completion = completion else {
                return
            }
            
            completion()
        }
    }
    
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}

// MARK: - DataSourceable
protocol DataSourceable: AnyObject {
    associatedtype DataSourceType
    
    var dataSource: DataSourceType? {get set}
    func set(dataSource: DataSourceType)
}

extension DataSourceable {
    func set(dataSource: DataSourceType) {
        self.dataSource = dataSource
    }
}

// MARK: - KeyNamespaceable
protocol KeyNamespaceable {}

extension KeyNamespaceable {
    static func namespace<T>(_ key: T) -> String where T: RawRepresentable {
        return "\(Self.self).\(key.rawValue)"
    }
}

// MARK: - StringUserDefaultable
protocol StringUserDefaultable: KeyNamespaceable {
    associatedtype StringDefaultKey: RawRepresentable
}

extension StringUserDefaultable where StringDefaultKey.RawValue == String {
    static func set(_ value: String, forKey key: StringDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func string(forKey key: StringDefaultKey) -> String? {
        let key = namespace(key)
        return UserDefaults.standard.string(forKey: key)
    }
    
    static func remove(forKey key: StringDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.removeObject(forKey: key)
    }
}

// MARK: - BoolUserDefaultable
protocol BoolUserDefaultable: KeyNamespaceable {
    associatedtype BoolDefaultKey: RawRepresentable
}

extension BoolUserDefaultable where BoolDefaultKey.RawValue == String {
    static func set(_ value: Bool, forKey key: BoolDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(value, forKey: key)
    }
    static func bool(forKey key: BoolDefaultKey) -> Bool {
        let key = namespace(key)
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func remove(forKey key: BoolDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.removeObject(forKey: key)
    }
}

// MARK: - Parameterizable
protocol Parameterizable {
    var asParameters: Parameters {get}
}

// MARK: - Routable
protocol Routable {
    associatedtype StoryboardIdentifier: RawRepresentable
    
    func present<T: UIViewController>(storyboard: StoryboardIdentifier, identifier: String?, animated: Bool, modalPresentationStyle: UIModalPresentationStyle?, modalTransitionStyle: UIModalTransitionStyle?, configure: ((T) -> Void)?, completion: ((T) -> Void)?)
    func show<T: UIViewController>(storyboard: StoryboardIdentifier, identifier: String?, configure: ((T) -> Void)?)
    func showDetailViewController<T: UIViewController>(storyboard: StoryboardIdentifier, identifier: String?, configure: ((T) -> Void)?)
}

extension Routable where Self: UIViewController, StoryboardIdentifier.RawValue == String {
    
    /**
     Presents the intial view controller of the specified storyboard modally.
     
     - parameter storyboard: Storyboard name.
     - parameter identifier: View controller name.
     - parameter configure: Configure the view controller before it is loaded.
     - parameter completion: Completion the view controller after it is loaded.
     */
    func present<T: UIViewController>(storyboard: StoryboardIdentifier, identifier: String? = nil, animated: Bool = true, modalPresentationStyle: UIModalPresentationStyle? = nil, modalTransitionStyle: UIModalTransitionStyle? = nil, configure: ((T) -> Void)? = nil, completion: ((T) -> Void)? = nil) {
        RoutingLogic.present(delegate: self, storyboard: storyboard.rawValue, identifier: identifier, animated: animated, modalPresentationStyle: modalPresentationStyle, modalTransitionStyle: modalTransitionStyle, configure: configure, completion: completion)
    }
    
    /**
     Present the intial view controller of the specified storyboard in the primary context.
     Set the initial view controller in the target storyboard or specify the identifier.
     
     - parameter storyboard: Storyboard name.
     - parameter identifier: View controller name.
     - parameter configure: Configure the view controller before it is loaded.
     */
    func show<T: UIViewController>(storyboard: StoryboardIdentifier, identifier: String? = nil, configure: ((T) -> Void)? = nil) {
        RoutingLogic.show(delegate: self, storyboard: storyboard.rawValue, identifier: identifier, configure: configure)
    }
    
    /**
     Present the intial view controller of the specified storyboard in the secondary (or detail) context.
     Set the initial view controller in the target storyboard or specify the identifier.
     
     - parameter storyboard: Storyboard name.
     - parameter identifier: View controller name.
     - parameter configure: Configure the view controller before it is loaded.
     */
    func showDetailViewController<T: UIViewController>(storyboard: StoryboardIdentifier, identifier: String? = nil, configure: ((T) -> Void)? = nil) {
        RoutingLogic.showDetailViewController(delegate: self, storyboard: storyboard.rawValue, identifier: identifier, configure: configure)
    }
}

enum RoutingLogic {
    static func present<T: UIViewController>(delegate: UIViewController, storyboard: String, identifier: String? = nil, animated: Bool = true, modalPresentationStyle: UIModalPresentationStyle? = nil, modalTransitionStyle: UIModalTransitionStyle? = nil, configure: ((T) -> Void)? = nil, completion: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController()) as? T
            else { return assertionFailure("Invalid controller for storyboard \(storyboard).") }
        
        if let modalPresentationStyle = modalPresentationStyle {
            controller.modalPresentationStyle = modalPresentationStyle
        }
        
        if let modalTransitionStyle = modalTransitionStyle {
            controller.modalTransitionStyle = modalTransitionStyle
        }
        
        configure?(controller)
        
        delegate.present(controller, animated: animated) {
            completion?(controller)
        }
    }
    
    static func show<T: UIViewController>(delegate: UIViewController, storyboard: String, identifier: String? = nil, configure: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController()) as? T
            else { return assertionFailure("Invalid controller for storyboard \(storyboard).") }
        
        configure?(controller)
        
        delegate.show(controller, sender: delegate)
    }
    
    static func showDetailViewController<T: UIViewController>(delegate: UIViewController, storyboard: String, identifier: String? = nil, configure: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController()) as? T
            else { return assertionFailure("Invalid controller for storyboard \(storyboard).") }
        
        configure?(controller)
        
        delegate.showDetailViewController(controller, sender: delegate)
    }
}

// MARK: - RootVCRoutable
protocol RootVCRoutable {
    associatedtype RootViewController: RawRepresentable
}

extension RootVCRoutable where RootViewController.RawValue == String {
    func changeRootViewController(to rootVC: RootViewController, viewControllerHandler: ((UIViewController?)->Void)? = nil) {
        
        let storyboard = UIStoryboard(name: rootVC.rawValue, bundle: nil)
        
        guard let vc = storyboard.instantiateInitialViewController() else {
            return
        }
        
        changeRootViewController(to: vc, viewControllerHandler: viewControllerHandler)
    }
    
    func changeRootViewController(to viewController: UIViewController, viewControllerHandler: ((UIViewController?)->Void)? = nil) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        if let viewControllerHandler = viewControllerHandler {
            viewControllerHandler(viewController)
        }
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    static func changeRootViewController(to rootVC: RootViewController, viewControllerHandler: ((UIViewController?)->Void)? = nil) {
        
        let storyboard = UIStoryboard(name: rootVC.rawValue, bundle: nil)
        
        guard let vc = storyboard.instantiateInitialViewController() else {
            return
        }
        
        changeRootViewController(to: vc, viewControllerHandler: viewControllerHandler)
    }
    
    static func changeRootViewController(to viewController: UIViewController, viewControllerHandler: ((UIViewController?)->Void)? = nil) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        if let viewControllerHandler = viewControllerHandler {
            viewControllerHandler(viewController)
        }
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}

// MARK: - SegueHandlerController
protocol SegueHandlerController {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerController where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    func performSegue(withIdentifier segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier")
        }
        
        return segueIdentifier
    }
}

// MARK: - Extension String
extension String {
    func addDecimalDots() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: .appLocale)
        
        guard let asInt = Int(self) else {
            return self
        }
        
        return numberFormatter.string(from: NSNumber(value: asInt))
    }
    
    private func getRutDv(value: String) -> (run: String, dv: String) {
        if (value.isEmpty || value.count < 2) {
            return (.empty, .empty)
        }
        
        var rut = value.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil)
        rut = rut.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        let dv = String(rut.last!)
        let run = String(rut.dropLast())
        
        return (run, dv)
    }
    
    func isRut() -> Bool {
        
        var rut = self.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range : nil)
        rut = rut.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range : nil)
        rut = rut.uppercased()
        
        if (rut.count < 8 || rut.count > 10) {
            return false
        }
        
        let rutRegex = "^(\\d{1,3}(\\.?\\d{3}){2})\\-?([\\dkK])$"
        let rutTest = NSPredicate(format: "SELF MATCHES %@", rutRegex)
        
        if (!rutTest.evaluate(with: rut)) {
            return false
        }
        
        let runTovalidate = getRutDv(value: self)
        
        let rutNumber = runTovalidate.run
        let rutDV = runTovalidate.dv
        
        let calculatedDV = validateDV(rut: rutNumber)
        
        if (rutDV != calculatedDV) {
            return false
        }
        
        return true
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\\“(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\\“)@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func toDate(with format: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: .appLocale)
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: self)
    }
    
    private func validateDV(rut: String) -> String? {
        var acumulated = 0
        var ti = 2
        
        for index in stride(from: rut.count - 1, through: 0, by: -1) {
            let n = Array(rut)[index]
            let nl = String(n)
            
            guard let vl = Int(nl) else {
                return .empty
            }
            
            acumulated += vl * ti
            
            if ti == 7 {
                ti = 1
            }
            
            ti += 1
        }
        
        let resto: Int = acumulated % 11
        let numericDigit = 11 - resto
        var digit = ""
        
        if (numericDigit <= 9) {
            digit = String(numericDigit)
        } else if (numericDigit == 10) {
            digit = "K"
        } else {
            digit = "0"
        }
        
        return digit
    }
    
    var hyphened: String {
        var mutableSelf = self
        mutableSelf.insert(
            "-",
            at: mutableSelf.index(before: mutableSelf.endIndex)
        )
        return mutableSelf
    }
}

// MARK: - Classes
// MARK: - Class HideableKeyboardUIViewController
class HideableKeyboardUIViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
}

// MARK: - Class GradientView
@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}

// MARK: ListTransform: from [T] to List<T>() where T: Primitive
func ListTransform<T>() -> TransformOf<List<T>, [T]> {
    return TransformOf(
        fromJSON: {
            (value: [T]?) -> List<T> in
            
            let result = List<T>()
            
            if let value = value {
                result.append(objectsIn: value)
            }
            
            return result
    }, toJSON: {
        (value: List<T>?) -> [T] in
        
        var results = [T]()
        
        if let value = value {
            results.append(contentsOf: Array(value))
        }
        
        return results
    }
    )
}

// MARK: - ListTransformClass: from [T] to List<T>() where T: Object
class ListTransformClass<T: Object>: TransformType where T: Mappable {
    typealias Object = List<T>
    typealias JSON = Array<AnyObject>
    
    func transformFromJSON(_ value: Any?) -> List<T>? {
        let realmList = List<T>()
        
        if let jsonArray = value as? Array<Any> {
            for item in jsonArray {
                if let realmModel = Mapper<T>().map(JSONObject: item) {
                    realmList.append(realmModel)
                }
            }
        }
        
        return realmList
    }
    
    func transformToJSON(_ value: List<T>?) -> Array<AnyObject>? {
        guard let realmList = value, realmList.count > 0 else { return nil }
        
        var resultArray = Array<T>()
        
        for entry in realmList {
            resultArray.append(entry)
        }
        
        return resultArray
    }
}

// MARK: - Storyboardable
protocol Storyboardable: class {
    static var defaultStoryboardName: String { get }
}

extension Storyboardable where Self: UIViewController {
    static var defaultStoryboardName: String {
        let selfName = String(describing: self)
        return selfName.replacingOccurrences(of: "ViewController", with: "")
    }
    
    static func storyboardViewController() -> Self {
        let storyboard = UIStoryboard(name: defaultStoryboardName, bundle: nil)
        
        guard let vc = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Could not instantiate initial storyboard with name: \(defaultStoryboardName)")
        }
        
        return vc
    }
}

extension UIViewController: Storyboardable { }

// MARK: - Extension Labels (values from zeplin)
enum AppFontSizes: CGFloat {
    case h1Size = 92.38
    case h2Size = 57.74
    case h3Size = 46.19
    case h4Size = 32.72
    case h5Size = 23.1
    case h6Size = 19.25
    case body1 = 15.4
    case body2 = 13.47
    case caption = 11.55
    case tabItem = 10
}

enum AppFontTypes: String {
    case medium = "Roboto-Medium"
    case regular = "Roboto-Regular"
    case bold = "Roboto-Bold"
}

extension UIFont {
    
    class var h1Font: UIFont {
        return UIFont(name: AppFontTypes.regular.rawValue, size: AppFontSizes.h1Size.rawValue)!
    }
    
    class var h2Font: UIFont {
        return UIFont(name: AppFontTypes.regular.rawValue, size: AppFontSizes.h2Size.rawValue)!
    }
    
    class var h3Font: UIFont {
        return UIFont(name: AppFontTypes.regular.rawValue, size: AppFontSizes.h3Size.rawValue)!
    }
    
    class var h4Font: UIFont {
        return UIFont(name: AppFontTypes.regular.rawValue, size: AppFontSizes.h4Size.rawValue)!
    }
    
    class var h5Font: UIFont {
        return UIFont(name: AppFontTypes.regular.rawValue, size: AppFontSizes.h5Size.rawValue)!
    }
    
    class var h6Font: UIFont {
        return UIFont(name: AppFontTypes.regular.rawValue, size: AppFontSizes.h6Size.rawValue)!
    }
    
    class var body1: UIFont {
        return UIFont(name: AppFontTypes.regular.rawValue, size: AppFontSizes.body1.rawValue)!
    }
    
    class var body2: UIFont {
        return UIFont(name: AppFontTypes.regular.rawValue, size: AppFontSizes.body2.rawValue)!
    }
    
    class var subtitle1: UIFont {
        return UIFont(name: AppFontTypes.regular.rawValue, size: AppFontSizes.body1.rawValue)!
    }
    
    class var subtitle2: UIFont {
        return UIFont(name: AppFontTypes.regular.rawValue, size: AppFontSizes.body2.rawValue)!
    }
    
    class var button: UIFont {
        return UIFont(name: AppFontTypes.bold.rawValue, size: AppFontSizes.body2.rawValue)!
    }
    
    class var caption: UIFont {
        return UIFont(name: AppFontTypes.regular.rawValue, size: AppFontSizes.caption.rawValue)!
    }
    
    class var tabItemFont: UIFont {
        return UIFont(name: AppFontTypes.medium.rawValue, size: AppFontSizes.tabItem.rawValue)!
    }
}

// MARK: - Extension Color (values from zeplin)
extension UIColor{
    @nonobjc class var vixonicColor: UIColor {
        return UIColor(red:0.00, green:0.44, blue:0.81, alpha:1.00)
    }
    @nonobjc class var blackBackground: UIColor {
        return UIColor(red:0.05, green:0.05, blue:0.05, alpha:0.5)
    }
    @nonobjc class var backBtnColor: UIColor {
        return UIColor(red:0.50, green:0.53, blue:0.55, alpha:1.0)
    }
    @nonobjc class var lightishBlue: UIColor {
        return UIColor(red: 61.0 / 255.0, green: 90.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var primary: UIColor {
        return UIColor(red:0.19, green:0.19, blue:0.19, alpha:1.00)
    }
    @nonobjc class var secondary: UIColor {
        return UIColor(red:0.01, green:0.85, blue:0.77, alpha:1.0)
    }
    @nonobjc class var success: UIColor {
        return UIColor(red:0.24, green:0.87, blue:0.80, alpha:1.0)
    }
    @nonobjc class var danger: UIColor {
        return UIColor(red:1.00, green:0.33, blue:0.27, alpha:1.0)
    }
    @nonobjc class var warning: UIColor {
        return UIColor(red:1.00, green:0.71, blue:0.00, alpha:1.0)
    }
    @nonobjc class var info: UIColor {
        return UIColor(red:0.00, green:0.72, blue:0.85, alpha:1.0)
    }
    @nonobjc class var light: UIColor {
        return UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
    }
    @nonobjc class var lighter: UIColor {
        return UIColor(red:0.97, green:0.97, blue:0.98, alpha:1.0)
    }
    @nonobjc class var terciary: UIColor {
        return UIColor(red:0.40, green:0.33, blue:0.75, alpha:1.0)
    }
    @nonobjc class var marineBlue: UIColor {
        return UIColor(red:0.00, green:0.16, blue:0.45, alpha:1.0)
    }
    @nonobjc class var red: UIColor {
        return UIColor(red:1, green:0.16, blue:0.16, alpha:1)
    }
    @nonobjc class var white: UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }
    @nonobjc class var primaryRipple: UIColor {
        return UIColor(red:0.38, green:0.00, blue:0.93, alpha:0.12)
    }
    @nonobjc class var secondaryRipple: UIColor {
        return UIColor(white: 1.0, alpha:0.12)
    }
    @nonobjc class var whiteRipple: UIColor {
        return UIColor(white: 1.0, alpha: 0.12)
    }
    @nonobjc class var charcoal: UIColor{
        return UIColor(red:0.23, green:0.27, blue:0.32, alpha:1.0)
    }
    @nonobjc class var timberWolf: UIColor{
        return UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
    }
    @nonobjc class var dodgerBlue: UIColor{
        return UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
    }
    @nonobjc class var darkJungleGreen: UIColor{
        return UIColor(red:0.13, green:0.15, blue:0.16, alpha:1.0)
    }
    @nonobjc class var black: UIColor{
        return UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
    }
    @nonobjc class var black60: UIColor{
        return UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.6)
    }
    @nonobjc class var black20: UIColor{
        return UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.2)
    }
    @nonobjc class var slateGray: UIColor{
        return UIColor(red:0.38, green:0.49, blue:0.55, alpha:1.0)
    }
    @nonobjc class var redSnackBar: UIColor{
        return UIColor(red:0.69, green:0.00, blue:0.13, alpha:1.0)
    }
}

// MARK: - Extension Material Buttons (values from zeplin)
enum CustomButtonType {
    case btnPrimary
    case btnSecondary
    case btnVixonicColor
    case btnVixonicBlackColor
}

enum MdcType {
    case text
    case outlined
    case contained
}

extension MDCButton {
    
    func setupButtonWithType(type: CustomButtonType, mdcType: MdcType) {
        
        let colorSchema = MDCSemanticColorScheme()
        let typeScheme = VixonicTypographyScheme()
        let buttonScheme = MDCButtonScheme()
        let rippleView = MDCRippleView()
        
        switch type {
        case .btnPrimary:
            colorSchema.primaryColor = .primary
            colorSchema.onPrimaryColor = .white
        case .btnSecondary:
            colorSchema.primaryColor = .white
            colorSchema.onPrimaryColor = .red
        case .btnVixonicColor:
            colorSchema.primaryColor = .vixonicColor
            colorSchema.onPrimaryColor = .white
        case .btnVixonicBlackColor:
            colorSchema.primaryColor = .black
            colorSchema.onPrimaryColor = .white
        }
        
        buttonScheme.colorScheme = colorSchema
        buttonScheme.typographyScheme = typeScheme
        buttonScheme.cornerRadius = 8
        
        self.clipsToBounds = true
        switch mdcType {
        case .text:
            MDCTextButtonThemer.applyScheme(buttonScheme, to: self)
            
        case .outlined:
            MDCOutlinedButtonThemer.applyScheme(buttonScheme, to: self)
            buttonScheme.cornerRadius = 0
//            self.inkColor = .primaryRipple
            
        case .contained:
            MDCContainedButtonThemer.applyScheme(buttonScheme, to: self)
        }
        
        self.isUppercaseTitle = true
    }
}
