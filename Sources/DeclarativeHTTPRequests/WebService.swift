//
//  WebService.swift
//  DeclarativeHTTPRequests
//
//  Created by Andrew J Wagner on 7/20/19.
//

import Foundation

/// Root of a given request
///
/// It defines all the basic properties that a request will have. Most notably,
/// it defines the baseURL.
///
/// A WebService can also customize a number of things
///
/// Most of these things are defined as instance methods and properties so that
/// you can customize them based on environment (e.g. Dev, Test, and Prod)
public protocol WebService {
    // MARK: Core

    /// Anything included in every the response from every endpoint
    ///
    /// For example, maybe every response includes a “status” property
    ///
    /// This will be parsed from first from every response and provided
    /// to validate(_:for:) for an custom response validation
    ///
    /// If the service does not return a standard basic response, use `NoBasicResponse`
    associatedtype BasicResponse: Decodable

    /// A type to represent all error responses
    ///
    /// When there is an error parsing/verifying the response,
    /// this will be attempted to be decoded to provide a service
    /// defined error message.
    ///
    /// For example, many services return a "message" property whenever
    /// an error occures.
    ///
    /// If the service does not return JSON errors, simply use `NoErrorResponse`
    associatedtype ErrorResponse: AnyErrorResponse

    /// The default web service to use for requests
    static var shared: Self {get}

    /// **OPTIONAL** URL session to use for requests
    ///
    /// Defaults to `URLSession.shared`
    var sessionOverride: Session? {get}

    /// Base URL for all requests to this service
    ///
    /// The final request URL will be formed by appending the endpoint's path
    /// to this URL
    var baseURL: URL {get}

    // MARK: Configuration

    /// **OPTIONAL** Chance to configure each URLRequest
    func configure(_ request: inout URLRequest) throws

    // **OPTIONAL** Chance to configure each input encoder
    func configure(_ encoder: inout JSONEncoder) throws

    // **OPTIONAL** Chance to configure each output encoder
    func configure(_ decoder: inout JSONDecoder) throws

    // MARK: Validation

    // **OPTIONAL** Chance to validate the URLResponse
    func validate<E: Endpoint>(_ response: URLResponse, for endpoint: E) throws

    // **OPTIONAL** Chance to validate the BasicResponse
    func validate<E: Endpoint>(_ response: BasicResponse, for endpoint: E) throws
}


extension WebService {
    public var sessionOverride: Session? { return nil }
    public func configure(_ request: inout URLRequest) throws {}
    public func configure(_ encoder: inout JSONEncoder) throws {}
    public func configure(_ decoder: inout JSONDecoder) throws {}
    public func validate<E: Endpoint>(_ response: URLResponse, for endpoint: E) throws {}
    public func validate<E: Endpoint>(_ response: BasicResponse, for endpoint: E) throws {}
}
