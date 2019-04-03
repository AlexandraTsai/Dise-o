//
//  ContainerViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/4/1.
//  Copyright © 2019年 蔡佳宣. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            
            tableView.dataSource = self
         
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.al_registerCellWithNib(identifier: String(describing: SelectionTableViewCell.self), bundle: nil)
        tableView.al_registerCellWithNib(identifier: String(describing: PhotoTableViewCell.self), bundle: nil)
    }
    
}

extension ContainerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SelectionTableViewCell.self), for: indexPath)
            
            guard let selectionCell = cell as? SelectionTableViewCell else {
                
                return cell
            }
          
            return selectionCell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotoTableViewCell.self), for: indexPath)
            
            guard let photoCell = cell as? PhotoTableViewCell else {
                
                return cell
                
            }
            
            return photoCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
           return  50
            
        } else {
            return tableView.frame.height - 50
        }
    }
    
}
