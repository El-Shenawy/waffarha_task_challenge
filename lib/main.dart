import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waffarha_flutter_challenge/utils/color_manager.dart';
import 'package:waffarha_flutter_challenge/views/screens/photos_listing_screen.dart';

import 'api_services/photos_api_service.dart';
import 'controllers/photo_cubit.dart';



void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PhotoCubit(PhotosApiService()),
        ),
      ],
      child: PhotoListingApp(),
    ),
  );
}


/// The main application widget.
class PhotoListingApp extends StatelessWidget {
  const PhotoListingApp({Key? key}) : super(key: key);

  /// Builds the application with a [GetMaterialApp] widget.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Listing App',
      theme: ThemeData(
        primarySwatch: ColorManager.myPrimaryMaterialColor,
      ),
      debugShowCheckedModeBanner: false,
      home: PhotoListingPage(),
    );
  }
}

// The above code creates a new class called PhotoListingApp to replace the MyApp class. The code remains functionally the same, with the exception of the class name change.

// Here are some additional comments that could be added to the code:

// PhotoListingApp class
// This is the main application widget that extends StatelessWidget and is immutable.
// It overrides the build method to return a GetMaterialApp widget wrapping the PhotoListingPage widget.
// It also sets the application title and theme, and disables the debugbanner.

// build method
// This method builds the application widget tree by returning a GetMaterialApp widget with the PhotoListingPage widget as the home page.
// The title parameter sets the title of the application, which is displayed in the app switcher.
// The theme parameter sets the primary color of the application to myPrimaryMaterialColor from the ColorManager class.
// The debugShowCheckedModeBanner parameter hides the debug banner in release mode.

// PhotoListingPage
// This is the main screen of the application that displays the list of photos.
// It is implemented in the photos_listing_screen file and is displayed as the home page of the application.
