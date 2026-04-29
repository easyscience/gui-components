__author__ = "github.com/AndrewSazonov"
__version__ = "0.0.1"

import os

from PySide6.QtCore import QObject, QTranslator, QLocale, Property, Slot
#from PySide6.QtWidgets import QApplication
#from PySide6.QtQml import QQmlApplicationEngine

class Translator(QObject):
    def __init__(self, app, engine, translations_path, languages):
        QObject.__init__(self)
        self._app = app
        self._engine = engine
        self._translations_path = translations_path
        self._translator = QTranslator()
        self._languages = self.sortByCode(languages)
        self._default_language_code = 'en'
        self.selectDefaultLanguage()

    @Property('QVariant', constant=True)
    def languages(self):
        return self._languages

    @Property('QVariant', constant=True)
    def defaultLanguageIndex(self):
        for index, language in enumerate(self._languages):
            if language['code'] == self._default_language_code:
                return index
        return 0

    @Slot(int)
    def selectLanguage(self, index):
        self._app.removeTranslator(self._translator)
        translation_file_path = self.translationFilePath(index)
        if translation_file_path is not None:
            self._translator.load(translation_file_path)
            self._app.installTranslator(self._translator)
        self._engine.retranslate()

    def sortByCode(self, languages):
        return sorted(languages, key=lambda k: k['code'])

    def translationFilePath(self, index):
        file_suffix = self._languages[index]['code']
        file_name = f'language_{file_suffix}.qm'
        file_path = os.path.join(self._translations_path, file_name)
        if os.path.isfile(file_path):
            return file_path
        return None

    def systemLanguageCode(self):
        system_locale = QLocale.system().name()
        system_language_code = system_locale[0:2]
        return system_language_code

    def systemLanguageIndex(self):
        for index, language in enumerate(self._languages):
            if language['code'] == self.systemLanguageCode():
                return index
        return self.defaultLanguageIndex()

    def selectSystemLanguage(self):
        self.selectLanguage(self.systemLanguageIndex())

    def selectDefaultLanguage(self):
        self.selectLanguage(self.defaultLanguageIndex)
