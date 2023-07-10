Pod::Spec.new do |spec|

spec.name = 'RCKML'
spec.version = '1.0.2'
spec.license = { :type => 'MIT', :file => 'LICENSE' }
spec.summary = 'A library for reading and writing KML files in Swift'

spec.source = { :git => 'https://github.com/RCCoop/RCKML.git', :tag => spec.version }
spec.source_files = 'Sources/RCKML/*.swift'

spec.swift_versions = ['5.6', '5.7', '5.8', '5.9']

spec.ios.deployment_target = '13.0'
spec.osx.deployment_target = '10.15'
spec.tvos.deployment_target = '14.0'
spec.watchos.deployment_target = '6.0'

spec.dependency 'AEXML', '~> 4.6'
spec.dependency 'ZIPFoundation', '~> 0.9'

spec.homepage = 'https://github.com/RCCoop/RCKML'
spec.author = { 'RCCoop' => 'guthookhikes@gmail.com' }

end