import Foundation
import Combine

extension Publisher {
    func share<Subject: Combine.Subject>(
        to subject: Subject
    ) -> AnyCancellable where Subject.Output == Self.Output, Subject.Failure == Self.Failure {
        return sink {
            subject.send(completion: $0)
        } receiveValue: {
            subject.send($0)
        }
    }
}
