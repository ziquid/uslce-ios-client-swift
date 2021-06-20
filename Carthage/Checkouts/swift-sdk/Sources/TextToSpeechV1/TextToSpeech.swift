/**
 * (C) Copyright IBM Corp. 2016, 2020.
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
 The IBM Watson&trade; Text to Speech service provides APIs that use IBM's speech-synthesis capabilities to synthesize
 text into natural-sounding speech in a variety of languages, dialects, and voices. The service supports at least one
 male or female voice, sometimes both, for each language. The audio is streamed back to the client with minimal delay.
 For speech synthesis, the service supports a synchronous HTTP Representational State Transfer (REST) interface and a
 WebSocket interface. Both interfaces support plain text and SSML input. SSML is an XML-based markup language that
 provides text annotation for speech-synthesis applications. The WebSocket interface also supports the SSML
 <code>&lt;mark&gt;</code> element and word timings.
 The service offers a customization interface that you can use to define sounds-like or phonetic translations for words.
 A sounds-like translation consists of one or more words that, when combined, sound like the word. A phonetic
 translation is based on the SSML phoneme format for representing a word. You can specify a phonetic translation in
 standard International Phonetic Alphabet (IPA) representation or in the proprietary IBM Symbolic Phonetic
 Representation (SPR). The Arabic, Chinese, Dutch, Australian English, and Korean languages support only IPA.
 */
public class TextToSpeech {

    /// The base URL to use when contacting the service.
    public var serviceURL: String? = "https://api.us-south.text-to-speech.watson.cloud.ibm.com"

    /// Service identifiers
    public static let defaultServiceName = "text_to_speech"
    // Service info for SDK headers
    internal let serviceName = defaultServiceName
    internal let serviceVersion = "v1"
    internal let serviceSdkName = "text_to_speech"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    var session = URLSession(configuration: URLSessionConfiguration.default)
    public let authenticator: Authenticator

