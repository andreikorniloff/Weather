//
//  Box.swift
//  Weather
//
//  Created by Andrei Kornilov on 03.10.2021.
//

import Foundation

class Box<T> {
    typealias Listener = (T) -> Void
    
    private var listeners: [UUID: Listener] = [:]
    
    var value: T {
        didSet {
            listeners.values.forEach { $0(value) }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }

    func bind(listener: @escaping Listener) -> Disposable {
        let identifier = UUID()
        
        listeners[identifier] = listener
        
        listener(value)
        
        return Disposable { self.listeners.removeValue(forKey: identifier) }
    }
}
