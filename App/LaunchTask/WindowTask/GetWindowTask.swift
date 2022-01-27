import Combine
import UIKit

final class GetWindowTask: Publisher {
    typealias Output = UIWindow
    typealias Failure = Error
    struct WindowIsNotAwailableError: Error {}
    
    let task: Future<UIWindow, Failure>
    
    init(_ scene: UIWindowScene) {
        self.task = .init { completion in
            guard let window = scene.windows.first else {
                completion(.failure(WindowIsNotAwailableError()))
                return
            }
            completion(.success(window))
        }
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, UIWindow == S.Input {
        task.receive(subscriber: subscriber)
    }
}
