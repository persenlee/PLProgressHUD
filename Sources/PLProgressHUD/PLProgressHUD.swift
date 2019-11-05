//
//  PLProgressHUD.swift
//  PLProgressHUD
//
//  Created by persen on 2019/11/1.
//

import Foundation
import UIKit

public enum PLProgressHUDStyle {
    case system
    case sector
    case annular
    case horizontal
    case custom
    case text
}

public class PLProgressHUD: UIView {
    public var style: PLProgressHUDStyle = .system {
        willSet(newValue){
            switch newValue {
            case .sector:
                self.progressView = PLSectorProgressView()
            case .annular:
                self.progressView = PLAnnularProgressView()
            case .horizontal:
                self.progressView = PLHorizontalProgressView()
            default:
                break
            }
            
        }
    }
    
    public lazy var color: UIColor = {
        return UIColor.white
    }()
    
    public var showEffect = false
    
    public var cornerRadius: CGFloat = 5
    
    public var opacity: CGFloat = 1
    
    public var minSize: CGSize = CGSize(width: 200, height: 200)
    
    public var textColor: UIColor = UIColor.black {
        didSet{
            self.titleLabel.textColor = self.textColor
        }
    }
    
    public  var textFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet{
            self.titleLabel.font = self.textFont
        }
    }
    
    public lazy var backgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    public lazy var activityView: UIActivityIndicatorView = {
        var activity: UIActivityIndicatorView?
        if #available(iOS 13.0, *) {
            activity = UIActivityIndicatorView(style: .medium)
        } else {
            activity = UIActivityIndicatorView(style: .gray)
        }
        activity!.color = UIColor.blue
        return activity!
    }()
    
    public var progressView: PLProgressViewProtocol?
    
    public var customView: UIView?
    
    public lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = color
        view.alpha = opacity
        view.layer.cornerRadius = cornerRadius
        return view
    }()
    
    public lazy var containerEffectView: UIVisualEffectView = {
        var effect: UIBlurEffect?
        if #available(iOS 10.0, *) {
            effect = UIBlurEffect(style:.regular)
        } else {
            effect = UIBlurEffect(style:.light)
        }
        let view = UIVisualEffectView(effect: effect)
        view.alpha = opacity
        view.layer.cornerRadius = cornerRadius
        return view
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = textColor
        label.font = textFont
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    public func showAtView(_ view: UIView) {
        view.addSubview(self)
        self.frame = view.bounds
        var referView: UIView?
        if showEffect {
            referView = containerEffectView
            self.addSubview(containerEffectView)
        } else {
            self.addSubview(containerView)
            referView = containerView
        }
        let x = (self.bounds.width - self.minSize.width) / 2
        let y = (self.bounds.height - self.minSize.height) / 2
        referView!.frame = CGRect(x: x, y: y, width: minSize.width, height: minSize.height)
        switch style {
        case .system:
            do {
                if showEffect {
                    self.containerEffectView.contentView.addSubview(self.activityView)
                } else {
                    self.containerView.addSubview(self.activityView)
                }
                self.activityView.center = CGPoint(x: referView!.bounds.size.width / 2, y: referView!.bounds.size.height / 2)
                self.activityView.startAnimating()
            }
        case .custom:
            do {
                if let customView = self.customView {
                    if showEffect {
                        self.containerEffectView.contentView.addSubview(customView)
                    } else {
                        self.containerView.addSubview(customView)
                    }
                }
            }
        case .horizontal,.annular,.sector:
            do {
                if showEffect {
                    self.containerEffectView.contentView.addSubview(self.progressView!)
                } else {
                    self.containerView.addSubview(self.progressView!)
                }
                if style == .horizontal {
                    let height = CGFloat(20)
                    self.progressView?.frame = CGRect(x: 5, y: (referView!.bounds.height - height)/2, width: referView!.bounds.width - 10, height: height)
                } else if style == .annular || style == .sector {
                    let length = min(referView!.bounds.width, referView!.bounds.height) / 2
                    self.progressView?.frame = CGRect(x: (referView!.bounds.width - length)/2, y: (referView!.bounds.height - length)/2, width: length, height: length)
                }
            }
        case .text:
            do {
                if showEffect {
                    self.containerEffectView.contentView.addSubview(self.titleLabel)
                } else {
                    self.containerView.addSubview(self.titleLabel)
                }
                self.titleLabel.frame = CGRect(x: 20, y: 0, width: referView!.bounds.width - 40, height: referView!.bounds.height)
            }
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        }, completion: nil)
    }
    
    public func hide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (complete) in
            self.removeFromSuperview()
        }
    }
    
}

