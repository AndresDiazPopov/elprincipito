Rails.application.configure do
  version = 'unknown version'
  File.open('CHANGELOG.md', 'r').each_line do |line|
    if line.starts_with?('## [') && !line.starts_with?('## [Unreleased')
      version = line[/\[.*\]/].tr('[]','')
      break
    end
  end

  config.app_version = version
  config.app_commit = File.exist?('REVISION') ? File.read('REVISION')[0..6] : `git rev-parse --short HEAD`[0..6]
end