//
//  AddTodoViewModel.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Jetsetter. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol AddTodoViewModelType {
    var viewDidDeallocate: PublishSubject<Void> { get }
    var saveButtonItemDidTap: PublishSubject<Void> { get }
    
    var title: Variable<String?> { get set }
    var description: Variable<String?> { get set }
    var isValid: Driver<Bool> { get }
}

struct AddTodoViewModel: AddTodoViewModelType {
    fileprivate let disposeBag = DisposeBag()
    let saveButtonItemDidTap = PublishSubject<Void>()
    let viewDidDeallocate = PublishSubject<Void>()
    
    var title = Variable<String?>("")
    var description = Variable<String?>("")
    var isValid: Driver<Bool>
    
    init() {
        self.isValid = title
            .asObservable()
            .map { text in text?.isEmpty == false }
            .startWith(false)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
        
        self.saveButtonItemDidTap
            .takeUntil(self.viewDidDeallocate)
            .subscribe(onNext: {
                // Save the item.  then inform the corrodinator that we are DONE
            })
            .addDisposableTo(self.disposeBag)
    }
}
