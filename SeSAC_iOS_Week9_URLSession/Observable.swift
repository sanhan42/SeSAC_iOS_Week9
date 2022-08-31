//
//  Observable.swift
//  SeSAC_iOS_Week9_URLSession
//
//  Created by 한상민 on 2022/08/31.
//

import Foundation

class Observable<T> { // 양방향 바인딩
    private var listener: ((T)->Void)?
    
    var value: T {
        didSet {
            print("didStet", value)
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T)->Void) {
        print(#function)
        closure(value) // 한 번 실행하고
        listener = closure // 이후에도 실행될 수 있게 담아줌.
    }
}
