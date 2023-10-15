import XCTest
import Combine
@testable import Vexillum

final class VexillumTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    func testEnabledShouldReturnTrueWhenFeatureIsEnabled() throws {
        let service = Vexillum()
        let feature = Vexillum.FeatureToggle.Static(enabled: true)
        XCTAssertTrue(service.enabled(feature))
    }
    
    func testEnabledShouldReturnFalseWhenFeatureIsDisabled() throws {
        let service = Vexillum()
        let feature = Vexillum.FeatureToggle.Static(enabled: false)
        XCTAssertFalse(service.enabled(feature))
    }
    
    func testPayloadShouldReturnTheCorrectPayloadForStaticFeature() throws {
        let service = Vexillum()
        let feature = Vexillum.FeatureToggle.Static(enabled: false, payload: "my_key")
        XCTAssertEqual("my_key", service.payload(feature))
    }

    func testObserveEnabledShouldObserveEmitProviderWhenDynamicFeatureIsEnabled() throws {
        let provider = CurrentValueSubject<Bool?, Never>(nil)
        let feature = Vexillum.FeatureToggle.Dynamic(defaultEnabled: true)
        let service = Vexillum(
            providers: [
                provider
                    .compactMap { $0 }
                    .map { [Vexillum.AnyProviderResult(feature: feature, newEnabled: $0, newPayload: ())] }
                    .eraseToAnyPublisher()
            ]
        )
        
        let observe = service.observeEnabled(feature)
        // default value
        observe.first().sink(receiveValue: { XCTAssertTrue($0) }).store(in: &cancellables)
        
        provider.send(false)
        observe.first().sink(receiveValue: { XCTAssertFalse($0) }).store(in: &cancellables)
        
        provider.send(true)
        observe.prefix(1).first().sink(receiveValue: { XCTAssertTrue($0) }).store(in: &cancellables)
        
    }
    
    func testObservePayloadShouldEmitTheCorrectPayloadForDynamicFeature() throws {
        let provider = CurrentValueSubject<String?, Never>(nil)
        let feature = Vexillum.FeatureToggle.Dynamic(defaultEnabled: true, defaultPayload: "key_default")
        let service = Vexillum(
            providers: [
                provider
                    .compactMap { $0 }
                    .map { [Vexillum.AnyProviderResult(feature: feature, newEnabled: true, newPayload: $0)] }
                    .eraseToAnyPublisher()
            ]
        )
        
        let observe = service.observePayload(feature)
        // default value
        observe.first().sink(receiveValue: { XCTAssertEqual("key_default", $0) }).store(in: &cancellables)
        
        provider.send("key_1")
        observe.first().sink(receiveValue: {XCTAssertEqual("key_1", $0)  }).store(in: &cancellables)
        
        provider.send("key_2")
        observe.first().sink(receiveValue: { XCTAssertEqual("key_2", $0)  }).store(in: &cancellables)
        
    }
}
