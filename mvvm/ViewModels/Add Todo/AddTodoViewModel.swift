//
//  AddTodoViewModel.swift
//  mvvm
//
//  Created by Paul Meyerle on 2/9/17.
//  Copyright © 2017 Paul Meyerle. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

protocol AddTodoViewModelType {
    // Inputs
    var saveButtonItemDidTap: PublishSubject<Void> { get }
    var title: Variable<String?> { get set }
    var description: Variable<String?> { get set }

    // Outputs
    var isValid: Driver<Bool> { get }
    var titleText: Driver<String> { get }
}

struct AddTodoViewModel: AddTodoViewModelType {
    private let disposeBag = DisposeBag()

    let saveButtonItemDidTap = PublishSubject<Void>()
    let viewDidDeallocate = PublishSubject<Void>()

    var title = Variable<String?>("")
    var description = Variable<String?>("")
    var isValid: Driver<Bool>
    var titleText: Driver<String>

    init(networking: NetworkProvider, sceneCoordinator: SceneCoordinator) {
        isValid = title
            .asObservable()
            .map { text in text?.isEmpty == false }
            .startWith(false)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)

        titleText = Observable.just("Add a Todo Item")
            .asDriver(onErrorJustReturn: "Add a Todo Item")

        let formData = Observable.combineLatest(title.asObservable(), description.asObservable()) { ($0, $1) }

        saveButtonItemDidTap
            .withLatestFrom(formData)
            .flatMapLatest { (title, description) -> Observable<TodoModel> in
                let todo = TodoModel(title: title!, description: description!)
                return networking.addTodo(todo: todo)
            }
            .subscribe(onNext: { _ in
                sceneCoordinator.pop()
            })
            .addDisposableTo(disposeBag)
    }
}
