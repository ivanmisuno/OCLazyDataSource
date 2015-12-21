Pod::Spec.new do |s|

  s.name         = "OCLazyDataSource"
  s.version      = "0.0.1"
  s.summary      = "Lazy data sources for UIKit collections."

  s.description  = <<-DESC
                   Lazy data sources for UIKit collections.
                   DESC

  s.homepage     = "https://github.com/impopappfactory/OCLazyDataSource"

  s.license      = "MIT"

  s.authors      = { "Ivan Misuno" => "i.misuno@gmail.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/impopappfactory/OCLazyDataSource" } # , :tag => s.version.to_s

  s.source_files = "OCLazyDataSource/DataSource/**/*.{h,m}"
  s.exclude_files = ""

  s.frameworks   = "Foundation"

  s.dependency 'NSEnumeratorLinq', '~> 0.2.7'
  
  s.requires_arc = true

end
