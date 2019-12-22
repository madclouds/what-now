struct Task: Codable, Equatable {

    var title: String
    var id: String
    var length: TaskLength

    static func == (lhs: Task, rhs: Task) -> Bool {
        return
            lhs.title == rhs.title &&
                lhs.length.length == rhs.length.length
    }
}

//everythign in models and viewmodels.  Try to create Task from dictionary or string.
//everything except for views
