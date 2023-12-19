//
//  ViewController.swift
//  FotoFlow
//
//  Created by LERÄ on 05.12.23.
//

import UIKit

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
        func tabelView(_ tableView: UITableView, numberOfRowInSection section: Int) -> Int {
            return 1
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            return UITableViewCell()
        }
    }
    
    extension ImagesListViewController: UITableViewDelegate {
        
        func tableView(_ tabelView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    }

