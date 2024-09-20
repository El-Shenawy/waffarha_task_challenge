import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waffarha_flutter_challenge/utils/color_manager.dart';
import '../../controllers/photo_cubit.dart';
import '../../utils/size_config.dart';
import '../../utils/values_manager.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_loader.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/display_type_button.dart';

/// A view class to display the photo data and handle user interactions.
class PhotoListingPage extends StatefulWidget {
  @override
  State<PhotoListingPage> createState() => _PhotoListingPageState();
}

class _PhotoListingPageState extends State<PhotoListingPage> {
  late PhotoCubit photoCubit;
  bool _isGrid = false;

  @override
  void initState() {
    super.initState();
    photoCubit = context.read<PhotoCubit>();
    photoCubit.fetchPhotos(); // Fetch initial photos
  }

  Widget _buildSortAndFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        sortByDropdown(photoCubit),
        const SizedBox(width: AppSize.s8),
        filterByAlbumDropdown(photoCubit),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the size config to adapt to different screen sizes.
    SizeConfig().init(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Photos Listing',
        backgroundColor: ColorManager.mainColor,
      ),
      bottomSheet: Container(
        height: SizeConfig.screenHeight * 0.08,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: BlocBuilder<PhotoCubit, PhotoState>(
          builder: (context, state) {
            return paginationButtons();
          },
        ),
      ),
      body: BlocBuilder<PhotoCubit, PhotoState>(
        builder: (context, state) {
          if (state is PhotoLoading) {
            return const Center(child: CustomLoader());
          } else if (state is PhotoError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is PhotoLoaded) {
            return Padding(
              padding: const EdgeInsets.all(AppPadding.p14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DisplayTypeToggleButtons(
                        isGrid: _isGrid,
                        onChanged: (bool value) {
                          setState(() {
                            _isGrid = value;
                          });
                        },
                      ),
                      _buildSortAndFilterRow(),
                    ],
                  ),
                  const SizedBox(height: AppSize.s8),
                  Expanded(
                      child: _isGrid
                          ? photosGridList()
                          : photosList()),
                  const SizedBox(height: AppSize.s50),
                ],
              ),
            );
          }
          return SizedBox.shrink(); // Default case if no state is matched
        },
      ),
    );
  }
}