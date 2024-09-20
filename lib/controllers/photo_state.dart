part of 'photo_cubit.dart';


abstract class PhotoState extends Equatable {
  @override
  List<Object> get props => [];
}

class PhotoInitial extends PhotoState {}

class PhotoLoading extends PhotoState {}

class PhotoLoaded extends PhotoState {
  final List<Photo> photos;
  final List<int> albums;
  final bool noMoreData;
  final bool isLoadingPreviousData;
  final bool isLoadingNextData;

  PhotoLoaded({
    required this.photos,
    required this.albums,
    required this.noMoreData,
    required this.isLoadingPreviousData,
    required this.isLoadingNextData,
  });

  @override
  List<Object> get props => [photos, albums, noMoreData, isLoadingPreviousData, isLoadingNextData];
}

class PhotoError extends PhotoState {
  final String message;

  PhotoError(this.message);

  @override
  List<Object> get props => [message];
}