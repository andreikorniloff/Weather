//
//  UIImageView+Extensions.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

extension UIImageView {
    func getImage(from url: String?) {
        guard let url = url else {
            image = UIImage(systemName: "xmark.shield")
            return
        }
        
        OpenWeatherMapService.shared.fetchImage(for: url) { [weak self] data in
            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
        }
    }
}
