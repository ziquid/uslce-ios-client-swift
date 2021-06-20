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
 Returns the top values for the field specified.

 Enums with an associated value of QueryTermAggregation:
    QueryAggregation
 */
public struct QueryTermAggregation: Codable, Equatable {

    /**
     The type of aggregation command used. Options include: term, histogram, timeslice, nested, filter, min, max, sum,
     average, unique_count, and top_hits.
     */
    public var type: String

    /**
     The field in the document used to generate top values from.
     */
    public var field: String

    /**
     The number of top values returned.
     */
    public var count: Int?

    /**
     Identifier specified in the query request of this aggregation.
     */
    public var name: String?

    /**
     Array of top values for the field.
     */
    public var results: [QueryTermAggregationResult]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case field = "field"
        case count = "count"
        case name = "name"
        case results = "results"
    }

}
