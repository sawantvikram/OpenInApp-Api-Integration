//
//  MyTabBarCtrl.swift
//  OpenInApp
//
//  Created by Touchzing media on 24/04/24.
//

import Foundation
import UIKit
class MyTabBarCtrl: UITabBarController, UITabBarControllerDelegate {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabBarItems()
        setupMiddleButton()
        
   }
    
    // TabBarButton – Setup Middle Button
        func setupMiddleButton() {

            let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-35, y: -20, width: 70, height: 70))
            
//            //STYLE THE BUTTON YOUR OWN WAY
            middleBtn.setImage(UIImage(systemName: "plus"), for: .normal)
            middleBtn.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.4352941176, blue: 1, alpha: 1)
            middleBtn.tintColor = .white
            middleBtn.layer.cornerRadius = 35
//            middleBtn.layer.borderWidth = 6
//            middleBtn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
//
            //add to the tabbar and add click event
            self.tabBar.addSubview(middleBtn)
            middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)

            self.view.layoutIfNeeded()
        }

        // Menu Button Touch Action
        @objc func menuButtonAction(sender: UIButton) {
            self.selectedIndex = 2   //to select the middle tab. use "1" if you have only 3 tabs.
        }
    
    func setupTabBarItems() {
          // Set images for each tab
          if let items = tabBar.items {
              items[0].image = UIImage(systemName: "link")
              items[1].image = UIImage(systemName: "book")
              items[3].image = UIImage(systemName: "speaker")
              items[4].image = UIImage(systemName: "person")
              
              // Adjust tab bar item insets if needed
              for item in items {
                  item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
              }
          }
      }
}
