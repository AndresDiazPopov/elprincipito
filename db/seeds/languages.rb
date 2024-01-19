language_es = Language.find_by(name: 'Español')
unless language_es
  language_es = Language.create(name: 'Español', locale: 'es', state: 'enabled')
  language_es.translations.create(name: 'Spanish', locale: 'en')
end

language_en = Language.find_by(name: 'Inglés')
unless language_en
  language_en = Language.create(name: 'Inglés', locale: 'es', state: 'enabled')
  language_en.translations.create(name: 'English', locale: 'en')
end