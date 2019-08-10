import Foundation

internal class MockURLSession: URLSession {
    let data: Data?
    let response: URLResponse?
    let error: Error?

    internal init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.response = response
        self.error = error
    }

    internal init(withResponseFileName filename: String, withExtension: String = "json") {
        let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let fileURL = currentDirectoryURL
            .appendingPathComponent("Tests", isDirectory: true)
            .appendingPathComponent("NextbikeTests", isDirectory: true)
            .appendingPathComponent(filename)
            .appendingPathExtension(withExtension)
        self.data = try! Data(contentsOf: fileURL)
        self.response = nil
        self.error = nil
    }

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(self.data, self.response, self.error)
        return MockURLSessionDataTask()
    }
}

internal class MockURLSessionDataTask: URLSessionDataTask {
    override func resume() {}
}
