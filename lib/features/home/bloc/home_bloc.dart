import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pruzi_korak/data/health_data/health_repository.dart';
import 'package:pruzi_korak/data/health_data/helth_native_sync.dart';
import 'package:pruzi_korak/data/home/home_repository.dart';
import 'package:pruzi_korak/domain/user/steps_model.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HealthRepository healthRepository;
  final HomeRepository homeRepository;

  HomeBloc(this.homeRepository, {required this.healthRepository})
    : super(HomeLoading()) {
    on<HomeLoadEvent>(_onLoad);
    on<HomeSilentUpdateEvent>(_onSilentUpdate);

    add(const HomeLoadEvent());
  }

  Future<void> _onLoad(HomeLoadEvent event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoading());
      await _fetchAndUpdateData(emit);
    } catch (_) {
      emit(const HomeError());
    }
  }

  Future<void> _onSilentUpdate(
    HomeSilentUpdateEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Don't emit loading state here - just update the data
      await _fetchAndUpdateData(emit);
    } catch (_) {
      emit(const HomeError());
    }
  }

  Future<void> _fetchAndUpdateData(Emitter<HomeState> emit) async {
    final syncData = await healthRepository.fetchSyncInfo();

    final lastSyncAtStr = syncData['last_sync_at'];
    final lastSignInAtStr = syncData['last_sign_in_at'];

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final lastSyncAt =
        lastSyncAtStr != null ? DateTime.parse(lastSyncAtStr) : null;
    final lastSignInAt =
        lastSignInAtStr != null ? DateTime.parse(lastSignInAtStr) : null;

    DateTime syncStart = today;
    if (lastSyncAt != null && lastSignInAt != null) {
      syncStart = lastSyncAt.isAfter(lastSignInAt) ? lastSyncAt : lastSignInAt;
    } else if (lastSyncAt != null) {
      syncStart = lastSyncAt;
    } else if (lastSignInAt != null) {
      syncStart = lastSignInAt;
    }

    final syncStartDateOnly = DateTime(
      syncStart.year,
      syncStart.month,
      syncStart.day,
    );

    if (syncStartDateOnly == todayDate) {
      final kilometers = await healthRepository.getTodayDistanceSinceLastSync(
        syncStart,
      );
      await healthRepository.sendTodayDistance(kilometers);
    } else {
      final allDistances = await healthRepository.getDailyDistancesFromLastSync(
        syncStart,
      );
      debugPrint('🏷️ allDistances: $allDistances');
      final filteredDistances =
          allDistances.where((entry) {
            final dateStr = entry['date'] as String?;
            final km = entry['total_kilometers'] as double? ?? 0.0;
            if (dateStr == null) return false;

            final entryDate = DateTime.tryParse(dateStr);
            if (entryDate == null) return false;

            return !(lastSignInAt != null &&
                    entryDate.isBefore(lastSignInAt)) &&
                km > 0;
          }).toList();

      await healthRepository.sendDailyDistances(filteredDistances);
    }

    final response = await homeRepository.getHomeData();
    final userModel = response.user;
    final teamStepsModel = response.teamUserStats;

    // Fetch user rank
    final myRank = await homeRepository.getMyRank();

    final userStepsModel = StepsModel(
      steps: teamStepsModel.userToday,
      totalSteps: teamStepsModel.userTotal,
    );

    final team = StepsModel(
      steps: teamStepsModel.teamToday,
      totalSteps: teamStepsModel.teamTotal,
    );

    emit(
      HomeLoaded(
        userModel: response.user,
        userStepsModel: userStepsModel,
        teamStepsModel: team,
        myRank: myRank,
      ),
    );
  }
}
