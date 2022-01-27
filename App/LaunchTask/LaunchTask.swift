import Combine
import UIKit

struct App {
    let session: Session
    let window: UIWindow
}

final class LaunchTask: Publisher {
    typealias Output = App
    typealias Failure = Error
    
    let windowTask: AnyPublisher<UIWindow, Error>
    let sessionTask: AnyPublisher<Session, Error>
    let userConsentTask: AnyPublisher<Void, Error>
    let termsAndConditionsTask: AnyPublisher<Void, Error>
    
    private lazy var publisher: AnyPublisher<Output, Failure> = windowTask
            .zip(sessionTask)
            .zip(userConsentTask)
            .zip(termsAndConditionsTask)
            .map { App(session: $0.0.0.1, window: $0.0.0.0) }
            .eraseToAnyPublisher()
            
    
    init(windowTask: AnyPublisher<UIWindow, Error>,
         sessionTask: AnyPublisher<Session, Error>,
         userConsentTask: AnyPublisher<Void, Error>,
         termsAndConditionsTask: AnyPublisher<Void, Error>) {
        self.windowTask = windowTask
        self.sessionTask = sessionTask
        self.userConsentTask = userConsentTask
        self.termsAndConditionsTask = termsAndConditionsTask
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, App == S.Input {
        publisher.receive(subscriber: subscriber)
    }
}
