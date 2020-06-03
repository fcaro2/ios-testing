//
//  MainViewController.swift
//  coronapp
//
//  Created by ismael alvarez on 06-04-20.
//  Copyright © 2020 ismael alvarez. All rights reserved.
//

import UIKit
import MaterialComponents
import MaterialComponents.MaterialBottomNavigation
import MaterialComponents.MaterialBottomNavigation_Theming

// MARK: - Tabs
enum Tabs: Int {
    case notification = 0
    case account
}

// MARK: - MainTabBarViewController
class MainTabBarViewController: UITabBarController {
    
    var isUpdate = false
    lazy var bottomNavBar: MDCBottomNavigationBar = {
        let bottomNavBar = MDCBottomNavigationBar()
        
        let tabBarItem1 = UITabBarItem(title: "Inicio", image: UIImage(named: "personIcon"), tag: 0)
        let tabBarItem2 = UITabBarItem(title: "Cuenta", image: UIImage(named: "emailIcon"), tag: 1)
        
        bottomNavBar.items = [
            tabBarItem1,
            tabBarItem2
        ]
        
        bottomNavBar.selectedItem = tabBarItem1
        bottomNavBar.delegate = self
        
        bottomNavBar.itemTitleFont = .body1

        bottomNavBar.selectedItemTintColor = .primary
        bottomNavBar.unselectedItemTintColor = .darkGray
        
        return bottomNavBar
    }()

    // MARK: - tabBarController transition flag
    var isStillAnimatingTransition = false

    var presenter: MainTabBarPresenterProtocol?
}

// MARK: - Lifecycle
extension MainTabBarViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        presenter?.onViewWillLayoutSubviews()
    }

}

// MARK: - Public methods
extension MainTabBarViewController {
    func select(tab: Tabs) {
        switch tab {
        case .notification:
            if let navigationController = viewControllers?[0] as? UINavigationController, !(navigationController.viewControllers.last is NotificationViewController) {
                let homeViewController = NotificationViewController.storyboardViewController()
                navigationController.setViewControllers([homeViewController], animated: true)
            }
        case .account:
            if let navigationController = viewControllers?[1] as? UINavigationController, !(navigationController.viewControllers.last is MainScreenViewController) {
                let mapViewController = MainScreenRouter.createModule()
                navigationController.setViewControllers([mapViewController], animated: true)
            }

        }

        let selectedIndex = tab.rawValue
        
        bottomNavBar.selectedItem = bottomNavBar.items[selectedIndex]
        
        self.selectedIndex = selectedIndex
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          navigationController?.setNavigationBarHidden(true, animated: animated)
      }
}

// MARK: - MDCBottomNavigationBarDelegate
extension MainTabBarViewController: MDCBottomNavigationBarDelegate {
    func bottomNavigationBar(_ bottomNavigationBar: MDCBottomNavigationBar, didSelect item: UITabBarItem) {
        //presenter?.handleBottomNavigationBarItemSelection()

        guard !isStillAnimatingTransition, selectedIndex != item.tag else {
            guard let nc = viewControllers?[selectedIndex] as? UINavigationController else { return }
            nc.popViewController(animated: true)

            return
        }


        selectedIndex = item.tag
    }
}

// MARK: - MainTabBarViewProtocol
extension MainTabBarViewController: MainTabBarViewProtocol {
    func addBottomNavBarAsSubView() {
        view.addSubview(bottomNavBar)
    }

    func setBottomNavBarFrame() {
        let size = bottomNavBar.sizeThatFits(view.bounds.size)
        var bottomNavBarFrame = CGRect(x: 0, y: view.bounds.height - size.height, width: size.width, height: size.height)
        
        bottomNavBarFrame.size.height += view.safeAreaInsets.bottom
        bottomNavBarFrame.origin.y -= view.safeAreaInsets.bottom
        
        bottomNavBar.frame = bottomNavBarFrame
    }
}
