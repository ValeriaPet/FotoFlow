//
//  TabBarController.swift
//  FotoFlow
//
//  Created by LERÄ on 15.04.24.
//
import Foundation
import UIKit

final class TabBarViewController: UITabBarController {
override func awakeFromNib() {
    super.awakeFromNib()
    
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    
    let imagesListViewController = storyboard.instantiateViewController(
               withIdentifier: "ImagesListViewController"
           )
               
    let profileViewController = ProfileViewController()
    profileViewController.tabBarItem = UITabBarItem(
         title: "",
         image: UIImage(named: "ProfileActive"),
         selectedImage: nil
     )
          self.viewControllers = [imagesListViewController, profileViewController]
          }
}
