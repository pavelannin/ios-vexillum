import Foundation

public extension Vexillum {
    enum FeatureToggle {
        public  typealias Id = UUID
        
        public struct Static<Payload> {
            internal let id: Id
            internal let enabled: Bool
            internal let payload: Payload
            let name: String?
            let description: String?
            
            public init(enabled: Bool, payload: Payload, id: Id = .init(), name: String? = nil, description: String? = nil) {
                self.id = id
                self.enabled = enabled
                self.payload = payload
                self.name = name
                self.description = description
            }
        }
        
        public struct Dynamic<Payload> {
            internal let id: Id
            internal let enabled: Bool
            internal let payload: Payload
            public let name: String?
            public let description: String?
            
            public var defaultEnabled: Bool { return self.enabled }
            public var defaultPayload: Payload { return self.payload }
            
            public init(defaultEnabled: Bool, defaultPayload: Payload, id: Id = .init(), name: String? = nil, description: String? = nil) {
                self.id = id
                self.enabled = defaultEnabled
                self.payload = defaultPayload
                self.name = name
                self.description = description
            }
        }
    }
}

public extension Vexillum.FeatureToggle.Static where Payload == Void {
    init(enabled: Bool, id: Vexillum.FeatureToggle.Id = .init(), name: String? = nil, description: String? = nil) {
        self.init(enabled: enabled, payload: (), id: id, name: name, description: description)
    }
}

public extension Vexillum.FeatureToggle.Dynamic where Payload == Void {
    init(defaultEnabled: Bool, id: Vexillum.FeatureToggle.Id = .init(), name: String? = nil, description: String? = nil) {
        self.init(defaultEnabled: defaultEnabled, defaultPayload: (), id: id, name: name, description: description)
    }
}
