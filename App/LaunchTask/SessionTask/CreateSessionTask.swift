import Combine
import UIKit

struct Session {
    let anonId: String = UUID().uuidString
}

final class SetupSessionTask: Publisher {
    typealias Output = Session
    typealias Failure = Error

    private let publisher = Future<Output, Failure> { completion in completion(.success(Session())) }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Session == S.Input {
        publisher.receive(subscriber: subscriber)
    }
}

