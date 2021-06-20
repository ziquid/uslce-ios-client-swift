/**
 * (C) Copyright IBM Corp. 2018, 2020.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

/**
 * IBM OpenAPI SDK Code Generator Version: 99-SNAPSHOT-be3b4618-20201221-123327
 **/

// swiftlint:disable file_length

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import IBMSwiftSDKCore

public typealias WatsonError = RestError
public typealias WatsonResponse = RestResponse
/**
 The IBM Watson&trade; Assistant service combines machine learning, natural language understanding, and an integrated
 dialog editor to create conversation flows between your apps and your users.
 The Assistant v1 API provides authoring methods your application can use to create or update a workspace.
 */
public class Assistant {

    /// The base URL to use when contacting the service.
    public var serviceURL: String? = "https://api.us-south.assistant.watson.cloud.ibm.com"

    /// Release date of the API version you want to use. Specify dates in YYYY-MM-DD format. The current version is
    /// `2020-04-01`.
    public var version: String

    /// Service identifiers
    public static let defaultServiceName = "conversation"
    // Service info for SDK headers
    internal let serviceName = defaultServiceName
    internal let serviceVersion = "v1"
    internal let serviceSdkName = "assistant"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    var session = URLSession(configuration: URLSessionConfiguration.default)
    public let authenticator: Authenticator

    #if os(Linux)
    /**
     Create a `Assistant` object.

     If an authenticator is not supplied, the initializer will retrieve credentials from the environment or
     a local credentials file and construct an appropriate authenticator using these credentials.
     The credentials file can be downloaded from your service instance on IBM Cloud as ibm-credentials.env.
     Make sure to add the credentials file to your project so that it can be loaded at runtime.

     If an authenticator is not supplied and credentials are not available in the environment or a local
     credentials file, initialization will fail by throwing an exception.
     In that case, try another initializer that directly passes in the credentials.

     - parameter version: Release date of the API version you want to use. Specify dates in YYYY-MM-DD format. The
       current version is `2020-04-01`.
     - parameter authenticator: The Authenticator object used to authenticate requests to the service
     - serviceName: String = defaultServiceName
     */
    public init(version: String, authenticator: Authenticator? = nil, serviceName: String = defaultServiceName) throws {
        self.version = version
        self.authenticator = try authenticator ?? ConfigBasedAuthenticatorFactory.getAuthenticator(credentialPrefix: serviceName)
        if let serviceURL = CredentialUtils.getServiceURL(credentialPrefix: serviceName) {
            self.serviceURL = serviceURL
        }
        RestRequest.userAgent = Shared.userAgent
    }
    #else
    /**
     Create a `Assistant` object.

     - parameter version: Release date of the API version you want to use. Specify dates in YYYY-MM-DD format. The
       current version is `2020-04-01`.
     - parameter authenticator: The Authenticator object used to authenticate requests to the service
     */
    public init(version: String, authenticator: Authenticator) {
        self.version = version
        self.authenticator = authenticator
        RestRequest.userAgent = Shared.userAgent
    }
    #endif

    #if !os(Linux)
    /**
      Allow network requests to a server without verification of the server certificate.
      **IMPORTANT**: This should ONLY be used if truly intended, as it is unsafe otherwise.
     */
    public func disableSSLVerification() {
        session = InsecureConnection.session()
    }
    #endif

    /**
     Use the HTTP response and data received by the Watson Assistant v1 service to extract
     information about the error that occurred.

     - parameter data: Raw data returned by the service that may represent an error.
     - parameter response: the URL response returned by the service.
     */
    func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> RestError {

        let statusCode = response.statusCode
        var errorMessage: String?
        var metadata = [String: Any]()

        do {
            let json = try JSON.decoder.decode([String: JSON].self, from: data)
            metadata["response"] = json
            if case let .some(.array(errors)) = json["errors"],
                case let .some(.object(error)) = errors.first,
                case let .some(.string(message)) = error["message"] {
                errorMessage = message
            } else if case let .some(.string(message)) = json["error"] {
                errorMessage = message
            } else if case let .some(.string(message)) = json["message"] {
                errorMessage = message
            } else {
                errorMessage = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
            }
        } catch {
            metadata["response"] = data
            errorMessage = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
        }

        return RestError.http(statusCode: statusCode, message: errorMessage, metadata: metadata)
    }

