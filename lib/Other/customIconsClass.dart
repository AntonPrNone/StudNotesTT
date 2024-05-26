// ignore_for_file: file_names,

import 'package:flutter/material.dart';

class CustomIcons {
  static final Map<String, String> subjectIconPaths = {
    'Religion1': 'assets/Icons/Subjects/SubjectReligion1.png',
    'SubjectForeignLanguage1':
        'assets/Icons/Subjects/SubjectForeignLanguage1.png',
    'SubjectSexEducation1': 'assets/Icons/Subjects/SubjectSexEducation1.png',
    'SubjectAlphabet1': 'assets/Icons/Subjects/SubjectAlphabet1.png',
    'SubjectTheater1': 'assets/Icons/Subjects/SubjectTheater1.png',
    'SubjectMath1': 'assets/Icons/Subjects/SubjectMath1.png',
    'SubjectJurisprudence1': 'assets/Icons/Subjects/SubjectJurisprudence1.png',
    'SubjectNatural1': 'assets/Icons/Subjects/SubjectNatural1.png',
    'SubjectPsychology1': 'assets/Icons/Subjects/SubjectPsychology1.png',
    'SubjectEconomy1': 'assets/Icons/Subjects/SubjectEconomy1.png',
    'SubjectForeignLanguage1-1':
        'assets/Icons/Subjects/SubjectForeignLanguage1-1.png',
    'SubjectAnthropology1': 'assets/Icons/Subjects/SubjectAnthropology1.png',
    'SubjectAlgebra1': 'assets/Icons/Subjects/SubjectAlgebra1.png',
    'SubjectPolitics1': 'assets/Icons/Subjects/SubjectPolitics1.png',
    'SubjectCompass1': 'assets/Icons/Subjects/SubjectCompass1.png',
    'SubjectSinging1': 'assets/Icons/Subjects/SubjectSinging1.png',
    'SubjectChemistry1': 'assets/Icons/Subjects/SubjectChemistry1.png',
    'SubjectRhetorical1': 'assets/Icons/Subjects/SubjectRhetorical1.png',
    'SubjectArcheology1': 'assets/Icons/Subjects/SubjectArcheology1.png',
    'SubjectExperiment1': 'assets/Icons/Subjects/SubjectExperiment1.png',
    'SubjectGeography1': 'assets/Icons/Subjects/SubjectGeography1.png',
    'SubjectZoology1': 'assets/Icons/Subjects/SubjectZoology1.png',
    'SubjectBook1': 'assets/Icons/Subjects/SubjectBook1.png',
    'SubjectCitizenship1': 'assets/Icons/Subjects/SubjectCitizenship1.png',
    'SubjectPhysical1': 'assets/Icons/Subjects/SubjectPhysical1.png',
    'SubjectHealthcare1': 'assets/Icons/Subjects/SubjectHealthcare1.png',
    'SubjectMath1-1': 'assets/Icons/Subjects/SubjectMath1-1.png',
    'SubjectHistory1': 'assets/Icons/Subjects/SubjectHistory1.png',
    'SubjectChemistry1-1': 'assets/Icons/Subjects/SubjectChemistry1-1.png',
    'SubjectHandcraft1': 'assets/Icons/Subjects/SubjectHandcraft1.png',
    'SubjectPhysical1-1': 'assets/Icons/Subjects/SubjectPhysical1-1.png',
    'SubjectAstronomy1': 'assets/Icons/Subjects/SubjectAstronomy1.png',
    'SubjectDriving1': 'assets/Icons/Subjects/SubjectDriving1.png',
    'SubjectSocialScience1': 'assets/Icons/Subjects/SubjectSocialScience1.png',
    'SubjectCraft1': 'assets/Icons/Subjects/SubjectCraft1.png',
    'SubjectGeometry1': 'assets/Icons/Subjects/SubjectGeometry1.png',
    'SubjectMusic1': 'assets/Icons/Subjects/SubjectMusic1.png',
    'SubjectPhilosophy1': 'assets/Icons/Subjects/SubjectPhilosophy1.png',
    'SubjectScroll1': 'assets/Icons/Subjects/SubjectScroll1.png',
    'SubjectNatural1-1': 'assets/Icons/Subjects/SubjectNatural1-1.png',
    'SubjectDraftsmanship1': 'assets/Icons/Subjects/SubjectDraftsmanship1.png',
    'SubjectBiology1': 'assets/Icons/Subjects/SubjectBiology1.png',
    'SubjectEcology1': 'assets/Icons/Subjects/SubjectEcology1.png',
    'SubjectScience1': 'assets/Icons/Subjects/SubjectScience1.png',
    'SubjectCoding1': 'assets/Icons/Subjects/SubjectCoding1.png',
    'SubjectCooking1': 'assets/Icons/Subjects/SubjectCooking1.png',
    'SubjectSport1': 'assets/Icons/Subjects/SubjectSport1.png',
    'SubjectWriting1': 'assets/Icons/Subjects/SubjectWriting1.png',
    'SubjectArt1': 'assets/Icons/Subjects/SubjectArt1.png',
    'SubjectBook1-1': 'assets/Icons/Subjects/SubjectBook1-1.png',
  };

  static ImageProvider getIcon(String iconName) {
    if (subjectIconPaths.containsKey(iconName)) {
      return AssetImage(subjectIconPaths[iconName]!);
    } else {
      return const AssetImage('assets/Icons/Subjects/NotFound.png');
    }
  }
}
