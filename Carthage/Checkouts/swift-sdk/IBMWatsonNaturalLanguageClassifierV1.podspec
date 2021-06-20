Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonNaturalLanguageClassifierV1'
  s.version               = '4.1.0'
  s.summary               = 'Client framework for the IBM Watson Natural Language Classifier service'
  s.description           = <<-DESC
Natural Language Classifier can help your application understand the language of short texts and
make predictions about how to handle them. A classifier learns from your example data and then can
return information for texts that it is not trained on.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/natural-language-classifier/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Jeff Arn' => 'jtarn@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'NaturalLanguageClassifier'
  s.ios.deployment_target = '10.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => "v#{s.version}" }

  s.source_files          = 'Sources/NaturalLanguageClassifierV1/**/*.swift',
                            'Sources/SupportingFiles/InsecureConnection.swift',
                            'Sources/SupportingFiles/Shared.swift'
  s.exclude_files         = 'Sources/NaturalLanguageClassifierV1/Shared.swift',
                            'Sources/NaturalLanguageClassifierV1/InsecureConnection.swift'

  s.swift_version         = ['4.2', '5.0', '5.1']
  s.dependency              'IBMSwiftSDKCore', '~> 1.0.0'

end
