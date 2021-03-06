//
//  Endpoint+MakeRequest.swift
//  Decree
//
//  Created by Andrew J Wagner on 7/20/19.
//

import Foundation

extension EmptyEndpoint {
#if canImport(ObjectiveC)
    /// Make asynchronous request to this endpoint
    ///
    /// This is generally most appropriate in front-ends so that the interface remains reactive
    ///
    /// - Parameter service: service to make the request to
    /// - Parameter callbackQueue: Queue to execute the onComplete and onProgress callbacks on. If nil, it will execute on an unpredictable queue. Defaults to the main queue.
    /// - Parameter onProgress: Callback that periodically reports the request's progress
    /// - Parameter onComplete: Callback when the request is complete
    @available(iOS 11.0, OSX 10.13, tvOS 11.0, *)
    public func makeRequest(to service: Service = Service.shared, callbackQueue: DispatchQueue? = DispatchQueue.main, onProgress: ((Double) -> ())?, onComplete: @escaping (_ result: EmptyResult) -> ()) {
        self._makeRequest(to: service, callbackQueue: callbackQueue, onProgress: onProgress, onComplete: onComplete)
    }
#endif

    /// Make asynchronous request to this endpoint
    ///
    /// This is generally most appropriate in front-ends so that the interface remains reactive
    ///
    /// - Parameter service: service to make the request to
    /// - Parameter callbackQueue: Queue to execute the onComplete callback on. If nil, it will execute on an unpredictable queue. Defaults to the main queue.
    /// - Parameter onComplete: Callback when the request is complete
    public func makeRequest(to service: Service = Service.shared, callbackQueue: DispatchQueue? = DispatchQueue.main, onComplete: @escaping (_ result: EmptyResult) -> ()) {
        self._makeRequest(to: service, callbackQueue: callbackQueue, onProgress: nil, onComplete: onComplete)
    }

    /// Make synchronous request to this endpoint
    ///
    /// This is generally most appropriate on back-ends to keep the handling of requests on the same thread
    ///
    /// - Parameter service: service to make the request to
    public func makeSynchronousRequest(to service: Service = Service.shared) throws {
        let semephore = DispatchSemaphore(value: 0)
        var result: EmptyResult?
        self._makeRequest(to: service, callbackQueue: nil, onProgress: nil) { output in
            result = output
            semephore.signal()
        }
        semephore.wait()

        switch result! {
        case .success:
            break
        case .failure(let error):
            throw error
        }
    }
}

extension InEndpoint where Input: Encodable {
#if canImport(ObjectiveC)
    /// Make asynchronous request to this endpoint
    ///
    /// This is generally most appropriate in front-ends so that the interface remains reactive
    ///
    /// **Important**: The Input must be Encodable
    ///
    /// - Parameter service: service to make the request to
    /// - Parameter input: data to pass to endpoint
    /// - Parameter callbackQueue: Queue to execute the onComplete and onProgress callbacks on. If nil, it will execute on an unpredictable queue. Defaults to the main queue.
    /// - Parameter onProgress: Callback that periodically reports the request's progress
    /// - Parameter onComplete: Callback when the request is complete
    @available(iOS 11.0, OSX 10.13, tvOS 11.0, *)
    public func makeRequest(to service: Service = Service.shared, with input: Input, callbackQueue: DispatchQueue? = DispatchQueue.main, onProgress: ((Double) -> ())?, onComplete: @escaping (_ result: EmptyResult) -> ()) {
        self._makeRequest(to: service, with: input, callbackQueue: callbackQueue, onProgress: onProgress, onComplete: onComplete)
    }
#endif

    /// Make asynchronous request to this endpoint
    ///
    /// This is generally most appropriate in front-ends so that the interface remains reactive
    ///
    /// **Important**: The Input must be Encodable
    ///
    /// - Parameter service: service to make the request to
    /// - Parameter input: data to pass to endpoint
    /// - Parameter callbackQueue: Queue to execute the onComplete callback on. If nil, it will execute on an unpredictable queue. Defaults to the main queue.
    /// - Parameter onComplete: Callback when the request is complete
    public func makeRequest(to service: Service = Service.shared, with input: Input, callbackQueue: DispatchQueue? = DispatchQueue.main, onComplete: @escaping (_ result: EmptyResult) -> ()) {
        self._makeRequest(to: service, with: input, callbackQueue: callbackQueue, onProgress: nil, onComplete: onComplete)
    }

    /// Make synchronous request to this endpoint
    ///
    /// This is generally most appropriate on back-ends to keep the handling of requests on the same thread
    ///
    /// **Important**: The Input must be Encodable
    ///
    /// - Parameter service: service to make the request to
    /// - Parameter input: data to pass to endpoint
    public func makeSynchronousRequest(to service: Service = Service.shared, with input: Input) throws {
        let semephore = DispatchSemaphore(value: 0)
        var result: EmptyResult?
        self._makeRequest(to: service, with: input, callbackQueue: nil, onProgress: nil) { output in
            result = output
            semephore.signal()
        }
        semephore.wait()

        switch result! {
        case .success:
            break
        case .failure(let error):
            throw error
        }
    }
}

