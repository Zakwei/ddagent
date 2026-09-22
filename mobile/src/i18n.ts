import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import { getLocales } from 'expo-localization';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { resources } from './i18n-resources';

const LANG_KEY = 'ddagent.language';
const deviceLang = getLocales()[0]?.languageTag ?? 'en';

i18n.use(initReactI18next).init({
  resources,
  lng: deviceLang,
  fallbackLng: 'en',
  ns: ['common', 'settings', 'auth', 'sidebar', 'chat', 'codeEditor', 'tasks'],
  defaultNS: 'common',
  interpolation: { escapeValue: false },
  react: { useSuspense: false },
});

AsyncStorage.getItem(LANG_KEY).then((saved) => {
  if (saved && saved !== i18n.language) i18n.changeLanguage(saved);
});

export const setLanguage = async (lng: string) => {
  await AsyncStorage.setItem(LANG_KEY, lng);
  await i18n.changeLanguage(lng);
};

export const getLanguage = () => i18n.language;

export default i18n;
