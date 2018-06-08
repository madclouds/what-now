//
//  FirebaseDatabaseService.swift
//  What Now
//
//  Created by Erik Bye on 6/7/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import Firebase

class FirebaseDatabaseService: DatabaseService {
    let db = Firestore.firestore()
    var tasksFromServer: [Task] = []
    init() {
        let db = Firestore.firestore()
        db.collection("tasks").addSnapshotListener { (querySnapshot, error) in
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
        }
    }
    func save(title: String, length: TaskLength) {
        let dict: [String: Any] = ["title": title,
                    "length": [
                        "length": length.length,
                        "title": length.title,
                        "subTitle": length.subTitle]]

        db.collection("tasks").addDocument(data: dict) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
        }
    }

    func update(task: Task) {
        //do update
    }

    func delete(task: Task) {
        db.collection("tasks").document(task.id).delete()
    }

    func getTasks() -> [Task] {
        return tasksFromServer
    }
}
