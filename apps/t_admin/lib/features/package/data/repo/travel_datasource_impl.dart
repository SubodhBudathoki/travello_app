import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:t_admin/core/utils/firebase_storage_utils.dart';
import 'package:t_admin/di/di_setup.dart';
import 'package:t_admin/features/package/data/model/travel_package_model.dart';
import 'package:t_admin/features/package/domain/repo/package_data_source.dart';

/// Travel Data Source Repo
@Injectable(as: TravelDataSource)
class TravelDataSourceImpl implements TravelDataSource {
  TravelDataSourceImpl({
    required this.firestore,
  });
  final FirebaseFirestore firestore;

  @override
  Future<void> addLocation({required String location}) {
    throw UnimplementedError();
  }

  @override
  Future<void> addTravelCategory({required String category}) {
    throw UnimplementedError();
  }

  @override
  Future<void> addTravelPacakge({
    required Uint8List vrImage,
    required List<Uint8List> images,
    required Uint8List featuredImage,
    required TravelPackageModel travelPackageModel,
  }) async {
    try {
      final firebaseStorageUitls = getIt<FirebaseStorageUitls>();
      final collectionRef = firestore.collection('packages');
      final featuredImageUrl = await firebaseStorageUitls.uploadImage(
        packageId: travelPackageModel.uuid,
        image: featuredImage,
      );
      final listImagesUrl =
          await firebaseStorageUitls.uploadMultipleImagesToFirebase(
        packageId: travelPackageModel.uuid,
        images: images,
      );
      final vrImageUrl = await firebaseStorageUitls.uploadImage(
        packageId: travelPackageModel.uuid,
        image: vrImage,
      );

      await collectionRef.add(
        travelPackageModel
            .copyWith(
              vrImage: vrImageUrl,
              images: listImagesUrl,
              featuredImage: featuredImageUrl,
            )
            .toJson(),
      );
    } on FirebaseException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  @override
  Stream<List<TravelPackageModel>> getTravelPackages() {
    // TODO: implement getTravelPackages
    throw UnimplementedError();
  }

  @override
  Future<void> updatePacakage(
      {required TravelPackageModel travelPackageModel}) {
    // TODO: implement updatePacakage
    throw UnimplementedError();
  }

  @override
  Future<void> deletePackage({required String id}) {
    // TODO: implement deletePackage
    throw UnimplementedError();
  }
}
