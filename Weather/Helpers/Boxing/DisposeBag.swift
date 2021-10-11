//
//  DisposeBag.swift
//  Weather
//
//  Created by Andrei Kornilov on 10.10.2021.
//

class DisposeBag {
    private var disposables: [Disposable] = []
    
    func append(_ disposable: Disposable) { disposables.append(disposable) }
}

extension Disposable {
    func disposed(by bag: DisposeBag) {
        bag.append(self)
    }
}
