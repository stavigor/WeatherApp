//
//  UIViewExtension.swift
//  WeatherApp
//
//  Created by Игорь Растегаев on 26.09.2023.
//

import UIKit

extension UIView{
    
    func addBlueRoundBorder(_ radius: CGFloat){
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 1.0
        self.layer.borderColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8941176471, alpha: 1)
    }
   
}

