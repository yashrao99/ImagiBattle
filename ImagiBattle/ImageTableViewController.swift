//
//  ImageTableViewController.swift
//  ImagiBattle
//
//  Created by Yash Rao on 4/11/18.
//  Copyright © 2018 com.YashasRao99. All rights reserved.
//

import Foundation
import UIKit

protocol SelectImageDelegate {
    func selectedImage(row: Int)
}

class ImageTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var imageTable: UITableView!
    
    var delegate: SelectImageDelegate?
    var tableData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageTable.delegate = self
        imageTable.dataSource = self
        
        let backgroundImg = UIImageView(frame: UIScreen.main.bounds)
        backgroundImg.image = UIImage(named: "SWBG")
        backgroundImg.contentMode = .scaleAspectFit
        self.view.insertSubview(backgroundImg, at: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = imageTable.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedImage(row: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
