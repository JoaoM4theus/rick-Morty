//
//  MainQueueDispatchDecorator.swift
//  RickMortyUI
//
//  Created by Joao Matheus on 23/10/23.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
    let decorate: T
    
    init(decorate: T) {
        self.decorate = decorate
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        completion()
    }
    
}
