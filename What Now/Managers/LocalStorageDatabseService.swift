import Firebase
import Snail

class LocalStorageDatabaseService: DatabaseService {
    var observable: Observable<Void>

    let kSavedTasks = "kSavedTasks"
    var tasksFromServer: [Task] = []
    var tasks: [Task] = []
    init() {
        self.observable = Observable<Void>()
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
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(tasks) {
        let taskData = NSKeyedArchiver.archivedData(withRootObject: data)
            UserDefaults.standard.set(taskData, forKey: kSavedTasks)
            observable.on(.next(()))
        }
    }

    func delete(task: Task) {
        if let indexToDelete = tasks.index(of: task) {
            tasks.remove(at: indexToDelete)
        }
        observable.on(.next(()))
    }

    func getTasks() -> [Task] {
        return tasks
    }
}