extension OutEndpoint where Output: Decodable {
#if canImport(ObjectiveC)
    /// Make asynchronous request to this endpoint
    ///
    /// This is generally most appropriate in front-ends so that the interface remains reactive
    ///
    /// **Important**: The Output must be Decodable
    ///
    /// - Parameter service: service to make the request to
    /// - Parameter callbackQueue: Queue to execute the onComplete and onProgress callbacks on. If nil, it will execute on an unpredictable queue. Defaults to the main queue.
    /// - Parameter onProgress: Callback that periodically reports the request's progress
    /// - Parameter onComplete: Callback when the request is complete that includes output if successful
    @available(iOS 11.0, OSX 10.13, tvOS 11.0, *)
    public func makeRequest(to service: Service = Service.shared, callbackQueue: DispatchQueue? = DispatchQueue.main, onProgress: ((Double) -> ())?, onComplete: @escaping (_ result: Result<Output, DecreeError>) -> ()) {
        self._makeRequest(to: service, callbackQueue: callbackQueue, onProgress: onProgress, onComplete: onComplete)
    }
#endif

    /// Make asynchronous request to this endpoint
    ///
    /// This is generally most appropriate in front-ends so that the interface remains reactive
    ///
    /// **Important**: The Output must be Decodable
    ///
    /// - Parameter service: service to make the request to
    /// - Parameter callbackQueue: Queue to execute the onComplete callback on. If nil, it will execute on an unpredictable queue. Defaults to the main queue.
    /// - Parameter onComplete: Callback when the request is complete that includes output if successful
    public func makeRequest(to service: Service = Service.shared, callbackQueue: DispatchQueue? = DispatchQueue.main, onComplete: @escaping (_ result: Result<Output, DecreeError>) -> ()) {
        self._makeRequest(to: service, callbackQueue: callbackQueue, onProgress: nil, onComplete: onComplete)
    }

    /// Make synchronous request to this endpoint
    ///
    /// This is generally most appropriate on back-ends to keep the handling of requests on the same thread
    ///
    /// **Important**: The Output must be Decodable
    ///
    /// - Parameter service: service to make the request to
    ///
    /// - Returns: endpoint's output
    public func makeSynchronousRequest(to service: Service = Service.shared) throws -> Output {
        let semephore = DispatchSemaphore(value: 0)
        var result: Result<Output, DecreeError>?
        self._makeRequest(to: service, callbackQueue: nil, onProgress: nil) { output in
            result = output
            semephore.signal()
        }
        semephore.wait()

        switch result! {
        case .success(let output):
            return output
        case .failure(let error):
            throw error
        }
    }
}

extension OutEndpoint {
    /// Make asynchronous download request to this endpoint
    ///
    /// This is generally most appropriate in front-ends so that the interface remains reactive
    ///
    /// **Important**: The URL in the callback is only guaranteed
    /// to exist until the callback returns. If you want to keep the file around, you must move
    /// it somewhere else or open it for reading.
    ///
    /// - Parameter service: service to make the request to
    /// - Parameter callbackQueue: Queue to execute the onComplete callbacks on. If nil, it will execute on an unpredictable queue. Defaults to the main queue.
    /// - Parameter onComplete: Callback when the request is complete that includes url to the downloaded data
    public func makeDownloadRequest(to service: Service = Service.shared, callbackQueue: DispatchQueue? = DispatchQueue.main, onComplete: @escaping (_ error: Result<URL, DecreeError>) -> ()) {
        self._makeDownloadRequest(to: service, callbackQueue: callbackQueue, onProgress: nil, onComplete: onComplete)
    }

#if canImport(ObjectiveC)
    /// Make asynchronous download request to this endpoint
    ///
    /// This is generally most appropriate in front-ends so that the interface remains reactive
    ///
    /// **Important**: The URL in the callback is only guaranteed
    /// to exist until the callback returns. If you want to keep the file around, you must move
    /// it somewhere else or open it for reading.
    ///
    /// - Parameter service: service to make the request to
    /// - Parameter callbackQueue: Queue to execute the onComplete and onProgress callbacks on. If nil, it will execute on an unpredictable queue. Defaults to the main queue.
    /// - Parameter onProgress: Callback that periodically reports the request's progress
    /// - Parameter onComplete: Callback when the request is complete that includes url to the downloaded data
    public func makeDownloadRequest(to service: Service = Service.shared, callbackQueue: DispatchQueue? = DispatchQueue.main, onProgress: ((Double) -> ())?, onComplete: @escaping (_ error: Result<URL, DecreeError>) -> ()) {
        self._makeDownloadRequest(to: service, callbackQueue: callbackQueue, onProgress: onProgress, onComplete: onComplete)
    }
#endif
}

