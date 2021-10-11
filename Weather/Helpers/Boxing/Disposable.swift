//
//  Disposable.swift
//  Weather
//
//  Created by Andrei Kornilov on 10.10.2021.
//

class Disposable {
    let dispose: () -> Void
    init(_ dispose: @escaping () -> Void) { self.dispose = dispose }
    deinit { dispose() }
}
