import Combine
import UIKit

final class GetUserTrackingConsentTask {
    typealias Output = Void
    typealias Failure = Error
    
    struct ConsentDeniedError: Error {}
    
    private let windowTask: AnyPublisher<UIWindow, Error>
    private let anonIdTask: AnyPublisher<String, Error>
    
    private lazy var publisher: AnyPublisher<Output, Failure> = windowTask
        .zip(anonIdTask)
        .receive(on: DispatchQueue.main)
        .flatMap { [weak self] window, anonId in
            Future<Void, Failure> { completion in
                self?.presentDialog(from: window, for: anonId, completion: completion)
            }
     
        }
        .withBarier
        .eraseToAnyPublisher()
    
    init(windowTask: AnyPublisher<UIWindow, Error>, anonIdTask: AnyPublisher<String, Error>) {
        self.windowTask = windowTask
        self.anonIdTask = anonIdTask
    }
    
    private func presentDialog(from window: UIWindow, for user: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let alert = UIAlertController(
            title: "Allow tracking?",
            message: "user: \(user)",
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "Yes", style: .default) { _ in completion(.success(Void())) })
        alert.addAction(.init(title: "No", style: .default) { _ in completion(.failure(ConsentDeniedError())) })
        window.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

extension GetUserTrackingConsentTask: Publisher {
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        publisher.receive(subscriber: subscriber)
    }
}
