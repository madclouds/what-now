import Firebase
import Snail

class LocalStorageDatabaseService: DatabaseService {
    var saveTask: Observable<Task>

    var onTasksChanged: Observable<[Task]>

    let kSavedTasks = "kSavedTasks-v1"
    var tasksFromServer: [Task] = []
    var tasks: [Task] = []
    init() {
        self.onTasksChanged = Observable()
        self.saveTask = Observable()
        if let savedData = UserDefaults.standard.value(forKey: kSavedTasks) as? Data {
            let decoder = JSONDecoder()
            if let data = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? Data {
                if let savedTasks = try? decoder.decode([Task].self, from: data) {
                    tasks = savedTasks
                }
            }
        }
    }
    func save(title: String, length: TaskLength) {
        let task = Task(title: title, id: "", length: length)
        tasks.append(task)
        tasksChanged()
    }

    func delete(task: Task) {
        if let indexToDelete = tasks.index(of: task) {
            tasks.remove(at: indexToDelete)
            tasksChanged()
        }
    }

    private func tasksChanged() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(tasks) {
            let taskData = NSKeyedArchiver.archivedData(withRootObject: data)
            UserDefaults.standard.set(taskData, forKey: kSavedTasks)
            onTasksChanged.on(.next(tasks))
        }

    }
    func getTasks() -> [Task] {
        return tasks
    }
}