    #if os(Linux)
    /**
     Create a `TextToSpeech` object.

     If an authenticator is not supplied, the initializer will retrieve credentials from the environment or
     a local credentials file and construct an appropriate authenticator using these credentials.
     The credentials file can be downloaded from your service instance on IBM Cloud as ibm-credentials.env.
     Make sure to add the credentials file to your project so that it can be loaded at runtime.

     If an authenticator is not supplied and credentials are not available in the environment or a local
     credentials file, initialization will fail by throwing an exception.
     In that case, try another initializer that directly passes in the credentials.

     - parameter authenticator: The Authenticator object used to authenticate requests to the service
     - serviceName: String = defaultServiceName
     */
    public init(authenticator: Authenticator? = nil, serviceName: String = defaultServiceName) throws {
        self.authenticator = try authenticator ?? ConfigBasedAuthenticatorFactory.getAuthenticator(credentialPrefix: serviceName)
        if let serviceURL = CredentialUtils.getServiceURL(credentialPrefix: serviceName) {
            self.serviceURL = serviceURL
        }
        RestRequest.userAgent = Shared.userAgent
    }
    #else
    /**
     Create a `TextToSpeech` object.

     - parameter authenticator: The Authenticator object used to authenticate requests to the service
     */
    public init(authenticator: Authenticator) {
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
     Use the HTTP response and data received by the Text to Speech service to extract
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
     List voices.

     Lists all voices available for use with the service. The information includes the name, language, gender, and other
     details about the voice. The ordering of the list of voices can change from call to call; do not rely on an
     alphabetized or static list of voices. To see information about a specific voice, use the **Get a voice** method.
     **See also:** [Listing all available
     voices](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-voices#listVoices).

     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listVoices(
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Voices>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listVoices")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
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
            url: serviceEndpoint + "/v1/voices",
            headerParameters: headerParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get a voice.

     Gets information about the specified voice. The information includes the name, language, gender, and other details
     about the voice. Specify a customization ID to obtain information for a custom model that is defined for the
     language of the specified voice. To list information about all available voices, use the **List voices** method.
     **See also:** [Listing a specific
     voice](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-voices#listVoice).
     ### Important voice updates
      The service's voices underwent significant change on 2 December 2020.
     * The Arabic, Chinese, Dutch, Australian English, and Korean voices are now neural instead of concatenative.
     * The `ar-AR_OmarVoice` voice is deprecated. Use `ar-MS_OmarVoice` voice instead.
     * The `ar-AR` language identifier cannot be used to create a custom model. Use the `ar-MS` identifier instead.
     * The standard concatenative voices for the following languages are now deprecated: Brazilian Portuguese, United
     Kingdom and United States English, French, German, Italian, Japanese, and Spanish (all dialects).
     * The features expressive SSML, voice transformation SSML, and use of the `volume` attribute of the `<prosody>`
     element are deprecated and are not supported with any of the service's neural voices.
     * All of the service's voices are now customizable and generally available (GA) for production use.
     The deprecated voices and features will continue to function for at least one year but might be removed at a future
     date. You are encouraged to migrate to the equivalent neural voices at your earliest convenience. For more
     information about all voice updates, see the [2 December 2020 service
     update](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-release-notes#December2020) in the release
     notes.

     - parameter voice: The voice for which information is to be returned. For more information about specifying a
       voice, see **Important voice updates** in the method description.
     - parameter customizationID: The customization ID (GUID) of a custom model for which information is to be
       returned. You must make the request with credentials for the instance of the service that owns the custom model.
       Omit the parameter to see information about the specified voice with no customization.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getVoice(
        voice: String,
        customizationID: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Voice>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getVoice")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let customizationID = customizationID {
            let queryParameter = URLQueryItem(name: "customization_id", value: customizationID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/voices/\(voice)"
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
     Synthesize audio.

     Synthesizes text to audio that is spoken in the specified voice. The service bases its understanding of the
     language for the input text on the specified voice. Use a voice that matches the language of the input text.
     The method accepts a maximum of 5 KB of input text in the body of the request, and 8 KB for the URL and headers.
     The 5 KB limit includes any SSML tags that you specify. The service returns the synthesized audio stream as an
     array of bytes.
     **See also:** [The HTTP
     interface](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-usingHTTP#usingHTTP).
     ### Audio formats (accept types)
      The service can return audio in the following formats (MIME types).
     * Where indicated, you can optionally specify the sampling rate (`rate`) of the audio. You must specify a sampling
     rate for the `audio/l16` and `audio/mulaw` formats. A specified sampling rate must lie in the range of 8 kHz to 192
     kHz. Some formats restrict the sampling rate to certain values, as noted.
     * For the `audio/l16` format, you can optionally specify the endianness (`endianness`) of the audio:
     `endianness=big-endian` or `endianness=little-endian`.
     Use the `Accept` header or the `accept` parameter to specify the requested format of the response audio. If you
     omit an audio format altogether, the service returns the audio in Ogg format with the Opus codec
     (`audio/ogg;codecs=opus`). The service always returns single-channel audio.
     * `audio/basic` - The service returns audio with a sampling rate of 8000 Hz.
     * `audio/flac` - You can optionally specify the `rate` of the audio. The default sampling rate is 22,050 Hz.
     * `audio/l16` - You must specify the `rate` of the audio. You can optionally specify the `endianness` of the audio.
     The default endianness is `little-endian`.
     * `audio/mp3` - You can optionally specify the `rate` of the audio. The default sampling rate is 22,050 Hz.
     * `audio/mpeg` - You can optionally specify the `rate` of the audio. The default sampling rate is 22,050 Hz.
     * `audio/mulaw` - You must specify the `rate` of the audio.
     * `audio/ogg` - The service returns the audio in the `vorbis` codec. You can optionally specify the `rate` of the
     audio. The default sampling rate is 22,050 Hz.
     * `audio/ogg;codecs=opus` - You can optionally specify the `rate` of the audio. Only the following values are valid
     sampling rates: `48000`, `24000`, `16000`, `12000`, or `8000`. If you specify a value other than one of these, the
     service returns an error. The default sampling rate is 48,000 Hz.
     * `audio/ogg;codecs=vorbis` - You can optionally specify the `rate` of the audio. The default sampling rate is
     22,050 Hz.
     * `audio/wav` - You can optionally specify the `rate` of the audio. The default sampling rate is 22,050 Hz.
     * `audio/webm` - The service returns the audio in the `opus` codec. The service returns audio with a sampling rate
     of 48,000 Hz.
     * `audio/webm;codecs=opus` - The service returns audio with a sampling rate of 48,000 Hz.
     * `audio/webm;codecs=vorbis` - You can optionally specify the `rate` of the audio. The default sampling rate is
     22,050 Hz.
     For more information about specifying an audio format, including additional details about some of the formats, see
     [Audio formats](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-audioFormats#audioFormats).
     ### Important voice updates
      The service's voices underwent significant change on 2 December 2020.
     * The Arabic, Chinese, Dutch, Australian English, and Korean voices are now neural instead of concatenative.
     * The `ar-AR_OmarVoice` voice is deprecated. Use `ar-MS_OmarVoice` voice instead.
     * The `ar-AR` language identifier cannot be used to create a custom model. Use the `ar-MS` identifier instead.
     * The standard concatenative voices for the following languages are now deprecated: Brazilian Portuguese, United
     Kingdom and United States English, French, German, Italian, Japanese, and Spanish (all dialects).
     * The features expressive SSML, voice transformation SSML, and use of the `volume` attribute of the `<prosody>`
     element are deprecated and are not supported with any of the service's neural voices.
     * All of the service's voices are now customizable and generally available (GA) for production use.
     The deprecated voices and features will continue to function for at least one year but might be removed at a future
     date. You are encouraged to migrate to the equivalent neural voices at your earliest convenience. For more
     information about all voice updates, see the [2 December 2020 service
     update](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-release-notes#December2020) in the release
     notes.
     ### Warning messages
      If a request includes invalid query parameters, the service returns a `Warnings` response header that provides
     messages about the invalid parameters. The warning includes a descriptive message and a list of invalid argument
     strings. For example, a message such as `"Unknown arguments:"` or `"Unknown url query arguments:"` followed by a
     list of the form `"{invalid_arg_1}, {invalid_arg_2}."` The request succeeds despite the warnings.

     - parameter text: The text to synthesize.
     - parameter accept: The requested format (MIME type) of the audio. You can use the `Accept` header or the
       `accept` parameter to specify the audio format. For more information about specifying an audio format, see
       **Audio formats (accept types)** in the method description.
     - parameter voice: The voice to use for synthesis. For more information about specifying a voice, see **Important
       voice updates** in the method description.
     - parameter customizationID: The customization ID (GUID) of a custom model to use for the synthesis. If a custom
       model is specified, it works only if it matches the language of the indicated voice. You must make the request
       with credentials for the instance of the service that owns the custom model. Omit the parameter to use the
       specified voice with no customization.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func synthesize(
        text: String,
        accept: String? = nil,
        voice: String? = nil,
        customizationID: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Data>?, WatsonError?) -> Void)
    {
        // construct body
        let synthesizeRequest = SynthesizeRequest(
            text: text)
        guard let body = try? JSON.encoder.encode(synthesizeRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "synthesize")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Content-Type"] = "application/json"
        if let accept = accept {
            headerParameters["Accept"] = accept
        }
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let voice = voice {
            let queryParameter = URLQueryItem(name: "voice", value: voice)
            queryParameters.append(queryParameter)
        }
        if let customizationID = customizationID {
            let queryParameter = URLQueryItem(name: "customization_id", value: customizationID)
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
            url: serviceEndpoint + "/v1/synthesize",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    // Private struct for the synthesize request body
    private struct SynthesizeRequest: Encodable {
        // swiftlint:disable identifier_name
        let text: String
        // swiftlint:enable identifier_name
    }

    /**
     Get pronunciation.

     Gets the phonetic pronunciation for the specified word. You can request the pronunciation for a specific format.
     You can also request the pronunciation for a specific voice to see the default translation for the language of that
     voice or for a specific custom model to see the translation for that model.
     **See also:** [Querying a word from a
     language](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customWords#cuWordsQueryLanguage).
     ### Important voice updates
      The service's voices underwent significant change on 2 December 2020.
     * The Arabic, Chinese, Dutch, Australian English, and Korean voices are now neural instead of concatenative.
     * The `ar-AR_OmarVoice` voice is deprecated. Use `ar-MS_OmarVoice` voice instead.
     * The `ar-AR` language identifier cannot be used to create a custom model. Use the `ar-MS` identifier instead.
     * The standard concatenative voices for the following languages are now deprecated: Brazilian Portuguese, United
     Kingdom and United States English, French, German, Italian, Japanese, and Spanish (all dialects).
     * The features expressive SSML, voice transformation SSML, and use of the `volume` attribute of the `<prosody>`
     element are deprecated and are not supported with any of the service's neural voices.
     * All of the service's voices are now customizable and generally available (GA) for production use.
     The deprecated voices and features will continue to function for at least one year but might be removed at a future
     date. You are encouraged to migrate to the equivalent neural voices at your earliest convenience. For more
     information about all voice updates, see the [2 December 2020 service
     update](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-release-notes#December2020) in the release
     notes.

     - parameter text: The word for which the pronunciation is requested.
     - parameter voice: A voice that specifies the language in which the pronunciation is to be returned. All voices
       for the same language (for example, `en-US`) return the same translation. For more information about specifying a
       voice, see **Important voice updates** in the method description.
     - parameter format: The phoneme format in which to return the pronunciation. The Arabic, Chinese, Dutch,
       Australian English, and Korean languages support only IPA. Omit the parameter to obtain the pronunciation in the
       default format.
     - parameter customizationID: The customization ID (GUID) of a custom model for which the pronunciation is to be
       returned. The language of a specified custom model must match the language of the specified voice. If the word is
       not defined in the specified custom model, the service returns the default translation for the custom model's
       language. You must make the request with credentials for the instance of the service that owns the custom model.
       Omit the parameter to see the translation for the specified voice with no customization.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getPronunciation(
        text: String,
        voice: String? = nil,
        format: String? = nil,
        customizationID: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Pronunciation>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getPronunciation")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "text", value: text))
        if let voice = voice {
            let queryParameter = URLQueryItem(name: "voice", value: voice)
            queryParameters.append(queryParameter)
        }
        if let format = format {
            let queryParameter = URLQueryItem(name: "format", value: format)
            queryParameters.append(queryParameter)
        }
        if let customizationID = customizationID {
            let queryParameter = URLQueryItem(name: "customization_id", value: customizationID)
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
            url: serviceEndpoint + "/v1/pronunciation",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create a custom model.

     Creates a new empty custom model. You must specify a name for the new custom model. You can optionally specify the
     language and a description for the new model. The model is owned by the instance of the service whose credentials
     are used to create it.
     **See also:** [Creating a custom
     model](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customModels#cuModelsCreate).
     ### Important voice updates
      The service's voices underwent significant change on 2 December 2020.
     * The Arabic, Chinese, Dutch, Australian English, and Korean voices are now neural instead of concatenative.
     * The `ar-AR_OmarVoice` voice is deprecated. Use `ar-MS_OmarVoice` voice instead.
     * The `ar-AR` language identifier cannot be used to create a custom model. Use the `ar-MS` identifier instead.
     * The standard concatenative voices for the following languages are now deprecated: Brazilian Portuguese, United
     Kingdom and United States English, French, German, Italian, Japanese, and Spanish (all dialects).
     * The features expressive SSML, voice transformation SSML, and use of the `volume` attribute of the `<prosody>`
     element are deprecated and are not supported with any of the service's neural voices.
     * All of the service's voices are now customizable and generally available (GA) for production use.
     The deprecated voices and features will continue to function for at least one year but might be removed at a future
     date. You are encouraged to migrate to the equivalent neural voices at your earliest convenience. For more
     information about all voice updates, see the [2 December 2020 service
     update](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-release-notes#December2020) in the release
     notes.

     - parameter name: The name of the new custom model.
     - parameter language: The language of the new custom model. You create a custom model for a specific language,
       not for a specific voice. A custom model can be used with any voice for its specified language. Omit the
       parameter to use the the default language, `en-US`. **Note:** The `ar-AR` language identifier cannot be used to
       create a custom model. Use the `ar-MS` identifier instead.
     - parameter description: A description of the new custom model. Specifying a description is recommended.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createCustomModel(
        name: String,
        language: String? = nil,
        description: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<CustomModel>?, WatsonError?) -> Void)
    {
        // construct body
        let createCustomModelRequest = CreateCustomModelRequest(
            name: name,
            language: language,
            description: description)
        guard let body = try? JSON.encoder.encode(createCustomModelRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createCustomModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
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
            url: serviceEndpoint + "/v1/customizations",
            headerParameters: headerParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the createCustomModel request body
    private struct CreateCustomModelRequest: Encodable {
        // swiftlint:disable identifier_name
        let name: String
        let language: String?
        let description: String?
        // swiftlint:enable identifier_name
    }

    /**
     List custom models.

     Lists metadata such as the name and description for all custom models that are owned by an instance of the service.
     Specify a language to list the custom models for that language only. To see the words in addition to the metadata
     for a specific custom model, use the **List a custom model** method. You must use credentials for the instance of
     the service that owns a model to list information about it.
     **See also:** [Querying all custom
     models](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customModels#cuModelsQueryAll).

     - parameter language: The language for which custom models that are owned by the requesting credentials are to be
       returned. Omit the parameter to see all custom models that are owned by the requester.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listCustomModels(
        language: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<CustomModels>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listCustomModels")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let language = language {
            let queryParameter = URLQueryItem(name: "language", value: language)
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
            url: serviceEndpoint + "/v1/customizations",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update a custom model.

     Updates information for the specified custom model. You can update metadata such as the name and description of the
     model. You can also update the words in the model and their translations. Adding a new translation for a word that
     already exists in a custom model overwrites the word's existing translation. A custom model can contain no more
     than 20,000 entries. You must use credentials for the instance of the service that owns a model to update it.
     You can define sounds-like or phonetic translations for words. A sounds-like translation consists of one or more
     words that, when combined, sound like the word. Phonetic translations are based on the SSML phoneme format for
     representing a word. You can specify them in standard International Phonetic Alphabet (IPA) representation
       <code>&lt;phoneme alphabet="ipa" ph="t&#601;m&#712;&#593;to"&gt;&lt;/phoneme&gt;</code>
       or in the proprietary IBM Symbolic Phonetic Representation (SPR)
       <code>&lt;phoneme alphabet="ibm" ph="1gAstroEntxrYFXs"&gt;&lt;/phoneme&gt;</code>
     **See also:**
     * [Updating a custom
     model](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customModels#cuModelsUpdate)
     * [Adding words to a Japanese custom
     model](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customWords#cuJapaneseAdd)
     * [Understanding
     customization](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customIntro#customIntro).

     - parameter customizationID: The customization ID (GUID) of the custom model. You must make the request with
       credentials for the instance of the service that owns the custom model.
     - parameter name: A new name for the custom model.
     - parameter description: A new description for the custom model.
     - parameter words: An array of `Word` objects that provides the words and their translations that are to be added
       or updated for the custom model. Pass an empty array to make no additions or updates.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateCustomModel(
        customizationID: String,
        name: String? = nil,
        description: String? = nil,
        words: [Word]? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct body
        let updateCustomModelRequest = UpdateCustomModelRequest(
            name: name,
            description: description,
            words: words)
        guard let body = try? JSON.encoder.encode(updateCustomModelRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateCustomModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)"
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
            messageBody: body
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    // Private struct for the updateCustomModel request body
    private struct UpdateCustomModelRequest: Encodable {
        // swiftlint:disable identifier_name
        let name: String?
        let description: String?
        let words: [Word]?
        // swiftlint:enable identifier_name
    }

    /**
     Get a custom model.

     Gets all information about a specified custom model. In addition to metadata such as the name and description of
     the custom model, the output includes the words and their translations as defined in the model. To see just the
     metadata for a model, use the **List custom models** method.
     **See also:** [Querying a custom
     model](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customModels#cuModelsQuery).

     - parameter customizationID: The customization ID (GUID) of the custom model. You must make the request with
       credentials for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getCustomModel(
        customizationID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<CustomModel>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getCustomModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)"
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
            headerParameters: headerParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete a custom model.

     Deletes the specified custom model. You must use credentials for the instance of the service that owns a model to
     delete it.
     **See also:** [Deleting a custom
     model](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customModels#cuModelsDelete).

     - parameter customizationID: The customization ID (GUID) of the custom model. You must make the request with
       credentials for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteCustomModel(
        customizationID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteCustomModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)"
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
            headerParameters: headerParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Add custom words.

     Adds one or more words and their translations to the specified custom model. Adding a new translation for a word
     that already exists in a custom model overwrites the word's existing translation. A custom model can contain no
     more than 20,000 entries. You must use credentials for the instance of the service that owns a model to add words
     to it.
     You can define sounds-like or phonetic translations for words. A sounds-like translation consists of one or more
     words that, when combined, sound like the word. Phonetic translations are based on the SSML phoneme format for
     representing a word. You can specify them in standard International Phonetic Alphabet (IPA) representation
       <code>&lt;phoneme alphabet="ipa" ph="t&#601;m&#712;&#593;to"&gt;&lt;/phoneme&gt;</code>
       or in the proprietary IBM Symbolic Phonetic Representation (SPR)
       <code>&lt;phoneme alphabet="ibm" ph="1gAstroEntxrYFXs"&gt;&lt;/phoneme&gt;</code>
     **See also:**
     * [Adding multiple words to a custom
     model](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customWords#cuWordsAdd)
     * [Adding words to a Japanese custom
     model](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customWords#cuJapaneseAdd)
     * [Understanding
     customization](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customIntro#customIntro).

     - parameter customizationID: The customization ID (GUID) of the custom model. You must make the request with
       credentials for the instance of the service that owns the custom model.
     - parameter words: The **Add custom words** method accepts an array of `Word` objects. Each object provides a
       word that is to be added or updated for the custom model and the word's translation.
       The **List custom words** method returns an array of `Word` objects. Each object shows a word and its translation
       from the custom model. The words are listed in alphabetical order, with uppercase letters listed before lowercase
       letters. The array is empty if the custom model contains no words.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func addWords(
        customizationID: String,
        words: [Word],
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct body
        let addWordsRequest = AddWordsRequest(
            words: words)
        guard let body = try? JSON.encoder.encode(addWordsRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "addWords")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words"
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
            messageBody: body
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    // Private struct for the addWords request body
    private struct AddWordsRequest: Encodable {
        // swiftlint:disable identifier_name
        let words: [Word]
        // swiftlint:enable identifier_name
    }

    /**
     List custom words.

     Lists all of the words and their translations for the specified custom model. The output shows the translations as
     they are defined in the model. You must use credentials for the instance of the service that owns a model to list
     its words.
     **See also:** [Querying all words from a custom
     model](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customWords#cuWordsQueryModel).

     - parameter customizationID: The customization ID (GUID) of the custom model. You must make the request with
       credentials for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listWords(
        customizationID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Words>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listWords")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words"
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
            headerParameters: headerParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Add a custom word.

     Adds a single word and its translation to the specified custom model. Adding a new translation for a word that
     already exists in a custom model overwrites the word's existing translation. A custom model can contain no more
     than 20,000 entries. You must use credentials for the instance of the service that owns a model to add a word to
     it.
     You can define sounds-like or phonetic translations for words. A sounds-like translation consists of one or more
     words that, when combined, sound like the word. Phonetic translations are based on the SSML phoneme format for
     representing a word. You can specify them in standard International Phonetic Alphabet (IPA) representation
       <code>&lt;phoneme alphabet="ipa" ph="t&#601;m&#712;&#593;to"&gt;&lt;/phoneme&gt;</code>
       or in the proprietary IBM Symbolic Phonetic Representation (SPR)
       <code>&lt;phoneme alphabet="ibm" ph="1gAstroEntxrYFXs"&gt;&lt;/phoneme&gt;</code>
     **See also:**
     * [Adding a single word to a custom
     model](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customWords#cuWordAdd)
     * [Adding words to a Japanese custom
     model](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customWords#cuJapaneseAdd)
     * [Understanding
     customization](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customIntro#customIntro).

     - parameter customizationID: The customization ID (GUID) of the custom model. You must make the request with
       credentials for the instance of the service that owns the custom model.
     - parameter word: The word that is to be added or updated for the custom model.
     - parameter translation: The phonetic or sounds-like translation for the word. A phonetic translation is based on
       the SSML format for representing the phonetic string of a word either as an IPA translation or as an IBM SPR
       translation. The Arabic, Chinese, Dutch, Australian English, and Korean languages support only IPA. A sounds-like
       is one or more words that, when combined, sound like the word.
     - parameter partOfSpeech: **Japanese only.** The part of speech for the word. The service uses the value to
       produce the correct intonation for the word. You can create only a single entry, with or without a single part of
       speech, for any word; you cannot create multiple entries with different parts of speech for the same word. For
       more information, see [Working with Japanese
       entries](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-rules#jaNotes).
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func addWord(
        customizationID: String,
        word: String,
        translation: String,
        partOfSpeech: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct body
        let addWordRequest = AddWordRequest(
            translation: translation,
            part_of_speech: partOfSpeech)
        guard let body = try? JSON.encoder.encode(addWordRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "addWord")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words/\(word)"
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
            method: "PUT",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            messageBody: body
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    // Private struct for the addWord request body
    private struct AddWordRequest: Encodable {
        // swiftlint:disable identifier_name
        let translation: String
        let part_of_speech: String?
        // swiftlint:enable identifier_name
    }

    /**
     Get a custom word.

     Gets the translation for a single word from the specified custom model. The output shows the translation as it is
     defined in the model. You must use credentials for the instance of the service that owns a model to list its words.
     **See also:** [Querying a single word from a custom
     model](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customWords#cuWordQueryModel).

     - parameter customizationID: The customization ID (GUID) of the custom model. You must make the request with
       credentials for the instance of the service that owns the custom model.
     - parameter word: The word that is to be queried from the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getWord(
        customizationID: String,
        word: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Translation>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getWord")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words/\(word)"
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
            headerParameters: headerParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete a custom word.

     Deletes a single word from the specified custom model. You must use credentials for the instance of the service
     that owns a model to delete its words.
     **See also:** [Deleting a word from a custom
     model](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-customWords#cuWordDelete).

     - parameter customizationID: The customization ID (GUID) of the custom model. You must make the request with
       credentials for the instance of the service that owns the custom model.
     - parameter word: The word that is to be deleted from the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteWord(
        customizationID: String,
        word: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteWord")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words/\(word)"
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
            headerParameters: headerParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Delete labeled data.

     Deletes all data that is associated with a specified customer ID. The method deletes all data for the customer ID,
     regardless of the method by which the information was added. The method has no effect if no data is associated with
     the customer ID. You must issue the request with credentials for the same instance of the service that was used to
     associate the customer ID with the data. You associate a customer ID with data by passing the `X-Watson-Metadata`
     header with a request that passes the data.
     **Note:** If you delete an instance of the service from the service console, all data associated with that service
     instance is automatically deleted. This includes all custom models and word/translation pairs, and all data related
     to speech synthesis requests.
     **See also:** [Information
     security](https://cloud.ibm.com/docs/text-to-speech?topic=text-to-speech-information-security#information-security).

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
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
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
