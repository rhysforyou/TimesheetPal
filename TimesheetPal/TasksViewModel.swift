//
//  TasksViewModel.swift
//  TimesheetPal
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TasksViewModel {
    let tasks: Observable<[TaskAssignment]>
    let selectedTask: Variable<TaskAssignment?>

    init(tasks: Observable<[TaskAssignment]>, selectedTask: Variable<TaskAssignment?>) {
        self.tasks = tasks
        self.selectedTask = selectedTask
    }
}
