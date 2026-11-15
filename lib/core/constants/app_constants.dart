class AppConstants {
  // Put your Gemini API key here for development.
  // Never commit a real key to a public repo.
  // Get a free key: https://aistudio.google.com/app/apikey
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '', // leave empty → app uses demo/offline mode
  );

  static const String geminiModel = 'gemini-2.0-flash';

  static const List<String> defaultSubjects = [
    'Anatomy',
    'Physiology',
    'Biochemistry',
    'Pathology',
    'Pharmacology',
    'Microbiology',
    'Forensic Medicine',
    'Community Medicine',
    'Medicine',
    'Surgery',
    'Obstetrics & Gynaecology',
    'Pediatrics',
    'Orthopedics',
    'Ophthalmology',
    'ENT',
    'Psychiatry',
    'Dermatology',
    'Radiology',
    'Anesthesia',
    'Other',
  ];
}
