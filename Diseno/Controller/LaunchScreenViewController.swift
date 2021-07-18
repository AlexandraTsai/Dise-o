//
//  LaunchScreenViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/4.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    init(coordinator: AppCoordinatorPrototype) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        drawSquare(with: .init(x: width / 2 - 10, y: height / 2 - 10),
                   strokeColor: .DSColor.yellow)
        drawSquare(with: .init(x: width / 2, y: height / 2 - 20),
                   strokeColor: .DSColor.logoC2)
        drawSquare(with: .init(x: width / 2 + 10, y: height / 2 - 30),
                   strokeColor: .DSColor.heavyGreen)
        showCircle()
    }

    private let coordinator: AppCoordinatorPrototype
}

// MARK: Drawing
private extension LaunchScreenViewController {
    func drawSquare(with center: CGPoint, strokeColor: UIColor) {
        let shapeLayer = CAShapeLayer()
        let bezierPath = UIBezierPath()
                
        // Start from top left
        bezierPath.move(to: CGPoint(x: center.x - 50, y: center.y - 50))
        bezierPath.addLine(to: CGPoint(x: center.x + 50, y: center.y - 50))
        bezierPath.addLine(to: CGPoint(x: center.x + 50, y: center.y + 50))
        bezierPath.addLine(to: CGPoint(x: center.x - 50, y: center.y + 50))
        bezierPath.addLine(to: CGPoint(x: center.x - 50, y: center.y - 50))

        shapeLayer.path = bezierPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = 3
        
        let animation2 = CABasicAnimation(keyPath: "strokeEnd")
        animation2.fromValue = 0
        animation2.toValue = 1
        animation2.duration = 2.5
        shapeLayer.add(animation2, forKey: "drawLineAnimation")
    
        view.layer.addSublayer(shapeLayer)
    }

    func showCircle() {
        let circleView = UIImageView()
        circleView.image = UIImage(named: ImageAsset.Icon_Circle.rawValue)
        circleView.frame = CGRect(x: width/2-30,
                                  y: height/2-20,
                                  width: 30,
                                  height: 30)
        
        let nameView = UIImageView()
        nameView.image = UIImage(named: ImageAsset.Icon_AppName.rawValue)
        nameView.frame = CGRect(x: width/2-60,
                                y: height/2+50,
                                width: 120,
                                height: 40)
                
        [circleView, nameView].forEach {
            $0.alpha = 0
            view.addSubview($0)
        }
        
        UIView.animateKeyframes(
            withDuration: 0.9,
            delay: 2.6,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    circleView.alpha = 1
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.9, animations: {
                    nameView.alpha = 1
                })
            }, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                    self?.coordinator.goToHomePage()
                })
            })
    }
}

private let width = UIScreen.width
private let height = UIScreen.height
