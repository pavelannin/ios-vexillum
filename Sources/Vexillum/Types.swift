import Foundation

extension Vexillum {
    enum FeatureToggle {
        internal typealias Id = UUID
        
        struct Static<Payload> : Identifiable {
            internal let id: Id
            internal let enabled: Bool
            internal let payload: Payload
            let name: String?
            let description: String?
            
            init(enabled: Bool, payload: Payload, id: Id = .init(), name: String? = nil, description: String? = nil) {
                self.id = id
                self.enabled = enabled
                self.payload = payload
                self.name = name
                self.description = description
            }
        }
        
        struct Dynamic<Payload> : Identifiable {
            internal let id: Id
            internal let enabled: Bool
            internal let payload: Payload
            let name: String?
            let description: String?
            
            var defaultEnabled: Bool { return self.enabled }
            var defaultPayload: Payload { return self.payload }
            
            init(defaultEnabled: Bool, defaultPayload: Payload, id: Id = .init(), name: String? = nil, description: String? = nil) {
                self.id = id
                self.enabled = defaultEnabled
                self.payload = defaultPayload
                self.name = name
                self.description = description
            }
        }
    }
}

extension Vexillum.FeatureToggle.Static where Payload == Void {
    init(enabled: Bool, id: Vexillum.FeatureToggle.Id = .init(), name: String? = nil, description: String? = nil) {
        self.init(enabled: enabled, payload: (), id: id, name: name, description: description)
    }
}

extension Vexillum.FeatureToggle.Dynamic where Payload == Void {
    init(defaultEnabled: Bool, id: Vexillum.FeatureToggle.Id = .init(), name: String? = nil, description: String? = nil) {
        self.init(defaultEnabled: defaultEnabled, defaultPayload: (), id: id, name: name, description: description)
    }
}
