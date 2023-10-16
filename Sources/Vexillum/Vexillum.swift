import Combine

public final class Vexillum {
    public typealias Provider = AnyPublisher<[AnyProviderResult], Never>
    
    @Published private var cache: [FeatureToggle.Id: FeatureToggle.Dynamic<Any>] = [:]
    private var providerCancellable: AnyCancellable?
    
    public init(providers: [Provider] = []) {
        self.providerCancellable = Publishers.MergeMany(providers)
            .flatMap { results in Publishers.MergeMany(results.map{ Just($0) }) }
            .map { result in result.value }
            .sink(receiveValue: { [weak self] updateFeature in self?.cache[updateFeature.id] = updateFeature })
    }
    
    public func enabled<Payload>(_ feature: FeatureToggle.Static<Payload>) -> Bool {
        return feature.enabled
    }
    
    public func observeEnabled<Payload>(_ feature: FeatureToggle.Dynamic<Payload>) -> AnyPublisher<Bool, Never> {
        return self.$cache
            .map { $0[feature.id] }
            .map { cachedFeature in cachedFeature?.enabled ?? feature.defaultEnabled}
            .eraseToAnyPublisher()
    }
    
    public func payload<Payload>(_ feature: FeatureToggle.Static<Payload>) -> Payload {
        return feature.payload
    }
    
    public func observePayload<Payload>(_ feature: FeatureToggle.Dynamic<Payload>) -> AnyPublisher<Payload, Never> {
        return self.$cache
            .map { $0[feature.id] }
            .map { cachedFeature in (cachedFeature?.payload as? Payload) ?? feature.defaultPayload }
            .eraseToAnyPublisher()
    }
    
    public struct AnyProviderResult {
        internal let value: Vexillum.FeatureToggle.Dynamic<Any>
        
        public init<Payload>(feature: FeatureToggle.Dynamic<Payload>, newEnabled: Bool, newPayload: Payload) {
            self.value = Vexillum.FeatureToggle.Dynamic<Any>(
                defaultEnabled: newEnabled,
                defaultPayload: newPayload as Any,
                id: feature.id,
                name: feature.name,
                description: feature.description
            )
        }
    }
}
