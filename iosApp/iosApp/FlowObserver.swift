import shared
import Combine

class FlowObserver<T>: ObservableObject {
    @Published var value: T?
    private var cancellable: AnyCancellable?
    
    init(flow: any kotlinx.coroutines.flow.StateFlow) {
        cancellable = FlowPublisher(flow: flow)
            .receive(on: RunLoop.main)
            .sink { completion in
                // Handle completion if needed
            } receiveValue: { [weak self] value in
                self?.value = value as? T
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
}

struct FlowPublisher: Publisher {
    typealias Output = Any?
    typealias Failure = Never
    
    private let flow: any kotlinx.coroutines.flow.StateFlow
    
    init(flow: any kotlinx.coroutines.flow.StateFlow) {
        self.flow = flow
    }
    
    func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Any? == S.Input {
        let subscription = FlowSubscription(flow: flow, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

private class FlowSubscription: Subscription {
    private var subscriber: AnySubscriber<Any?, Never>?
    private var job: Kotlinx_coroutines_coreJob?
    private let flow: any kotlinx.coroutines.flow.StateFlow
    
    init<S>(flow: any kotlinx.coroutines.flow.StateFlow, subscriber: S) where S: Subscriber, S.Input == Any?, S.Failure == Never {
        self.flow = flow
        self.subscriber = AnySubscriber(subscriber)
        
        job = FlowExtensionsKt.subscribe(flow) { value in
            _ = self.subscriber?.receive(value)
        }
    }
    
    func request(_ demand: Subscribers.Demand) {
        // No-op, Flow handles backpressure
    }
    
    func cancel() {
        subscriber = nil
        job?.cancel(cause: nil)
    }
}
