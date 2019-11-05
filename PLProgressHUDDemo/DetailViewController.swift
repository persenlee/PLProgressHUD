
//
//  DetailViewController.swift
//  PLProgressHUD
//
//  Created by persen on 2019/11/4.
//

import Foundation
import UIKit
import PLProgressHUD

class DetailViewController: UIViewController {
    var style: PLProgressHUDStyle?
    var hud: PLProgressHUD?
    var progress: Double = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let hud = PLProgressHUD(frame: self.view.bounds)
        self.hud = hud
        hud.color = UIColor.gray
        hud.style = style!
//        hud.showEffect = true
        hud.showAtView(self.view)
        hud.textColor = UIColor.white
        hud.titleLabel.text = "Downloading...Please wait for seconds....."
        if hud.style == .custom || hud.style == .system || hud.style == .text {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
                hud.hide()
            }
        } else {
            hud.progressView?.lineWidth = (style == .horizontal) ? 2 : 10
            timer = Timer(timeInterval: 0.1, repeats: true, block: { (timer) in
                self.addProgress()
            })
            RunLoop.current.add(timer!, forMode: .common)
            timer?.fire()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    func addProgress() {
        progress += 0.01
        progress = min(1, progress)
        if progress >= 1 {
            hud?.hide()
            timer?.invalidate()
            timer = nil
        }
        self.hud?.progressView?.progress = CGFloat(progress)
    }
}
