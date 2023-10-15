import Combine

class Vexillum {
    typealias Provider = AnyPublisher<[AnyProviderResult], Never>
    
    @Published private var cache: [FeatureToggle.Id: FeatureToggle.Dynamic<Any>] = [:]
    private var providerCancellable: AnyCancellable?
    
    init(providers: [Provider] = []) {
        self.providerCancellable = Publishers.MergeMany(providers)
            .flatMap { results in Publishers.MergeMany(results.map{ Just($0) }) }
            .map { result in result.value }
            .sink(receiveValue: { [weak self] updateFeature in self?.cache[updateFeature.id] = updateFeature })
    }
    
    func enabled<Payload>(_ feature: FeatureToggle.Static<Payload>) -> Bool {
        return feature.enabled
    }
    
    func observeEnabled<Payload>(_ feature: FeatureToggle.Dynamic<Payload>) -> AnyPublisher<Bool, Never> {
        return self.$cache
            .map { $0[feature.id] }
            .map { cachedFeature in cachedFeature?.enabled ?? feature.defaultEnabled}
            .eraseToAnyPublisher()
    }
    
    func payload<Payload>(_ feature: FeatureToggle.Static<Payload>) -> Payload {
        return feature.payload
    }
    
    func observePayload<Payload>(_ feature: FeatureToggle.Dynamic<Payload>) -> AnyPublisher<Payload, Never> {
        return self.$cache
            .map { $0[feature.id] }
            .map { cachedFeature in (cachedFeature?.payload as? Payload) ?? feature.defaultPayload }
            .eraseToAnyPublisher()
    }
    
    struct AnyProviderResult {
        internal let value: Vexillum.FeatureToggle.Dynamic<Any>
        
        init<Payload>(feature: FeatureToggle.Dynamic<Payload>, newEnabled: Bool, newPayload: Payload) {
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
