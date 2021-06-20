/**
 * (C) Copyright IBM Corp. 2020.
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

import Foundation

/**
 A stateless response from the Watson Assistant service.
 */
public struct MessageResponseStateless: Codable, Equatable {

    /**
     Assistant output to be rendered or processed by the client.
     */
    public var output: MessageOutput

    /**
     Context data for the conversation. You can use this property to access context variables. The context is not stored
     by the assistant; to maintain session state, include the context from the response in the next message.
     */
    public var context: MessageContextStateless

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case output = "output"
        case context = "context"
    }

}
