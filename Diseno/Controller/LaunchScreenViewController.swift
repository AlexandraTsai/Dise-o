//
//  LaunchScreenViewController.swift
//  Project2
//
//  Created by 蔡佳宣 on 2019/5/4.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        drawFirstLine()
        drawSecondLine()
        drawThirdLine()
        showCircle()

    }
    
    func drawFirstLine() {
        
        let shapeLayer = CAShapeLayer()
        let bezierPath = UIBezierPath()
        
        let width = UIScreen.main.bounds.width
        let heigth = UIScreen.main.bounds.height
        
        bezierPath.move(to: CGPoint(x: width/2-60, y: heigth/2-60))
        bezierPath.addLine(to: CGPoint(x: width/2+40, y: heigth/2-60))
        bezierPath.addLine(to: CGPoint(x: width/2+40, y: heigth/2+40))
        bezierPath.addLine(to: CGPoint(x: width/2-60, y: heigth/2+40))
        bezierPath.addLine(to: CGPoint(x: width/2-60, y: heigth/2-60))
        
        shapeLayer.path = bezierPath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.DSColor.yellow.cgColor
        shapeLayer.lineWidth = 3
        
        let animation2 = CABasicAnimation(keyPath: "strokeEnd")
        
        animation2.fromValue = 0
        animation2.toValue = 1
        animation2.duration = 2.5
        shapeLayer.add(animation2, forKey: "drawLineAnimation")
    
        self.view.layer.addSublayer(shapeLayer)
       
    }
    
    func drawSecondLine() {
        
        let width = UIScreen.main.bounds.width
        let heigth = UIScreen.main.bounds.height
       
        let shapeLayer2 = CAShapeLayer()
        let bezierPath2 = UIBezierPath()
        
        bezierPath2.move(to: CGPoint(x: width/2-50, y: heigth/2-70))
        bezierPath2.addLine(to: CGPoint(x: width/2+50, y: heigth/2-70))
        bezierPath2.addLine(to: CGPoint(x: width/2+50, y: heigth/2+30))
        bezierPath2.addLine(to: CGPoint(x: width/2-50, y: heigth/2+30))
        bezierPath2.close()
        
        shapeLayer2.path = bezierPath2.cgPath
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.strokeColor = UIColor.DSColor.logoC2.cgColor
        shapeLayer2.lineWidth = 2.5
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2.5
        shapeLayer2.add(animation, forKey: "drawLineAnimation")
        
         self.view.layer.addSublayer(shapeLayer2)
    }
    
    func drawThirdLine() {
        
        let width = UIScreen.main.bounds.width
        let heigth = UIScreen.main.bounds.height
        
        let shapeLayer3 = CAShapeLayer()
        let bezierPath3 = UIBezierPath()
        
        bezierPath3.move(to: CGPoint(x: width/2-40, y: heigth/2-80))
        bezierPath3.addLine(to: CGPoint(x: width/2+60, y: heigth/2-80))
        bezierPath3.addLine(to: CGPoint(x: width/2+60, y: heigth/2+20))
        bezierPath3.addLine(to: CGPoint(x: width/2-40, y: heigth/2+20))
        bezierPath3.close()
        
        shapeLayer3.path = bezierPath3.cgPath
        
        shapeLayer3.fillColor = UIColor.clear.cgColor
        shapeLayer3.lineWidth = 3
        shapeLayer3.strokeColor = UIColor.DSColor.heavyGreen.cgColor
        
        let animation3 = CABasicAnimation(keyPath: "strokeEnd")
        
        animation3.fromValue = 0
        animation3.toValue = 1
        animation3.duration = 2.5
        shapeLayer3.add(animation3, forKey: "drawLineAnimation")
        
        self.view.layer.addSublayer(shapeLayer3)
      
    }
    
    func showCircle() {
        
        let circleView = UIImageView()
        circleView.image = UIImage(named: ImageAsset.Icon_Circle.rawValue)
        circleView.frame = CGRect(x: UIScreen.main.bounds.width/2-30,
                                  y: UIScreen.main.bounds.height/2-20,
                                  width: 30,
                                  height: 30)
        
        circleView.alpha = 0
        
        let nameView = UIImageView()
        nameView.image = UIImage(named: ImageAsset.Icon_AppName.rawValue)
        nameView.frame = CGRect(x: UIScreen.main.bounds.width/2-60,
                                  y: UIScreen.main.bounds.height/2+50,
                                  width: 120,
                                  height: 40)
        
        nameView.alpha = 0
        
        self.view.addSubview(circleView)
        self.view.addSubview(nameView)
        
        UIView.animate(withDuration: 0.5, delay: 2.6, options: .curveEaseIn, animations: {
            
            circleView.alpha = 1
            
        }, completion: { done in
            
            if done {
                
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn,
                               animations: { [weak nameView] in
                                
                    nameView?.alpha = 1
                    
                }, completion: {  done in
                    
                    if done {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                            
                             self?.goToHomePage()
                        })
                        
                    }
                    
                })
                
            }
            
        })
    }
    
    @objc func goToHomePage() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let homeVC = storyboard
            .instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        
        let navController = UINavigationController(rootViewController: homeVC)

        self.present(navController, animated: false, completion: nil)
        
    }
   
}
