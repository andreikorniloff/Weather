//
//  UIView+Extensions.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

extension UIView {
    func edgeTo(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func edgeTo(layoutGuide: UILayoutGuide) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
    }
    
    func addTopBorder(with color: UIColor, andHeight borderHeight: CGFloat) {
        let border = UIView()
        
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderHeight)
        
        addSubview(border)
    }
    
    func addBottomBorder(with color: UIColor, andHeight borderHeight: CGFloat) {
        let border = UIView()
        
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.size.width, height: borderHeight)
        
        addSubview(border)
    }
}
