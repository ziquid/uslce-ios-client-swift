Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonToneAnalyzerV3'
  s.version               = '4.1.0'
  s.summary               = 'Client framework for the IBM Watson Tone Analyzer service'
  s.description           = <<-DESC
IBM Watson™ Tone Analyzer uses linguistic analysis to detect emotional and language tones in written text.
The service can analyze tone at both the document and sentence levels.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/tone-analyzer/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Jeff Arn' => 'jtarn@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'ToneAnalyzer'
  s.ios.deployment_target = '10.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => "v#{s.version}" }

  s.source_files          = 'Sources/ToneAnalyzerV3/**/*.swift',
                            'Sources/SupportingFiles/InsecureConnection.swift',
                            'Sources/SupportingFiles/Shared.swift'
  s.exclude_files         = 'Sources/ToneAnalyzerV3/Shared.swift',
                            'Sources/ToneAnalyzerV3/InsecureConnection.swift'

  s.swift_version         = ['4.2', '5.0', '5.1']
  s.dependency              'IBMSwiftSDKCore', '~> 1.0.0'
end