    /**
     Get response to user input.

     Send user input to a workspace and receive a response.
     **Important:** This method has been superseded by the new v2 runtime API. The v2 API offers significant advantages,
     including ease of deployment, automatic state management, versioning, and search capabilities. For more
     information, see the [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-api-overview).

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter input: An input object that includes the input text.
     - parameter intents: Intents to use when evaluating the user input. Include intents from the previous response to
       continue using those intents rather than trying to recognize intents in the new input.
     - parameter entities: Entities to use when evaluating the message. Include entities from the previous response to
       continue using those entities rather than detecting entities in the new input.
     - parameter alternateIntents: Whether to return more than one intent. A value of `true` indicates that all
       matching intents are returned.
     - parameter context: State information for the conversation. To maintain state, include the context from the
       previous response.
     - parameter output: An output object that includes the response to the user, the dialog nodes that were
       triggered, and messages from the log.
     - parameter nodesVisitedDetails: Whether to include additional diagnostic information about the dialog nodes that
       were visited during processing of the message.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func message(
        workspaceID: String,
        input: MessageInput? = nil,
        intents: [RuntimeIntent]? = nil,
        entities: [RuntimeEntity]? = nil,
        alternateIntents: Bool? = nil,
        context: Context? = nil,
        output: OutputData? = nil,
        nodesVisitedDetails: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<MessageResponse>?, WatsonError?) -> Void)
    {
        // construct body
        let messageRequest = MessageRequest(
            input: input,
            intents: intents,
            entities: entities,
            alternate_intents: alternateIntents,
            context: context,
            output: output)
        let body: Data?
        do {
            body = try JSON.encoder.encodeIfPresent(messageRequest)
        } catch {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "message")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let nodesVisitedDetails = nodesVisitedDetails {
            let queryParameter = URLQueryItem(name: "nodes_visited_details", value: "\(nodesVisitedDetails)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/message"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the message request body
    private struct MessageRequest: Encodable {
        // swiftlint:disable identifier_name
        let input: MessageInput?
        let intents: [RuntimeIntent]?
        let entities: [RuntimeEntity]?
        let alternate_intents: Bool?
        let context: Context?
        let output: OutputData?
        init? (input: MessageInput? = nil, intents: [RuntimeIntent]? = nil, entities: [RuntimeEntity]? = nil, alternate_intents: Bool? = nil, context: Context? = nil, output: OutputData? = nil) {
            if input == nil && intents == nil && entities == nil && alternate_intents == nil && context == nil && output == nil {
                return nil
            }
            self.input = input
            self.intents = intents
            self.entities = entities
            self.alternate_intents = alternate_intents
            self.context = context
            self.output = output
        }
        // swiftlint:enable identifier_name
    }

    /**
     Identify intents and entities in multiple user utterances.

     Send multiple user inputs to a workspace in a single request and receive information about the intents and entities
     recognized in each input. This method is useful for testing and comparing the performance of different workspaces.
     This method is available only with Premium plans.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter input: An array of input utterances to classify.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func bulkClassify(
        workspaceID: String,
        input: [BulkClassifyUtterance]? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<BulkClassifyResponse>?, WatsonError?) -> Void)
    {
        // construct body
        let bulkClassifyRequest = BulkClassifyRequest(
            input: input)
        let body: Data?
        do {
            body = try JSON.encoder.encodeIfPresent(bulkClassifyRequest)
        } catch {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "bulkClassify")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/bulk_classify"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the bulkClassify request body
    private struct BulkClassifyRequest: Encodable {
        // swiftlint:disable identifier_name
        let input: [BulkClassifyUtterance]?
        init? (input: [BulkClassifyUtterance]? = nil) {
            if input == nil {
                return nil
            }
            self.input = input
        }
        // swiftlint:enable identifier_name
    }

    /**
     List workspaces.

     List the workspaces associated with a Watson Assistant service instance.

     - parameter pageLimit: The number of records to return in each page of results.
     - parameter includeCount: Whether to include information about the number of records that satisfy the request,
       regardless of the page limit. If this parameter is `true`, the `pagination` object in the response includes the
       `total` property.
     - parameter sort: The attribute by which returned workspaces will be sorted. To reverse the sort order, prefix
       the value with a minus sign (`-`).
     - parameter cursor: A token identifying the page of results to retrieve.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listWorkspaces(
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<WorkspaceCollection>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listWorkspaces")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let includeCount = includeCount {
            let queryParameter = URLQueryItem(name: "include_count", value: "\(includeCount)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + "/v1/workspaces",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create workspace.

     Create a workspace based on component objects. You must provide workspace components defining the content of the
     new workspace.

     - parameter name: The name of the workspace. This string cannot contain carriage return, newline, or tab
       characters.
     - parameter description: The description of the workspace. This string cannot contain carriage return, newline,
       or tab characters.
     - parameter language: The language of the workspace.
     - parameter dialogNodes: An array of objects describing the dialog nodes in the workspace.
     - parameter counterexamples: An array of objects defining input examples that have been marked as irrelevant
       input.
     - parameter metadata: Any metadata related to the workspace.
     - parameter learningOptOut: Whether training data from the workspace (including artifacts such as intents and
       entities) can be used by IBM for general service improvements. `true` indicates that workspace training data is
       not to be used.
     - parameter systemSettings: Global settings for the workspace.
     - parameter webhooks:
     - parameter intents: An array of objects defining the intents for the workspace.
     - parameter entities: An array of objects describing the entities for the workspace.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createWorkspace(
        name: String? = nil,
        description: String? = nil,
        language: String? = nil,
        dialogNodes: [DialogNode]? = nil,
        counterexamples: [Counterexample]? = nil,
        metadata: [String: JSON]? = nil,
        learningOptOut: Bool? = nil,
        systemSettings: WorkspaceSystemSettings? = nil,
        webhooks: [Webhook]? = nil,
        intents: [CreateIntent]? = nil,
        entities: [CreateEntity]? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Workspace>?, WatsonError?) -> Void)
    {
        // construct body
        let createWorkspaceRequest = CreateWorkspaceRequest(
            name: name,
            description: description,
            language: language,
            dialog_nodes: dialogNodes,
            counterexamples: counterexamples,
            metadata: metadata,
            learning_opt_out: learningOptOut,
            system_settings: systemSettings,
            webhooks: webhooks,
            intents: intents,
            entities: entities)
        let body: Data?
        do {
            body = try JSON.encoder.encodeIfPresent(createWorkspaceRequest)
        } catch {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createWorkspace")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + "/v1/workspaces",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the createWorkspace request body
    private struct CreateWorkspaceRequest: Encodable {
        // swiftlint:disable identifier_name
        let name: String?
        let description: String?
        let language: String?
        let dialog_nodes: [DialogNode]?
        let counterexamples: [Counterexample]?
        let metadata: [String: JSON]?
        let learning_opt_out: Bool?
        let system_settings: WorkspaceSystemSettings?
        let webhooks: [Webhook]?
        let intents: [CreateIntent]?
        let entities: [CreateEntity]?
        init? (name: String? = nil, description: String? = nil, language: String? = nil, dialog_nodes: [DialogNode]? = nil, counterexamples: [Counterexample]? = nil, metadata: [String: JSON]? = nil, learning_opt_out: Bool? = nil, system_settings: WorkspaceSystemSettings? = nil, webhooks: [Webhook]? = nil, intents: [CreateIntent]? = nil, entities: [CreateEntity]? = nil) {
            if name == nil && description == nil && language == nil && dialog_nodes == nil && counterexamples == nil && metadata == nil && learning_opt_out == nil && system_settings == nil && webhooks == nil && intents == nil && entities == nil {
                return nil
            }
            self.name = name
            self.description = description
            self.language = language
            self.dialog_nodes = dialog_nodes
            self.counterexamples = counterexamples
            self.metadata = metadata
            self.learning_opt_out = learning_opt_out
            self.system_settings = system_settings
            self.webhooks = webhooks
            self.intents = intents
            self.entities = entities
        }
        // swiftlint:enable identifier_name
    }

    /**
     Get information about a workspace.

     Get information about a workspace, optionally including all workspace content.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter export: Whether to include all element content in the returned data. If **export**=`false`, the
       returned data includes only information about the element itself. If **export**=`true`, all content, including
       subelements, is included.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter sort: Indicates how the returned workspace data will be sorted. This parameter is valid only if
       **export**=`true`. Specify `sort=stable` to sort all workspace objects by unique identifier, in ascending
       alphabetical order.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getWorkspace(
        workspaceID: String,
        export: Bool? = nil,
        includeAudit: Bool? = nil,
        sort: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Workspace>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getWorkspace")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update workspace.

     Update an existing workspace with new or modified data. You must provide component objects defining the content of
     the updated workspace.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter name: The name of the workspace. This string cannot contain carriage return, newline, or tab
       characters.
     - parameter description: The description of the workspace. This string cannot contain carriage return, newline,
       or tab characters.
     - parameter language: The language of the workspace.
     - parameter dialogNodes: An array of objects describing the dialog nodes in the workspace.
     - parameter counterexamples: An array of objects defining input examples that have been marked as irrelevant
       input.
     - parameter metadata: Any metadata related to the workspace.
     - parameter learningOptOut: Whether training data from the workspace (including artifacts such as intents and
       entities) can be used by IBM for general service improvements. `true` indicates that workspace training data is
       not to be used.
     - parameter systemSettings: Global settings for the workspace.
     - parameter webhooks:
     - parameter intents: An array of objects defining the intents for the workspace.
     - parameter entities: An array of objects describing the entities for the workspace.
     - parameter append: Whether the new data is to be appended to the existing data in the object. If
       **append**=`false`, elements included in the new data completely replace the corresponding existing elements,
       including all subelements. For example, if the new data for a workspace includes **entities** and
       **append**=`false`, all existing entities in the workspace are discarded and replaced with the new entities.
       If **append**=`true`, existing elements are preserved, and the new elements are added. If any elements in the new
       data collide with existing elements, the update request fails.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateWorkspace(
        workspaceID: String,
        name: String? = nil,
        description: String? = nil,
        language: String? = nil,
        dialogNodes: [DialogNode]? = nil,
        counterexamples: [Counterexample]? = nil,
        metadata: [String: JSON]? = nil,
        learningOptOut: Bool? = nil,
        systemSettings: WorkspaceSystemSettings? = nil,
        webhooks: [Webhook]? = nil,
        intents: [CreateIntent]? = nil,
        entities: [CreateEntity]? = nil,
        append: Bool? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Workspace>?, WatsonError?) -> Void)
    {
        // construct body
        let updateWorkspaceRequest = UpdateWorkspaceRequest(
            name: name,
            description: description,
            language: language,
            dialog_nodes: dialogNodes,
            counterexamples: counterexamples,
            metadata: metadata,
            learning_opt_out: learningOptOut,
            system_settings: systemSettings,
            webhooks: webhooks,
            intents: intents,
            entities: entities)
        let body: Data?
        do {
            body = try JSON.encoder.encodeIfPresent(updateWorkspaceRequest)
        } catch {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateWorkspace")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let append = append {
            let queryParameter = URLQueryItem(name: "append", value: "\(append)")
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the updateWorkspace request body
    private struct UpdateWorkspaceRequest: Encodable {
        // swiftlint:disable identifier_name
        let name: String?
        let description: String?
        let language: String?
        let dialog_nodes: [DialogNode]?
        let counterexamples: [Counterexample]?
        let metadata: [String: JSON]?
        let learning_opt_out: Bool?
        let system_settings: WorkspaceSystemSettings?
        let webhooks: [Webhook]?
        let intents: [CreateIntent]?
        let entities: [CreateEntity]?
        init? (name: String? = nil, description: String? = nil, language: String? = nil, dialog_nodes: [DialogNode]? = nil, counterexamples: [Counterexample]? = nil, metadata: [String: JSON]? = nil, learning_opt_out: Bool? = nil, system_settings: WorkspaceSystemSettings? = nil, webhooks: [Webhook]? = nil, intents: [CreateIntent]? = nil, entities: [CreateEntity]? = nil) {
            if name == nil && description == nil && language == nil && dialog_nodes == nil && counterexamples == nil && metadata == nil && learning_opt_out == nil && system_settings == nil && webhooks == nil && intents == nil && entities == nil {
                return nil
            }
            self.name = name
            self.description = description
            self.language = language
            self.dialog_nodes = dialog_nodes
            self.counterexamples = counterexamples
            self.metadata = metadata
            self.learning_opt_out = learning_opt_out
            self.system_settings = system_settings
            self.webhooks = webhooks
            self.intents = intents
            self.entities = entities
        }
        // swiftlint:enable identifier_name
    }

    /**
     Delete workspace.

     Delete a workspace from the service instance.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteWorkspace(
        workspaceID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteWorkspace")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     List intents.

     List the intents for a workspace.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter export: Whether to include all element content in the returned data. If **export**=`false`, the
       returned data includes only information about the element itself. If **export**=`true`, all content, including
       subelements, is included.
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter includeCount: Whether to include information about the number of records that satisfy the request,
       regardless of the page limit. If this parameter is `true`, the `pagination` object in the response includes the
       `total` property.
     - parameter sort: The attribute by which returned intents will be sorted. To reverse the sort order, prefix the
       value with a minus sign (`-`).
     - parameter cursor: A token identifying the page of results to retrieve.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listIntents(
        workspaceID: String,
        export: Bool? = nil,
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<IntentCollection>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listIntents")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
            queryParameters.append(queryParameter)
        }
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let includeCount = includeCount {
            let queryParameter = URLQueryItem(name: "include_count", value: "\(includeCount)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create intent.

     Create a new intent.
     If you want to create multiple intents with a single API call, consider using the **[Update
     workspace](#update-workspace)** method instead.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The name of the intent. This string must conform to the following restrictions:
       - It can contain only Unicode alphanumeric, underscore, hyphen, and dot characters.
       - It cannot begin with the reserved prefix `sys-`.
     - parameter description: The description of the intent. This string cannot contain carriage return, newline, or
       tab characters.
     - parameter examples: An array of user input examples for the intent.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createIntent(
        workspaceID: String,
        intent: String,
        description: String? = nil,
        examples: [Example]? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Intent>?, WatsonError?) -> Void)
    {
        // construct body
        let createIntentRequest = CreateIntentRequest(
            intent: intent,
            description: description,
            examples: examples)
        guard let body = try? JSON.encoder.encode(createIntentRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createIntent")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the createIntent request body
    private struct CreateIntentRequest: Encodable {
        // swiftlint:disable identifier_name
        let intent: String
        let description: String?
        let examples: [Example]?
        // swiftlint:enable identifier_name
    }

    /**
     Get intent.

     Get information about an intent, optionally including all intent content.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The intent name.
     - parameter export: Whether to include all element content in the returned data. If **export**=`false`, the
       returned data includes only information about the element itself. If **export**=`true`, all content, including
       subelements, is included.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getIntent(
        workspaceID: String,
        intent: String,
        export: Bool? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Intent>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getIntent")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents/\(intent)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update intent.

     Update an existing intent with new or modified data. You must provide component objects defining the content of the
     updated intent.
     If you want to update multiple intents with a single API call, consider using the **[Update
     workspace](#update-workspace)** method instead.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The intent name.
     - parameter newIntent: The name of the intent. This string must conform to the following restrictions:
       - It can contain only Unicode alphanumeric, underscore, hyphen, and dot characters.
       - It cannot begin with the reserved prefix `sys-`.
     - parameter newDescription: The description of the intent. This string cannot contain carriage return, newline,
       or tab characters.
     - parameter newExamples: An array of user input examples for the intent.
     - parameter append: Whether the new data is to be appended to the existing data in the object. If
       **append**=`false`, elements included in the new data completely replace the corresponding existing elements,
       including all subelements. For example, if the new data for the intent includes **examples** and
       **append**=`false`, all existing examples for the intent are discarded and replaced with the new examples.
       If **append**=`true`, existing elements are preserved, and the new elements are added. If any elements in the new
       data collide with existing elements, the update request fails.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateIntent(
        workspaceID: String,
        intent: String,
        newIntent: String? = nil,
        newDescription: String? = nil,
        newExamples: [Example]? = nil,
        append: Bool? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Intent>?, WatsonError?) -> Void)
    {
        // construct body
        let updateIntentRequest = UpdateIntentRequest(
            intent: newIntent,
            description: newDescription,
            examples: newExamples)
        guard let body = try? JSON.encoder.encode(updateIntentRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateIntent")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let append = append {
            let queryParameter = URLQueryItem(name: "append", value: "\(append)")
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents/\(intent)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the updateIntent request body
    private struct UpdateIntentRequest: Encodable {
        // swiftlint:disable identifier_name
        let intent: String?
        let description: String?
        let examples: [Example]?
        // swiftlint:enable identifier_name
    }

    /**
     Delete intent.

     Delete an intent from a workspace.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The intent name.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteIntent(
        workspaceID: String,
        intent: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteIntent")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents/\(intent)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     List user input examples.

     List the user input examples for an intent, optionally including contextual entity mentions.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The intent name.
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter includeCount: Whether to include information about the number of records that satisfy the request,
       regardless of the page limit. If this parameter is `true`, the `pagination` object in the response includes the
       `total` property.
     - parameter sort: The attribute by which returned examples will be sorted. To reverse the sort order, prefix the
       value with a minus sign (`-`).
     - parameter cursor: A token identifying the page of results to retrieve.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listExamples(
        workspaceID: String,
        intent: String,
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ExampleCollection>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listExamples")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let includeCount = includeCount {
            let queryParameter = URLQueryItem(name: "include_count", value: "\(includeCount)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents/\(intent)/examples"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create user input example.

     Add a new user input example to an intent.
     If you want to add multiple examples with a single API call, consider using the **[Update intent](#update-intent)**
     method instead.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The intent name.
     - parameter text: The text of a user input example. This string must conform to the following restrictions:
       - It cannot contain carriage return, newline, or tab characters.
       - It cannot consist of only whitespace characters.
     - parameter mentions: An array of contextual entity mentions.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createExample(
        workspaceID: String,
        intent: String,
        text: String,
        mentions: [Mention]? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Example>?, WatsonError?) -> Void)
    {
        // construct body
        let createExampleRequest = CreateExampleRequest(
            text: text,
            mentions: mentions)
        guard let body = try? JSON.encoder.encode(createExampleRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createExample")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents/\(intent)/examples"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the createExample request body
    private struct CreateExampleRequest: Encodable {
        // swiftlint:disable identifier_name
        let text: String
        let mentions: [Mention]?
        // swiftlint:enable identifier_name
    }

    /**
     Get user input example.

     Get information about a user input example.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The intent name.
     - parameter text: The text of the user input example.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getExample(
        workspaceID: String,
        intent: String,
        text: String,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Example>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getExample")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents/\(intent)/examples/\(text)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update user input example.

     Update the text of a user input example.
     If you want to update multiple examples with a single API call, consider using the **[Update
     intent](#update-intent)** method instead.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The intent name.
     - parameter text: The text of the user input example.
     - parameter newText: The text of the user input example. This string must conform to the following restrictions:
       - It cannot contain carriage return, newline, or tab characters.
       - It cannot consist of only whitespace characters.
     - parameter newMentions: An array of contextual entity mentions.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateExample(
        workspaceID: String,
        intent: String,
        text: String,
        newText: String? = nil,
        newMentions: [Mention]? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Example>?, WatsonError?) -> Void)
    {
        // construct body
        let updateExampleRequest = UpdateExampleRequest(
            text: newText,
            mentions: newMentions)
        guard let body = try? JSON.encoder.encode(updateExampleRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateExample")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents/\(intent)/examples/\(text)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the updateExample request body
    private struct UpdateExampleRequest: Encodable {
        // swiftlint:disable identifier_name
        let text: String?
        let mentions: [Mention]?
        // swiftlint:enable identifier_name
    }

    /**
     Delete user input example.

     Delete a user input example from an intent.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The intent name.
     - parameter text: The text of the user input example.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteExample(
        workspaceID: String,
        intent: String,
        text: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteExample")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents/\(intent)/examples/\(text)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     List counterexamples.

     List the counterexamples for a workspace. Counterexamples are examples that have been marked as irrelevant input.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter includeCount: Whether to include information about the number of records that satisfy the request,
       regardless of the page limit. If this parameter is `true`, the `pagination` object in the response includes the
       `total` property.
     - parameter sort: The attribute by which returned counterexamples will be sorted. To reverse the sort order,
       prefix the value with a minus sign (`-`).
     - parameter cursor: A token identifying the page of results to retrieve.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listCounterexamples(
        workspaceID: String,
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<CounterexampleCollection>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listCounterexamples")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let includeCount = includeCount {
            let queryParameter = URLQueryItem(name: "include_count", value: "\(includeCount)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/counterexamples"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create counterexample.

     Add a new counterexample to a workspace. Counterexamples are examples that have been marked as irrelevant input.
     If you want to add multiple counterexamples with a single API call, consider using the **[Update
     workspace](#update-workspace)** method instead.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter text: The text of a user input marked as irrelevant input. This string must conform to the following
       restrictions:
       - It cannot contain carriage return, newline, or tab characters.
       - It cannot consist of only whitespace characters.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createCounterexample(
        workspaceID: String,
        text: String,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Counterexample>?, WatsonError?) -> Void)
    {
        // construct body
        let createCounterexampleRequest = CreateCounterexampleRequest(
            text: text)
        guard let body = try? JSON.encoder.encode(createCounterexampleRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createCounterexample")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/counterexamples"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the createCounterexample request body
    private struct CreateCounterexampleRequest: Encodable {
        // swiftlint:disable identifier_name
        let text: String
        // swiftlint:enable identifier_name
    }

    /**
     Get counterexample.

     Get information about a counterexample. Counterexamples are examples that have been marked as irrelevant input.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter text: The text of a user input counterexample (for example, `What are you wearing?`).
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getCounterexample(
        workspaceID: String,
        text: String,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Counterexample>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getCounterexample")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/counterexamples/\(text)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update counterexample.

     Update the text of a counterexample. Counterexamples are examples that have been marked as irrelevant input.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter text: The text of a user input counterexample (for example, `What are you wearing?`).
     - parameter newText: The text of a user input marked as irrelevant input. This string must conform to the
       following restrictions:
       - It cannot contain carriage return, newline, or tab characters.
       - It cannot consist of only whitespace characters.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateCounterexample(
        workspaceID: String,
        text: String,
        newText: String? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Counterexample>?, WatsonError?) -> Void)
    {
        // construct body
        let updateCounterexampleRequest = UpdateCounterexampleRequest(
            text: newText)
        guard let body = try? JSON.encoder.encode(updateCounterexampleRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateCounterexample")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/counterexamples/\(text)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the updateCounterexample request body
    private struct UpdateCounterexampleRequest: Encodable {
        // swiftlint:disable identifier_name
        let text: String?
        // swiftlint:enable identifier_name
    }

    /**
     Delete counterexample.

     Delete a counterexample from a workspace. Counterexamples are examples that have been marked as irrelevant input.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter text: The text of a user input counterexample (for example, `What are you wearing?`).
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteCounterexample(
        workspaceID: String,
        text: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteCounterexample")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/counterexamples/\(text)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     List entities.

     List the entities for a workspace.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter export: Whether to include all element content in the returned data. If **export**=`false`, the
       returned data includes only information about the element itself. If **export**=`true`, all content, including
       subelements, is included.
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter includeCount: Whether to include information about the number of records that satisfy the request,
       regardless of the page limit. If this parameter is `true`, the `pagination` object in the response includes the
       `total` property.
     - parameter sort: The attribute by which returned entities will be sorted. To reverse the sort order, prefix the
       value with a minus sign (`-`).
     - parameter cursor: A token identifying the page of results to retrieve.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listEntities(
        workspaceID: String,
        export: Bool? = nil,
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<EntityCollection>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listEntities")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
            queryParameters.append(queryParameter)
        }
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let includeCount = includeCount {
            let queryParameter = URLQueryItem(name: "include_count", value: "\(includeCount)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create entity.

     Create a new entity, or enable a system entity.
     If you want to create multiple entities with a single API call, consider using the **[Update
     workspace](#update-workspace)** method instead.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity. This string must conform to the following restrictions:
       - It can contain only Unicode alphanumeric, underscore, and hyphen characters.
       - If you specify an entity name beginning with the reserved prefix `sys-`, it must be the name of a system entity
       that you want to enable. (Any entity content specified with the request is ignored.).
     - parameter description: The description of the entity. This string cannot contain carriage return, newline, or
       tab characters.
     - parameter metadata: Any metadata related to the entity.
     - parameter fuzzyMatch: Whether to use fuzzy matching for the entity.
     - parameter values: An array of objects describing the entity values.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createEntity(
        workspaceID: String,
        entity: String,
        description: String? = nil,
        metadata: [String: JSON]? = nil,
        fuzzyMatch: Bool? = nil,
        values: [CreateValue]? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Entity>?, WatsonError?) -> Void)
    {
        // construct body
        let createEntityRequest = CreateEntityRequest(
            entity: entity,
            description: description,
            metadata: metadata,
            fuzzy_match: fuzzyMatch,
            values: values)
        guard let body = try? JSON.encoder.encode(createEntityRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createEntity")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the createEntity request body
    private struct CreateEntityRequest: Encodable {
        // swiftlint:disable identifier_name
        let entity: String
        let description: String?
        let metadata: [String: JSON]?
        let fuzzy_match: Bool?
        let values: [CreateValue]?
        // swiftlint:enable identifier_name
    }

    /**
     Get entity.

     Get information about an entity, optionally including all entity content.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter export: Whether to include all element content in the returned data. If **export**=`false`, the
       returned data includes only information about the element itself. If **export**=`true`, all content, including
       subelements, is included.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getEntity(
        workspaceID: String,
        entity: String,
        export: Bool? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Entity>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getEntity")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update entity.

     Update an existing entity with new or modified data. You must provide component objects defining the content of the
     updated entity.
     If you want to update multiple entities with a single API call, consider using the **[Update
     workspace](#update-workspace)** method instead.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter newEntity: The name of the entity. This string must conform to the following restrictions:
       - It can contain only Unicode alphanumeric, underscore, and hyphen characters.
       - It cannot begin with the reserved prefix `sys-`.
     - parameter newDescription: The description of the entity. This string cannot contain carriage return, newline,
       or tab characters.
     - parameter newMetadata: Any metadata related to the entity.
     - parameter newFuzzyMatch: Whether to use fuzzy matching for the entity.
     - parameter newValues: An array of objects describing the entity values.
     - parameter append: Whether the new data is to be appended to the existing data in the entity. If
       **append**=`false`, elements included in the new data completely replace the corresponding existing elements,
       including all subelements. For example, if the new data for the entity includes **values** and
       **append**=`false`, all existing values for the entity are discarded and replaced with the new values.
       If **append**=`true`, existing elements are preserved, and the new elements are added. If any elements in the new
       data collide with existing elements, the update request fails.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateEntity(
        workspaceID: String,
        entity: String,
        newEntity: String? = nil,
        newDescription: String? = nil,
        newMetadata: [String: JSON]? = nil,
        newFuzzyMatch: Bool? = nil,
        newValues: [CreateValue]? = nil,
        append: Bool? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Entity>?, WatsonError?) -> Void)
    {
        // construct body
        let updateEntityRequest = UpdateEntityRequest(
            entity: newEntity,
            description: newDescription,
            metadata: newMetadata,
            fuzzy_match: newFuzzyMatch,
            values: newValues)
        guard let body = try? JSON.encoder.encode(updateEntityRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateEntity")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let append = append {
            let queryParameter = URLQueryItem(name: "append", value: "\(append)")
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the updateEntity request body
    private struct UpdateEntityRequest: Encodable {
        // swiftlint:disable identifier_name
        let entity: String?
        let description: String?
        let metadata: [String: JSON]?
        let fuzzy_match: Bool?
        let values: [CreateValue]?
        // swiftlint:enable identifier_name
    }

    /**
     Delete entity.

     Delete an entity from a workspace, or disable a system entity.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteEntity(
        workspaceID: String,
        entity: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteEntity")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     List entity mentions.

     List mentions for a contextual entity. An entity mention is an occurrence of a contextual entity in the context of
     an intent user input example.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter export: Whether to include all element content in the returned data. If **export**=`false`, the
       returned data includes only information about the element itself. If **export**=`true`, all content, including
       subelements, is included.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listMentions(
        workspaceID: String,
        entity: String,
        export: Bool? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<EntityMentionCollection>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listMentions")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/mentions"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List entity values.

     List the values for an entity.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter export: Whether to include all element content in the returned data. If **export**=`false`, the
       returned data includes only information about the element itself. If **export**=`true`, all content, including
       subelements, is included.
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter includeCount: Whether to include information about the number of records that satisfy the request,
       regardless of the page limit. If this parameter is `true`, the `pagination` object in the response includes the
       `total` property.
     - parameter sort: The attribute by which returned entity values will be sorted. To reverse the sort order, prefix
       the value with a minus sign (`-`).
     - parameter cursor: A token identifying the page of results to retrieve.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listValues(
        workspaceID: String,
        entity: String,
        export: Bool? = nil,
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ValueCollection>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listValues")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
            queryParameters.append(queryParameter)
        }
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let includeCount = includeCount {
            let queryParameter = URLQueryItem(name: "include_count", value: "\(includeCount)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create entity value.

     Create a new value for an entity.
     If you want to create multiple entity values with a single API call, consider using the **[Update
     entity](#update-entity)** method instead.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value. This string must conform to the following restrictions:
       - It cannot contain carriage return, newline, or tab characters.
       - It cannot consist of only whitespace characters.
     - parameter metadata: Any metadata related to the entity value.
     - parameter type: Specifies the type of entity value.
     - parameter synonyms: An array of synonyms for the entity value. A value can specify either synonyms or patterns
       (depending on the value type), but not both. A synonym must conform to the following resrictions:
       - It cannot contain carriage return, newline, or tab characters.
       - It cannot consist of only whitespace characters.
     - parameter patterns: An array of patterns for the entity value. A value can specify either synonyms or patterns
       (depending on the value type), but not both. A pattern is a regular expression; for more information about how to
       specify a pattern, see the
       [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-entities#entities-create-dictionary-based).
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createValue(
        workspaceID: String,
        entity: String,
        value: String,
        metadata: [String: JSON]? = nil,
        type: String? = nil,
        synonyms: [String]? = nil,
        patterns: [String]? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Value>?, WatsonError?) -> Void)
    {
        // construct body
        let createValueRequest = CreateValueRequest(
            value: value,
            metadata: metadata,
            type: type,
            synonyms: synonyms,
            patterns: patterns)
        guard let body = try? JSON.encoder.encode(createValueRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createValue")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the createValue request body
    private struct CreateValueRequest: Encodable {
        // swiftlint:disable identifier_name
        let value: String
        let metadata: [String: JSON]?
        let type: String?
        let synonyms: [String]?
        let patterns: [String]?
        // swiftlint:enable identifier_name
    }

    /**
     Get entity value.

     Get information about an entity value.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter export: Whether to include all element content in the returned data. If **export**=`false`, the
       returned data includes only information about the element itself. If **export**=`true`, all content, including
       subelements, is included.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getValue(
        workspaceID: String,
        entity: String,
        value: String,
        export: Bool? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Value>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getValue")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values/\(value)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update entity value.

     Update an existing entity value with new or modified data. You must provide component objects defining the content
     of the updated entity value.
     If you want to update multiple entity values with a single API call, consider using the **[Update
     entity](#update-entity)** method instead.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter newValue: The text of the entity value. This string must conform to the following restrictions:
       - It cannot contain carriage return, newline, or tab characters.
       - It cannot consist of only whitespace characters.
     - parameter newMetadata: Any metadata related to the entity value.
     - parameter newType: Specifies the type of entity value.
     - parameter newSynonyms: An array of synonyms for the entity value. A value can specify either synonyms or
       patterns (depending on the value type), but not both. A synonym must conform to the following resrictions:
       - It cannot contain carriage return, newline, or tab characters.
       - It cannot consist of only whitespace characters.
     - parameter newPatterns: An array of patterns for the entity value. A value can specify either synonyms or
       patterns (depending on the value type), but not both. A pattern is a regular expression; for more information
       about how to specify a pattern, see the
       [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-entities#entities-create-dictionary-based).
     - parameter append: Whether the new data is to be appended to the existing data in the entity value. If
       **append**=`false`, elements included in the new data completely replace the corresponding existing elements,
       including all subelements. For example, if the new data for the entity value includes **synonyms** and
       **append**=`false`, all existing synonyms for the entity value are discarded and replaced with the new synonyms.
       If **append**=`true`, existing elements are preserved, and the new elements are added. If any elements in the new
       data collide with existing elements, the update request fails.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateValue(
        workspaceID: String,
        entity: String,
        value: String,
        newValue: String? = nil,
        newMetadata: [String: JSON]? = nil,
        newType: String? = nil,
        newSynonyms: [String]? = nil,
        newPatterns: [String]? = nil,
        append: Bool? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Value>?, WatsonError?) -> Void)
    {
        // construct body
        let updateValueRequest = UpdateValueRequest(
            value: newValue,
            metadata: newMetadata,
            type: newType,
            synonyms: newSynonyms,
            patterns: newPatterns)
        guard let body = try? JSON.encoder.encode(updateValueRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateValue")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let append = append {
            let queryParameter = URLQueryItem(name: "append", value: "\(append)")
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values/\(value)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the updateValue request body
    private struct UpdateValueRequest: Encodable {
        // swiftlint:disable identifier_name
        let value: String?
        let metadata: [String: JSON]?
        let type: String?
        let synonyms: [String]?
        let patterns: [String]?
        // swiftlint:enable identifier_name
    }

    /**
     Delete entity value.

     Delete a value from an entity.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteValue(
        workspaceID: String,
        entity: String,
        value: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteValue")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values/\(value)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     List entity value synonyms.

     List the synonyms for an entity value.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter includeCount: Whether to include information about the number of records that satisfy the request,
       regardless of the page limit. If this parameter is `true`, the `pagination` object in the response includes the
       `total` property.
     - parameter sort: The attribute by which returned entity value synonyms will be sorted. To reverse the sort
       order, prefix the value with a minus sign (`-`).
     - parameter cursor: A token identifying the page of results to retrieve.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listSynonyms(
        workspaceID: String,
        entity: String,
        value: String,
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<SynonymCollection>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listSynonyms")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let includeCount = includeCount {
            let queryParameter = URLQueryItem(name: "include_count", value: "\(includeCount)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values/\(value)/synonyms"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create entity value synonym.

     Add a new synonym to an entity value.
     If you want to create multiple synonyms with a single API call, consider using the **[Update
     entity](#update-entity)** or **[Update entity value](#update-entity-value)** method instead.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter synonym: The text of the synonym. This string must conform to the following restrictions:
       - It cannot contain carriage return, newline, or tab characters.
       - It cannot consist of only whitespace characters.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createSynonym(
        workspaceID: String,
        entity: String,
        value: String,
        synonym: String,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Synonym>?, WatsonError?) -> Void)
    {
        // construct body
        let createSynonymRequest = CreateSynonymRequest(
            synonym: synonym)
        guard let body = try? JSON.encoder.encode(createSynonymRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createSynonym")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values/\(value)/synonyms"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the createSynonym request body
    private struct CreateSynonymRequest: Encodable {
        // swiftlint:disable identifier_name
        let synonym: String
        // swiftlint:enable identifier_name
    }

    /**
     Get entity value synonym.

     Get information about a synonym of an entity value.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter synonym: The text of the synonym.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getSynonym(
        workspaceID: String,
        entity: String,
        value: String,
        synonym: String,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Synonym>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getSynonym")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values/\(value)/synonyms/\(synonym)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update entity value synonym.

     Update an existing entity value synonym with new text.
     If you want to update multiple synonyms with a single API call, consider using the **[Update
     entity](#update-entity)** or **[Update entity value](#update-entity-value)** method instead.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter synonym: The text of the synonym.
     - parameter newSynonym: The text of the synonym. This string must conform to the following restrictions:
       - It cannot contain carriage return, newline, or tab characters.
       - It cannot consist of only whitespace characters.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateSynonym(
        workspaceID: String,
        entity: String,
        value: String,
        synonym: String,
        newSynonym: String? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Synonym>?, WatsonError?) -> Void)
    {
        // construct body
        let updateSynonymRequest = UpdateSynonymRequest(
            synonym: newSynonym)
        guard let body = try? JSON.encoder.encode(updateSynonymRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateSynonym")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values/\(value)/synonyms/\(synonym)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the updateSynonym request body
    private struct UpdateSynonymRequest: Encodable {
        // swiftlint:disable identifier_name
        let synonym: String?
        // swiftlint:enable identifier_name
    }

    /**
     Delete entity value synonym.

     Delete a synonym from an entity value.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter synonym: The text of the synonym.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteSynonym(
        workspaceID: String,
        entity: String,
        value: String,
        synonym: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteSynonym")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values/\(value)/synonyms/\(synonym)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     List dialog nodes.

     List the dialog nodes for a workspace.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter includeCount: Whether to include information about the number of records that satisfy the request,
       regardless of the page limit. If this parameter is `true`, the `pagination` object in the response includes the
       `total` property.
     - parameter sort: The attribute by which returned dialog nodes will be sorted. To reverse the sort order, prefix
       the value with a minus sign (`-`).
     - parameter cursor: A token identifying the page of results to retrieve.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listDialogNodes(
        workspaceID: String,
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DialogNodeCollection>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listDialogNodes")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let includeCount = includeCount {
            let queryParameter = URLQueryItem(name: "include_count", value: "\(includeCount)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/dialog_nodes"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create dialog node.

     Create a new dialog node.
     If you want to create multiple dialog nodes with a single API call, consider using the **[Update
     workspace](#update-workspace)** method instead.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter dialogNode: The dialog node ID. This string must conform to the following restrictions:
       - It can contain only Unicode alphanumeric, space, underscore, hyphen, and dot characters.
     - parameter description: The description of the dialog node. This string cannot contain carriage return, newline,
       or tab characters.
     - parameter conditions: The condition that will trigger the dialog node. This string cannot contain carriage
       return, newline, or tab characters.
     - parameter parent: The ID of the parent dialog node. This property is omitted if the dialog node has no parent.
     - parameter previousSibling: The ID of the previous sibling dialog node. This property is omitted if the dialog
       node has no previous sibling.
     - parameter output: The output of the dialog node. For more information about how to specify dialog node output,
       see the
       [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-dialog-overview#dialog-overview-responses).
     - parameter context: The context for the dialog node.
     - parameter metadata: The metadata for the dialog node.
     - parameter nextStep: The next step to execute following this dialog node.
     - parameter title: The alias used to identify the dialog node. This string must conform to the following
       restrictions:
       - It can contain only Unicode alphanumeric, space, underscore, hyphen, and dot characters.
     - parameter type: How the dialog node is processed.
     - parameter eventName: How an `event_handler` node is processed.
     - parameter variable: The location in the dialog context where output is stored.
     - parameter actions: An array of objects describing any actions to be invoked by the dialog node.
     - parameter digressIn: Whether this top-level dialog node can be digressed into.
     - parameter digressOut: Whether this dialog node can be returned to after a digression.
     - parameter digressOutSlots: Whether the user can digress to top-level nodes while filling out slots.
     - parameter userLabel: A label that can be displayed externally to describe the purpose of the node to users.
     - parameter disambiguationOptOut: Whether the dialog node should be excluded from disambiguation suggestions.
       Valid only when **type**=`standard` or `frame`.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createDialogNode(
        workspaceID: String,
        dialogNode: String,
        description: String? = nil,
        conditions: String? = nil,
        parent: String? = nil,
        previousSibling: String? = nil,
        output: DialogNodeOutput? = nil,
        context: DialogNodeContext? = nil,
        metadata: [String: JSON]? = nil,
        nextStep: DialogNodeNextStep? = nil,
        title: String? = nil,
        type: String? = nil,
        eventName: String? = nil,
        variable: String? = nil,
        actions: [DialogNodeAction]? = nil,
        digressIn: String? = nil,
        digressOut: String? = nil,
        digressOutSlots: String? = nil,
        userLabel: String? = nil,
        disambiguationOptOut: Bool? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DialogNode>?, WatsonError?) -> Void)
    {
        // construct body
        let createDialogNodeRequest = CreateDialogNodeRequest(
            dialog_node: dialogNode,
            description: description,
            conditions: conditions,
            parent: parent,
            previous_sibling: previousSibling,
            output: output,
            context: context,
            metadata: metadata,
            next_step: nextStep,
            title: title,
            type: type,
            event_name: eventName,
            variable: variable,
            actions: actions,
            digress_in: digressIn,
            digress_out: digressOut,
            digress_out_slots: digressOutSlots,
            user_label: userLabel,
            disambiguation_opt_out: disambiguationOptOut)
        guard let body = try? JSON.encoder.encode(createDialogNodeRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createDialogNode")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/dialog_nodes"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the createDialogNode request body
    private struct CreateDialogNodeRequest: Encodable {
        // swiftlint:disable identifier_name
        let dialog_node: String
        let description: String?
        let conditions: String?
        let parent: String?
        let previous_sibling: String?
        let output: DialogNodeOutput?
        let context: DialogNodeContext?
        let metadata: [String: JSON]?
        let next_step: DialogNodeNextStep?
        let title: String?
        let type: String?
        let event_name: String?
        let variable: String?
        let actions: [DialogNodeAction]?
        let digress_in: String?
        let digress_out: String?
        let digress_out_slots: String?
        let user_label: String?
        let disambiguation_opt_out: Bool?
        // swiftlint:enable identifier_name
    }

    /**
     Get dialog node.

     Get information about a dialog node.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter dialogNode: The dialog node ID (for example, `get_order`).
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getDialogNode(
        workspaceID: String,
        dialogNode: String,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DialogNode>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getDialogNode")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/dialog_nodes/\(dialogNode)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update dialog node.

     Update an existing dialog node with new or modified data.
     If you want to update multiple dialog nodes with a single API call, consider using the **[Update
     workspace](#update-workspace)** method instead.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter dialogNode: The dialog node ID (for example, `get_order`).
     - parameter newDialogNode: The dialog node ID. This string must conform to the following restrictions:
       - It can contain only Unicode alphanumeric, space, underscore, hyphen, and dot characters.
     - parameter newDescription: The description of the dialog node. This string cannot contain carriage return,
       newline, or tab characters.
     - parameter newConditions: The condition that will trigger the dialog node. This string cannot contain carriage
       return, newline, or tab characters.
     - parameter newParent: The ID of the parent dialog node. This property is omitted if the dialog node has no
       parent.
     - parameter newPreviousSibling: The ID of the previous sibling dialog node. This property is omitted if the
       dialog node has no previous sibling.
     - parameter newOutput: The output of the dialog node. For more information about how to specify dialog node
       output, see the
       [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-dialog-overview#dialog-overview-responses).
     - parameter newContext: The context for the dialog node.
     - parameter newMetadata: The metadata for the dialog node.
     - parameter newNextStep: The next step to execute following this dialog node.
     - parameter newTitle: The alias used to identify the dialog node. This string must conform to the following
       restrictions:
       - It can contain only Unicode alphanumeric, space, underscore, hyphen, and dot characters.
     - parameter newType: How the dialog node is processed.
     - parameter newEventName: How an `event_handler` node is processed.
     - parameter newVariable: The location in the dialog context where output is stored.
     - parameter newActions: An array of objects describing any actions to be invoked by the dialog node.
     - parameter newDigressIn: Whether this top-level dialog node can be digressed into.
     - parameter newDigressOut: Whether this dialog node can be returned to after a digression.
     - parameter newDigressOutSlots: Whether the user can digress to top-level nodes while filling out slots.
     - parameter newUserLabel: A label that can be displayed externally to describe the purpose of the node to users.
     - parameter newDisambiguationOptOut: Whether the dialog node should be excluded from disambiguation suggestions.
       Valid only when **type**=`standard` or `frame`.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the
       response.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateDialogNode(
        workspaceID: String,
        dialogNode: String,
        newDialogNode: String? = nil,
        newDescription: String? = nil,
        newConditions: String? = nil,
        newParent: String? = nil,
        newPreviousSibling: String? = nil,
        newOutput: DialogNodeOutput? = nil,
        newContext: DialogNodeContext? = nil,
        newMetadata: [String: JSON]? = nil,
        newNextStep: DialogNodeNextStep? = nil,
        newTitle: String? = nil,
        newType: String? = nil,
        newEventName: String? = nil,
        newVariable: String? = nil,
        newActions: [DialogNodeAction]? = nil,
        newDigressIn: String? = nil,
        newDigressOut: String? = nil,
        newDigressOutSlots: String? = nil,
        newUserLabel: String? = nil,
        newDisambiguationOptOut: Bool? = nil,
        includeAudit: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DialogNode>?, WatsonError?) -> Void)
    {
        // construct body
        let updateDialogNodeRequest = UpdateDialogNodeRequest(
            dialog_node: newDialogNode,
            description: newDescription,
            conditions: newConditions,
            parent: newParent,
            previous_sibling: newPreviousSibling,
            output: newOutput,
            context: newContext,
            metadata: newMetadata,
            next_step: newNextStep,
            title: newTitle,
            type: newType,
            event_name: newEventName,
            variable: newVariable,
            actions: newActions,
            digress_in: newDigressIn,
            digress_out: newDigressOut,
            digress_out_slots: newDigressOutSlots,
            user_label: newUserLabel,
            disambiguation_opt_out: newDisambiguationOptOut)
        guard let body = try? JSON.encoder.encode(updateDialogNodeRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateDialogNode")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/dialog_nodes/\(dialogNode)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the updateDialogNode request body
    private struct UpdateDialogNodeRequest: Encodable {
        // swiftlint:disable identifier_name
        let dialog_node: String?
        let description: String?
        let conditions: String?
        let parent: String?
        let previous_sibling: String?
        let output: DialogNodeOutput?
        let context: DialogNodeContext?
        let metadata: [String: JSON]?
        let next_step: DialogNodeNextStep?
        let title: String?
        let type: String?
        let event_name: String?
        let variable: String?
        let actions: [DialogNodeAction]?
        let digress_in: String?
        let digress_out: String?
        let digress_out_slots: String?
        let user_label: String?
        let disambiguation_opt_out: Bool?
        // swiftlint:enable identifier_name
    }

    /**
     Delete dialog node.

     Delete a dialog node from a workspace.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter dialogNode: The dialog node ID (for example, `get_order`).
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteDialogNode(
        workspaceID: String,
        dialogNode: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteDialogNode")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/dialog_nodes/\(dialogNode)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     List log events in a workspace.

     List the events from the log of a specific workspace.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter sort: How to sort the returned log events. You can sort by **request_timestamp**. To reverse the sort
       order, prefix the parameter value with a minus sign (`-`).
     - parameter filter: A cacheable parameter that limits the results to those matching the specified filter. For
       more information, see the
       [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-filter-reference#filter-reference).
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter cursor: A token identifying the page of results to retrieve.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listLogs(
        workspaceID: String,
        sort: String? = nil,
        filter: String? = nil,
        pageLimit: Int? = nil,
        cursor: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<LogCollection>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listLogs")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let filter = filter {
            let queryParameter = URLQueryItem(name: "filter", value: filter)
            queryParameters.append(queryParameter)
        }
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/logs"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List log events in all workspaces.

     List the events from the logs of all workspaces in the service instance.

     - parameter filter: A cacheable parameter that limits the results to those matching the specified filter. You
       must specify a filter query that includes a value for `language`, as well as a value for
       `request.context.system.assistant_id`, `workspace_id`, or `request.context.metadata.deployment`. For more
       information, see the
       [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-filter-reference#filter-reference).
     - parameter sort: How to sort the returned log events. You can sort by **request_timestamp**. To reverse the sort
       order, prefix the parameter value with a minus sign (`-`).
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter cursor: A token identifying the page of results to retrieve.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listAllLogs(
        filter: String,
        sort: String? = nil,
        pageLimit: Int? = nil,
        cursor: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<LogCollection>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listAllLogs")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "filter", value: filter))
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }

        // construct REST request

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + "/v1/logs",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete labeled data.

     Deletes all data associated with a specified customer ID. The method has no effect if no data is associated with
     the customer ID.
     You associate a customer ID with data by passing the `X-Watson-Metadata` header with a request that passes data.
     For more information about personal data and customer IDs, see [Information
     security](https://cloud.ibm.com/docs/assistant?topic=assistant-information-security#information-security).

     - parameter customerID: The customer ID for which all data is to be deleted.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteUserData(
        customerID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteUserData")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "customer_id", value: customerID))

        // construct REST request

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceEndpoint + "/v1/user_data",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

}