extension InOutEndpoint where Input: Encodable, Output: Decodable {
#if canImport(ObjectiveC)
    /// Make Asynchronous Request to this endpoint
    ///
    /// This is generally most appropriate in front-ends so that the interface remains reactive
    ///
    /// **Important**: The Input must be Encodable and the Output must be Decodable
    ///
    /// - Parameter service: service to make the request to
    /// - Parameter input: data to pass to endpoint
    /// - Parameter callbackQueue: Queue to execute the onComplete and onProgress callbacks on. If nil, it will execute on an unpredictable queue. Defaults to the main queue.
    /// - Parameter onProgress: Callback that periodically reports the request's progress
    /// - Parameter onComplete: Callback when the request is complete that includes output if successful
    @available(iOS 11.0, OSX 10.13, tvOS 11.0, *)
    public func makeRequest(to service: Service = Service.shared, with input: Input, callbackQueue: DispatchQueue? = DispatchQueue.main, onProgress: ((Double) -> ())?, onComplete: @escaping (_ error: Result<Output, DecreeError>) -> ()) {
        self._makeRequest(to: service, with: input, callbackQueue: callbackQueue, onProgress: onProgress, onComplete: onComplete)
    }
#endif

    /// Make Asynchronous Request to this endpoint
    ///
    /// This is generally most appropriate in front-ends so that the interface remains reactive
    ///
    /// **Important**: The Input must be Encodable and the Output must be Decodable
    ///
    /// - Parameter service: service to make the request to
    /// - Parameter input: data to pass to endpoint
    /// - Parameter callbackQueue: Queue to execute the onComplete callback on. If nil, it will execute on an unpredictable queue. Defaults to the main queue.
    /// - Parameter onComplete: Callback when the request is complete that includes output if successful
    public func makeRequest(to service: Service = Service.shared, with input: Input, callbackQueue: DispatchQueue? = DispatchQueue.main, onComplete: @escaping (_ error: Result<Output, DecreeError>) -> ()) {
        self._makeRequest(to: service, with: input, callbackQueue: callbackQueue, onProgress: nil, onComplete: onComplete)
    }

    /// Make synchronous Request to this endpoint
    ///
    /// This is generally most appropriate on back-ends to keep the handling of requests on the same thread
    ///
    /// **Important**: The Input must be Encodable and the Output must be Decodable
    ///
    /// - Parameter service: service to make the request to
    /// - Parameter input: data to pass to endpoint
    ///
    /// - Returns: endpoint's output
    public func makeSynchronousRequest(to service: Service = Service.shared, with input: Input) throws -> Output {
        let semephore = DispatchSemaphore(value: 0)
        var result: Result<Output, DecreeError>?
        self._makeRequest(to: service, with: input, callbackQueue: nil, onProgress: nil) { output in
            result = output
            semephore.signal()
        }
        semephore.wait()

        switch result! {
        case .success(let output):
            return output
        case .failure(let error):
            throw error
        }
    }
}

extension InOutEndpoint where Input: Encodable {
    /// Make asynchronous download request to this endpoint
    ///
    /// This is generally most appropriate in front-ends so that the interface remains reactive
    ///
    /// **Important**: The Input must be Encodable and the URL in the callback is only guaranteed
    /// to exist until the callback returns. If you want to keep the file around, you must move
    /// it somewhere else or open it for reading.
    ///
    /// - Parameter service: service to make the request to
    /// - Parameter input: data to pass to endpoint
    /// - Parameter callbackQueue: Queue to execute the onComplete callbacks on. If nil, it will execute on an unpredictable queue. Defaults to the main queue.
    /// - Parameter onComplete: Callback when the request is complete that includes url to the downloaded data
    public func makeDownloadRequest(to service: Service = Service.shared, with input: Input, callbackQueue: DispatchQueue? = DispatchQueue.main, onComplete: @escaping (_ error: Result<URL, DecreeError>) -> ()) {
        self._makeDownloadRequest(to: service, with: input, callbackQueue: callbackQueue, onProgress: nil, onComplete: onComplete)
    }

#if canImport(ObjectiveC)
    /// Make asynchronous download request to this endpoint
    ///
    /// This is generally most appropriate in front-ends so that the interface remains reactive
    ///
    /// **Important**: The Input must be Encodable and the URL in the callback is only guaranteed
    /// to exist until the callback returns. If you want to keep the file around, you must move
    /// it somewhere else or open it for reading.
    ///
    /// - Parameter service: service to make the request to
    /// - Parameter input: data to pass to endpoint
    /// - Parameter callbackQueue: Queue to execute the onComplete and onProgress callbacks on. If nil, it will execute on an unpredictable queue. Defaults to the main queue.
    /// - Parameter onProgress: Callback that periodically reports the request's progress
    /// - Parameter onComplete: Callback when the request is complete that includes url to the downloaded data
    public func makeDownloadRequest(to service: Service = Service.shared, with input: Input, callbackQueue: DispatchQueue? = DispatchQueue.main, onProgress: ((Double) -> ())?, onComplete: @escaping (_ error: Result<URL, DecreeError>) -> ()) {
        self._makeDownloadRequest(to: service, with: input, callbackQueue: callbackQueue, onProgress: onProgress, onComplete: onComplete)
    }
#endif
}
