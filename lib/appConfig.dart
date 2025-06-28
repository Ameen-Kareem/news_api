import 'package:flutter/foundation.dart';

class Appconfig {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseKey = String.fromEnvironment('SUPABASE_KEY');
  static const newsApiKey = String.fromEnvironment('NEWS_API_KEY');

  static List newsCategories = [
    "business",
    "entertainment",
    "general",
    "health",
    "science",
    "sports",
    "technology",
  ];
  static final Map<String, String> newsCountries = {
    "United Arab Emirates": "ae",
    "Argentina": "ar",
    "Austria": "at",
    "Australia": "au",
    "Belgium": "be",
    "Bulgaria": "bg",
    "Brazil": "br",
    "Canada": "ca",
    "Switzerland": "ch",
    "China": "cn",
    "Colombia": "co",
    "Czech Republic": "cz",
    "Germany": "de",
    "Egypt": "eg",
    "France": "fr",
    "United Kingdom": "gb",
    "Greece": "gr",
    "Hong Kong": "hk",
    "Hungary": "hu",
    "Indonesia": "id",
    "Ireland": "ie",
    "Israel": "il",
    "India": "in",
    "Italy": "it",
    "Japan": "jp",
    "South Korea": "kr",
    "Lithuania": "lt",
    "Latvia": "lv",
    "Morocco": "ma",
    "Mexico": "mx",
    "Malaysia": "my",
    "Nigeria": "ng",
    "Netherlands": "nl",
    "Norway": "no",
    "New Zealand": "nz",
    "Philippines": "ph",
    "Poland": "pl",
    "Portugal": "pt",
    "Romania": "ro",
    "Serbia": "rs",
    "Russia": "ru",
    "Saudi Arabia": "sa",
    "Sweden": "se",
    "Singapore": "sg",
    "Slovenia": "si",
    "Slovakia": "sk",
    "Thailand": "th",
    "Turkey": "tr",
    "Taiwan": "tw",
    "Ukraine": "ua",
    "United States": "us",
    "Venezuela": "ve",
    "South Africa": "za",
  };

  static const baseUrl = "https://newsapi.org/v2/";
}
