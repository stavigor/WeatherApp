//
//  CustomTabbar.swift
//  WeatherApp
//
//  Created by Игорь Растегаев on 26.09.2023.
//

import UIKit
import CoreLocation

class CustomTabBar: UITabBarController {
    
    private let tabHeight = CGFloat(85)
    
    private let button = UIButton(frame: CGRect(x: 0, y: 0, width: 68, height: 68))

    private var shapeLayer: CALayer?
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        setupMiddleButton()
        addShape()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = tabHeight
        tabBar.frame.origin.y = view.frame.height - tabHeight
    }
        
    private func setTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .none
        
        tabBar.standardAppearance = appearance
        tabBar.clipsToBounds = true
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        tabBar.items?[1].isEnabled = false
    }
    
    func setupMiddleButton() {
        var menuButtonFrame = button.frame
        menuButtonFrame.origin.y = tabBar.frame.minY -  button.frame.height - 16
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        
        button.frame = menuButtonFrame
        button.backgroundColor = .white // #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8941176471, alpha: 1)
        button.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(button)
        button.setBackgroundImage(UIImage(systemName: "safari.fill"), for: .normal)
        button.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        view.layoutIfNeeded()
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        shapeLayer.lineWidth = 0.5
        
        if let oldShapeLayer = self.shapeLayer {
            tabBar.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            tabBar.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {
        let height: CGFloat = 34
        let path = UIBezierPath()
        path.lineWidth = 1.5
        let centerWidth = tabBar.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0))

        path.addCurve(to: CGPoint(x: centerWidth, y: height),
        controlPoint1: CGPoint(x: (centerWidth - height), y: 0), controlPoint2: CGPoint(x: centerWidth - height, y: height))

        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
        controlPoint1: CGPoint(x: centerWidth + height, y: height), controlPoint2: CGPoint(x: (centerWidth + height), y: 0))

        path.addLine(to: CGPoint(x: tabBar.frame.width, y: 0))
        path.addLine(to: CGPoint(x: tabBar.frame.width, y: tabHeight))
        path.addLine(to: CGPoint(x: 0, y: tabHeight))
        path.close()

        return path.cgPath
    }
    
    @objc func menuButtonAction(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "webView")
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)        
    }

}
