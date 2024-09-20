import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../api_services/photos_api_service.dart';
import '../models/photo.dart';

part 'photo_state.dart';

class PhotoCubit extends Cubit<PhotoState> {
  final PhotosApiService _photoService;
  int currentPage = 1;
  final int pageLimit = 10;
  int selectedAlbum = 0;
  String sortBy = 'albumId';
  bool noMoreData = false;

  PhotoCubit(this._photoService) : super(PhotoInitial()) {
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    emit(PhotoLoading());
    try {
      final photos = await _photoService.fetchPhotos(
        startPage: (currentPage - 1) * pageLimit,
        pageLimit: pageLimit,
        albumId: selectedAlbum == 0 ? null : selectedAlbum,
      );

        noMoreData = photos.isEmpty || currentPage >= 500;

      emit(PhotoLoaded(
        photos: photos,
        albums: List<int>.generate(100, (i) => i + 1),
        noMoreData: noMoreData,
        isLoadingPreviousData: false,
        isLoadingNextData: false,
      ));
    } catch (e) {
      emit(PhotoError(e.toString()));
    }
  }

  void setSelectedAlbum(int albumId) {
    selectedAlbum = albumId;
    currentPage = 1;
    fetchPhotos();
  }

  void setSortBy(String sortKey) {
    sortBy = sortKey;
    fetchPhotos();
  }

  Future<void> nextPage() async {
    emit(PhotoLoading());
    currentPage++;
   await fetchPhotos();
  }

  Future<void> prevPage() async {
    if (currentPage > 1) {
      emit(PhotoLoading());
      currentPage--;
      await fetchPhotos();
    }
  }

  List<Photo> get filteredPhotos {
    final state = this.state;
    if (state is PhotoLoaded) {
      if (selectedAlbum == 0) {
        return state.photos;
      } else {
        return state.photos.where((photo) => photo.albumId == selectedAlbum).toList();
      }
    }
    return [];
  }

  List<Photo> get sortedPhotos {
    final state = this.state;
    if (state is PhotoLoaded) {
      List<Photo> sortedList = List.from(filteredPhotos);
      sortedList.sort((a, b) {
        if (sortBy == 'albumId') {
          return a.albumId.compareTo(b.albumId);
        } else {
          return a.title.compareTo(b.title);
        }
      });
      return sortedList;
    }
    return [];
  }

  List<Photo> get paginatedPhotos {
    final state = this.state;
    if (state is PhotoLoaded) {
      final startIndex = (currentPage - 1) * pageLimit;
      final endIndex = currentPage * pageLimit;
      final filteredPhotos = sortedPhotos
          .where((photo) => selectedAlbum == 0 || photo.albumId == selectedAlbum)
          .toList();
      if (startIndex >= filteredPhotos.length) {
        currentPage = (filteredPhotos.length / pageLimit).ceil();
      }
      return filteredPhotos.sublist(startIndex, endIndex);
    }
    return [];
  }
}
