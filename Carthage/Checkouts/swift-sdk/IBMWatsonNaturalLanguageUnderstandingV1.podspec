Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonNaturalLanguageUnderstandingV1'
  s.version               = '4.1.0'
  s.summary               = 'Client framework for the IBM Watson Natural Language Understanding service'
  s.description           = <<-DESC
IBM Watson™ Natural Language Understanding can analyze semantic features of text input,
including categories, concepts, emotion, entities, keywords, metadata, relations, semantic roles, and sentiment.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/natural-language-understanding/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Jeff Arn' => 'jtarn@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'NaturalLanguageUnderstanding'
  s.ios.deployment_target = '10.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => "v#{s.version}" }

  s.source_files          = 'Sources/NaturalLanguageUnderstandingV1/**/*.swift',
                            'Sources/SupportingFiles/InsecureConnection.swift',
                            'Sources/SupportingFiles/Shared.swift'
  s.exclude_files         = 'Sources/NaturalLanguageUnderstandingV1/Shared.swift',
                            'Sources/NaturalLanguageUnderstandingV1/InsecureConnection.swift'

  s.swift_version         = ['4.2', '5.0', '5.1']
  s.dependency              'IBMSwiftSDKCore', '~> 1.0.0'

end
