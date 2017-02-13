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
import Moya

protocol AddTodoViewModelType {
    var viewDidDeallocate: PublishSubject<Void> { get }
    var saveButtonItemDidTap: PublishSubject<Void> { get }
    
    var title: Variable<String?> { get set }
    var description: Variable<String?> { get set }
    var isValid: Driver<Bool> { get }
}

struct AddTodoViewModel: AddTodoViewModelType {
    fileprivate let disposeBag = DisposeBag()
    private let todoService: RxMoyaProvider<TodoService>
    
    
    let saveButtonItemDidTap = PublishSubject<Void>()
    let viewDidDeallocate = PublishSubject<Void>()
    
    var title = Variable<String?>("")
    var description = Variable<String?>("")
    var isValid: Driver<Bool>
    
    init(todoService: RxMoyaProvider<TodoService>) {
        self.todoService = todoService
        
        self.isValid = title
            .asObservable()
            .map { text in text?.isEmpty == false }
            .startWith(false)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
        
        let formData = Observable.combineLatest(self.title.asObservable(), self.description.asObservable()) { ($0, $1) }
        
        self.saveButtonItemDidTap
            .takeUntil(self.viewDidDeallocate)
            .withLatestFrom(formData)
            .subscribe(onNext: { (title, description) in
                // Save the item.  then inform the corrodinator that we are DONE
                let todo = TodoModel(title: title!, description: description!)
                todoService.request(.createTodo(todo: todo))
                    .debug("create user")
                    .subscribe { event in
                        switch event {
                        case let .next(response):
                            _ = response
                        case let .error(error):
                            _ = error
                        default:
                            break
                        }
                    }
            })
            .addDisposableTo(self.disposeBag)
    }
}
