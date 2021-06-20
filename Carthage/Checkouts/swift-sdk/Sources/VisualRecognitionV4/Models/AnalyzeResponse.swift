/**
 * (C) Copyright IBM Corp. 2019, 2020.
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
 Results for all images.
 */
public struct AnalyzeResponse: Codable, Equatable {

    /**
     Analyzed images.
     */
    public var images: [Image]

    /**
     Information about what might cause less than optimal output.
     */
    public var warnings: [Warning]?

    /**
     A unique identifier of the request. Included only when an error or warning is returned.
     */
    public var trace: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case images = "images"
        case warnings = "warnings"
        case trace = "trace"
    }

}