public protocol PLProgressViewProtocol: UIView {
   dynamic var progress: CGFloat {get set}
   dynamic var completeColor: UIColor {get set}
   dynamic var remainColor: UIColor {get set}
   dynamic var lineColor: UIColor {get set}
   dynamic var lineWidth: CGFloat {get set}
}

public class PLBaseProgressView: UIView,PLProgressViewProtocol
{
    dynamic public var progress: CGFloat {
        didSet {
            setNeedsDisplay()
        }
    }
    
    dynamic public var completeColor: UIColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    dynamic public var remainColor: UIColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    dynamic public var lineColor: UIColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    dynamic public var lineWidth: CGFloat {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public override init(frame: CGRect) {
        self.progress = 0
        self.completeColor = UIColor.red
        self.lineColor = UIColor.blue
        self.remainColor = UIColor.blue
        self.lineWidth = 0
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
//        addObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    deinit {
//          removeObserver()
//      }
//
//    func addObserver() {
//      for keyPath in keyPaths {
//        addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
//      }
//    }
//
//    func removeObserver() {
//      for keyPath in keyPaths {
//          removeObserver(self, forKeyPath: keyPath)
//      }
//    }
//
//    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//      if let keyPath = keyPath,keyPaths.contains(keyPath) {
//          setNeedsDisplay()
//      }
//    }
//
//    let keyPaths = ["progress","completeColor","lineColor","remainColor","lineWidth"]
}

public class PLSectorProgressView:  PLBaseProgressView{
    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(self.lineWidth)
        context?.setStrokeColor(self.lineColor.cgColor)
        context?.setFillColor(self.remainColor.cgColor)
        //draw ring
        let radius = max(min(rect.width, rect.height) / 2 - self.lineWidth,0)
        context?.addArc(center: CGPoint(x: rect.width/2, y: rect.height/2), radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        context?.fillPath()
        
        context?.addArc(center: CGPoint(x: rect.width/2, y: rect.height/2), radius: radius + self.lineWidth/2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        context?.strokePath()

        //draw complete
        if progress > 0 {
            context?.setFillColor(self.completeColor.cgColor)
            context?.move(to: CGPoint(x: rect.midX, y: rect.midY))
            context?.addLine(to: CGPoint(x: rect.midX, y: rect.midY - radius))
            context?.addArc(center: CGPoint(x: rect.width/2, y: rect.height/2), radius: radius, startAngle: -CGFloat.pi/2, endAngle: self.progress * 2 * CGFloat.pi-CGFloat.pi/2, clockwise: true)
            context?.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
            context?.fillPath()
        }
    }
      
    public override init(frame: CGRect) {
          super.init(frame: frame)
          self.completeColor = UIColor.red
          self.lineColor = UIColor.blue
          self.remainColor = UIColor.yellow
          self.lineWidth = 10
    }
      
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public class PLAnnularProgressView: PLBaseProgressView {

    
    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(self.lineWidth)
        context?.setStrokeColor(self.lineColor.cgColor)
        
        //draw ring
        let radius = max(min(rect.width, rect.height) / 2 - self.lineWidth,0)
        context?.addArc(center: CGPoint(x: rect.width/2, y: rect.height/2), radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        context?.strokePath()
        
        //draw complete
        if progress > 0 {
            context?.setStrokeColor(self.completeColor.cgColor)
            context?.addArc(center: CGPoint(x: rect.width/2, y: rect.height/2), radius: radius, startAngle: -CGFloat.pi/2, endAngle: self.progress * 2 * CGFloat.pi-CGFloat.pi/2, clockwise: true)
            context?.strokePath()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.completeColor = UIColor.red
        self.lineColor = UIColor.blue
        self.remainColor = UIColor.blue
        self.lineWidth = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public class PLHorizontalProgressView: PLBaseProgressView{
    
    
    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(self.lineWidth)
        context?.setStrokeColor(self.lineColor.cgColor)
        context?.setFillColor(self.remainColor.cgColor)
        
        //draw background
        let radius = rect.height / 2 - self.lineWidth
        context?.move(to: CGPoint(x: self.lineWidth + radius,y: self.lineWidth))
        context?.addLine(to: CGPoint(x: rect.width - self.lineWidth - radius, y: self.lineWidth))
        context?.addArc(center: CGPoint(x: rect.width - self.lineWidth - radius, y: rect.height/2), radius: radius, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi/2, clockwise: false)
        context?.addLine(to: CGPoint(x: self.lineWidth + radius, y: rect.height - self.lineWidth
        ))
        context?.addArc(center: CGPoint(x: self.lineWidth + radius, y: rect.height/2), radius: radius, startAngle: CGFloat.pi/2, endAngle: 3 * CGFloat.pi / 2, clockwise: false)
        context?.fillPath()
        
        //draw border
        context?.move(to: CGPoint(x: self.lineWidth + radius,y: self.lineWidth))
        context?.addLine(to: CGPoint(x: rect.width - self.lineWidth - radius, y: self.lineWidth))
        context?.addArc(center: CGPoint(x: rect.width - self.lineWidth - radius, y: rect.height/2), radius: radius, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi/2, clockwise: false)
        context?.addLine(to: CGPoint(x: self.lineWidth + radius, y: rect.height - self.lineWidth
        ))
        context?.addArc(center: CGPoint(x: self.lineWidth + radius, y: rect.height/2), radius: radius, startAngle: CGFloat.pi/2, endAngle: 3 * CGFloat.pi / 2, clockwise: false)
        context?.strokePath()
   
        //draw line progress
        context?.setFillColor(self.completeColor.cgColor)
        let completeWidth = self.progress * (rect.width - 2 * self.lineWidth)
        if completeWidth > rect.width - 2 * self.lineWidth - radius && completeWidth <= rect.width - 2 * self.lineWidth{
            let w = completeWidth - (rect.width - 2 * self.lineWidth - radius)
            let angle = asin(w/radius)
            let h = sqrt(pow(radius, 2) - pow(w, 2))
            context?.move(to: CGPoint(x: self.lineWidth + radius, y: self.lineWidth))
            context?.addLine(to: CGPoint(x: rect.width - 2 * self.lineWidth - radius, y: self.lineWidth))
            context?.addArc(center: CGPoint(x: rect.width - self.lineWidth - radius, y: rect.height/2), radius: radius, startAngle: -CGFloat.pi/2, endAngle: -CGFloat.pi/2 + angle, clockwise: false)
            context?.addLine(to: CGPoint(x: self.lineWidth
                + completeWidth, y: rect.height + h))
            context?.addArc(center: CGPoint(x: rect.width - self.lineWidth - radius,y: rect.height/2),radius: radius, startAngle: CGFloat.pi/2-angle, endAngle: CGFloat.pi/2, clockwise: false)
            context?.addLine(to: CGPoint(x: self.lineWidth + radius, y: rect.height / 2 + radius))
            context?.addArc(center: CGPoint(x: self.lineWidth + radius, y: rect.height/2), radius: radius, startAngle: CGFloat.pi/2, endAngle: 3 * CGFloat.pi / 2, clockwise: false)
            context?.fillPath()
        } else if completeWidth > radius {
            context?.move(to: CGPoint(x: self.lineWidth + radius, y: self.lineWidth))
            context?.addLine(to: CGPoint(x: self.lineWidth + completeWidth, y: self.lineWidth))
            context?.addLine(to: CGPoint(x: self.lineWidth + completeWidth, y: rect.height / 2 + radius))
            context?.addLine(to: CGPoint(x: self.lineWidth + radius, y: rect.height / 2 + radius))
            context?.addArc(center: CGPoint(x: self.lineWidth + radius, y: rect.height/2), radius: radius, startAngle: CGFloat.pi/2, endAngle: 3 * CGFloat.pi / 2, clockwise: false)
            context?.fillPath()
        } else if  completeWidth > 0 {
            let w = radius - completeWidth
            let angle = acos(w/radius)
            let h = sqrt(pow(radius, 2) - pow(w, 2))
            context?.addArc(center: CGPoint(x: self.lineWidth + radius, y: rect.height / 2), radius: radius, startAngle: (CGFloat.pi - angle) , endAngle: (CGFloat.pi + angle), clockwise: false)
            context?.move(to: CGPoint(x: self.lineWidth + radius - completeWidth, y: self.lineWidth + radius - h))
            context?.addLine(to: CGPoint(x: self.lineWidth + radius - completeWidth, y: rect.height/2 + h))
            context?.fillPath()
        }
        
    }
    
    public override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = UIColor.clear
            self.completeColor = UIColor.red
            self.lineColor = UIColor.black
            self.remainColor = UIColor.blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
