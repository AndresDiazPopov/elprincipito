language_es = Language.create(name: 'Español', locale: 'es', state: 'enabled')
language_es.translations.create(name: 'Spanish', locale: 'en')

language_en = Language.create(name: 'Inglés', locale: 'es', state: 'enabled')
language_en.translations.create(name: 'English', locale: 'en')