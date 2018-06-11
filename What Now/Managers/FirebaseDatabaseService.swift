//
//  FirebaseDatabaseService.swift
//  What Now
//
//  Created by Erik Bye on 6/7/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import Firebase
import Snail

class FirebaseDatabaseService: DatabaseService {
    var observable: Observable<Void>
    let db = Firestore.firestore()
    var tasksFromServer: [Task] = []
    init() {
        self.observable = Observable<Void>()
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser {
            db.collection("tasks").document(user.uid).collection("tasks").addSnapshotListener { (querySnapshot, error) in
                guard error == nil else {
                    return
                }
                self.tasksFromServer = []
                for document in querySnapshot!.documents {
                    var data = document.data()
                    data["id"] = document.documentID
                    let json = try? JSONSerialization.data(withJSONObject: data)
                    if let newTask = try? JSONDecoder().decode(Task.self, from: json!) {
                        self.tasksFromServer.append(newTask)
                    }
                }
                self.observable.on(.next(()))
            }

        }
    }
    func save(title: String, length: TaskLength) {
        let dict: [String: Any] = ["title": title,
                    "length": [
                        "length": length.length,
                        "title": length.title,
                        "subTitle": length.subTitle]]

        if let user = Auth.auth().currentUser {
            db.collection("tasks").document(user.uid).collection("tasks").addDocument(data: dict) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                }
            }
        }
    }

    func update(task: Task) {
        //do update
    }

    func delete(task: Task) {
        if let user = Auth.auth().currentUser {
            db.collection("tasks").document(user.uid).collection("tasks").document(task.id).delete()
        }
    }

    func getTasks() -> [Task] {
        return tasksFromServer
    }
}
