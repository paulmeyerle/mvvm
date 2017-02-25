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
    fileprivate let todoService: RxMoyaProvider<TodoService>
    fileprivate let appCoordinator: AppCoordinator

    let saveButtonItemDidTap = PublishSubject<Void>()
    let viewDidDeallocate = PublishSubject<Void>()

    var title = Variable<String?>("")
    var description = Variable<String?>("")
    var isValid: Driver<Bool>

    init(todoService: RxMoyaProvider<TodoService>, appCoordinator: AppCoordinator) {
        self.todoService = todoService
        self.appCoordinator = appCoordinator

        isValid = title
            .asObservable()
            .map { text in text?.isEmpty == false }
            .startWith(false)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)

        let formData = Observable.combineLatest(title.asObservable(), description.asObservable()) { ($0, $1) }

        saveButtonItemDidTap
            .takeUntil(viewDidDeallocate)
            .withLatestFrom(formData)
            .flatMapLatest({ (title, description) -> Observable<Response> in
                let todo = TodoModel(title: title!, description: description!)
                return todoService.request(.createTodo(todo: todo))
                    .debug("create user")
            })
            .mapObject(type: TodoModel.self)
            .subscribe { event in
                switch event {
                case .next:
                    appCoordinator.viewTodos()
                case .error(let error):
                    _ = error
                    // show error?
                default:
                    break
                }
            }
            .addDisposableTo(disposeBag)
    }
}
