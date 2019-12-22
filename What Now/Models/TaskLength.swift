enum TaskLength: Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let length = try values.decode(Float.self, forKey: .length)
        switch length {
        case 1: self = .oneMinute
        case 5: self = .fiveMinute
        case 15: self = .fifteenMinute
        case 30: self = .thirtyMinute
        case 60: self = .oneHour
        case 180: self = .threeHour
        case 300: self = .fiveHour
        default: self = .fiveHour
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(length, forKey: .length)
        try container.encode(subTitle, forKey: .subTitle)
    }

    case oneMinute
    case fiveMinute
    case fifteenMinute
    case thirtyMinute
    case oneHour
    case threeHour
    case fiveHour

    static let all: [TaskLength] = [.oneMinute, .fiveMinute, .fifteenMinute, .thirtyMinute, .oneHour, .fiveHour]

    var title: String {
        switch self {
        case .oneMinute: return "1"
        case .fiveMinute: return "5"
        case .fifteenMinute: return "15"
        case .thirtyMinute: return "30"
        case .oneHour: return "1"
        case .threeHour: return "3"
        case .fiveHour: return "5"
        }
    }

    var subTitle: String {
        switch self {
        case .oneMinute: return "min"
        case .fiveMinute: return "min"
        case .fifteenMinute: return "min"
        case .thirtyMinute: return "min"
        case .oneHour: return "hr"
        case .threeHour: return "hr"
        case .fiveHour: return "hr"
        }
    }

    var length: Float {
        switch self {
        case .oneMinute: return 1
        case .fiveMinute: return 5
        case .fifteenMinute: return 15
        case .thirtyMinute: return 30
        case .oneHour: return 60
        case .threeHour: return 60*3
        case .fiveHour: return 60*5
        }
    }

    enum CodingKeys: String, CodingKey {
        case title
        case subTitle
        case length
    }
}
