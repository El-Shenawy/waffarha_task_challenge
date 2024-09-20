import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waffarha_flutter_challenge/utils/color_manager.dart';
import 'package:waffarha_flutter_challenge/utils/font_manager.dart';
import 'package:waffarha_flutter_challenge/utils/size_config.dart';
import 'package:waffarha_flutter_challenge/utils/values_manager.dart';
import 'package:waffarha_flutter_challenge/views/widgets/custom_text.dart';

import '../../controllers/photo_cubit.dart';
import 'image_with_border_radius.dart';

/// A custom widget for displaying a dropdown button to sort photos by title or album ID.
Widget sortByDropdown(PhotoCubit cubit) {
  return BlocBuilder<PhotoCubit, PhotoState>(
    builder: (context, state) {
      String selectedSortBy = '';
      if (state is PhotoLoaded) {
        selectedSortBy = context.read<PhotoCubit>().sortBy;
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Sort By'),
          const SizedBox(height: AppSize.s12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p12,
            ),
            height: SizeConfig.screenHeight * 0.04,
            width: SizeConfig.screenWidth * 0.31,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s28),
              border: Border.all(color: ColorManager.colorGrayText),
              color: ColorManager.colorLightGray,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedSortBy.isEmpty ? null : selectedSortBy,
                items: const [
                  DropdownMenuItem(
                    value: 'title',
                    child: CustomText(
                      text: 'Title',
                      fontSize: FontSize.s14,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'albumId',
                    child: CustomText(
                      text: 'Album Id',
                      fontSize: FontSize.s14,
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    context.read<PhotoCubit>().setSortBy(value);
                  }
                },
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// A custom widget or displaying a dropdown button to filter photos by album.
Widget filterByAlbumDropdown(PhotoCubit cubit) {
  return BlocBuilder<PhotoCubit, PhotoState>(
    builder: (context, state) {
      int selectedAlbum = 0;
      List<int> albums = [];

      if (state is PhotoLoaded) {
        selectedAlbum = context.read<PhotoCubit>().selectedAlbum;
        albums = state.albums;
      }

      return Column(
        children: [
          const Text('Filter By Album'),
          const SizedBox(height: AppSize.s12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p12,
            ),
            height: SizeConfig.screenHeight * 0.04,
            width: SizeConfig.screenWidth * 0.22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s28),
              border: Border.all(color: ColorManager.colorGrayText),
              color: ColorManager.colorLightGray,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selectedAlbum,
                items: [
                  const DropdownMenuItem(
                    value: 0,
                    child: CustomText(
                      text: 'All',
                      fontSize: FontSize.s14,
                    ),
                  ),
                  ...albums.map(
                        (album) => DropdownMenuItem(
                      value: album,
                      child: Text(album.toString()),
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    context.read<PhotoCubit>().setSelectedAlbum(value);
                    context.read<PhotoCubit>().fetchPhotos(); // Fetch photos with the new filter
                  }
                },
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// A custom widget for displaying a list of photos with thumbnails and details.
Widget photosList() {
  return BlocBuilder<PhotoCubit, PhotoState>(
    builder: (context, state) {
      if (state is PhotoLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is PhotoError) {
        return Center(child: Text('Error: ${state.message}'));
      } else if (state is PhotoLoaded) {
        final photos =  context.read<PhotoCubit>().sortedPhotos;

        return photos.isEmpty ? Center(child: Text("No more data")):ListView.builder(
          itemCount: photos.length,
          itemBuilder: (context, index) {
            final photo = photos[index];
            return Card(
              child: ListTile(
                leading: ImageWithBorderRadius(
                  width: AppSize.s50,
                  height: AppSize.s50,
                  imageUrl: photo.thumbnailUrl,
                ),
                title: Text(photo.title),
                subtitle: Text('Album Id: ${photo.albumId}'),
                trailing: Text('${photo.id}'),
              ),
            );
          },
        );
      }
      return SizedBox.shrink(); // Default case if no state is matched
    },
  );
}

/// A custom widget for displaying a list of photos with thumbnails and details.
Widget photosGridList() {
  return BlocBuilder<PhotoCubit, PhotoState>(
    builder: (context, state) {
      if (state is PhotoLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is PhotoError) {
        return Center(child: Text('Error: ${state.message}'));
      } else if (state is PhotoLoaded) {
        final photos = context.read<PhotoCubit>().sortedPhotos;

        return photos.isEmpty ? Center(child: Text("No more data")):GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            final photo = photos[index];
            return Container(
              margin: const EdgeInsets.all(AppMargin.m8),
              decoration: BoxDecoration(
                color: ColorManager.whiteColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              width: double.infinity,
              height: SizeConfig.screenHeight * 0.6,
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.p8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ImageWithBorderRadius(
                      width: double.infinity,
                      height: SizeConfig.screenHeight * 0.06,
                      imageUrl: photo.thumbnailUrl,
                    ),
                    CustomText(
                      text: photo.title,
                      fontSize: FontSize.s14,
                    ),
                    const SizedBox(height: AppSize.s4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Album Id: ${photo.albumId}'),
                        Text('${photo.id}'),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      return SizedBox.shrink(); // Default case if no state is matched
    },
  );
}

/// A custom widget for displaying pagination buttons to navigate between pages of photos.
Widget paginationButtons() {
  return BlocBuilder<PhotoCubit, PhotoState>(
    builder: (context, state) {
      bool isLoading = false;
      bool isAtFirstPage = true;
      bool noMoreData = false;

      if (state is PhotoLoading) {
        isLoading = true;
      } else if (state is PhotoLoaded) {
        isAtFirstPage = context.read<PhotoCubit>().currentPage == 1;
        noMoreData = context.read<PhotoCubit>().noMoreData;
      }

      if (isLoading) {
        return SizedBox();
      }

      return Padding(
        padding: const EdgeInsets.only(left: AppPadding.p12, right: AppPadding.p12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: SizeConfig.screenHeight * 0.04,
              width: SizeConfig.screenWidth * 0.25,
              child: ElevatedButton(
                onPressed: isAtFirstPage
                    ? null
                    : () async {
                  await context.read<PhotoCubit>().prevPage();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.mainColor, // Background color
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // Rounded corners
                  ),
                  elevation: isAtFirstPage ? 0 : 4, // Elevation effect
                ),
                child: const Text(
                  'Prev',
                 style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: AppSize.s12),
            Text('Page ${context.read<PhotoCubit>().currentPage}'),
            const SizedBox(width: AppSize.s12),
            SizedBox(
              height: SizeConfig.screenHeight * 0.04,
              width: SizeConfig.screenWidth * 0.25,
              child: ElevatedButton(
                onPressed: noMoreData
                    ? null
                    : () async {
                  await context.read<PhotoCubit>().nextPage();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.mainColor, // Background color
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // Rounded corners
                  ),
                  elevation: isAtFirstPage ? 0 : 4, // Elevation effect
                ),
                child: const Text('Next',style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      );
    },
  );
}


