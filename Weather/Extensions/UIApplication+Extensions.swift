//
//  UIApplication+Extensions.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

extension UIApplication {
    static var statusBarHeight: CGFloat {
        let window = shared.windows.filter { $0.isKeyWindow }.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
}

