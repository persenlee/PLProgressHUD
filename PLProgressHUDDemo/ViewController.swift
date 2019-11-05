//
//  ViewController.swift
//  PLProgressHUD
//
//  Created by persen on 2019/11/1.
//

import UIKit
import PLProgressHUD

class ViewController: UITableViewController {

    let dataSource = [PLProgressHUDStyle.system,.sector,.annular,.horizontal,.custom,.text]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "PLProgressHUDDemo"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let style = dataSource[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.style = style
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

