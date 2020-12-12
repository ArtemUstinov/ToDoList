//
//  Extension + TableView.swift
//  RealmApp
//
//  Created by Артём Устинов on 12.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit

extension UITableView {
    
    func setTableView() {
        
        self.separatorInset = UIEdgeInsets(top: 3, left: 15,
                                           bottom: 3, right: 15)
        self.tableFooterView = UIView()
    }
}
