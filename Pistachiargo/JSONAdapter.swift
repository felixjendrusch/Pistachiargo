//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import Foundation

import Result
import Pistachio
import Argo

public struct JSONAdapter<Value>: AdapterType {
    private typealias Adapter = DictionaryAdapter<String, Value, JSONValue, NSError>
    private let adapter: Adapter

    public init(specification: Adapter.Specification, valueClosure: JSONValue -> Result<Value, NSError>) {
        adapter = DictionaryAdapter(specification: specification, dictionaryTransformer: JSONValueTransformers.dictionary, valueClosure: valueClosure)
    }

    public init(specification: Adapter.Specification, @autoclosure(escaping) value: () -> Value) {
        self.init(specification: specification, valueClosure: { _ in
            return Result.success(value())
        })
    }

    public func transform(value: Value) -> Result<JSONValue, NSError> {
        return adapter.transform(value)
    }

    public func reverseTransform(transformedValue: JSONValue) -> Result<Value, NSError> {
        return adapter.reverseTransform(transformedValue)
    }
}
