public struct Billboard {
    public static func printSomething() {
        print("===========================================================")
        print("App Name: \(Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String)")
        print("Version: \(Bundle.main.infoDictionary![kCFBundleVersionKey as String] as! String)")
        print("Build: \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)")
        print("===========================================================")
    }
}
